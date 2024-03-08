import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/Auth/controller/sharedpref_function.dart';
import 'package:quranschool/pages/Auth/profile/profile_page.dart';
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

  var chatDocId = 'soKQFOTEAd8W52nlBJap';
  var _textController = new TextEditingController();
  _ChatDetailState(this.friendUid, this.friendName, this.currentuserName,
      this.currentuserid);
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  // Add a new field to store last read timestamp in the user's document
  void updateLastReadTimestamp(String userId) {
    chats.doc(chatDocId).update({
      'users.$userId.lastReadTimestamp': FieldValue.serverTimestamp(),
    });
  }

  void checkUser() async {
    try {
      await chats
          .where('users', isEqualTo: {friendUid: null, currentuserid: null})
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) async {
            if (querySnapshot.docs.isNotEmpty) {
              setState(() {
                chatDocId = querySnapshot.docs.single.id;
              });
              print(chatDocId);
            } else {
              // Document not found, add a new one
              await createNewChatDocument();
            }
          })
          .catchError((error) {
            print("Error getting documents: $error");
          });
    } catch (error) {
      print("General error: $error");
    }
  }

  Future<void> createNewChatDocument() async {
    try {
      final newDocumentRef = await chats.add({
        'users': {currentuserid: null, friendUid: null},
        'names': {currentuserid: currentuserName, friendUid: friendName},
        'txMsg': {
          currentuserid: FieldValue.serverTimestamp(),
          friendUid: FieldValue.serverTimestamp()
        },
        'rxMsg': {
          currentuserid: FieldValue.serverTimestamp(),
          friendUid: FieldValue.serverTimestamp()
        },
      });
      setState(() {
        chatDocId = newDocumentRef.id;
      });
    } catch (error) {
      print("Error adding document: $error");
    }
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
      FirebaseFirestore.instance.collection('chats').doc(chatDocId).update({
        'txMsg.$currentuserid': FieldValue.serverTimestamp(),
      });
      // updateLastReadTimestamp(currentuserid);
    });

    // Update lastMessageTimestamp in the 'names' collection
    FirebaseFirestore.instance.collection('users').doc(friendUid).set({
      'lastMessageTimestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  void checkUnreadMessages() async {
    var unreadFriends = <String>[];

    // Query all documents in the 'chats' collection
    var querySnapshot =
        await FirebaseFirestore.instance.collection('chats').get();

    for (var doc in querySnapshot.docs) {
      var txMsg = doc['txMsg'];
      var rxMsg = doc['rxMsg'];

      if (txMsg[currentuserid] != null && rxMsg[friendUid] != null) {
        var txTimestamp = (txMsg[currentuserid] as Timestamp).toDate();
        var rxTimestamp = (rxMsg[friendUid] as Timestamp).toDate();

        if (txTimestamp.isAfter(rxTimestamp)) {
          // Add friendUid to the list of unread messages
          unreadFriends.add(friendUid);
        }
      }

      if (txMsg[friendUid] != null && rxMsg[currentuserid] != null) {
        var txTimestamp = (txMsg[friendUid] as Timestamp).toDate();
        var rxTimestamp = (rxMsg[currentuserid] as Timestamp).toDate();

        if (txTimestamp.isAfter(rxTimestamp)) {
          // Add currentuserid to the list of unread messages
          unreadFriends.add(currentuserid);
        }
      }
    }

    // Now unreadFriends contains the list of friends with unread messages
    print('Friends with unread messages: $unreadFriends');
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
    return WillPopScope(
      onWillPop: () async {
        // Execute your function here before popping the screen
        // For example, you can call the checkUnreadMessages function
        currentUserController.currentUser.value = await loadUserData('user');
        chatController.getchatList();
        // Return true to allow the screen to be popped
        return true;
      },
      child: StreamBuilder<QuerySnapshot>(
        stream: chats
            .doc(chatDocId)
            .collection('messages')
            .orderBy('createdOn', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("fetch_failed".tr),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                body: Center(
              child: LoadingBouncingGrid.circle(
                borderColor: mybrowonColor,
                backgroundColor: Colors.white,
                // borderSize: 3.0,
                // size: sp(20),
                // backgroundColor: Color(0xff112A04),
                //  duration: Duration(milliseconds: 500),
              ),
            ));
          }

          if (snapshot.hasData) {
            var data;
            // Update rxMsg.currentuserid in the document
            FirebaseFirestore.instance
                .collection('chats')
                .doc(chatDocId)
                .update({
              'rxMsg.$currentuserid': FieldValue.serverTimestamp(),
            });
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
                                backGroundColor:
                                    isSender(data['uid'].toString())
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
                                                  color: isSender(data['uid']
                                                          .toString())
                                                      ? Colors.white
                                                      : Colors.black),
                                              maxLines: 100,
                                              overflow: TextOverflow.ellipsis)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
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
                                decoration: InputDecoration(
                                  hintText: 'type_message'.tr,
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
      ),
    );
  }
}
