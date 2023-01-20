import 'package:flutter/material.dart';
import 'package:get/get.dart';

showLoading() async {
  await Get.dialog(
    Stack(
      children: const [
        Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}

hideLoading(BuildContext context) {
  try {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  } catch (e) {}
}
