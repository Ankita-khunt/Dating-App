import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/chat/chat_detail/controller_chat_detail.dart';
import 'package:dating_app/src/screen/dashboard/chat/chats/controller_chats.dart';

class BindingChats implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerChats());
    Get.lazyPut(() => ControllerChatDetail());
  }
}
