import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';

const appId = "65a5460ed6af49978a85479fdd87fa13";
// const token =
//     "00665a5460ed6af49978a85479fdd87fa13IADY9GNZ7hUeOtOY8+TP6+YJ0xJ8gHklvDDSgka+l7HahzbVTQ0AAAAAIgCBKewDlvNHZQQAAQAmsEZlAgAmsEZlAwAmsEZlBAAmsEZl";
// const channel = "QS-SID14TID15";

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
  bool _isScreenShared = false;

  int uid = 0; // uid of the local user

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance

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

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

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

  void leave() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }

  Future<void> shareScreen() async {
    setState(() {
      _isScreenShared = !_isScreenShared;
    });

    if (_isScreenShared) {
      // Start screen sharing

      agoraEngine.startScreenCapture(const ScreenCaptureParameters2(
          captureAudio: true,
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
      publishMicrophoneTrack: !_isScreenShared,
      publishScreenTrack: _isScreenShared,
      publishScreenCaptureAudio: _isScreenShared,
      publishScreenCaptureVideo: _isScreenShared,
    );

    agoraEngine.updateChannelMediaOptions(options);
  }

// Release the resources when you leave
  @override
  void dispose() async {
    await agoraEngine.leaveChannel();
    agoraEngine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: Scaffold(
          appBar: simplAppbar(true),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            children: [
              // Container for the local video
              Container(
                height: 240,
                decoration: BoxDecoration(border: Border.all()),
                child: Center(child: _localPreview()),
              ),
              const SizedBox(height: 10),
              //Container for the Remote video
              Container(
                height: 240,
                decoration: BoxDecoration(border: Border.all()),
                child: Center(child: _remoteVideo()),
              ),
              // Button Row
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isJoined ? null : () => {join()},
                      child: const Text("Join"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isJoined ? () => {leave()} : null,
                      child: const Text("Leave"),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isJoined ? () => {shareScreen()} : null,
                      child: Text(_isScreenShared
                          ? "Stop sharing screen"
                          : "Share screen"),
                    ),
                  ),
                ],
              ),
              // Button Row ends
            ],
          )),
    );
  }

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
      return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
      );
    }
  }

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
