import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../home_view.dart';
import 'home_controller.dart';

class LoginController extends GetxController {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController pwdEditingController = TextEditingController();
  var userEmail = '';
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
      List<String> jwt = appleCredential.identityToken?.split('.') ?? [];
      String payload = jwt[1];
      payload = base64.normalize(payload);

      final List<int> jsonData = base64.decode(payload);
      final userInfo = jsonDecode(utf8.decode(jsonData));
      print(userInfo);
      String email = userInfo['email'];
      print('이메일 디코딩 : email');


      FirebaseAuth.instance.fetchSignInMethodsForEmail('cpcp127@naver.com').then((value) async {
        if(value.isEmpty){
          UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
          loginEmail.value=authResult.user!.email!;
          FirebaseFirestore.instance.collection('users').doc(loginEmail.value).get().then((res){
            if(res.data()!['email']==loginEmail.value){
              Get.put(HomeController());
              Get.to(() => HomeView());
              box.write('auto_login_email', loginEmail.value);
            }else{
              // Get.put(RegisterController());
              // Get.to(() => RegisterView(),arguments: authResult);
            }
          }).catchError((e){
            // Get.put(RegisterController());
            // Get.to(() => RegisterView(),arguments: authResult);
          });
        }else{
          Fluttertoast.showToast(msg:'이미 등록된 이메일입니다!');
        }
      });


  }
}