import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quranschool/core/db_links/db_links.dart';
import 'package:quranschool/core/size_config.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:quranschool/pages/sessions/controller/session_control.dart';
import 'package:quranschool/pages/sessions/nextSession.dart';
import 'package:quranschool/pages/sessions/rate.dart';

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

  ///////////////////////////////////////////////////////////////////////////////////////
// - define varirbles to control video icon buttons
///////////////////////////////////////////////////////////////////////////////////////
  bool _isScreenShared = false;

  int uid = 0; // uid of the local user

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance
  bool isMuted = false;
  bool isCameraOn = true;
  bool areButtonsVisible = true;
  bool isLocalVideoVisible = true;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  void initState() {
    super.initState();
    // Set up an instance of Agora engine
    setupVideoSDKEngine();
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
          });
        },
      ),
    );
  }

///////////////////////////////////////////////////////////////////////////////////////
// - join channel button
///////////////////////////////////////////////////////////////////////////////////////
  void join() async {
    await agoraEngine.startPreview();

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
      setState(() {
        isLocalVideoVisible = true;
      });
    } else {
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
// - share Screen
///////////////////////////////////////////////////////////////////////////////////////
  Future<void> shareScreen() async {
    setState(() {
      _isScreenShared = !_isScreenShared;
    });

    if (_isScreenShared) {
      // Start screen sharing

      agoraEngine.startScreenCapture(const ScreenCaptureParameters2(
          //  captureAudio: true,
          audioParams: ScreenAudioParameters(
              sampleRate: 16000, channels: 2, captureSignalVolume: 100),
          captureVideo: true,
          videoParams: ScreenVideoParameters(
              dimensions: VideoDimensions(height: 1280, width: 720),
              frameRate: 15,
              bitrate: 600)));
    } else {
      await agoraEngine.stopScreenCapture();
    }

    // Update channel media options to publish camera or screen capture streams
    ChannelMediaOptions options = ChannelMediaOptions(
      publishCameraTrack: !_isScreenShared,
      publishMicrophoneTrack: true, // !_isScreenShared,
      publishScreenTrack: _isScreenShared,
      publishScreenCaptureAudio: _isScreenShared,
      publishScreenCaptureVideo: _isScreenShared,
    );

    agoraEngine.updateChannelMediaOptions(options);
  }

  ///////////////////////////////////////////////////////////////////////////////////////
// - exit page
///////////////////////////////////////////////////////////////////////////////////////

// Release the resources when you leave
  @override
  void dispose() async {
    _cleanupAgoraResources();
    super.dispose();
  }

  Future<void> _cleanupAgoraResources() async {
    // Release Agora resources and leave the channel
    await agoraEngine.leaveChannel();
    agoraEngine.release();
  }

  ///////
  ///
  final MySesionController mySesionController = Get.put(MySesionController());
///////////////////////////////////////////////////////////////////////////////////////
// - start Widgets
///////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Center(child: _remoteVideo()),
                ),
                // Local Video Preview (Initially Hidden)
                if (isLocalVideoVisible)
                  Positioned(
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
                  ),
                // Buttons (Disappear by Default)
                if (areButtonsVisible || !_isJoined)
                  Positioned(
                    bottom: 20.0,
                    left: 20.0,
                    child: Column(
                      children: [
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
                        if (_isJoined)
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
                        if (_isJoined)
                          IconButton(
                            icon: Icon(_isScreenShared
                                ? Icons.screen_share
                                : Icons.stop_screen_share),
                            onPressed: () {
                              shareScreen();
                            },
                          ),
                        if (_isJoined)
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
                        if (_isJoined)
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
        'Join a channel'.tr,
        textAlign: TextAlign.center,
      );
    }
  }

///////////////////////////////////////////////////////////////////////////////////////
// - Remote Preview Widget
///////////////////////////////////////////////////////////////////////////////////////
// Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: channelName),
        ),
      );
    } else {
      String msg = '';
      if (_isJoined) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }
}
