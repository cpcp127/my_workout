import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:testpro/home_tab/second_tab_controller.dart';
import 'package:testpro/login/login_controller.dart';
import 'package:testpro/model/user_model.dart';
import 'package:testpro/widget/show_loading.dart';

class HomeController extends GetxController {
  var myUser = UserModel().obs;
  var isLoading = true.obs;
  var tabIndex = 1.obs;
  var selectImage = [].obs;
  var photoDownloadUrlList = [].obs;
  PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();
  TextEditingController claimEditingController = TextEditingController();
  //var events = <Map<String, dynamic>>[].obs;
  List<Event> eventList = [];
  RxMap eventsMain = {
    // DateTime.utc(2022,12,27) : [ Event('title'), Event('title2') ],
    // DateTime.utc(2022,7,14) : [ Event('title3') ],
  }.obs;
  Rx<DateTime> selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  ).obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;

  @override
  Future<void> onInit() async {
    print('init start');
    super.onInit();
    isLoading.value = true;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email!)
        .get()
        .then((value) {
      print(value.data());
      //var myUserJson=jsonEncode(value.data());
      myUser.value = UserModel.fromJson(value.data());
    });
    await loadEvent();

    isLoading.value = false;
    print('init end');
  }

  @override
  void onReady() {
    super.onReady();
    print('ready start');
    print('ready end');
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadEvent() async {
    //events.clear();
    FirebaseFirestore.instance
        .collection('${myUser.value.nickname}_오운완')
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {

        eventsMain.addAll({
          DateTime.utc(
              value.docs[i].data()['date'].toDate().year,
              value.docs[i].data()['date'].toDate().month,
              value.docs[i].data()['date'].toDate().day): [
            Event(value.docs[i].data()['photoUrlList'])
          ]
        });
      }
    });
  }

  List getEventsForDay(DateTime day) {
    return eventsMain[day] ?? [];
  }

  Future<void> selectImagePicker() async {
    selectImage.clear();
    await ImagePicker().pickMultiImage().then((value) {
      for (int i = 0; i < value.length; i++) {
        selectImage.add(value[i].path);
      }
    });
  }

  Future<void> uploadProfileImageStorage() async {
    final firebaseStorageRef = FirebaseStorage.instance;
    for (int i = 0; i < selectImage.length; i++) {
      TaskSnapshot task = await firebaseStorageRef
          .ref()
          .child('오운완 이미지')
          .child('${myUser.value.nickname}_오운완_${DateTime.now()}_$i')
          .putFile(File(selectImage[i]));
      photoDownloadUrlList.add(await task.ref.getDownloadURL());
    }
  }

  Future<void> uploadTodayHealth() async {
    showLoading();
    await uploadProfileImageStorage();
    FirebaseFirestore.instance
        .collection('${myUser.value.nickname}_오운완')
        .doc(DateTime.now().toString())
        .set({
      'photoUrlList': photoDownloadUrlList,
      'date': DateTime.now().toLocal(),
    }).whenComplete(() {
      Get.back();
    });
  }
}

class Event {
  List<dynamic> title;

  Event(this.title);
}
