import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:quranschool/core/db_links/db_links.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/chat/chat_details.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:quranschool/pages/sessions/controller/session_control.dart';
import 'package:quranschool/pages/sessions/nextSession.dart';
import 'package:quranschool/pages/sessions/rate.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// const appId = "65a5460ed6af49978a85479fdd87fa13";
// const token =
//     "00665a5460ed6af49978a85479fdd87fa13IADY9GNZ7hUeOtOY8+TP6+YJ0xJ8gHklvDDSgka+l7HahzbVTQ0AAAAAIgCBKewDlvNHZQQAAQAmsEZlAgAmsEZlAwAmsEZlBAAmsEZl";
// const channel = "QS-SID14TID15";

///////////////////////////////////////////////////////////////////////////////////////
// - this taken Channel Name and token as input and it is coming from MySesionController.getToken
///////////////////////////////////////////////////////////////////////////////////////
class VideoScreenCall extends StatefulWidget {
  final channelName;
  final token;
  VideoScreenCall({Key? key, this.channelName, this.token}) : super(key: key);

  @override
  _VideoScreenCallState createState() =>
      _VideoScreenCallState(channelName, token);
}

class _VideoScreenCallState extends State<VideoScreenCall> {
  _VideoScreenCallState(this.channelName, this.token);
  // String channelName = "QS-SID14TID15";
  // String token =
  //     "00665a5460ed6af49978a85479fdd87fa13IADY9GNZ7hUeOtOY8+TP6+YJ0xJ8gHklvDDSgka+l7HahzbVTQ0AAAAAIgCBKewDlvNHZQQAAQAmsEZlAgAmsEZlAwAmsEZlBAAmsEZl";

  final channelName;
  final token;
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());
  final MySesionController mySesionController = Get.put(MySesionController());

  ///////////////////////////////////////////////////////////////////////////////////////
// - define varirbles to control video icon buttons
///////////////////////////////////////////////////////////////////////////////////////
  bool _isScreenShared = false;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  int uid = 0; // uid of the local user

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance
  bool isMuted = false;
  bool isCameraOn = false;
  bool areButtonsVisible = true;
  bool isLocalVideoVisible = false;
  bool _isChatOpen = true;

  //bool _isScreenShared = false;
  int? _screenSharingUid;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  bool _remoteVideoMuted = false; // Add this variable

  @override
  void initState() {
    super.initState();
    // Set up an instance of Agora engine
    setupVideoSDKEngine();
    // Enable wakelock to keep the screen on
    WakelockPlus.enable();
  }

///////////////////////////////////////////////////////////////////////////////////////
// - Virtual Back ground  https://docs.agora.io/en/video-calling/enable-features/virtual-background?platform=flutter
///////////////////////////////////////////////////////////////////////////////////////
  int counter = 2; // to cycle through different types of backgrounds
  bool isVirtualBackGroundEnabled = false;

  Future<void> setVirtualBackground() async {
    if (!await agoraEngine
        .isFeatureAvailableOnDevice(FeatureType.videoVirtualBackground)) {
      showMessage("Virtual background feature is not available on this device");
      return;
    }

    VirtualBackgroundSource virtualBackgroundSource;

    virtualBackgroundSource = const VirtualBackgroundSource(
        backgroundSourceType: BackgroundSourceType.backgroundBlur,
        blurDegree: BackgroundBlurDegree.blurDegreeHigh);
    // Set processing properties for background
    SegmentationProperty segmentationProperty = const SegmentationProperty(
        modelType: SegModelType
            .segModelAi, // Use segModelGreen if you have a green background
        greenCapacity: 0.5 // Accuracy for identifying green colors (range 0-1)
        );

    // Enable or disable virtual background
    agoraEngine.enableVirtualBackground(
        enabled: !isVirtualBackGroundEnabled,
        backgroundSource: virtualBackgroundSource,
        segproperty: segmentationProperty);
    showMessage("Setting blur background");

    setState(() {
      isVirtualBackGroundEnabled = !isVirtualBackGroundEnabled;
    });

    // counter++;
    // if (counter > 3) {
    //   counter = 0;
    //   isVirtualBackGroundEnabled = false;
    //   showMessage("Virtual background turned off");
    // } else {
    //   isVirtualBackGroundEnabled = true;
    // }

    // VirtualBackgroundSource virtualBackgroundSource;

    // // Set the type of virtual background
    // if (counter == 1) {
    //   virtualBackgroundSource = const VirtualBackgroundSource(
    //       backgroundSourceType: BackgroundSourceType.backgroundBlur,
    //       blurDegree: BackgroundBlurDegree.blurDegreeHigh);
    //   showMessage("Setting blur background");
    // } else if (counter == 2) {
    //   // Set a solid background color
    //   virtualBackgroundSource = const VirtualBackgroundSource(
    //       backgroundSourceType: BackgroundSourceType.backgroundColor,
    //       color: 0x0000FF);
    //   showMessage("Setting color background");
    // } else {
    //   // Set a background image
    //   virtualBackgroundSource = const VirtualBackgroundSource(
    //       backgroundSourceType: BackgroundSourceType.backgroundImg,
    //       source: "<path to an image file>");
    //   showMessage("Setting image background");
    // }

    // // Set processing properties for background
    // SegmentationProperty segmentationProperty = const SegmentationProperty(
    //     modelType: SegModelType
    //         .segModelAi, // Use segModelGreen if you have a green background
    //     greenCapacity: 0.5 // Accuracy for identifying green colors (range 0-1)
    //     );

    // // Enable or disable virtual background
    // agoraEngine.enableVirtualBackground(
    //     enabled: isVirtualBackGroundEnabled,
    //     backgroundSource: virtualBackgroundSource,
    //     segproperty: segmentationProperty);
  }

