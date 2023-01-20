import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../home_view.dart';
import '../register/register_controller.dart';
import '../register/register_view.dart';
import 'home_controller.dart';

class LoginController extends GetxController {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController pwdEditingController = TextEditingController();

  var loginEmail = ''.obs;
  final box = GetStorage();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  void signInWithApple() async {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // FirebaseFirestore.instance.collection('users').doc(emailEditingController.text).set({
      //   'email':emailEditingController.text,
      // });
      UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      loginEmail.value=authResult.user!.email!;
      FirebaseFirestore.instance.collection('users').doc(loginEmail.value).get().then((res){
        if(res.data()!['email']==loginEmail.value){
          Get.put(HomeController());
          Get.to(() => HomeView());
          box.write('auto_login_email', loginEmail.value);
        }else{
          Get.put(RegisterController());
          Get.to(() => RegisterView(),arguments: authResult);
        }
      }).catchError((e){
        Get.put(RegisterController());
        Get.to(() => RegisterView(),arguments: authResult);
      });
  }
}