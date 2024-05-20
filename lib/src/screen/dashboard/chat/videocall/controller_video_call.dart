import 'package:agora_token_service/agora_token_service.dart';
import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/video_chat_model.dart';
import 'package:dating_app/src/screen/dashboard/chat/videocall/agora_video_call/agora.config.dart';
import 'package:dating_app/src/screen/dashboard/chat/videocall/agora_video_call/call_screen.dart';
import 'package:dating_app/src/services/repository/video_call_webservices/decline_video_call_webservice.dart';
import 'package:dating_app/src/services/repository/video_call_webservices/video_call_webservices.dart';
import 'package:flutter/foundation.dart';

class ControllerVideoCall extends GetxController {
  // RxString receiverId = "".obs;
  Rx<GetVideoChatDetailsResponseModel> responseModel = GetVideoChatDetailsResponseModel().obs;

  Future<void> videoChatDetail(String receiverId, String receiverrofileImage) async {
    VideoChatDetails().getVideoChatDetails(receiverId).then((value) {
      responseModel.value = value!.result ?? responseModel.value;
      if (value.code.toString() == "1") {
        if (kDebugMode) {
          print(tokenAgoraVideoCall);
        }
        final token = RtcTokenBuilder.build(
          appId: value.result?.appId ?? "",
          appCertificate: '2cb20b02817e47e492002a72bdaff198',
          channelName: value.result?.channelId ?? "",
          uid: '0',
          role: RtcRole.publisher,
          expireTimestamp: (3600 + DateTime.now().millisecondsSinceEpoch ~/ 1000),
        );
        PushNotificationService().playRingToneForCall(0.2, ringtone: "lib/src/asset/phone-ringing-6805.mp3");
        SharedPref.setString(PreferenceConstants.receiverID, receiverId);
        hideLoader();
        Get.to(VideoCallPage(
          channelName: value.result?.channelId ?? "",
          channelToken: token,
          appId: value.result?.appId ?? "",
          recieverId: receiverId,
          userImage: receiverrofileImage,
        ))!
            .then((value) {
          PushNotificationService().stopRingTon();

          PushNotificationService().enableIOSNotifications(true);
        });
        hideLoader();
      } else {
        hideLoader();

        showSnackBar(
            Get.overlayContext, "${value.message?.split(" ").first} ${toLabelValue(value.message!.split(" ").last)}");
      }
    });
  }

  void declineVideoCall(String receiverId, String channelId) {
    DeclineVideoCall().declineCallApi(receiverId, channelId).then((value) {
      PushNotificationService().stopRingTon();
    }).onError((error, stackTrace) {
      PushNotificationService().stopRingTon();
    });
  }
}
