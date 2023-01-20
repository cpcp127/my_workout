import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';

import '../login/home_controller.dart';

class CommentController extends GetxController {
  RxString articleId = ''.obs;
  HomeController homeController = Get.find<HomeController>();
  TextEditingController commentController = TextEditingController();
  PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();
  @override
  void onInit() {
    super.onInit();
    print('on init!!!!!');
    articleId.value = Get.arguments;
  }

  @override
  void onClose() {
    super.onClose();
  }
}