///////////////////////////////////////////////////////////////////////////////////////
// - prepare Video SDK
///////////////////////////////////////////////////////////////////////////////////////

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    // await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));

    await agoraEngine.enableVideo();

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onUserMuteVideo: (RtcConnection connection, int remoteUid, bool muted) {
          showMessage(
              "Remote user uid:$remoteUid has ${muted ? "muted" : "unmuted"} their video");
          setState(() {
            _remoteVideoMuted = muted;
          });
        },
        onRemoteVideoStateChanged: (RtcConnection connection,
            int remoteUid,
            RemoteVideoState state,
            RemoteVideoStateReason reason,
            int elapsed) {
          if (state == RemoteVideoState.remoteVideoStateStopped ||
              state == RemoteVideoState.remoteVideoStateFrozen) {
            // Remote user has stopped sharing screen
            setState(() {
              if (_screenSharingUid == remoteUid) {
                _screenSharingUid = null;
                _isScreenShared = false;
              }
            });
          } else if (state == RemoteVideoState.remoteVideoStateDecoding) {
            // Remote user has started sharing screen
            setState(() {
              _screenSharingUid = remoteUid;
              _isScreenShared = true;
            });
          }
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage(
              "Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
            //_remoteVideoMuted = true;
          });
        },
      ),
    );
  }

///////////////////////////////////////////////////////////////////////////////////////
// - join channel button
///////////////////////////////////////////////////////////////////////////////////////
  void join() async {
    await agoraEngine.muteLocalVideoStream(true);
    //await agoraEngine.startPreview();

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: uid,
    );
  }

///////////////////////////////////////////////////////////////////////////////////////
// - leave channel button
///////////////////////////////////////////////////////////////////////////////////////
  void leave() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }

///////////////////////////////////////////////////////////////////////////////////////
// - camera switch
///////////////////////////////////////////////////////////////////////////////////////
  Future<void> cameraswitch() async {
    await agoraEngine.muteLocalVideoStream(!isCameraOn);

    if (isCameraOn) {
      await agoraEngine.startPreview();
      setState(() {
        isLocalVideoVisible = true;
      });
    } else {
      await agoraEngine.stopPreview();
      setState(() {
        isLocalVideoVisible = false;
      });
    }
  }

///////////////////////////////////////////////////////////////////////////////////////
// - mute Switch
///////////////////////////////////////////////////////////////////////////////////////
  Future<void> muteswitch() async {
    await agoraEngine.muteLocalAudioStream(isMuted);

    //  isMuted ? agoraEngine.enableAudio() : agoraEngine.disableAudio();
  }

  ///////////////////////////////////////////////////////////////////////////////////////
// - exit page
///////////////////////////////////////////////////////////////////////////////////////

