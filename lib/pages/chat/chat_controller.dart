import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:quranschool/core/db_links/db_links.dart';

import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/chat/models/studentsubscription_model.dart';

class ChatController extends GetxController {
  var studSubdata = <StudSubModel>[].obs;

  var isLoading = false.obs;

  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());

  @override
  void onInit() {
    super.onInit();
  }

  _failmessage(response) async {
    isLoading(false);

    Get.snackbar('${response.statusCode}', 'fetch_failed'.tr,
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
  }

// Get Availity First then Get Sessions then generate Meeting to be showed
  Future getchatList() async {
    isLoading.value = true;
    // String? _url;
    // if (currentUserController.currentUser.value.userType == "teacher") {
    //   _url = studsubUrl +currentUserController.currentUser.value.userType+"="+studsubUrl +currentUserController.currentUser.value.id.toString();
    // } else if ((currentUserController.currentUser.value.userType == "student")) {
    //   _url = studsubUrl + id.toString();
    // }
    print(currentUserController.currentUser.value.userType +
        "=" +
        studsubUrl +
        currentUserController.currentUser.value.id.toString());
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
      }
      // Now  call Session
      isLoading.value = false;

      // Get.to(const ShowResult());
    } else {
      _failmessage(response);
      isLoading.value = false;
    }
    isLoading.value = false;

    return studSubdata;
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
}
