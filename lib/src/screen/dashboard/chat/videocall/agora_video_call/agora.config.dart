import 'package:agora_token_service/agora_token_service.dart';

/// Get your own App ID at https://dashboard.agora.io/
String get appIdConfig {
  // Allow pass an `appId` as an environment variable with name `TEST_APP_ID` by using --dart-define
  return const String.fromEnvironment('TEST_APP_ID',
      defaultValue: "e357f0405ca84e4292ad6aa86f19be3d");
}

/// Please refer to https://docs.agora.io/en/Agora%20Platform/token
String get tokenAgoraVideoCall {
  // Allow pass a `token` as an environment variable with name `TEST_TOKEN` by using --dart-define

  final token = RtcTokenBuilder.build(
    appId: 'e357f0405ca84e4292ad6aa86f19be3d',
    appCertificate: '2cb20b02817e47e492002a72bdaff198',
    channelName: channelId,
    uid: '0',
    role: RtcRole.publisher,
    expireTimestamp: (3600 + DateTime.now().millisecondsSinceEpoch ~/ 1000),
  );

  return String.fromEnvironment('TEST_TOKEN', defaultValue: token);
}

/// Your channel ID
String get channelId {
  // Allow pass a `channelId` as an environment variable with name `TEST_CHANNEL_ID` by using --dart-define
  return const String.fromEnvironment(
    'TEST_CHANNEL_ID',
    defaultValue: 'testing_channel_vrin_herbal',
  );
}

/// Your int user ID
const int uid = 0;

/// Your user ID for the screen sharing
const int screenSharingUid = 10;

/// Your string user ID
const String stringUid = '0';

String get musicCenterAppId {
  // Allow pass a `token` as an environment variable with name `TEST_TOKEN` by using --dart-define
  return const String.fromEnvironment('MUSIC_CENTER_APPID',
      defaultValue: '<MUSIC_CENTER_APPID>');
}
