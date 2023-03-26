import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:testpro/home_tab/comment_controller.dart';
import 'package:testpro/home_tab/comment_view.dart';
import 'package:testpro/home_tab/first_tab_controller.dart';
import 'package:testpro/login/home_controller.dart';
import 'package:testpro/upload_feed/upload_feed_controller.dart';
import 'package:testpro/upload_feed/upload_feed_view.dart';
import 'package:easy_refresh/easy_refresh.dart';

class FirstTabView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('피드'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.lazyPut(() => UploadFeedController());
                Get.to(() => UploadFeedView());
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.refreshChangeListener.refreshed = true;
        },
        child: PaginateFirestore(
            listeners: [
              controller.refreshChangeListener,
            ],
            itemBuilder: (context, snapshot, index) {
              PageController pageController = PageController();
              DateTime date = DateTime.parse(
                  snapshot[index]['dateTime'].toDate().toString());
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            NetworkImage(snapshot[index]['user_photo']),
                      ),
                      const SizedBox(width: 4),
                      Text(snapshot[index]['nickname']),
                      const Expanded(child: SizedBox()),
                      IconButton(
                          onPressed: () {
                            Get.bottomSheet(
                              Container(
                                height: 250,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text('신고하기'),
                                      const SizedBox(height: 16),
                                      const Text('신고 이유를 써주세요'),
                                      const SizedBox(height: 16),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: TextFormField(
                                          controller: controller.claimEditingController,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          decoration: const InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: (){
                                                Get.back();
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                ),
                                                height: 56,
                                                child: Center(child: Text('취소'),),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: (){
                                                FirebaseFirestore.instance.collection('claims').add({
                                                  'article_id':snapshot[index].id,
                                                  'claim_reason':controller.claimEditingController.text,

                                                }).then((value){
                                                  Get.back();
                                                  Fluttertoast.showToast(msg: '신고 완료');
                                                }).catchError((e){
                                                  Fluttertoast.showToast(msg: '신고 실패');
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.red,
                                                ),
                                                height: 56,
                                                child: Center(child: Text('신고'),),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16)),
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.more_horiz)),
                    ],
                  ),
                  snapshot[index]['photoUrlList'].isEmpty
                      ? Container()
                      : Stack(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              child: PageView.builder(
                                controller: pageController,
                                itemCount:
                                    snapshot[index]['photoUrlList'].length,
                                itemBuilder: (context, pageviewIndex) {
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width,
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot[index]['photoUrlList']
                                          [pageviewIndex],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                          color: Colors.transparent,
                                          height: 100,
                                          width: 100,
                                          child: const Center(
                                              child:
                                                  CircularProgressIndicator())),
                                    ),
                                    // decoration: BoxDecoration(
                                    //     image: DecorationImage(
                                    //         image: NetworkImage(snapshot[index]
                                    //                 ['photoUrlList']
                                    //             [pageviewIndex]),
                                    //         fit: BoxFit.cover)),
                                  );
                                },
                              ),
                            ),
                            Positioned.fill(
                              top: 16,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: SmoothPageIndicator(
                                    effect: const WormEffect(
                                      activeDotColor: Colors.blue,
                                      dotColor: Colors.black,
                                    ),
                                    controller: pageController,
                                    count:
                                        snapshot[index]['photoUrlList'].length),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 10),
                  Text(snapshot[index]['description']),
                  Text(DateFormat('yyyy년 MM월 dd일').format(date).toString()),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          snapshot[index]['like']
                                  .contains(controller.myUser.value.nickname)
                              ? await FirebaseFirestore.instance
                                  .collection('articles')
                                  .doc(snapshot[index].id)
                                  .update({
                                  'like': FieldValue.arrayRemove(
                                      [controller.myUser.value.nickname]),
                                }).then((value) {
                                  controller.refreshChangeListener.refreshed =
                                      true;
                                })
                              : await FirebaseFirestore.instance
                                  .collection('articles')
                                  .doc(snapshot[index].id)
                                  .update({
                                  'like': FieldValue.arrayUnion(
                                      [controller.myUser.value.nickname]),
                                }).then((value) {
                                  controller.refreshChangeListener.refreshed =
                                      true;
                                });
                        },
                        icon: Icon(
                          snapshot[index]['like']
                                  .contains(controller.myUser.value.nickname)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                      Text(snapshot[index]['like'].length.toString()),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          print(snapshot[index].id);
                          //Get.put(CommentController());
                          Get.to(() => CommentView(),
                              arguments: snapshot[index].id);
                          Get.put(CommentController());
                        },
                        icon: const Icon(
                          Icons.comment,
                          color: Colors.black,
                        ),
                      ),
                      Text(snapshot[index]['comment'].toString()),
                    ],
                  ),
                  Divider(
                      thickness: 1,
                      height: 1,
                      color: Colors.grey.withOpacity(0.2)),
                  const SizedBox(height: 11),
                ],
              );
            },
            query: FirebaseFirestore.instance.collection('articles'),
            itemBuilderType: PaginateBuilderType.listView),
      ),
    );
  }
}
