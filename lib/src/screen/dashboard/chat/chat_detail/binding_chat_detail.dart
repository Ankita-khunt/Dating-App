import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/chat/chat_detail/controller_chat_detail.dart';

class BindingChatDetail implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerChatDetail());
  }
}
