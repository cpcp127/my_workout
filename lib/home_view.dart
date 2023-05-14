import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:testpro/home_tab/first_tab_view.dart';
import 'package:testpro/home_tab/second_tab_view.dart';
import 'package:testpro/home_tab/third_tab_view.dart';
import 'package:testpro/login/home_controller.dart';
import 'package:testpro/model/user_model.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // bottomNavigationBar: CurvedNavigationBar(
        //   index: 1,
        //   backgroundColor: Colors.blueAccent,
        //   items: <Widget>[
        //     Icon(Icons.add, size: 30),
        //     Icon(Icons.accessibility_new_outlined, size: 30),
        //     Icon(Icons.compare_arrows, size: 30),
        //   ],
        //   onTap: (index) {
        //     //Handle button tap
        //     controller.tabIndex.value = index;
        //   },
        // ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index){
          controller.tabIndex.value = index;
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.add), label: '하나'),
          NavigationDestination(icon: Icon(Icons.accessibility_new_outlined), label: '둘'),
          NavigationDestination(icon: Icon(Icons.compare_arrows), label: '셋'),
        ],
      ),
        body: Obx(() => controller.tabIndex.value == 0
            ? FirstTabView()
            : controller.tabIndex.value == 1
                ? SecondTabView()
                : ThirdTabView()));
  }
}
