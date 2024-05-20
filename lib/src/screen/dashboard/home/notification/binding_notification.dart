import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/chat/chat_detail/controller_chat_detail.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/controller_card_swipe.dart';
import 'package:dating_app/src/screen/dashboard/home/notification/controller_notification.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/controller_user_detail.dart';
import 'package:dating_app/src/screen/dashboard/matches/match/controller_match.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_likes/controller_my_likes.dart';

class BindingNotification implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerNotification());
    Get.lazyPut(() => TabbarController());
    Get.put(ControllerUserDetail());
    Get.lazyPut(() => ControllerMatch());
    Get.lazyPut(() => ControllerCard());
    Get.lazyPut(() => ControllerMyLikes());
    Get.lazyPut(() => ControllerChatDetail());
  }
}
