import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:testpro/register/register_stepper_controller.dart';

class RegisterStepperView extends GetView<RegisterStepperController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Visibility(
                visible: controller.stepperIndex.value == 0 ? false : true,
                child: FloatingActionButton(
                  onPressed: () {
                    controller.stepperIndex.value--;
                  },
                  child: Icon(Icons.navigate_before),
                ),
              ),
              FloatingActionButton(
                onPressed: () async {
                  controller.stepperIndex.value == 0
                      ? await controller
                          .validateEmail(controller.emailFocus,
                              controller.emailEditingController.text)
                          .then((value) {
                          print(value);
                          if (value == 'ok') {
                            controller.stepperIndex.value++;
                            FocusManager.instance.primaryFocus?.unfocus();
                          } else {
                            Fluttertoast.showToast(msg: value);
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                        })
                      : controller.stepperIndex.value == 1
                          ? await controller
                              .validatePassword(controller.pwdFocus,
                                  controller.pwdEditingController.text)
                              .then((value) {
                              print(value);
                              if (value == 'ok') {
                                controller.stepperIndex.value++;
                                FocusManager.instance.primaryFocus?.unfocus();
                              } else {
                                Fluttertoast.showToast(msg: value);
                                FocusManager.instance.primaryFocus?.unfocus();
                              }
                            })
                          : controller.validateStepThree().then((value) {
                              if (value == 'ok') {
                                controller.stepperIndex.value++;
                                FocusManager.instance.primaryFocus?.unfocus();
                              } else {
                                Fluttertoast.showToast(msg: value);
                                FocusManager.instance.primaryFocus?.unfocus();
                              }
                            });
                },
                child: Icon(Icons.navigate_next),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(
                () => controller.stepperIndex.value == 0
                    ? emailStep()
                    : controller.stepperIndex.value == 1
                        ? pwdStep()
                        : nickAndPhotoStep(),
              ))),
    );
  }

  Column emailStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '이메일',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 20),
        const Text(
          '이메일을 입력해주세요',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        TextField(
          focusNode: controller.emailFocus,
          controller: controller.emailEditingController,
          decoration: const InputDecoration(
            labelText: '이메일',
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(width: 1, color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(width: 1, color: Colors.black),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        )
      ],
    );
  }

  Column pwdStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '비밀번호',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 20),
        const Text(
          '비밀번호 입력해주세요',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        TextField(
          obscureText: true,
          focusNode: controller.pwdFocus,
          controller: controller.pwdEditingController,
          decoration: const InputDecoration(
            labelText: '비밀번호',
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(width: 1, color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(width: 1, color: Colors.black),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
          ),
          //keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        const Text(
          '비밀번호를 확인해주세요',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        TextField(
          obscureText: true,
          focusNode: controller.pwdCheckFocus,
          controller: controller.pwdCheckEditingController,
          decoration: const InputDecoration(
            labelText: '비밀번호 확인',
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(width: 1, color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(width: 1, color: Colors.black),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
          ),
          //keyboardType: TextInputType.emailAddress,
        )
      ],
    );
  }

  Column nickAndPhotoStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '기타 정보',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 20),
        const Text(
          '프로필 사진을 업로드 해주세요',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                controller.selectGender.value = 'M';
              },
              child: Container(
                width: 120,
                height: 48,
                child: Center(
                    child: Text(
                  '남자',
                  style: TextStyle(
                      color: controller.selectGender.value == 'M'
                          ? Colors.teal
                          : Colors.black),
                )),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: controller.selectGender.value == 'M'
                            ? Colors.teal
                            : Colors.black)),
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.selectGender.value = 'W';
              },
              child: Container(
                width: 120,
                height: 48,
                child: Center(
                    child: Text('여자',
                        style: TextStyle(
                            color: controller.selectGender.value == 'W'
                                ? Colors.teal
                                : Colors.black))),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: controller.selectGender.value == 'W'
                            ? Colors.teal
                            : Colors.black)),
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          '프로필 사진을 업로드 해주세요',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        Obx(
          () => controller.selectImage.isEmpty
              ? IconButton(
                  iconSize: 100,
                  onPressed: () async {
                    await controller.selectImagePicker();
                  },
                  icon: Icon(Icons.add_box_outlined))
              : GestureDetector(
                  onTap: () async {
                    await controller.selectImagePicker();
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      //border: Border.all(color: Colors.blue),
                      image: DecorationImage(
                          image: FileImage(File(controller.selectImage.first)),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 20),
        const Text(
          '닉네임을 입력해주세요',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        TextField(
          focusNode: controller.nicknameFocus,
          controller: controller.nickEditingController,
          decoration: const InputDecoration(
            labelText: '닉네임',
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(width: 1, color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(width: 1, color: Colors.black),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
          ),
          keyboardType: TextInputType.text,
        )
      ],
    );
  }
}
