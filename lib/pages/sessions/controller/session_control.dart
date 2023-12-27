import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
//import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:quranschool/core/db_links/db_links.dart';

import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';

import 'package:quranschool/pages/search/model/searchwords_model.dart';
import 'package:quranschool/pages/search/show_result.dart';
import 'package:quranschool/pages/sessions/sessionsShow.dart';
import 'package:quranschool/pages/sessions/videoScreen.dart';
import 'package:quranschool/pages/student/subscription/control/subscription_controller.dart';
import 'package:quranschool/pages/student/subscription/models/subscriptionPrice_model.dart';
import 'package:quranschool/pages/teacher/model/availability_model.dart';
import 'package:quranschool/pages/teacher/model/meeting_model.dart';
import 'package:quranschool/pages/teacher/model/sessions_model.dart';
import 'package:quranschool/pages/teacher/model/teacher_model.dart';
import 'package:intl/intl.dart';

class MySesionController extends GetxController {
  var sessions = <Session>[].obs;

  var meetings = <Meeting>[].obs;
  var token = "".obs;
  var channelname = "".obs;
  var feedbackEdit = false.obs;

  var isLoading = false.obs;
  var isNextSessionloading = true.obs;
  var remainingSessions = -1.obs;
  var isScreenSharing = false.obs;
  var selectedMeeting = Meeting("", DateTime.now(), DateTime.now(),
          Colors.black, true, true, -1, -1, -1, "", -1, "", -1, "", "")
      .obs;

  var nextSession = Session().obs;
  var selectedSession = Session().obs;

