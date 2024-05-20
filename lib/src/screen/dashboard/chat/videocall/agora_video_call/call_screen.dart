import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/chat/videocall/agora_video_call/video_calling_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../services/repository/video_call_webservices/get_decline_call_webservices.dart';
import '../../../../../widgets/widget.card.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage(
      {Key? key,
      required this.channelName,
      required this.channelToken,
      required this.appId,
      required this.recieverId,
      this.userImage})
      : super(key: key);

  final String channelName;
  final String channelToken;
  final String appId;
  final String recieverId;
  final String? userImage;

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> with SingleTickerProviderStateMixin {
  int? _remoteUid;
  bool _localUserJoined = false;
  bool isMicMute = false;
  bool isCameraOn = true;
  Timer? timer;
  Timer? callEndTimer;
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animationController?.repeat(reverse: true);
    initAgora();
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    rtcengine = createAgoraRtcEngine();
    await rtcengine
        .initialize(RtcEngineContext(
      appId: widget.appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ))
        .onError((error, stackTrace) {
      if (kDebugMode) {
        print("error=================");
      }
    }).catchError((err) {
      if (kDebugMode) {
        print(err);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      rtcengine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            if (kDebugMode) {
              print("local user ${connection.localUid} joined");
            }
            setState(() {
              _localUserJoined = true;
            });

            callEndTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
              videoCallDeclineMethod(
                  RemoteMessage(data: {"receiver_id": widget.recieverId, "channel_id": widget.channelName}));

              rtcengine.leaveChannel(options: const LeaveChannelOptions(stopAllEffect: true)).then((value) {
                callEndTimer?.cancel();
                callEndTimer = null;
                if ((Get.currentRoute != Routes.chat_detail) && (Get.currentRoute != Routes.customTabbar)) {
                  Get.back();
                }
              });
            });
            if (_localUserJoined && _remoteUid == null) {
              timer = Timer.periodic(const Duration(seconds: 2), (timer) {
                getDeclineVideoCall();
              });
            }
          },
          onLeaveChannel: (connection, stats) {
            debugPrint("on leave channel $stats ");
          },
          onError: (err, msg) {
            debugPrint("Error in Agora $err");
            debugPrint("Error in Agora $msg");
            showSnackBar(context, "We are facing some technical issues, please try again later.");
            _dispose();
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            debugPrint("remote user $remoteUid joined");
            callEndTimer?.cancel();
            callEndTimer = null;

            setState(() {
              _remoteUid = remoteUid;
            });
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            debugPrint("remote user $remoteUid left channel");
            _remoteUid = null;
            callEndTimer?.cancel();
            callEndTimer = null;
            if (kDebugMode) {
              if (kDebugMode) {
                print("userOffline callback");
              }
            }
            _dispose();
          },
          onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
            if (kDebugMode) {
              print(connection);
            }
            debugPrint('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
          },
        ),
      );
    });

    await rtcengine.setClientRole(role: ClientRoleType.clientRoleBroadcaster).onError((error, stackTrace) {
      if (kDebugMode) {
        print("error setClientRole");
      }
      callEndTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
        videoCallDeclineMethod(
            RemoteMessage(data: {"receiver_id": widget.recieverId, "channel_id": widget.channelName}));

        callEndTimer?.cancel();
        callEndTimer = null;
        if ((Get.currentRoute != Routes.chat_detail) && (Get.currentRoute != Routes.customTabbar)) {
          Get.back();
        }
      });
    });

    await rtcengine.enableVideo();
    await rtcengine.startPreview();

    await rtcengine.joinChannel(
      token: widget.channelToken,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return showDialogBox(
            Get.overlayContext!,
            toLabelValue(StringConstants.exit_videocall),
            () {
              if (kDebugMode) {
                print("First clcik");
              }
              Get.back();
            },
            "no",
            () {
              if (kDebugMode) {
                print("Second clcik");
              }

              videoCallDeclineMethod(
                  RemoteMessage(data: {"receiver_id": widget.recieverId, "channel_id": widget.channelName}));

              rtcengine.leaveChannel(options: const LeaveChannelOptions(stopAllEffect: true)).then((value) {
                Get.back();
              });
            },
            "yes");
      },
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _remoteVideo(),
                      Positioned(
                        child: SafeArea(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        isMicMute = !isMicMute;
                                      });
                                      rtcengine.muteLocalAudioStream(isMicMute);
                                    },
                                    child: SvgPicture.asset(isMicMute
                                        ? ImageConstants.icon_microphone_mute
                                        : ImageConstants.icon_microphone)),
                                InkWell(
                                    onTap: () {
                                      rtcengine.switchCamera();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: SvgPicture.asset(ImageConstants.icon_flip),
                                      ),
                                    )),
                                InkWell(
                                    onTap: () {
                                      if (isCameraOn) {
                                        rtcengine.enableLocalVideo(false);
                                        isCameraOn = false;
                                      } else {
                                        rtcengine.enableLocalVideo(true);
                                        isCameraOn = true;
                                      }
                                      setState(() {});
                                    },
                                    child: SvgPicture.asset(
                                      ImageConstants.icon_videostop,
                                      color: isCameraOn ? Colors.white : Colors.grey,
                                    )),
                                InkWell(
                                  onTap: () async {
                                    String receiverID = await SharedPref.getString(PreferenceConstants.receiverID);
                                    if (widget.channelName == "") {
                                      videoCallDeclineMethod(RemoteMessage(data: {
                                        "receiver_id": widget.recieverId ?? receiverID,
                                        "channel_id": widget.channelName ?? ""
                                      }));
                                      callEndTimer?.cancel();
                                      callEndTimer = null;

                                      if ((Get.currentRoute != Routes.chat_detail) &&
                                          (Get.currentRoute != Routes.customTabbar)) {
                                        Get.back();
                                      }
                                    } else {
                                      videoCallDeclineMethod(RemoteMessage(data: {
                                        "receiver_id": widget.recieverId ?? receiverID,
                                        "channel_id": widget.channelName
                                      }));
                                      rtcengine
                                          .leaveChannel(options: const LeaveChannelOptions(stopAllEffect: true))
                                          .then((value) {
                                        callEndTimer?.cancel();
                                        callEndTimer = null;
                                        if ((Get.currentRoute != Routes.chat_detail) &&
                                            (Get.currentRoute != Routes.customTabbar)) {
                                          if (kDebugMode) {
                                            print("call cut ==++");
                                          }
                                          Get.back();
                                        }
                                        if (kDebugMode) {
                                          print("object");
                                        }
                                      });
                                    }
                                  },
                                  child: CustomCard(
                                      isGradientCard: false,
                                      borderradius: 8,
                                      bordercolor: Colors.transparent,
                                      borderwidth: 0,
                                      backgroundColor: ColorConstants().errorRed,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                                        child: SvgPicture.asset(ImageConstants.icon_call_video),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: 100,
                  height: 150,
                  child: Center(
                    child: _localUserJoined
                        ? AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: rtcengine,
                              canvas: const VideoCanvas(uid: 0),
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: rtcengine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    } else {
      return Container(
        color: Colors.black,
        child: widget.userImage != ""
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(500),
                      child: CachedNetworkImage(
                        imageUrl: "${generalSetting!.s3Url}${widget.userImage}",
                        height: 200,
                        width: 200,
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FadeTransition(
                    opacity: animationController!,
                    child: Text(
                      "Ringing...",
                      style: TextStyleConfig.boldTextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              )
            : FadeTransition(
                opacity: animationController!,
                child: Text(
                  "Connecting.....",
                  style: TextStyleConfig.boldTextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
      );
    }
  }

  Future<void> _dispose() async {
    await rtcengine.leaveChannel().then((value) {
      if ((Get.currentRoute != Routes.chat_detail) && (Get.currentRoute != Routes.customTabbar)) {
        if (kDebugMode) {
          print("Dispose ==++");
        }
        Get.back();
      }
    });
    await rtcengine.release();
    if (timer != null && timer!.isActive) {
      timer?.cancel();
    }
  }

  void getDeclineVideoCall() {
    GetDeclineVideoCall().getDeclineCallApi(widget.recieverId, widget.channelName).then((value) {
      if (value.callDeclined == "1") {
        PushNotificationService().stopRingTon();
        timer?.cancel();
        _dispose();
      }
    });
  }
}
