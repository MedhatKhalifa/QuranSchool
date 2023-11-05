import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:get/get.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:intl/intl.dart';

class ChatDetail extends StatefulWidget {
  final friendUid;
  final friendName;
  final currentuserName;
  final currentuserid;

  ChatDetail(
      {Key? key,
      this.friendUid,
      this.friendName,
      this.currentuserName,
      this.currentuserid})
      : super(key: key);

  @override
  _ChatDetailState createState() =>
      _ChatDetailState(friendUid, friendName, currentuserName, currentuserid);
}

class _ChatDetailState extends State<ChatDetail> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final friendUid;
  final friendName;
  final currentuserName;
  final currentuserid;
  //final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());

  var chatDocId;
  var _textController = new TextEditingController();
  _ChatDetailState(this.friendUid, this.friendName, this.currentuserName,
      this.currentuserid);
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    await chats
        .where('users', isEqualTo: {friendUid: null, currentuserid: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
            if (querySnapshot.docs.isNotEmpty) {
              setState(() {
                chatDocId = querySnapshot.docs.single.id;
              });

              print(chatDocId);
            } else {
              await chats.add({
                'users': {currentuserid: null, friendUid: null},
                'names': {currentuserid: currentuserName, friendUid: friendName}
              }).then((value) {
                return {
                  setState(() {
                    chatDocId = value.id;
                  })
                };
              });
            }
          },
        )
        .catchError((error) {});
  }

  void sendMessage(String msg) {
    if (msg == '') return;
    chats.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uid': currentuserid,
      'friendName': friendName,
      'msg': msg
    }).then((value) {
      _textController.text = '';
    });
  }

  bool isSender(String friend) {
    return friend == currentuserid;
  }

  Alignment getAlignment(friend) {
    if (friend == currentuserid) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chats
          .doc(chatDocId)
          .collection('messages')
          .orderBy('createdOn', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Text("Loading"),
            ),
          );
        }

        if (snapshot.hasData) {
          var data;
          return Scaffold(
            appBar: simplAppbar(true, friendName),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      reverse: true,
                      children: snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                          data = document.data()!;
                          print(document.toString());
                          print(data['msg']);
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ChatBubble(
                              clipper: ChatBubbleClipper6(
                                nipSize: 0,
                                radius: 9,
                                type: isSender(data['uid'].toString())
                                    ? BubbleType.sendBubble
                                    : BubbleType.receiverBubble,
                              ),
                              alignment: getAlignment(data['uid'].toString()),
                              margin: EdgeInsets.only(top: 20),
                              backGroundColor: isSender(data['uid'].toString())
                                  ? mybrowonColor
                                  : Color(0xffE7E7ED),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(data['msg'],
                                            style: TextStyle(
                                                fontSize: sp(10),
                                                color: isSender(
                                                        data['uid'].toString())
                                                    ? Colors.white
                                                    : Colors.black),
                                            maxLines: 100,
                                            overflow: TextOverflow.ellipsis)
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          data['createdOn'] == null
                                              ? DateFormat("yy-MM-dd HH:mm")
                                                  .format(DateTime.now())
                                              : DateFormat("yy-MM-dd HH:mm")
                                                  .format(data['createdOn']
                                                      .toDate()),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: isSender(
                                                      data['uid'].toString())
                                                  ? Colors.white
                                                  : Colors.black),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  Container(
                    // height: 50,
                    margin: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Color.fromARGB(255, 134, 134, 136),
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Container(
                        //   margin: const EdgeInsets.only(
                        //       left: 8.0, right: 8.0, bottom: 12.0),
                        //   child: Transform.rotate(
                        //       angle: 45,
                        //       child: const Icon(
                        //         Icons.attach_file_sharp,
                        //         color: Colors.white,
                        //       )),
                        // ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextFormField(
                              controller: _textController,
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 6,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Type your message...',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 11.0),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: GestureDetector(
                              onTap: () {
                                sendMessage(_textController.text);
                              },
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
