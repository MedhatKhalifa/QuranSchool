import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:quranschool/core/db_links/db_links.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:quranschool/pages/sessions/controller/session_control.dart';
import 'package:quranschool/pages/sessions/nextSession.dart';
import 'package:quranschool/pages/sessions/rate.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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

  final channelName;
  final token;

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

    SegmentationProperty segmentationProperty = const SegmentationProperty(
        modelType: SegModelType.segModelAi, greenCapacity: 0.5);

    agoraEngine.enableVirtualBackground(
        enabled: !isVirtualBackGroundEnabled,
        backgroundSource: virtualBackgroundSource,
        segproperty: segmentationProperty);
    showMessage("Setting blur background");

    setState(() {
      isVirtualBackGroundEnabled = !isVirtualBackGroundEnabled;
    });
  }

  Future<void> setupVideoSDKEngine() async {
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));

    await agoraEngine.enableVideo();

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
        onUserMuteVideo: (RtcConnection connection, int uid, bool muted) {
          if (muted) {
            setState(() {
              _remoteUid = null;
            });
          }
        },
      ),
    );
  }

  void join() async {
    await agoraEngine.startPreview();

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

  void leave() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }

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

  Future<void> muteswitch() async {
    await agoraEngine.muteLocalAudioStream(isMuted);
  }

  Future<void> shareScreen() async {
    setState(() {
      _isScreenShared = !_isScreenShared;
    });

    if (_isScreenShared) {
      agoraEngine.startScreenCapture(const ScreenCaptureParameters2(
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

    ChannelMediaOptions options = ChannelMediaOptions(
      publishCameraTrack: !_isScreenShared,
      publishMicrophoneTrack: true,
      publishScreenTrack: _isScreenShared,
      publishScreenCaptureAudio: _isScreenShared,
      publishScreenCaptureVideo: _isScreenShared,
    );

    agoraEngine.updateChannelMediaOptions(options);
  }

  @override
  void dispose() async {
    _cleanupAgoraResources();
    super.dispose();
  }

  Future<void> _cleanupAgoraResources() async {
    await agoraEngine.leaveChannel();
    agoraEngine.release();
  }

  bool _quranview = false;
  final MySesionController mySesionController = Get.put(MySesionController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _cleanupAgoraResources();
        mySesionController.getFirstSessionAfterNow();
        mySesionController.feedbackEdit.value = true;
        Get.to(RateSession());
        return false;
      },
      child: Scaffold(
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
                                  maxZoomLevel: 1,
                                ),
                              )
                            : _remoteVideo()),
                  ),
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
                                });
                              },
                            ),
                          if (_isJoined)
                            IconButton(
                              icon: Icon(isMuted ? Icons.mic_off : Icons.mic),
                              onPressed: () {
                                setState(() {
                                  isMuted = !isMuted;
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
                                });
                                cameraswitch();
                              },
                            ),
                          if (_isJoined)
                            IconButton(
                              icon: Icon(_isScreenShared
                                  ? Icons.stop_screen_share
                                  : Icons.screen_share),
                              onPressed: shareScreen,
                            ),
                          if (_isJoined)
                            IconButton(
                              icon: Icon(
                                Icons.call_end,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _cleanupAgoraResources();
                                mySesionController.getFirstSessionAfterNow();
                                mySesionController.feedbackEdit.value = true;
                                Get.to(RateSession());
                              },
                            ),
                          if (!_isJoined)
                            IconButton(
                              icon: Icon(
                                Icons.call,
                                color: Colors.green,
                              ),
                              onPressed: join,
                            ),
                        ],
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

  // Local user preview
  Widget _localPreview() {
    if (_isJoined && isCameraOn) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const Text(
        'Video is off',
        textAlign: TextAlign.center,
      );
    }
  }

  // Remote user video
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
      return const Text(
        'Waiting for remote user to join...',
        textAlign: TextAlign.center,
      );
    }
  }
}
