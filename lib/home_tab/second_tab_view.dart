import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:testpro/home_tab/second_tab_controller.dart';
import 'package:testpro/login/home_controller.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SecondTabView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if(controller.eventsMain[DateTime.utc(controller.focusedDay.value.year,DateTime.now().month,DateTime.now().day)]==null){
            await uploadTodayWorkOut(context);
          }else{
            Fluttertoast.showToast(msg: '이미 오운완 했습니다!');
          }

        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('오운완'),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoading.value == true
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                    ),
                    Obx(
                      () => controller.isLoading.value == true
                          ? Center(child: CircularProgressIndicator())
                          : TableCalendar(
                              headerStyle: HeaderStyle(
                                titleCentered: true,
                                formatButtonVisible: false,
                              ),
                              locale: 'ko-KR',
                              onPageChanged: (day) {

                                controller.selectedDay.value = day;
                                controller.focusedDay.value = day;
                              },
                              focusedDay: controller.focusedDay.value,
                              firstDay: DateTime.utc(2022, 1, 1),
                              lastDay: DateTime.utc(2030, 3, 14),
                              onDaySelected:
                                  (DateTime selectedDay, DateTime focusedDay) {
                                controller.selectedDay.value = selectedDay;
                                controller.focusedDay.value = focusedDay;
                              },
                              eventLoader: controller.getEventsForDay,
                              selectedDayPredicate: (DateTime day) {
                                return isSameDay(
                                    controller.selectedDay.value, day);
                              },
                            ),
                    ),
                    Obx(() => Container(
                            width: 300,
                            height: 300,
                            child: controller.eventsMain[DateTime.utc(
                                        controller.selectedDay.value.year,
                                        controller.selectedDay.value.month,
                                        controller.selectedDay.value.day)] ==
                                    null
                                ? Container(
                                    child: Center(
                                        child: Text(
                                      '텅텅!!',
                                      style: TextStyle(fontSize: 30),
                                    )),
                                  )
                                : PageView.builder(
                                    controller: PageController(initialPage: 0),
                                    itemCount: controller
                                        .eventsMain[DateTime.utc(
                                            controller.selectedDay.value.year,
                                            controller.selectedDay.value.month,
                                            controller.selectedDay.value.day)]!
                                        .first
                                        .title
                                        .length,
                                    itemBuilder: (BuildContext context, index) {
                                      return Container(
                                        width: 300,
                                        height: 300,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: controller
                                              .eventsMain[DateTime.utc(
                                                  controller
                                                      .selectedDay.value.year,
                                                  controller
                                                      .selectedDay.value.month,
                                                  controller
                                                      .selectedDay.value.day)]!
                                              .first
                                              .title[index],
                                          placeholder: (context, url) => Container(
                                              color: Colors.transparent,
                                              height: 100,
                                              width: 100,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator())),
                                        ),
                                        // decoration: BoxDecoration(
                                        //   image: DecorationImage(
                                        //       image: NetworkImage(controller
                                        //           .eventsMain[DateTime.utc(
                                        //               controller
                                        //                   .selectedDay.value.year,
                                        //               controller
                                        //                   .selectedDay.value.month,
                                        //               controller
                                        //                   .selectedDay.value.day)]!
                                        //           .first
                                        //           .title[index]),
                                        //       fit: BoxFit.cover),
                                        // ),
                                      );
                                    }),
                          )),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
      ),
    );
  }

  uploadTodayWorkOut(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(mainAxisSize: MainAxisSize.max),
              Text('${DateFormat('yyyy년 MM월 dd일').format(DateTime.now())} 오운완'),
              GestureDetector(
                onTap: () async {
                  await controller.selectImagePicker();
                },
                child: Obx(
                  () => controller.selectImage.isEmpty
                      ? Container(
                          width: MediaQuery.of(context).size.width - 32,
                          height: MediaQuery.of(context).size.width - 32,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.blue),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width - 32,
                          height: MediaQuery.of(context).size.width - 32,
                          child: PageView.builder(
                              controller: PageController(initialPage: 0),
                              itemCount: controller.selectImage.length,
                              itemBuilder: (BuildContext context, index) {
                                return Container(
                                  width: MediaQuery.of(context).size.width - 32,
                                  height:
                                      MediaQuery.of(context).size.width - 32,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(File(
                                              controller.selectImage[index])),
                                          fit: BoxFit.cover)),
                                );
                              }),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () async {
                    await controller.uploadTodayHealth();
                  },
                  child: Container(
                    height: 56,
                    child: const Center(child: Text('오운완!')),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blue,
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }
}

class Event {
  String title;

  Event(this.title);
}
