import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testpro/login/home_controller.dart';

class UploadFeedController extends GetxController {
  RxList<XFile> editPhotoList = <XFile>[].obs;
  HomeController homeController = Get.find<HomeController>();
  var photoDownloadUrlList = [].obs;
  TextEditingController articleDescription = TextEditingController();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
  Future<void> uploadArticlePhoto() async {
    final firebaseStorageRef = FirebaseStorage.instance;
    for (int i = 0; i < editPhotoList.length; i++) {
      TaskSnapshot task = await firebaseStorageRef
          .ref()
          .child('article')
          .child('${homeController.myUser.value.nickname}_article_${DateTime.now()}_$i')
          .putFile(File(editPhotoList[i].path));
      photoDownloadUrlList.add(await task.ref.getDownloadURL());
    }
  }
}