  var diffMinutes = 0.obs;
  // late Rx<AgoraClient> agoraclient = AgoraClient(
  //         agoraConnectionData:
  //             AgoraConnectionData(appId: "appId", channelName: "channelName"))
  //     .obs;
  var agoraEngine = createAgoraRtcEngine().obs;
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());

  final SubscribitionController subscribitionController =
      Get.put(SubscribitionController());

  @override
  void onInit() {
    super.onInit();
  }

  late RtcEngine _engine;

  Future getMySesions() async {
    sessions.clear();
    meetings.clear();
    String? _url;
    if (currentUserController.currentUser.value.userType == "teacher") {
      _url = sessionTeacherUrl +
          currentUserController.currentUser.value.id.toString();
    } else if ((currentUserController.currentUser.value.userType ==
        "student")) {
      _url = sessionStudentUrl +
          currentUserController.currentUser.value.id.toString();
    }
    isLoading.value = true;
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
      isLoading.value = false;

      // Now generate Meeting
      // if (selectedTeacher.value.user != null) {
      //   generateMetings();
      // }
      //    Get.to(const ShowResult());
    } else {
      isLoading.value = false;
      _failmessage(response);
    }
    isLoading.value = false;
    return sessions;
  }

  Future updateSessiondata(id,
      [String? sessionStatus,
      bool? teacherAttendance,
      int? studentRate,
      String? teacherOpinion,
      bool? studentAttendance,
      int? teacherRank,
      String? review]) async {
    String? _url;

    _url = updateSessionUrl + id.toString() + "/";

    isLoading.value = true;
    var dio = Dio();
    var response = await dio.put(
      _url!,
      data: {
        if (sessionStatus != null) 'sessionStatus': sessionStatus,
        if (teacherAttendance != null) 'teacherAttendance': teacherAttendance,
        if (studentRate != null) 'studentRate': studentRate,
        if (teacherOpinion != null) 'teacherOpinion': teacherOpinion,
        if (studentAttendance != null) 'studentAttendance': studentAttendance,
        if (teacherRank != null) 'teacherRank': teacherRank,
        if (review != null) 'review': review,

        //'accountToken': userctrl.currentUser.value.accountToken,
      },
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
      print(response.statusCode);
    } else {
      isLoading.value = false;
      _failmessage(response);
    }
    isLoading.value = false;
    return sessions;
  }

  Future updateMySession(Meeting _meeting) async {
    String? _url;

    _url = updateSessionUrl + _meeting.id.toString() + "/";

    isLoading.value = true;
    var dio = Dio();
    var response = await dio.put(
      _url!,
      data: {
        'student': _meeting.student.toString(),
        'teacher': _meeting.teacher.toString(),
        'sessionStatus': "Pending",
        'studentSubscription': "1",
        'date': DateFormat('yyyy-MM-dd').format(_meeting.from),
        'time': DateFormat('HH:m').format(_meeting.from),
        //'accountToken': userctrl.currentUser.value.accountToken,
      },
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
      // Send Notification to student
      sendNotification(
          _meeting.student,
          "Session time changed to " +
              DateFormat('HH:m').format(_meeting.from) +
              " " +
              DateFormat('HH:m').format(_meeting.from) +
              " ",
          "Change Session Time");
      subscribitionController.getSessionsbyteaherID(
          currentUserController.currentUser.value.id,
          currentUserController.currentUser.value.userType);
      Get.to(SessionsShow());
    } else {
      isLoading.value = false;
      _failmessage(response);
    }
    isLoading.value = false;
    return sessions;
  }

  /// Send Notification
  ///
  Future sendNotification(userprofileId, body, title) async {
    isLoading.value = true;
    var dio = Dio();
    var response = await dio.post(
      notificationUrl,
      data: {
        'body': body,
        'title': title,
        'userprofileId': userprofileId,
        'imgUrl':
            "https://i.ytimg.com/vi/m5WUPHRgdOA/hqdefault.jpg?sqp=-oaymwEXCOADEI4CSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLDwz-yjKEdwxvKjwMANGk5BedCOXQ",
        'iconUrl':
            'https://yt3.ggpht.com/ytc/AKedOLSMvoy4DeAVkMSAuiuaBdIGKC7a5Ib75bKzKO3jHg=s900-c-k-c0x00ffffff-no-rj',

        //'accountToken': userctrl.currentUser.value.accountToken,
      },
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
      // Send Notification to student
    } else {
      _failmessage(response);
    }
    isLoading.value = false;
  }

  getFirstSessionAfterNow() async {
    isNextSessionloading.value = true;
    await getMySesions();
    if (sessions.isNotEmpty) {
      DateTime now = DateTime.now();
      DateTime comparetime = now.subtract(Duration(minutes: 30));

      // Filter sessions that are after the current time
      final List<Session> futureSessions = sessions.where((session) {
        final DateTime sessionDateTime =
            DateTime.parse('${session.date} ${session.time}');
        return sessionDateTime.isAfter(comparetime);
      }).toList();

      // Sort the filtered sessions by date and time
      futureSessions.sort((a, b) {
        final DateTime aDateTime = DateTime.parse('${a.date} ${a.time}');
        final DateTime bDateTime = DateTime.parse('${b.date} ${b.time}');
        return aDateTime.compareTo(bDateTime);
      });

      // Return the first session after the current time, if any
      if (futureSessions.isNotEmpty) {
        nextSession.value = futureSessions.first;
        selectedSession.value = futureSessions.first;
        final DateTime sessionDateTime = DateTime.parse(
            '${nextSession.value.date} ${nextSession.value.time}');
        final Duration difference = sessionDateTime.difference(now);
        diffMinutes.value = difference.inMinutes;
        // get remaining sessions
        getRemainingsessions(nextSession.value.studentSubscription);
      } else {
        diffMinutes.value = -1000002; // no Feature Sessions
        isNextSessionloading.value = false;
      }
    } else {
      diffMinutes.value = -1000001; // No old nor future sesssion
      isNextSessionloading.value = false;
    }
  }

// get Remaining sessions

  Future getRemainingsessions(studentSubscriptionID) async {
    String? _url;

    isNextSessionloading.value = true;
    var dio = Dio();

    var response = await dio.get(
      studentsubscriptionsUrl + studentSubscriptionID.toString() + '/',
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 600;
        },
        //headers: {},
      ),
    );
    print(studentsubscriptionsUrl + studentSubscriptionID.toString() + '/');
    if (response.statusCode == 200) {
      //playerId
      print(response.data['remainingSessions']);
      remainingSessions = response.data['remainingSessions'];

      isNextSessionloading.value = false;
    } else {
      //isLoading.value = false;
      _failmessage(response);
    }
    // isLoading.value = false;
    isNextSessionloading.value = false;
  }

  // update remaining of student subcribtion

  Future updateRemainingsessions(studentSubscriptionID) async {
    String? _url;

    isNextSessionloading.value = true;
    var dio = Dio();

    var response = await dio.put(
      studentsubscriptionsUrl + studentSubscriptionID.toString() + '/',
      data: {'remainingSessions': remainingSessions - 1},
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 600;
        },
        //headers: {},
      ),
    );

    if (response.statusCode == 200) {
      //playerId

      remainingSessions = response.data['remainingSessions'];

      isNextSessionloading.value = false;
    } else {
      //isLoading.value = false;
      _failmessage(response);
    }
    // isLoading.value = false;
    isNextSessionloading.value = false;
  }

