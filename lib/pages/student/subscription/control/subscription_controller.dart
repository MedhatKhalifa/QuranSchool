import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:quranschool/core/db_links/db_links.dart';

import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';

import 'package:quranschool/pages/search/model/searchwords_model.dart';
import 'package:quranschool/pages/search/show_result.dart';
import 'package:quranschool/pages/student/subscription/models/subscriptionPrice_model.dart';
import 'package:quranschool/pages/teacher/model/availability_model.dart';
import 'package:quranschool/pages/teacher/model/meeting_model.dart';
import 'package:quranschool/pages/teacher/model/sessions_model.dart';
import 'package:quranschool/pages/teacher/model/teacher_model.dart';
import 'package:intl/intl.dart';

class SubscribitionController extends GetxController {
  Rx<Teacher> selectedTeacher = Teacher().obs;

  var sessions = <Session>[].obs;
  List<Rx<SubscriptionsPrice>> subscriptionsPrice = [SubscriptionsPrice().obs];
  Rx<SubscriptionsPrice> selectedsubscriptionsPrice = SubscriptionsPrice().obs;

  var availabilities = <Availability>[].obs;
  // var filteredSlots = <Availability>[].obs;
  var reservedSessions = <Session>[].obs;
  var reservedSessionsall = <Session>[].obs;
  var subPriceList = <SubscriptionsPrice>[].obs;
  var selectedMeetings = <Meeting>[].obs;
  var meetings = <Meeting>[].obs;
  var filteredReservedSessionsall = <Session>[].obs;
  var selectedPayement = SubscriptionsPrice().obs;
  var countofSelectSession = 0.obs;
  var studentSubscriptionId = 0.obs;
  var isLoading = false.obs;

  var isLoadingAvail = false.obs;
  var isLoadingsession = false.obs;
  var isLoadingmeetings = false.obs;
  var isLoadinpricelist = false.obs;
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());

  @override
  void onInit() {
    super.onInit();
  }

/////
  ///
  ///
  ///
  ///
  // get Day Name from date
  String getDayName(var date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('EEEE').format(dateTime);
  }

/////
  ///
  ///
  ///
  ///
// fluter free slots to selected date

  // filteronDay(var _selectedDate) {
  //   var _targetDay = getDayName(_selectedDate);
  //   List<Availability> _v =
  //       availabilities.where((slot) => slot.day == _targetDay).toList();
  //   print(_v);
  //   filteredSlots.clear();
  //   filteredSlots.assignAll(_v);

  //   // return availabilities
  //   //     .where((slot) => slot.value.day == _targetDay)
  //   //     .map((rxAvailability) => rxAvailability.value)
  //   //     .toList();
  // }

/////
  ///
  ///
  ///
// drop sessions from free slots
  // dropsession(date) {
  //   for (var s in sessions) {
  //     // Filter out the free slots based on date and time
  //     filteredSlots.removeWhere((slot) =>
  //         slot.day == getDayName(s.date!) &&
  //         DateTime.parse(date) == DateTime.parse(s.date!) &&
  //         slot.fromTime == s.time!);
  //   }
  //   print(filteredSlots);
  // }

/////
  ///
  ///
  ///
