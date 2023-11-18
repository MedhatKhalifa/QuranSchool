// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:quranschool/pages/Auth/Model/users.dart';
// import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
// import 'package:quranschool/pages/common_widget/simple_appbar.dart';
// import 'package:quranschool/pages/sessions/session_control.dart';

// class MyVideoCall extends StatefulWidget {
//   const MyVideoCall({super.key});

//   @override
//   State<MyVideoCall> createState() => _MyVideoCallState();
// }

// class _MyVideoCallState extends State<MyVideoCall> {
//   final CurrentUserController currentUserController =
//       Get.put(CurrentUserController());

//   final MySesionController mySesionController = Get.put(MySesionController());
//   bool _isScreenShared = false;
//   late final RtcEngine agoraEngine;
//   Future<void> shareScreen() async {
//     setState(() {
//       _isScreenShared = !_isScreenShared;
//     });

//     if (_isScreenShared) {
//       // Start screen sharing
//       agoraEngine.startScreenCapture(const ScreenCaptureParameters2(
//           captureAudio: true,
//           audioParams: ScreenAudioParameters(
//               sampleRate: 16000, channels: 2, captureSignalVolume: 100),
//           captureVideo: true,
//           videoParams: ScreenVideoParameters(
//               dimensions: VideoDimensions(height: 1280, width: 720),
//               frameRate: 15,
//               bitrate: 600)));
//     } else {
//       await agoraEngine.stopScreenCapture();
//     }

//     // Update channel media options to publish camera or screen capture streams
//     ChannelMediaOptions options = ChannelMediaOptions(
//       publishCameraTrack: !_isScreenShared,
//       publishMicrophoneTrack: !_isScreenShared,
//       publishScreenTrack: _isScreenShared,
//       publishScreenCaptureAudio: _isScreenShared,
//       publishScreenCaptureVideo: _isScreenShared,
//     );

//     agoraEngine.updateChannelMediaOptions(options);
//   }
//   //Instantiate the client
//   // final AgoraClient client = AgoraClient(
//   //   agoraConnectionData: AgoraConnectionData(

//   //     tempToken:
//   //         "00665a5460ed6af49978a85479fdd87fa13IACVwXkhbERfo",
//   //     appId: "65a5460ed6af49978a85479fdd87fa13",
//   //     channelName: "hamada",
//   //   ),
//   // );

// // // Initialize the Agora Engine
// //   @override
// //   void initState() {
// //     super.initState();
// //     initAgora();
// //   }

// //   void initAgora() async {
// //     await client.initialize();
// //   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // Handle back button press here
//         print('end session'); // Add this line to print when the call is closed
//         return true; // Return true to allow the back button press or false to prevent it
//       },
//       child: Scaffold(
//         appBar: simplAppbar(true),
//         body: Obx(
//           () => SafeArea(
//             child: (mySesionController.isLoading.value)
//                 ? Center(child: CircularProgressIndicator())
//                 : Stack(
//                     children: [
//                       AgoraVideoView(
//                         controller: VideoViewController(
//                           rtcEngine: mySesionController.agoraEngine.value,
//                           canvas: VideoCanvas(uid: 1),

//                           // client: mySesionController.agoraclient.value,
//                         ),
//                       )
//                     ],
//                   ),
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             // shareScreen();
//             if (mySesionController.isScreenSharing.value) {
//               mySesionController.stopScreenSharing(); // Stop screen sharing
//             } else {
//               mySesionController.startScreenSharing(); // Start screen sharing
//             }
//           },
//           child: Icon(mySesionController.isScreenSharing.value
//               ? Icons.stop
//               : Icons.screen_share),
//         ),
//       ),
//     );
//   }
// }
