import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:testpro/register/register_stepper_controller.dart';

class RegisterStepperView extends GetView<RegisterStepperController> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
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
            )
        ],
      ),
          )),
    );
  }
}
