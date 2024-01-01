import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:quranschool/core/db_links/db_links.dart';

import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/notification/notification_model.dart';

class NotificationController extends GetxController {
  var allNotifications = <NotificationModel>[].obs;
  var isLoading = false.obs;

  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());

// Add an observable for filtered friends
  var filteredFriends = <NotificationModel>[].obs;

  // Add a method to update filtered friends
  void updateFilteredFriends(List<NotificationModel> filteredList) {
    filteredFriends.assignAll(filteredList);
  }

  @override
  void onInit() {
    super.onInit();
  }

  _failmessage(response) async {
    isLoading(false);

    Get.snackbar('${response.statusCode}', 'fetch_failed'.tr,
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
  }

  void sortallsubbdate() {
    print(allNotifications);
    allNotifications.sort((a, b) => b.date.compareTo(a.date));
    print(allNotifications);
  }

  Future getallSubList() async {
    isLoading.value = true;
    allNotifications.clear();
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

        List<NotificationModel> _temp =
            notificationModelfromListofMap(responseMapList);
        //_temp = _temp.toSet().toList();
        allNotifications.clear();
        allNotifications.assignAll(_temp);
        sortallsubbdate();
        // updateFilteredFriends(allNotifications);

        print(allNotifications);
      }
      // Now  call Session
      isLoading.value = false;

      // Get.to(const ShowResult());
    } else {
      _failmessage(response);
      isLoading.value = false;
    }
    // isLoading.value = false;
    isLoading.value = false;

    //return studSubdata;
  }
}
