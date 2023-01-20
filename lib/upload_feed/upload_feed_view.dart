import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:testpro/services/image_upload_service.dart';
import 'package:testpro/upload_feed/upload_feed_controller.dart';

class UploadFeedView extends GetView<UploadFeedController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('피드 올리기'),
        centerTitle: true,
        actions: [IconButton(onPressed: () async {
          if(controller.editPhotoList.isEmpty){
            await FirebaseFirestore.instance.collection('articles').add({
              'nickname': controller.homeController.myUser.value.nickname,
              'user_photo':controller.homeController.myUser.value.photoUrl,
              'photoUrlList': [],
              'description':controller.articleDescription.text,
              'dateTime':DateTime.now(),
              'comment':0,
              'like':[],
            });
            Get.back();
            controller.homeController.refreshChangeListener.refreshed=true;
          }else{
            await controller.uploadArticlePhoto();
            //먼자 사진을 storage에 등록하고 firestore에 등록하다
           await FirebaseFirestore.instance.collection('articles').add({
              'nickname': controller.homeController.myUser.value.nickname,
              'user_photo':controller.homeController.myUser.value.photoUrl,
              'photoUrlList': controller.photoDownloadUrlList,
              'description':controller.articleDescription.text,
              'dateTime':DateTime.now(),
              'comment':0,
              'like':[],
            });
           Get.back();
           controller.homeController.refreshChangeListener.refreshed=true;
          }

        }, icon: const Icon(Icons.check))],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              ImageUploadService().imageSelect(controller.editPhotoList);
            },
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 2)),
                child: const Icon(Icons.add, size: 50),
              ),
            ),
          ),
          TextField(
            controller: controller.articleDescription,
          ),
          Obx(
            () => controller.editPhotoList.isEmpty
                ? Container()
                : Container(
              width: MediaQuery.of(context).size.width - 32,
              height: MediaQuery.of(context).size.width - 32,
                  child: PageView.builder(
                      controller: PageController(initialPage: 0),
                      itemCount: controller.editPhotoList.length,
                      itemBuilder: (BuildContext context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.width - 32,
                          height: MediaQuery.of(context).size.width - 32,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(
                                      File(controller.editPhotoList[index].path)),
                                  fit: BoxFit.contain)),
                        );
                      }),
                ),
          ),
        ],
      ),
    );
  }
}
