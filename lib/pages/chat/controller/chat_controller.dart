import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:quranschool/core/db_links/db_links.dart';

import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/chat/models/studentsubscription_model.dart';

class ChatController extends GetxController {
  var studSubdata = <StudSubModel>[].obs;
  var allsubdata = <StudSubModel>[].obs;
  RxBool isLoading = true.obs;
  var isLoadingall = true.obs;

  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());

// Add an observable for filtered friends
  var filteredFriends = <StudSubModel>[].obs;

  // Add a method to update filtered friends
  void updateFilteredFriends(List<StudSubModel> filteredList) {
    filteredFriends.assignAll(filteredList);
  }

  @override
  void onInit() {
    super.onInit();
  }

  _failmessage(response) async {
    Get.snackbar('${response.statusCode}', 'fetch_failed'.tr,
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
  }

// Get Availity First then Get Sessions then generate Meeting to be showed
  Future getchatList() async {
    isLoading.value = true;
    studSubdata.clear();
    filteredFriends.clear();

    // String? _url;
    // if (currentUserController.currentUser.value.userType == "teacher") {
    //   _url = studsubUrl +currentUserController.currentUser.value.userType+"="+studsubUrl +currentUserController.currentUser.value.id.toString();
    // } else if ((currentUserController.currentUser.value.userType == "student")) {
    //   _url = studsubUrl + id.toString();
    // }

    var dio = Dio();
    var response = await dio.get(
      studsubUrl +
          currentUserController.currentUser.value.userType +
          "=" +
          currentUserController.currentUser.value.id.toString(),
      options: Options(
        // followRedirects: false,
        validateStatus: (status) {
          return status! < 505;
        },
        //headers: {},
      ),
    );

    if (response.statusCode == 200) {
      // sessions = parseAvailabilitysfromListofMap(
      //     response.data.cast<Map<String, dynamic>>());

      if (response.data.length > 0) {
        List<Map<String, dynamic>> responseMapList =
            List<Map<String, dynamic>>.from(response.data);

        List<Map<String, dynamic>> uniqueList = [];

        for (var map in responseMapList) {
          bool isDuplicate = false;

          for (var uniqueMap in uniqueList) {
            if (map["teacherID"] == uniqueMap["teacherID"] &&
                map["studentID"] == uniqueMap["studentID"]) {
              isDuplicate = true;
              break;
            }
          }

          if (!isDuplicate) {
            uniqueList.add(map);
          }
        }

        // Parse the list of JSON objects into a list of Session objects
        List<StudSubModel> _temp = studSubModelfromListofMap(uniqueList);
        //_temp = _temp.toSet().toList();
        studSubdata.clear();
        studSubdata.assignAll(_temp);
        //  availabilities = _sessions.cast<Rx<Availability>>();

        List<String> unreadFriends = await checkUnreadMessages();

        setUnreadMessages(unreadFriends);
        sortStudSubModels();
        updateFilteredFriends(studSubdata);
        print(studSubdata);
      }
      // Now  call Session

      // updateloading(false);

      // Get.to(const ShowResult());
    } else {
      _failmessage(response);
    }

    isLoading.value = false;
    //updateloading(false);
    //return studSubdata;
  }

  void updateloading(newvalue) {
    isLoading.update((value) {
      // Modify the value here
      value = newvalue;
    });
  }

  Future<List<String>> checkUnreadMessages() async {
    var unreadFriends = <String>[];

    // Query all documents in the 'chats' collection
    var querySnapshot =
        await FirebaseFirestore.instance.collection('chats').get();
    for (var chat in studSubdata) {
      var currentuserid = currentUserController.currentUser.value.id.toString();
      var friendUid = chat.friendtID.toString();

      for (var doc in querySnapshot.docs) {
        var txMsg = doc['txMsg'];
        var rxMsg = doc['rxMsg'];

        // if (txMsg[currentuserid] != null && rxMsg[friendUid] != null) {
        //   var txTimestamp = (txMsg[currentuserid] as Timestamp).toDate();
        //   var rxTimestamp = (rxMsg[friendUid] as Timestamp).toDate();

        //   if (txTimestamp.isAfter(rxTimestamp)) {
        //     // Add friendUid to the list of unread messages
        //     unreadFriends.add(friendUid);
        //   }
        // }

        if (txMsg[friendUid] != null && rxMsg[currentuserid] != null) {
          var txTimestamp = (txMsg[friendUid] as Timestamp).toDate();
          var rxTimestamp = (rxMsg[currentuserid] as Timestamp).toDate();

          if (txTimestamp.isAfter(rxTimestamp)) {
            // Add currentuserid to the list of unread messages
            unreadFriends.add(friendUid);
          }
        }
      }
    }

    // Now unreadFriends contains the list of friends with unread messages
    print('Friends with unread messages: $unreadFriends');
    return unreadFriends;
  }

  void setUnreadMessages(unreadFriends) {
    for (var studSubModel in studSubdata) {
      if (unreadFriends.contains(studSubModel.friendtID.toString())) {
        studSubModel.unreadMsg = true;
      }
    }
  }

  void sortStudSubModels() {
    studSubdata.sort((a, b) {
      // Place entries with unread messages first
      if (a.unreadMsg && !b.unreadMsg) {
        return -1;
      } else if (!a.unreadMsg && b.unreadMsg) {
        return 1;
      }

      // If both have unread messages or both don't, maintain their current order
      return 0;
    });
  }

  void sortallsubbdate() {
    print(allsubdata);
    allsubdata.sort((a, b) => b.subscriptionDate.compareTo(a.subscriptionDate));
    print(allsubdata);
    // allsubdata.sort((a, b) {
    //   // Place entries with unread messages first
    //   if (a.unreadMsg && !b.unreadMsg) {
    //     return -1;
    //   } else if (!a.unreadMsg && b.unreadMsg) {
    //     return 1;
    //   }

    //   // If both have unread messages or both don't, maintain their current order
    //   return 0;
    // });
  }

  // void createDocID() async {
  //   await chats
  //       .where('users', isEqualTo: {friendUid: null, currentUserId: null})
  //       .limit(1)
  //       .get()
  //       .then(
  //         (QuerySnapshot querySnapshot) async {
  //           if (querySnapshot.docs.isNotEmpty) {
  //             setState(() {
  //               chatDocId = querySnapshot.docs.single.id;
  //             });

  //             print(chatDocId);
  //           } else {
  //             await chats.add({
  //               'users': {currentUserId: null, friendUid: null},
  //               'names': {
  //                 currentUserId: FirebaseAuth.instance.currentUser?.displayName,
  //                 friendUid: friendName
  //               }
  //             }).then((value) => {chatDocId = value});
  //           }
  //         },
  //       )
  //       .catchError((error) {});
  // }

  // Get Availity First then Get Sessions then generate Meeting to be showed
  Future getallSubList() async {
    isLoadingall.value = true;
    allsubdata.clear();
    filteredFriends.clear();

    var dio = Dio();
    var response = await dio.get(
      studsubUrl +
          currentUserController.currentUser.value.userType +
          "=" +
          currentUserController.currentUser.value.id.toString(),
      options: Options(
        // followRedirects: false,
        validateStatus: (status) {
          return status! < 505;
        },
        //headers: {},
      ),
    );

    if (response.statusCode == 200) {
      // sessions = parseAvailabilitysfromListofMap(
      //     response.data.cast<Map<String, dynamic>>());

      if (response.data.length > 0) {
        List<Map<String, dynamic>> responseMapList =
            List<Map<String, dynamic>>.from(response.data);

        List<StudSubModel> _temp = studSubModelfromListofMap(responseMapList);
        //_temp = _temp.toSet().toList();
        allsubdata.clear();
        allsubdata.assignAll(_temp);
        sortallsubbdate();
        updateFilteredFriends(allsubdata);

        print(allsubdata);
      }
      // Now  call Session
      isLoadingall.value = false;

      // Get.to(const ShowResult());
    } else {
      _failmessage(response);
      isLoadingall.value = false;
    }
    // isLoading.value = false;
    isLoadingall.value = false;

    //return studSubdata;
  }
}
