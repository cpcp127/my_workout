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
      resizeToAvoidBottomInset: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Visibility(
                visible: controller.stepperIndex.value == 0 ? false : true,
                child: FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: () {
                    controller.stepperIndex.value--;
                  },
                  child: const Icon(Icons.navigate_before),
                ),
              ),
              FloatingActionButton(
                heroTag: "btn2",
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
                          : controller.stepperIndex.value == 2
                              ? controller.stepperIndex.value++
                              : controller.validateStepThree().then((value) {
                                print(value);
                                  if (value == 'ok') {
                                    //controller.stepperIndex.value++;
                                    showDialog(
                                      // The user CANNOT close this dialog  by pressing outsite it
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (_) {
                                          return Dialog(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 16),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('회원가입중...',style: TextStyle(fontSize: 20),),
                                                  SizedBox(height: 8),
                                                  CircularProgressIndicator(),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                    );
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    controller.fireAuthLogin(context).whenComplete((){
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    Fluttertoast.showToast(msg: value);
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  }
                                });
                },
                child:
                Obx(()=>
                controller.stepperIndex.value != 3
                      ? Icon(Icons.navigate_next)
                      : Icon(Icons.check),
                ),

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
                        : controller.stepperIndex.value == 2
                            ? myWorkOutStep(context)
                            : infoStep(),
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

  Column myWorkOutStep(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '나의 운동',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 20),
        const Text(
          '내가 주로 하는 운동을 선택 해주세요',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        Obx(
          () => Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            children: List<Widget>.generate(
              controller.chipLabel.length,
              (index) => ChoiceChip(
                pressElevation: 0.0,
                //backgroundColor: Colors.grey[100],
                label: Text(controller.chipLabel[index]),
                selected: controller.chipIndex.value == index,
                onSelected: (bool selected) {
                  controller.chipIndex.value = (selected ? index : null)!;
                  controller.selectChipLabel.value =
                      controller.chipLabel[index];
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column infoStep() {
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
          '닉네임을 입력해주세요',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        TextField(
          focusNode: controller.nicknameFocus,
          controller: controller.nickEditingController,
          maxLength: 8,
          decoration: const InputDecoration(
            labelText: '닉네임',
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(width: 1 ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(width: 1),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
          ),
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 20),
        const Text(
          '프로필 사진을 업로드 해주세요',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        Obx(
          () => controller.selectImage.isEmpty
              ? GestureDetector(
                  onTap: () async {
                    await controller.selectImagePicker();
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    child: const Center(
                      child: Text(
                        '사진을 업로드\n해주세요',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black)),
                  ),
                )
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
      ],
    );
  }
}