// drop sessions from free slots
  // filterDayandSession(var _selectedDate) {
  //   print(availabilities);
  //   print(sessions);
  //   filteronDay(_selectedDate);
  //   dropsession(_selectedDate);
  // }

  Future createStudentSubsc() async {
    try {
      isLoading(true);
      var dio = Dio();
      print(DateFormat('yyyy-MM-dd').format(DateTime.now()));
      var response = await dio.post(
        createstudentsubscriptionsUrl,
        data: {
          'student': currentUserController.currentUser.value.id,
          'subscription': selectedPayement.value.id,
          "teacher": selectedTeacher.value.id,
          "actualPrice": selectedPayement.value.price,
          "subscriptionDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
          "studentSubscriptionStatus": "Pending",
          "comment": "Teacher Name" +
              selectedTeacher.value.user!.fullName +
              "Teacher user Name is" +
              selectedTeacher.value.user!.username,

          //'gender': 'male',
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 600;
          },
          //headers: {},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // _redirectUser();
        studentSubscriptionId.value = response.data['id'];
        createSession();
      } else {
        _failmessage(response);
      }
    } finally {
      // isLoading.value = false;
    }
  }

  Future createSession() async {
    isLoading.value = true;
    var dio = Dio();

    for (Meeting selectedMeeting in selectedMeetings) {
      try {
        var response = await dio.post(
          creatSessionUrl,
          data: {
            'date': DateFormat('yyyy-MM-dd').format(selectedMeeting.from),
            'time': DateFormat('HH:mm').format(selectedMeeting.from),
            "sessionStatus": "Pending Approval",
            "teacher": selectedMeeting.teacher,
            "student": selectedMeeting.student,
            "studentSubscription": studentSubscriptionId.value,
            //'gender': 'male',
          },
          options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 600;
            },
            //headers: {},
          ),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // _redirectUser();
          print(response.statusCode);
        } else {
          _failmessage(response);
        }
      } finally {}
    }

    isLoading.value = false;
  }

  _failmessage(response) async {
    isLoading(false);

    Get.snackbar('${response.statusCode}', 'fetch_failed'.tr,
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
  }

// Get Availity First then Get Sessions then generate Meeting to be showed
  Future getAvaiTime() async {
    isLoadingAvail.value = true;
    isLoadingmeetings.value = true;
    var dio = Dio();
    var response = await dio.get(
      availTeacherUrl + selectedTeacher.value.id.toString(),
      options: Options(
        // followRedirects: false,
        validateStatus: (status) {
          return status! < 505;
        },
        //headers: {},
      ),
    );
    print(availTeacherUrl + selectedTeacher.value.user!.id.toString());
    // List<Teacher> teachers = [];
    if (response.statusCode == 200) {
      // sessions = parseAvailabilitysfromListofMap(
      //     response.data.cast<Map<String, dynamic>>());

      if (response.data.length > 0) {
        final List<Map<String, dynamic>> responseMapList =
            List<Map<String, dynamic>>.from(response.data);

        // Parse the list of JSON objects into a list of Session objects
        List<Availability> _avas =
            parseAvailabilitysfromListofMap(responseMapList);
        // Divide into intervals
        var _avas2 = generateIntervals(_avas);
        availabilities.clear();
        availabilities.assignAll(_avas2);
        //  availabilities = _sessions.cast<Rx<Availability>>();
      }
      // Now  call Session
      isLoadingAvail.value = false;
      getSessionsbyteaherID(selectedTeacher.value.user!.id, "teacher");
      // Get.to(const ShowResult());
    } else {
      _failmessage(response);
      isLoadingAvail.value = false;
    }
    isLoadingAvail.value = false;

    return sessions;
  }

  generateMetings() {
// Generate sessions for 90 days with inteval 30 min start from now
// store it in reservedSessionsall

    countofSelectSession.value = 0;
    var _sessionsall = generateDatetimeSessions(selectedTeacher.value.user!.id,
        currentUserController.currentUser.value.id, 90);
    reservedSessionsall.clear();
    filteredReservedSessionsall.clear();
    reservedSessionsall.assignAll(_sessionsall);

// Now keep matching between all generated sessions and Avaiability
// Store it in filteredReservedSessionsall
    for (var reservedSession in reservedSessionsall) {
      // bool shouldRemove = false;
      for (var availability in availabilities) {
        //print(getDayName(reservedSession.date));

        if (getDayName(reservedSession.date) == availability.day.toString() &&
            reservedSession.time == availability.fromTime) {
          filteredReservedSessionsall.add(reservedSession);
          // shouldRemove = true;
          break;
        }
      }
      // if (shouldRemove) {
      //   filteredReservedSessionsall.add(reservedSession);
      // }
    }

// Now Drop already buys sessions slots from filteredReservedSessionsall
// update filteredReservedSessionsall
    var sessionsToRemove =
        <Session>[]; // Create a list to store sessions to remove

    for (var reservedSession in filteredReservedSessionsall.toList()) {
      for (var s in sessions) {
        if (DateTime.parse(
                reservedSession.date! + " " + reservedSession.time!) ==
            DateTime.parse(s.date! + " " + s.time!)) {
          sessionsToRemove.add(reservedSession); // Add the session to remove
          break; // Exit the inner loop once a match is found
        }
      }
    }

// Remove the sessions marked for removal
    filteredReservedSessionsall
        .removeWhere((session) => sessionsToRemove.contains(session));

    /// Create Meetings

    // Clear all instances of the Meeting class.
    meetings.clear();
    for (var s in filteredReservedSessionsall) {
      meetings.add(Meeting(
          "",
          DateTime.parse(s.date! + " " + s.time!),
          DateTime.parse(s.date! + " " + s.time!).add(Duration(minutes: 30)),
          Colors.grey,
          false,
          false,
          s.teacher!,
          s.student!));
    }
    // print(meetings);
    isLoadingmeetings.value = false;

// filter on avaiability only if day name of date of session == Day of Aviability and start time of sessions == time of avail
    // filteronDayinallsessions();
  }

  Future getSessionsbyteaherID(int id, String search) async {
    String? _url;
    if (search == "teacher") {
      _url = sessionTeacherUrl + id.toString();
    } else if ((search == "student")) {
      _url = sessionStudentUrl + id.toString();
    }
    isLoadingsession.value = true;
    var dio = Dio();
    var response = await dio.get(
      _url!,
      options: Options(
        // followRedirects: false,
        validateStatus: (status) {
          return status! < 505;
        },
        //headers: {},
      ),
    );
    // List<Teacher> teachers = [];
    if (response.statusCode == 200) {
      //playerId
      if (response.data.length > 0) {
        // Ensure that the input parameter is of type List<Map<String, dynamic>>
        final List<Map<String, dynamic>> responseMapList =
            List<Map<String, dynamic>>.from(response.data);

        // Parse the list of JSON objects into a list of Session objects
        List<Session> _sessions = parseSessionsfromListofMap(responseMapList);
        var _sessions3 = parseSessionsfromListofMap(responseMapList);
        sessions.clear();
        sessions.assignAll(_sessions3);
      }
      isLoadingsession.value = false;

      // Now generate Meeting
      if (selectedTeacher.value.user != null) {
        generateMetings();
      }
      //    Get.to(const ShowResult());
    } else {
      isLoadingsession.value = false;
      _failmessage(response);
    }
    isLoadingsession.value = false;
    return sessions;
  }

  /// Get Subscription Price
  ///
  Future getSubscribitonList() async {
    isLoadinpricelist.value = true;
    isLoadingmeetings.value = true;
    var dio = Dio();
    var response = await dio.get(
      subscriptionsUrl,
      options: Options(
        // followRedirects: false,
        validateStatus: (status) {
          return status! < 505;
        },
        //headers: {},
      ),
    );
    // List<Teacher> teachers = [];
    if (response.statusCode == 200) {
      //playerId
      if (response.data.length > 0) {
        // Ensure that the input parameter is of type List<Map<String, dynamic>>
        final List<Map<String, dynamic>> responseMapList =
            List<Map<String, dynamic>>.from(response.data);

        // Parse the list of JSON objects into a list of Session objects
        // List<SubscriptionsPrice> _subscriptionsPrices = parseSessionsfromListofMap(responseMapList);
        var _sublist = parseSubscriptionsPricesfromListofMap(responseMapList);
        subPriceList.clear();
        subPriceList.assignAll(_sublist);

        isLoadinpricelist.value = false;
        // isLoading.value = false;
        // sessions = parseAvailabilitysfromListofMap(
        //     response.data.cast<Map<String, dynamic>>());
      }
      //    Get.to(const ShowResult());
    } else {
      // isLoading.value = false;
      _failmessage(response);
      isLoadinpricelist.value = false;
    }
    isLoadinpricelist.value = false;
    return sessions;
  }
}
