import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageUploadService {
  Future<void> imageSelect(RxList<XFile> editPhotoList) async {
    List<XFile> result = await ImagePicker().pickMultiImage();
    if (result.isEmpty) {
      return;
    } else {
      await Future.delayed(const Duration(milliseconds: 300));
      Get.to(() => ImageUploadView(
            result: result,
            editPhotoList: editPhotoList,
          ));
    }
  }
}

class ImageUploadView extends StatefulWidget {
  final List<XFile> result;
  final RxList<XFile> editPhotoList;

  const ImageUploadView(
      {Key? key, required this.result, required this.editPhotoList})
      : super(key: key);

  @override
  State<ImageUploadView> createState() => _ImageUploadViewState();
}

class _ImageUploadViewState extends State<ImageUploadView> {
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이미지 업로드'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  PageView.builder(
                      controller: pageController,
                      itemCount: widget.result.length,
                      itemBuilder: (BuildContext context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.width - 32,
                          height: MediaQuery.of(context).size.width - 32,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(
                                      File(widget.result[index].path)),
                                  fit: BoxFit.contain)),
                        );
                      }),
                  Positioned.fill(
                    top: 16,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SmoothPageIndicator(
                          effect: WormEffect(
                            activeDotColor: Colors.blue,
                            dotColor: Colors.black,
                          ),
                          controller: pageController,
                          count: widget.result.length),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 56,
              child: Row(
                children: [
                  Flexible(
                      child: GestureDetector(
                          onTap: () async {
                            //편집
                            CroppedFile? croppedFile =
                                await ImageCropper().cropImage(
                              sourcePath: widget
                                  .result[pageController.page!.toInt()].path
                                  .toString(),
                              maxWidth: 3000,
                              maxHeight: 3000,
                              uiSettings: [
                                AndroidUiSettings(
                                  activeControlsWidgetColor: Colors.black,
                                  toolbarTitle: '이미지 자르기',
                                  toolbarColor: Colors.black,
                                  toolbarWidgetColor: Colors.white,
                                  initAspectRatio:
                                      CropAspectRatioPreset.original,
                                  lockAspectRatio: true,
                                ),
                                IOSUiSettings(
                                  aspectRatioLockEnabled: true,
                                  title: '이미지 자르기',
                                  doneButtonTitle: '완료',
                                  cancelButtonTitle: '취소',
                                )
                              ],
                            );
                            setState(() {
                              widget.result[pageController.page!.toInt()] =
                                  XFile(croppedFile!.path);
                            });
                          },
                          child: Container(
                            color: Colors.black,
                          ))),
                  Flexible(
                      child: GestureDetector(
                          onTap: () {
                            //바로 올리기
                            widget.editPhotoList.value = widget.result;
                            Get.back();
                          },
                          child: Container(
                            color: Colors.blue,
                          ))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