////////
  ///
  ///
  ///
  ///
  ///
  Future getToken(teacherID, studentID) async {
    String? _url;

    isLoading.value = true;
    var dio = Dio();

    var response = await dio.post(
      tokenUrl,
      data: {
        'studentID': studentID.toString(),
        'TeacherID': teacherID.toString(),
        //'accountToken': userctrl.currentUser.value.accountToken,
      },
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 600;
        },
        //headers: {},
      ),
    );

    if (response.statusCode == 200) {
      //playerId
      if (response.data['status']) {
        token.value = response.data['data']['token'];
        channelname.value = response.data['data']['channelname'];
        Get.to(VideoScreenCall(
            channelName: channelname.value, token: token.value));

        if (nextSession.value.teacherAttendance == false &&
            currentUserController.currentUser.value.userType == "teacher") {
          updateRemainingsessions(nextSession.value.studentSubscription);
        }
        currentUserController.currentUser.value.userType == "teacher"
            ? updateSessiondata(nextSession.value.id, null, true)
            : updateSessiondata(
                nextSession.value.id, null, null, null, null, true);
        // Enable video and screen sharing

        // //create an instance of the Agora engine
        // agoraEngine.value = createAgoraRtcEngine();
        // await agoraEngine.value.initialize(
        //     const RtcEngineContext(appId: "65a5460ed6af49978a85479fdd87fa13"));
        // // Set channel options including the client role and channel profile
        // ChannelMediaOptions options = const ChannelMediaOptions(
        //   clientRoleType: ClientRoleType.clientRoleBroadcaster,
        //   channelProfile: ChannelProfileType.channelProfileCommunication,
        // );
        // await agoraEngine.value.joinChannel(
        //   token: token.value,
        //   channelId: channelname.value,
        //   options: options,
        //   uid: 0,
        // );

        // agoraclient.value = AgoraClient(
        //     agoraConnectionData: AgoraConnectionData(
        //   appId: "65a5460ed6af49978a85479fdd87fa13",
        //   tempToken: token.value,
        //   channelName: channelname.value,
        // ));
        // await agoraclient.value.initialize();
        isLoading.value = false;
      }
    } else {
      //isLoading.value = false;
      _failmessage(response);
    }
    // isLoading.value = false;
    return sessions;
  }

  // Method to start screen sharing
  Future<void> startScreenSharing() async {
    await _engine.enableVideo();
    //await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    // await _engine.enableVideo();
    await _engine.startPreview();

    // agoraEngine.value.startScreenCapture(const ScreenCaptureParameters2(
    //     captureAudio: true,
    //     audioParams: ScreenAudioParameters(
    //         sampleRate: 16000, channels: 2, captureSignalVolume: 100),
    //     captureVideo: true,
    //     videoParams: ScreenVideoParameters(
    //         dimensions: VideoDimensions(height: 1280, width: 720),
    //         frameRate: 15,
    //         bitrate: 600)));

    // await _engine.enableVideo();
    // await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    // await _engine.enableVideo();
    // await _engine.startPreview();

    // _engine.startScreenCapture(const ScreenCaptureParameters2(
    //     captureAudio: true,
    //     audioParams: ScreenAudioParameters(
    //         sampleRate: 16000, channels: 2, captureSignalVolume: 100),
    //     captureVideo: true,
    //     videoParams: ScreenVideoParameters(
    //         dimensions: VideoDimensions(height: 1280, width: 720),
    //         frameRate: 15,
    //         bitrate: 600)));
    isScreenSharing.value = true;
  }

  // Method to stop screen sharing
  Future<void> stopScreenSharing() async {
    // Implement code to stop screen sharing
    // await _engine.stopScreenCapture();
    // await _engine.leaveChannel(); // Leave the channel
    await agoraEngine.value.leaveChannel();
    await agoraEngine.value.release();
    isScreenSharing.value = false;
  }

  _failmessage(response) async {
    isLoading(false);

    Get.snackbar('${response.statusCode}', 'fetch_failed'.tr,
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
  }
}
