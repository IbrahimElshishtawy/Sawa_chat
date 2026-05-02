import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallPage extends StatefulWidget {
  final String channelName;
  const VideoCallPage({super.key, required this.channelName});

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  late RtcEngine _engine;
  bool localJoined = false;
  int? remoteUid;

  static const String appId = 'PUT_YOUR_AGORA_APP_ID';

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    await [Permission.camera, Permission.microphone].request();

    _engine = createAgoraRtcEngine();

    await _engine.initialize(const RtcEngineContext(appId: appId));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (_, _) {
          setState(() => localJoined = true);
        },
        onUserJoined: (_, uid, _) {
          setState(() => remoteUid = uid);
        },
        onUserOffline: (_, _, _) {
          setState(() => remoteUid = null);
        },
      ),
    );

    await _engine.enableVideo();

    await _engine.joinChannel(
      token: '',
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  Widget _localView() {
    if (!localJoined) {
      return const Center(child: CircularProgressIndicator());
    }
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  Widget _remoteView() {
    if (remoteUid == null) {
      return const Center(child: Text('Waiting for user...'));
    }
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine,
        canvas: VideoCanvas(uid: remoteUid),
        connection: RtcConnection(channelId: widget.channelName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: _remoteView()),
          Positioned(
            right: 16,
            top: 50,
            width: 120,
            height: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _localView(),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () => Navigator.pop(context),
                child: const Icon(Icons.call_end),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
