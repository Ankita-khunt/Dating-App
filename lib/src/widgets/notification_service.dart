import 'dart:io';

import 'package:agora_token_service/agora_token_service.dart';
import 'package:dating_app/src/screen/dashboard/chat/chat_detail/binding_chat_detail.dart';
import 'package:dating_app/src/screen/dashboard/chat/chats/binding_chats.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/binding_user_detail.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/controller_user_detail.dart';
import 'package:dating_app/src/screen/dashboard/matches/match/binding_match.dart';
import 'package:dating_app/src/screen/dashboard/matches/match/controller_match.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_likes/controller_my_likes.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/profile/binding_profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:just_audio/just_audio.dart';

import '../../imports.dart';
import '../../main.dart';
import '../screen/dashboard/chat/chat_detail/controller_chat_detail.dart';
import '../screen/dashboard/chat/chats/controller_chats.dart';
import '../screen/dashboard/chat/videocall/agora_video_call/call_screen.dart';
import '../screen/dashboard/chat/videocall/binding_video_call.dart';
import '../screen/dashboard/chat/videocall/controller_video_call.dart';
import '../screen/dashboard/custom_tab/binding/binding_tabbar.dart';
import '../screen/dashboard/home/card_swip/controller_card_swipe.dart';

late final player = AudioPlayer();

class PushNotificationService {
  RemoteMessage? remoteMessage;

// It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    await Firebase.initializeApp();

    enableIOSNotifications(true);
    await registerNotificationListeners();
  }

  Future<void> registerNotificationListeners() async {
    final AndroidNotificationChannel channel = androidNotificationChannel();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@drawable/ic_launcher');
    DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) {
        if (kDebugMode) {
          print("Notificatyionnn======>  ????");
        }
      },
    );
    InitializationSettings initSettings = InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveNotificationResponseBackGround);

