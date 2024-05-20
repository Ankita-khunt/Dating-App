import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/authentication/login/controller_login.dart';
import 'package:dating_app/src/screen/dashboard/chat/chat_detail/controller_chat_detail.dart';
import 'package:dating_app/src/screen/setupprofile/controller_setup_profile.dart';

class BindingLogin implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerLogin());
    Get.lazyPut(() => ControllerCreateNewPass());
    Get.lazyPut(() => ControllerSetUpProfile());
    Get.lazyPut(() => ControllerChatDetail());
  }
}
