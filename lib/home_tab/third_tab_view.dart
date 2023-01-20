import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:testpro/home_tab/third_tab_controller.dart';

class ThirdTabView extends GetView<ThirdTabController>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('세번째 탭'),
        centerTitle: true,
      ),
    );
  }

}