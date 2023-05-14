import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:testpro/register/register_email_controller.dart';

class RegisterEmailView extends GetView<RegisterEmailController> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text('프로필 이미지'),
                  GestureDetector(
                    onTap: () async {
                      await controller.selectImagePicker();
                    },
                    child: Obx(
                      () => controller.selectImage.isEmpty
                          ? Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                //border: Border.all(color: Colors.blue),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/plush_icon.png'),
                                    fit: BoxFit.cover),
                              ),
                            )
                          : Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                //border: Border.all(color: Colors.blue),
                                image: DecorationImage(
                                    image: FileImage(
                                        File(controller.selectImage.first)),
                                    fit: BoxFit.cover),
                              ),
                            ),
                    ),
                  ),
                  const Text('이메일'),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextField(
                        controller: controller.emailEditingController,
                        decoration: const InputDecoration(
                          labelText: '이메일',
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      )),
                  const Text('비밀번호'),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextFormField(
                        controller: controller.pwdEditingController,
                        decoration: const InputDecoration(
                          labelText: '비밀번호',
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '필수입력 사항입니다';
                          }
                          if (value.trim().length < 8) {
                            return '8자 이상으로 입력해주세요';
                          }
                        },
                      )),
                  const Text('닉네임'),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextField(
                        controller: controller.nickEditingController,
                        decoration: const InputDecoration(
                          labelText: '닉네임',
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                        ),
                      )),
                  const Text('성별'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              controller.selectGender.value = 'M';
                            },
                            child: Obx(
                              () => Container(
                                height: 56,
                                child: const Center(child: Text('남자')),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color:
                                            controller.selectGender.value == 'M'
                                                ? Colors.blue
                                                : Colors.black,
                                        width: 1)),
                              ),
                            ),
                          ),
                          flex: 1,
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: GestureDetector(
                              onTap: () {
                                controller.selectGender.value = 'W';
                              },
                              child: Obx(
                                () => Container(
                                  height: 56,
                                  child: const Center(child: Text('여자')),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color:
                                              controller.selectGender.value ==
                                                      'W'
                                                  ? Colors.blue
                                                  : Colors.black,
                                          width: 1)),
                                ),
                              )),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                  Obx(()=>
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 6,
                        children: List<Widget>.generate(
                          controller.chipLabel.length,
                              (index) => ChoiceChip(
                            pressElevation: 0.0,
                            selectedColor: Colors.blue,
                            backgroundColor: Colors.grey[100],
                            label: Text(controller.chipLabel[index]),
                            selected: controller.chipIndex.value == index,
                            onSelected: (bool selected){
                              controller.chipIndex.value = (selected ? index : null)!;
                              controller.selectChipLabel.value=controller.chipLabel[index];
                            },
                          ),
                        ),
                      ),
                  ),

                  // const Text('데드리프트'),
                  // buildTextFiled(controller.deadNode,
                  //     controller.deadEditingController, '데드리프트'),
                  // const Text('스쿼트'),
                  // buildTextFiled(controller.squartNode,
                  //     controller.squartEditingController, '스쿼트'),
                  // const Text('벤치프레스'),
                  // buildTextFiled(controller.benchNode,
                  //     controller.benchEditingController, '벤치프레스'),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: GestureDetector(
                      onTap: () {
                        //
                        controller.fireAuthLogin(context);
                        //FirebaseFirestore.instance.collection('users')
                      },
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.blue,
                        ),
                        child: const Center(child: Text('등록')),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildTextFiled(FocusNode focusNode,
      TextEditingController textEditingController, String label) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextField(
          focusNode: focusNode,
          controller: textEditingController,
          decoration: InputDecoration(
            labelText: label,
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(width: 1, color: Colors.black),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(width: 1, color: Colors.black),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
          ),
          keyboardType: TextInputType.number,
        ));
  }
}
