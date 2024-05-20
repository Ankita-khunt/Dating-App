import 'package:agora_token_service/agora_token_service.dart';
import 'package:dating_app/main.dart';
import 'package:dating_app/src/screen/dashboard/chat/videocall/binding_video_call.dart';

// import 'package:flutter_callkit_incoming/entities/entities.dart';
// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import '../../../../../../imports.dart';
import '../controller_video_call.dart';
import 'call_screen.dart';

void videoCallAcceptMethod(RemoteMessage message) {
  final token = RtcTokenBuilder.build(
    appId: message.data['app_id'] ?? "",
    appCertificate: '2cb20b02817e47e492002a72bdaff198',
    channelName: message.data["channel_id"] ?? "",
    uid: "0",
    role: RtcRole.publisher,
    expireTimestamp: (3600 + DateTime.now().millisecondsSinceEpoch ~/ 1000),
  );

  navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (_) => VideoCallPage(
            channelName: message.data["channel_id"] ?? "",
            channelToken: token,
            appId: message.data['app_id'] ?? "",
            recieverId: "",
            userImage: "",
          )));
}

videoCallDeclineMethod(RemoteMessage message) {
  BindingVideoCall().dependencies();
  Get.find<ControllerVideoCall>().declineVideoCall(message.data["receiver_id"], message.data["channel_id"]);
}
