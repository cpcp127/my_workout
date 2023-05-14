import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testpro/home_view.dart';
import 'package:testpro/login/home_controller.dart';
import 'package:testpro/login/login_controller.dart';
import 'package:testpro/register/register_email_controller.dart';
import 'package:testpro/register/register_emali_view.dart';
import 'package:testpro/register/register_stepper_controller.dart';
import 'package:testpro/register/register_stepper_view.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('로그인'),
            _buildTextField('이메일', controller.emailEditingController),
            _buildTextField('비밀번호', controller.pwdEditingController),
            //Expanded(child: SizedBox()),
            GestureDetector(
              onTap: () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: controller.emailEditingController.text,
                          password: controller
                              .pwdEditingController.text) //아이디와 비밀번호로 로그인 시도
                      .then((value) {
                    print(value);
                    if (value.user!.emailVerified == true) {
                      controller.box.write('auto_login_email', controller.emailEditingController.text);
                      Get.put(HomeController());
                      Get.to(() => HomeView());
                    } else {
                      print('이메일 확인 안댐');
                    }
                    return value;
                  });
                } on FirebaseAuthException catch (e) {
                  //로그인 예외처리
                  if (e.code == 'user-not-found') {
                    print('등록되지 않은 이메일입니다');
                  } else if (e.code == 'wrong-password') {
                    print('비밀번호가 틀렸습니다');
                  } else {
                    print(e.code);
                  }
                }
              },
              child: Text('로그인'),
            ),
            SizedBox(height: 20),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: SignInWithAppleButton(
            //     onPressed: () async {
            //       controller.signInWithApple();
            //     },
            //   ),
            // ),
            // SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                //
                Get.put(RegisterStepperController());
                Get.to(() => RegisterStepperView());
              },
              child: Text('회원가입'),
            )
          ],
        ),
      ),
    );
  }

  Padding _buildTextField(
      String label, TextEditingController textEditingController) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            labelText: label,
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
        ));
  }
}