// onMessage is called when the app is in foreground and a notification is received
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      FlutterAppBadger.updateBadgeCount(1);
      remoteMessage = message;
      if (kDebugMode) {
        print(remoteMessage?.data);
      }

      if (remoteMessage!.data['notification_type'] == "1") {
        //Chat Type Notifications
        BindingChatDetail().dependencies();
        BindingChats().dependencies();

        if (isChatDetailOpen.value == true && (selectedChatReceiverID.value == message?.data["user_id"])) {
          Get.find<ControllerChatDetail>().chatdetailAPI(message?.data["chat_id"], message?.data["user_id"]);
        } else {
          Get.find<ControllerChats>().chatlistAPI("0");
        }
      } else if (remoteMessage!.data['notification_type'] == "2") {
        enableIOSNotifications(false);

        //Video Call Notification
      } else if (remoteMessage!.data['notification_type'] == "3") {
      } else if (remoteMessage!.data['notification_type'] == "4") {
        //MatchProfileNotification
      } else if (remoteMessage!.data['notification_type'] == "5") {
        //view user profile Notification
      } else if (remoteMessage!.data['notification_type'] == "7") {
        //call decline notification
        enableIOSNotifications(true);
        stopRingTon();

        FlutterRingtonePlayer.stop();
        if (isOpenCallDialog == true) {
          Get.back();
        }
      }
      if (remoteMessage!.data['notification_type'] != "7") {
        if (selectedChatReceiverID.value != "" && (remoteMessage!.data['notification_type'] == "1")) {
          if (selectedChatReceiverID != message?.data["user_id"]) {
            enableIOSNotifications(true);
            RemoteNotification? notification = message!.notification;

            AndroidNotification? android = message.notification?.android;
            if (notification != null && android != null && !kIsWeb) {
              flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title,
                notification.body,
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    channel.id,
                    channel.name,
                    channelDescription: channel.description,
                    // TODO add a proper drawable resource to android, for now using
                    //      one that already exists in example app.
                    icon: '@mipmap/ic_launcher',
                  ),
                ),
              );
            }
          } else {}
        } else {
          if ((remoteMessage!.data['notification_type'] != "2")) {
            RemoteNotification? notification = message!.notification;
            AndroidNotification? android = message.notification?.android;
            if (notification != null && android != null && !kIsWeb) {
              flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title,
                notification.body,
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    channel.id,
                    channel.name,
                    channelDescription: channel.description,
                    // TODO add a proper drawable resource to android, for now using
                    //      one that already exists in example app.
                    icon: '@mipmap/ic_launcher',
                  ),
                ),
              );
            }
          }

          RemoteNotification? notification = message!.notification;
          if (remoteMessage?.data["message"] == "Video Call") {
            playRingToneForCall(0.5);
            isOpenCallDialog = true;
            callAcceptRejectDialog(Get.overlayContext!, message);
            debugPrint(" ===================== IOS call Notification =================");
          }
        }
      }
    });

    ///on Open APP when Notification Comes
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (kDebugMode) {
        print(message);
      }
      remoteMessage = message;
      FlutterAppBadger.updateBadgeCount(1);
      if (message.data['notification_type'] == "1") {
        //Chat Type notifications
        bottomNavigationBackgroundColor = ColorConstants().white;
        TabbarBinding().dependencies();

        Get.find<TabbarController>().currentIndex.value = 2;
        Get.toNamed(Routes.chat_detail);
        Get.find<ControllerChatDetail>().chatdetailAPI(message.data["chat_id"], message.data["user_id"]);
      } else if (remoteMessage?.data['notification_type'] == "2") {
        playRingToneForCall(0.5);
        callAcceptRejectDialog(Get.overlayContext!, message);
      } else if (remoteMessage?.data['notification_type'] == "3") {
        BindingProfile().dependencies();
        Get.find<ControllerMyLikes>().tabController.index = 1;
        Get.find<ControllerMyLikes>().getMyLikesAPI(false);
      } else if (remoteMessage?.data['notification_type'] == "4") {
        BindingMatch().dependencies();
        Get.find<ControllerMatch>().matchlistAPI();
      } else if (remoteMessage?.data['notification_type'] == "5") {
        BindingUserdetail().dependencies();

        bottomNavigationBackgroundColor = ColorConstants().white;
        TabbarBinding().dependencies();

        Get.find<TabbarController>().currentIndex.value = 0;
        Get.toNamed(Routes.user_detail);
        Get.find<ControllerUserDetail>().userdata = null;
        Get.find<ControllerUserDetail>().isShowLikeButtom(true);
        Get.find<ControllerUserDetail>().isDataLoaded(false);
        Get.find<ControllerUserDetail>().getSetUpProfileAPI().then((value) {
          Get.find<ControllerUserDetail>().getUserDetailAPI(remoteMessage?.data["receiver_id"], latitude.toString(),
              longitude.toString(), Get.find<ControllerCard>().isIncognitoModeON.value);
        });
      } else if (remoteMessage!.data['notification_type'] == "7") {
        //call decline notification
        enableIOSNotifications(true);
        FlutterRingtonePlayer.stop();

        stopRingTon();
        if (isOpenCallDialog == true) {
          Get.back();
        }
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        Future.delayed(
          const Duration(seconds: 5),
          () {
            remoteMessage = message;
            RemoteNotification? notification = message.notification;
            AndroidNotification? android = message.notification?.android;
            FlutterAppBadger.updateBadgeCount(1);

            if (message.data['notification_type'] == "1") {
              //Chat Type notifications
              bottomNavigationBackgroundColor = ColorConstants().white;
              TabbarBinding().dependencies();
              Get.find<TabbarController>().currentIndex.value = 2;
              Get.toNamed(Routes.chat_detail);
              Get.find<ControllerChatDetail>().chatdetailAPI(message.data["chat_id"], message.data["user_id"]);
            } else if (remoteMessage?.data['notification_type'] == "2") {
              if (remoteMessage?.data["message"] == "Video Call") {
                bottomNavigationBackgroundColor = ColorConstants().white;
                TabbarBinding().dependencies();

                Get.find<TabbarController>().currentIndex.value = 2;
                Get.find<ControllerChats>().chatlistAPI("0");

                playRingToneForCall(0.5);

                callAcceptRejectDialog(Get.overlayContext!, message);
              }
            } else if (remoteMessage?.data['notification_type'] == "3") {
              BindingProfile().dependencies();
              Get.find<ControllerMyLikes>().tabController.index = 1;
              Get.find<ControllerMyLikes>().getMyLikesAPI(false);
            } else if (remoteMessage?.data['notification_type'] == "4") {
              BindingMatch().dependencies();
              Get.find<ControllerMatch>().matchlistAPI();
            } else if (remoteMessage?.data['notification_type'] == "5") {
              BindingUserdetail().dependencies();

              bottomNavigationBackgroundColor = ColorConstants().white;
              TabbarBinding().dependencies();

              Get.find<TabbarController>().currentIndex.value = 0;
              Get.toNamed(Routes.user_detail);
              Get.find<ControllerUserDetail>().userdata = null;
              Get.find<ControllerUserDetail>().isShowLikeButtom(true);
              Get.find<ControllerUserDetail>().isDataLoaded(false);
              Get.find<ControllerUserDetail>().getSetUpProfileAPI().then((value) {
                Get.find<ControllerUserDetail>().getUserDetailAPI(remoteMessage?.data["receiver_id"],
                    latitude.toString(), longitude.toString(), Get.find<ControllerCard>().isIncognitoModeON.value);
              });
            } else if (remoteMessage!.data['notification_type'] == "7") {
              //call decline notification
              enableIOSNotifications(true);
              stopRingTon();

              FlutterRingtonePlayer.stop();
              if (isOpenCallDialog == true) {
                Get.back();
              }
              //view user profile Notification
            }
          },
        );
      }
    });
  }

  Future<void> enableIOSNotifications(bool isShowNotification) async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: isShowNotification, // Required to display a heads up notification
      badge: isShowNotification,
      sound: isShowNotification,
    );
  }

  playRingToneForCall(double volume, {String? ringtone}) async {
    if (Platform.isAndroid) {
      if (ringtone != null) {
        FlutterRingtonePlayer.play(fromAsset: ringtone, volume: volume, looping: true);
      } else {
        FlutterRingtonePlayer.playRingtone(looping: true);
      }
    } else {
      await player.setAsset(ringtone ?? 'lib/src/asset/ringtone_iphone.mp3');
      await player.setLoopMode(LoopMode.all);
      await player.setVolume(volume); // Half as loud

      player.play();
    }
  }

  stopRingTon() {
    FlutterRingtonePlayer.stop();

    player.stop();
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    if (kDebugMode) {
      print(remoteMessage?.data);
    }

    FlutterAppBadger.updateBadgeCount(1);
    if (remoteMessage!.data['notification_type'] == "1") {
      //Chat Type notifications
      bottomNavigationBackgroundColor = ColorConstants().white;
      TabbarBinding().dependencies();

      Get.find<TabbarController>().currentIndex.value = 2;
      Get.toNamed(Routes.chat_detail);
      Get.find<ControllerChatDetail>().chatdetailAPI(remoteMessage!.data["chat_id"], remoteMessage!.data["user_id"]);
    } else if (remoteMessage!.data['notification_type'] == "2") {
      if (remoteMessage?.data["message"] == "Video Call") {
        playRingToneForCall(0.5);
        callAcceptRejectDialog(Get.overlayContext!, remoteMessage!);
        enableIOSNotifications(false);
      }
    } else if (remoteMessage!.data['notification_type'] == "3") {
      BindingMatch().dependencies();
      Get.find<ControllerMatch>().matchlistAPI();
    } else if (remoteMessage!.data['notification_type'] == "5") {
      BindingUserdetail().dependencies();

      String lattitude = await SharedPref.getString(PreferenceConstants.currentLAT);
      String longitude = await SharedPref.getString(PreferenceConstants.currentLONG);

      bottomNavigationBackgroundColor = ColorConstants().white;
      TabbarBinding().dependencies();

      Get.find<TabbarController>().currentIndex.value = 0;
      Get.toNamed(Routes.user_detail);
      Get.find<ControllerUserDetail>().userdata = null;
      Get.find<ControllerUserDetail>().isShowLikeButtom(true);
      Get.find<ControllerUserDetail>().isDataLoaded(false);
      Get.find<ControllerUserDetail>().getSetUpProfileAPI().then((value) {
        Get.find<ControllerUserDetail>().getUserDetailAPI(remoteMessage?.data["receiver_id"], lattitude.toString(),
            longitude.toString(), Get.find<ControllerCard>().isIncognitoModeON.value);
      });
    }
  }

  void onDidReceiveNotificationResponseBackGround(NotificationResponse notificationResponse) async {
    if (remoteMessage?.data["message"] == "Video Call") {
      playRingToneForCall(0.5);
      callAcceptRejectDialog(Get.overlayContext!, remoteMessage!);
    }
  }

  AndroidNotificationChannel androidNotificationChannel() => const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.', // description
        importance: Importance.max,
      );

  callAcceptRejectDialog(BuildContext context, RemoteMessage message) {
    hideLoader();
    isOpenCallDialog = true;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                backgroundColor: Colors.white,
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Visibility(
                            visible: true,
                            child: CustomText(
                              text: "Video call",
                              textAlign: TextAlign.center,
                              style: TextStyleConfig.boldTextStyle(
                                  color: ColorConstants().black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: TextStyleConfig.bodyText20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              child: CustomText(
                                text: "${remoteMessage?.data["title"]} is trying to reach you!!",
                                maxlines: 20,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyleConfig.regularTextStyle(
                                    color: ColorConstants().grey1,
                                    fontWeight: FontWeight.w400,
                                    fontSize: TextStyleConfig.bodyText16),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    enableIOSNotifications(true);

                                    FlutterRingtonePlayer.stop();
                                    stopRingTon();
                                    BindingVideoCall().dependencies();
                                    Get.find<ControllerVideoCall>()
                                        .declineVideoCall(message.data["receiver_id"], message.data["channel_id"]);
                                    Get.back();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(20),
                                      backgroundColor: Colors.red),
                                  child: const Icon(Icons.call_end, color: Colors.white),
                                ),
                                SizedBox(width: Get.width * .12),
                                ElevatedButton(
                                  onPressed: () {
                                    FlutterRingtonePlayer.stop();
                                    stopRingTon();
                                    final token = RtcTokenBuilder.build(
                                      appId: message.data['app_id'] ?? "",
                                      appCertificate: '2cb20b02817e47e492002a72bdaff198',
                                      channelName: message.data["channel_id"] ?? "",
                                      uid: "0",
                                      role: RtcRole.publisher,
                                      expireTimestamp: (3600 + DateTime.now().millisecondsSinceEpoch ~/ 1000),
                                    );
                                    Get.back();
                                    navigatorKey.currentState?.push(
                                      MaterialPageRoute(
                                          builder: (context) => VideoCallPage(
                                                channelName: message.data["channel_id"] ?? "",
                                                channelToken: token,
                                                appId: message.data['app_id'] ?? "",
                                                recieverId: "",
                                                userImage: "",
                                              )),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(20),
                                      backgroundColor: Colors.green),
                                  child: const Icon(Icons.call, color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((value) {
      isOpenCallDialog = false;
    });
  }
}
