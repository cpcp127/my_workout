import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:testpro/home_tab/comment_controller.dart';

class CommentView extends GetView<CommentController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('댓글'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.refreshChangeListener.refreshed = true;
                },
                child: PaginateFirestore(
                    listeners: [
                      controller.refreshChangeListener,
                    ],
                    onEmpty: Container(),
                    itemBuilder: (context, snapshot, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              NetworkImage(snapshot[index]['user_photo']),
                        ),
                        title: Text(snapshot[index]['nickname']),
                        subtitle: Text(snapshot[index]['comment']),
                        trailing: Text(Jiffy(snapshot[index]['datetime'].toDate())
                            .fromNow(),),
                      );
                    },
                    query: FirebaseFirestore.instance
                        .collection('comment')
                        .doc('articles')
                        .collection(controller.articleId.value).orderBy('datetime',descending: true),
                    itemBuilderType: PaginateBuilderType.listView),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        controller.homeController.myUser.value.photoUrl!),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: controller.commentController,
                      decoration: const InputDecoration(
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
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('comment')
                            .doc('articles')
                            .collection(controller.articleId.value)
                            .add({
                          'nickname':controller.homeController.myUser.value.nickname,
                          'datetime':DateTime.now(),
                          'comment':controller.commentController.text,
                          'user_photo':controller.homeController.myUser.value.photoUrl,
                        }).then((value){
                          //comment 숫자 늘려주기
                          FirebaseFirestore.instance
                              .collection('articles')
                              .doc(controller.articleId.value)
                              .update({
                            'comment': FieldValue.increment(1),
                          });
                          controller.commentController.clear();
                          controller.refreshChangeListener.refreshed = true;
                          controller.homeController.refreshChangeListener.refreshed=true;
                        }).catchError((e){
                          Fluttertoast.showToast(msg: '댓글 등록 실패');
                        });

                      },
                      icon: Icon(Icons.send))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
