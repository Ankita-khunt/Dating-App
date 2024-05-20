import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/chat/chat_detail/controller_chat_detail.dart';
import 'package:dating_app/src/screen/dashboard/chat/chats/controller_chats.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/controller_card_swipe.dart';
import 'package:dating_app/src/screen/dashboard/matches/match/controller_match.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/profile/controller_profile.dart';

class TabbarBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TabbarController());
    Get.lazyPut(() => ControllerProfile());
    Get.lazyPut(() => ControllerCard());
    Get.lazyPut(() => ControllerChats());
    Get.lazyPut(() => ControllerMatch());
    Get.lazyPut(() => ControllerChatDetail());
  }
}
