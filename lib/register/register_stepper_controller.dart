import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';

class RegisterStepperController extends GetxController{
  final box = GetStorage();

  TextEditingController nickEditingController = TextEditingController();

  TextEditingController emailEditingController = TextEditingController();

  TextEditingController pwdEditingController = TextEditingController();

  RxString selectGender = ''.obs;
  RxInt chipIndex = 0.obs;
  List<String> chipLabel = ['헬스','수영','클라이밍','크로스핏','테니스','복싱','주짓수','유도','등산','사이클','필라테스','요가','기타'];
  var selectChipLabel = '헬스'.obs;
  var selectImage = [].obs;
  var photoDownloadUrl = '';
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
  Future<void> fireAuthLogin(context) async {
    //showLoading();
    await uploadProfileImageStorage();
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailEditingController.text,
        password: pwdEditingController.text,
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(emailEditingController.text)
          .set({
        'email': emailEditingController.text,
        'nickname': nickEditingController.text,
        'gender': selectGender.value,
        'photoUrl':photoDownloadUrl,
        'my_work_out':selectChipLabel.value,
        //'login_provider':Get.arguments.credential!.signInMethod!,
      }).then((value){
        //box.write('${email}_login', true);
        FirebaseAuth.instance.currentUser?.sendEmailVerification();
        Fluttertoast.showToast(msg: '회원가입 완료!');
        Get.back();
        //hideLoading(context);
      }).catchError((e){
        print(e);
        Fluttertoast.showToast(msg: e.code);
        //Get.back();
        //hideLoading(context);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: '비밀번호 약함');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: '이미 등록된 이메일');
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> selectImagePicker() async {
    await ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      selectImage.clear();
      selectImage.add(value!.path);
    });
  }

  Future<void> uploadProfileImageStorage() async {
    final firebaseStorageRef = FirebaseStorage.instance;

    TaskSnapshot task = await firebaseStorageRef
        .ref()
        .child('profileImage')
        .child('${emailEditingController.text}_profileImage')
        .putFile(File(selectImage.first));

    photoDownloadUrl = await task.ref.getDownloadURL();
  }
}