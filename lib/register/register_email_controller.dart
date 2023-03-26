import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testpro/widget/show_loading.dart';
import 'package:get_storage/get_storage.dart';
class RegisterEmailController extends GetxController {
  final box = GetStorage();
  TextEditingController nickEditingController = TextEditingController();

  TextEditingController emailEditingController = TextEditingController();

  TextEditingController pwdEditingController = TextEditingController();

  TextEditingController squartEditingController = TextEditingController();
  FocusNode squartNode = FocusNode();

  TextEditingController deadEditingController = TextEditingController();
  FocusNode deadNode = FocusNode();

  TextEditingController benchEditingController = TextEditingController();
  FocusNode benchNode = FocusNode();

  RxString selectGender = ''.obs;
  var selectImage = [].obs;
  var photoDownloadUrl = '';
  // String email = '';
  // String loginProvider='';
  //late UserCredential userCredential;
  @override
  void onInit() {
    super.onInit();
    print('on init');

    //userCredential=Get.arguments;
  }

  @override
  void onReady() {
    super.onReady();
    print('on ready');
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
        'deadLift': deadEditingController.text,
        'squart': squartEditingController.text,
        'bench': benchEditingController.text,
        //'login_provider':Get.arguments.credential!.signInMethod!,
      }).then((value){
        //box.write('${email}_login', true);
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
