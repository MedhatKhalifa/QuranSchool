// import 'package:flutter/material.dart';

// class VideoCallScreen extends StatefulWidget {
//   @override
//   _VideoCallScreenState createState() => _VideoCallScreenState();
// }

// class _VideoCallScreenState extends State<VideoCallScreen> {
//   bool isMuted = false;
//   bool isCameraOn = true;
//   bool _isScreenShared = false;
//   bool _isJoined = true;
//   bool areButtonsVisible = false;
//   bool isLocalVideoVisible = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('Video Call'),
//       // ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 areButtonsVisible = !areButtonsVisible;
//               });
//             },
//             child: Stack(
//               children: [
//                 // Remote Video Full Screen
//                 Container(
//                   color: Colors.black,
//                   height: constraints.maxHeight,
//                   width: constraints.maxWidth,
//                   child: Center(child: _remoteVideo()),
//                 ),
//                 // Local Video Preview (Initially Hidden)
//                 if (areButtonsVisible && isLocalVideoVisible)
//                   Positioned(
//                     bottom: 20.0,
//                     right: 20.0,
//                     width: constraints.maxWidth * 0.25,
//                     height: constraints.maxHeight * 0.2,
//                     child: Container(
//                       color: Colors.black,
//                       child: Center(
//                         child: _localPreview(),
//                       ),
//                     ),
//                   ),
//                 // Buttons (Disappear by Default)
//                 if (areButtonsVisible)
//                   Positioned(
//                     bottom: 20.0,
//                     left: 20.0,
//                     child: Column(
//                       children: [
//                         IconButton(
//                           icon: Icon(isMuted ? Icons.mic_off : Icons.mic),
//                           onPressed: () {
//                             setState(() {
//                               isMuted = !isMuted;
//                               // Implement your mute/unmute logic here
//                             });
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(
//                               isCameraOn ? Icons.videocam : Icons.videocam_off),
//                           onPressed: () {
//                             setState(() {
//                               isCameraOn = !isCameraOn;
//                               // Implement your camera on/off logic here
//                             });
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(_isScreenShared
//                               ? Icons.screen_share
//                               : Icons.stop_screen_share),
//                           onPressed: () {
//                             shareScreen();
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(isLocalVideoVisible
//                               ? Icons.visibility
//                               : Icons.visibility_off),
//                           onPressed: () {
//                             setState(() {
//                               isLocalVideoVisible = !isLocalVideoVisible;
//                             });
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(_isJoined ? Icons.call_end : Icons.call,
//                               color: _isJoined ? Colors.green : Colors.red),
//                           onPressed: () {
//                             setState(() {
//                               _isJoined = !_isJoined;
//                               // Implement your join/leave call logic here
//                             });
//                             _isJoined ? join() : leave();
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
