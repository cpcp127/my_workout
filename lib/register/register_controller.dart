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
class RegisterController extends GetxController {
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
  String email = '';
  String loginProvider='';
 //late UserCredential userCredential;
  @override
  void onInit() {
    super.onInit();
    print('on init');
    print(Get.arguments);
    //userCredential=Get.arguments;
  }

  @override
  void onReady() {
    super.onReady();
    print('on ready');
    print(Get.arguments);
    email=Get.arguments.user!.email!;
    loginProvider=Get.arguments.credential.signInMethod!;
    print(email);
    print(loginProvider);
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fireAuthLogin(context) async {
    showLoading();
    await uploadProfileImageStorage();
    FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .set({
      'email': email,
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
      hideLoading(context);
    }).catchError((e){
      Fluttertoast.showToast(msg: e.code);
      Get.back();
      hideLoading(context);
    });

    // print(
    //     '${emailEditingController.text}, ${pwdEditingController.text}'); //괜히 출력해봄.
    // await FirebaseAuth.instance
    //     .createUserWithEmailAndPassword(
    //         email: emailEditingController.text,
    //         password: pwdEditingController.text)
    //     .then((value) {
    //   FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(value.user!.email)
    //       .set({
    //     'email': value.user!.email,
    //     'nickname': nickEditingController.text,
    //     'gender': selectGender.value,
    //     'photoUrl':photoDownloadUrl,
    //     'deadLift': deadEditingController.text,
    //     'squart': squartEditingController.text,
    //     'bench': benchEditingController.text,
    //   });
    //   Fluttertoast.showToast(msg: '회원가입 완료!');
    //   Get.back();
    //   hideLoading(context);
    // }).catchError((e) {
    //   Fluttertoast.showToast(msg: e.code);
    //   hideLoading(context);
    // });
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
