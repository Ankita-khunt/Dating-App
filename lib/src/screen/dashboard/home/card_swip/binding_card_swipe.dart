import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/chat/chat_detail/controller_chat_detail.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/controller_card_swipe.dart';
import 'package:dating_app/src/screen/dashboard/home/filter/controller_filter.dart';
import 'package:dating_app/src/screen/dashboard/home/notification/controller_notification.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/controller_user_detail.dart';

class BindingCard implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerCard());
    Get.lazyPut(() => ControllerNotification());
    Get.lazyPut(() => ControllerUserDetail());
    Get.lazyPut(() => ControllerFilter());
    Get.lazyPut(() => ControllerChatDetail());
  }
}