// Release the resources when you leave
  @override
  void dispose() async {
    _cleanupAgoraResources();
    // Disable wakelock when the page is closed
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> _cleanupAgoraResources() async {
    // Release Agora resources and leave the channel
    await agoraEngine.leaveChannel();
    agoraEngine.release();
  }

  bool _quranview = false;
  ///////
  ///

///////////////////////////////////////////////////////////////////////////////////////
// - start Widgets
///////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Override the back button behavior to navigate to a specific page, e.g., '/home'
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomePage()),
        // );
        // _cleanupAgoraResources();
        // mySesionController.getFirstSessionAfterNow();

        // mySesionController.feedbackEdit.value = true;
        // Get.to(RateSession());
        return false; // Do not allow the default back button behavior
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Video Call'),
        // ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  areButtonsVisible = !areButtonsVisible;
                });
              },
              child: Stack(
                children: [
                  // Remote Video Full Screen
                  Container(
                    color: Colors.black,
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: Center(
                        child: _quranview
                            ? Padding(
                                padding: const EdgeInsets.all(10),
                                child: SfPdfViewer.asset(
                                  'assets/quran.pdf',
                                  key: _pdfViewerKey,
                                  // canShowPaginationDialog: false,
                                  // pageSpacing: 0,
                                  ///  pageLayoutMode: PdfPageLayoutMode.single,
                                  maxZoomLevel: 1,
                                  //   enableDocumentLinkAnnotation: false
                                ),
                              )
                            : _remoteVideo()), //
                  ),

                  // if (_isChatOpen)
                  //   Positioned(
                  //     bottom: 0,
                  //     left: 0,
                  //     right: 0,
                  //     child: Container(
                  //       color: Colors.white,
                  //       height: 400, // Adjust as needed
                  //       child: Column(
                  //         children: [
                  //           AppBar(
                  //             title: Text('Chat'),
                  //             leading: IconButton(
                  //               icon: Icon(Icons.close),
                  //               onPressed: () {},
                  //             ),
                  //           ),
                  //           // Replace with your ChatDetail widget
                  //           Expanded(
                  //             child: ChatDetail(
                  //               friendName: 'Friend',
                  //               friendUid: 'FriendID',
                  //               currentuserName: 'CurrentUser',
                  //               currentuserid: 'CurrentUserID',
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // Local Video Preview (Initially Hidden)
                  isLocalVideoVisible && isCameraOn
                      ? Positioned(
                          bottom: 20.0,
                          right: 20.0,
                          width: constraints.maxWidth * 0.25,
                          height: constraints.maxHeight * 0.2,
                          child: Container(
                            color: Colors.black,
                            child: Center(
                              child: _localPreview(),
                            ),
                          ),
                        )
                      : isLocalVideoVisible
                          ? Positioned(
                              bottom: 20.0,
                              right: 20.0,
                              width: constraints.maxWidth * 0.25,
                              height: constraints.maxHeight * 0.2,
                              child: Container(
                                color: Colors.black,
                                child: Center(child: _showimage(true)),
                              ),
                            )
                          : Text(''),
                  // Buttons (Disappear by Default)
                  if (areButtonsVisible || !_isJoined)
                    Positioned(
                      bottom: 20.0,
                      left: 20.0,
                      child: Column(
                        children: [
                          if (_isJoined || _quranview)
                            IconButton(
                              icon: Icon(_quranview
                                  ? FlutterIslamicIcons.quran
                                  : FlutterIslamicIcons.quran2),
                              onPressed: () {
                                setState(() {
                                  _quranview = !_quranview;
                                  // Implement your mute/unmute logic here
                                });
                              },
                            ),
                          if (_isJoined && !_quranview)
                            IconButton(
                              icon: Icon(Icons.message),
                              onPressed: () {
                                // setState(() {
                                //   isCameraOn = !isCameraOn;
                                //   // Implement your camera on/off logic here
                                // });
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      insetPadding: EdgeInsets.all(10),
                                      child: ChatDetail(
                                        friendName: currentUserController
                                                    .currentUser
                                                    .value
                                                    .userType ==
                                                "teacher"
                                            ? mySesionController
                                                .nextSession.value.studentName
                                            : mySesionController
                                                .nextSession.value.teacherName,
                                        friendUid: currentUserController
                                                    .currentUser
                                                    .value
                                                    .userType ==
                                                "teacher"
                                            ? mySesionController
                                                .nextSession.value.student
                                                .toString()
                                            : mySesionController
                                                .nextSession.value.teacher
                                                .toString(),
                                        currentuserName: currentUserController
                                            .currentUser.value.username,
                                        currentuserid: currentUserController
                                            .currentUser.value.id
                                            .toString(),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          if (_isJoined)
                            IconButton(
                              icon: Icon(isMuted ? Icons.mic_off : Icons.mic),
                              onPressed: () {
                                setState(() {
                                  isMuted = !isMuted;
                                  // Implement your mute/unmute logic here
                                });
                                muteswitch();
                              },
                            ),
                          if (_isJoined && !_quranview)
                            IconButton(
                              icon: Icon(isCameraOn
                                  ? Icons.videocam
                                  : Icons.videocam_off),
                              onPressed: () {
                                setState(() {
                                  isCameraOn = !isCameraOn;
                                  // Implement your camera on/off logic here
                                });
                                cameraswitch();
                              },
                            ),
                          if (_isJoined && !_quranview)
                            IconButton(
                              icon: Icon(_isScreenShared
                                  ? Icons.screen_share
                                  : Icons.stop_screen_share),
                              onPressed: () {
                                shareScreen();
                              },
                            ),
                          if (_isJoined && !_quranview)
                            IconButton(
                              icon: Icon(
                                isVirtualBackGroundEnabled
                                    ? Icons.blur_on
                                    : Icons.blur_off,
                              ),
                              onPressed: () {
                                setVirtualBackground();
                              },
                            ),
                          if (_isJoined && !_quranview)
                            IconButton(
                              icon: Icon(isLocalVideoVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  isLocalVideoVisible = !isLocalVideoVisible;
                                });
                              },
                            ),
                          IconButton(
                            icon: Icon(
                                _isJoined
                                    ? Icons.stop_circle
                                    : Icons.play_circle_fill,
                                color: _isJoined ? Colors.red : Colors.green,
                                size: sp(30)),
                            onPressed: () {
                              setState(() {
                                _isJoined = !_isJoined;
                                //isLocalVideoVisible = !isLocalVideoVisible;
                                if (_isJoined) {
                                  isMuted = false;
                                  isLocalVideoVisible = true;
                                } else {
                                  isLocalVideoVisible = false;
                                }
                                // Implement your join/leave call logic here
                              });
                              _isJoined ? join() : leave();
                            },
                          ),
                        ],
                      ),
                    ),

                  // X Icon at the top-right corner
                  Positioned(
                    top: 20.0,
                    right: 20.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                      ), // Change to the desired icon
                      onPressed: () {
                        // Implement the action you want when the X icon is pressed
                        _cleanupAgoraResources();
                        mySesionController.getFirstSessionAfterNow();

                        mySesionController.feedbackEdit.value = true;
                        Get.to(RateSession());
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////////////////////////////////
// - local Preview Widget
///////////////////////////////////////////////////////////////////////////////////////
// Display local video preview
  Widget _localPreview() {
    // Display local video or screen sharing preview
    if (_isJoined) {
      if (!_isScreenShared) {
        return AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: agoraEngine,
            canvas: const VideoCanvas(uid: 0),
          ),
        );
      } else {
        return AgoraVideoView(
            controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: const VideoCanvas(
            uid: 0,
            sourceType: VideoSourceType.videoSourceScreen,
          ),
        ));
      }
    } else {
      return Text(
        'join_session'.tr,
        textAlign: TextAlign.center,
      );
    }
  }

///////////////////////////////////////////////////////////////////////////////////////
// - Remote Preview Widget
///////////////////////////////////////////////////////////////////////////////////////
// Display remote user's video
  // Widget _remoteVideo() {
  //   if (_remoteUid != null) {
  //     return AgoraVideoView(
  //       controller: VideoViewController.remote(
  //         rtcEngine: agoraEngine,
  //         canvas: VideoCanvas(uid: _remoteUid),
  //         connection: RtcConnection(channelId: channelName),
  //       ),
  //     );
  //   } else {
  //     String msg = '';
  //     if (_isJoined) msg = 'Waiting for a remote user to join';
  //     return Text(
  //       msg,
  //       textAlign: TextAlign.center,
  //     );
  //   }
  // }

  Widget _showimage(islocal) {
    String url = '';

    if (currentUserController.currentUser.value.userType == 'teacher' &&
        islocal) {
      url =
          'http://18.156.95.47/media/${mySesionController.nextSession.value.teacherImage}';
    } else {
      url =
          'http://18.156.95.47/media/${mySesionController.nextSession.value.studentImage}';
    }

    return url != 'http://18.156.95.47/media/'
        ? CircleAvatar(
            radius: islocal ? sp(30) : sp(60),
            backgroundImage: NetworkImage(
              // 'https://quraanshcool.pythonanywhere.com/media/${chatController.filteredFriends[index].friendImage}',
              url,
            ),
          )
        : Container(
            decoration: BoxDecoration(
                // color: Colors.grey[200],
                borderRadius: BorderRadius.circular(50)),
            child: Opacity(
                opacity: 0.9,
                child: Icon(
                  islocal
                      ? FlutterIslamicIcons.muslim2
                      : FlutterIslamicIcons.muslim,
                  size: islocal ? sp(30) : sp(60),
                  color: islocal ? Colors.greenAccent : Colors.green,
                )
                // Image.asset(
                //   "assets/images/logo/logo.png",
                //   width: sp(200),
                //   height: sp(80),
                //   //color: Colors.red,
                // ),
                ),
          );
  }

  Widget _remoteVideo() {
    if (_isScreenShared && _screenSharingUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: _screenSharingUid!),
          connection: RtcConnection(channelId: channelName),
        ),
      );
    } else if (_remoteUid != null) {
      if (_remoteVideoMuted) {
        return Center(child: _showimage(false)

            // Text(
            //   'Remote user has turned off their camera',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(color: Colors.white),
            // ),
            );
      } else {
        return AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: agoraEngine,
            canvas: VideoCanvas(uid: _remoteUid!),
            connection: RtcConnection(channelId: channelName),
          ),
        );
      }
    } else {
      String msg = '';
      if (_isJoined) msg = 'waiting_remote'.tr;
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }
}
