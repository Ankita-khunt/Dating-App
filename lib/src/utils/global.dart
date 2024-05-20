library globals;

import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/authentication/login_model.dart';
import 'package:dating_app/src/model/dashboard/notification_model.dart';
import 'package:dating_app/src/model/label_model/common_chip_model.dart';
import 'package:dating_app/src/model/profile/my_subscription_model.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

var isInterNetExist = 0;
String? fcmtoken = "";
List<LabelResult> labelList = [];

late RtcEngine rtcengine;

GeneralSetting? generalSetting;
const String googleAPIKey = "AIzaSyDFEDH0OFN1aYV2n2QQ1zIbC8J6t9mngPI";
bool? isUserSubscribe;
int? uploadImageCount;
Color bottomNavigationBackgroundColor = ColorConstants().secondaryGradient;
String deviceType = Platform.isAndroid ? 0.toString() : 1.toString();
ValueNotifier chatUnreadCount = ValueNotifier(0);

RxList<ChipModel> booleanList = [
  ChipModel(id: "1", name: toLabelValue(StringConstants.yes)),
  ChipModel(id: "0", name: toLabelValue(StringConstants.no))
].obs;
bool isOpenCallDialog = false;

//Validate Pass
RxBool ispasswordNotValid = false.obs;
RxBool isConfirmpassNotValid = false.obs;
String? latitude;
String? longitude;

//for detect chat detail creen opens or not
RxBool isChatDetailOpen = false.obs;
RxString selectedChatReceiverID = "".obs;
//

LoginResponse? loginresponse;
RxBool isAppLaunched = false.obs;
RxBool isShowTimePopUp = false.obs;
RxBool isClickFromButtonView = false.obs;

NotificationData? message;

bool initialURILinkHandled = false;
IO.Socket? socket;

String? currentUuid;

MySubscriptionPlanResponse? currentSubscriptionData;

Future<int> getFileSize(String fileUrl) async {
  try {
    final file = File.fromUri(Uri.parse(fileUrl));

    if (await file.exists()) {
      final length = await file.length();
      // The file size is in bytes. You can convert it to other units if needed.
      if (kDebugMode) {
        print("Lyo lenght$length");
      }
      return length;
    } else {
      throw const FileSystemException('File not found');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error while getting file size: $e');
    }
    return -1; // Return -1 to indicate an error.
  }
}
