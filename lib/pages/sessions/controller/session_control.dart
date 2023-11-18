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
import 'package:quranschool/pages/sessions/videoScreen.dart';
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

  var isLoading = false.obs;
  var isScreenSharing = false.obs;
  var selectedMeeting = Meeting("", DateTime.now(), DateTime.now(),
          Colors.black, true, true, -1, -1, -1, "", -1, "", -1)
      .obs;

  // late Rx<AgoraClient> agoraclient = AgoraClient(
  //         agoraConnectionData:
  //             AgoraConnectionData(appId: "appId", channelName: "channelName"))
  //     .obs;
  var agoraEngine = createAgoraRtcEngine().obs;
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());

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
