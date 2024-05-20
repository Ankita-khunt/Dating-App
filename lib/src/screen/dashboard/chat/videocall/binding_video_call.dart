import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/chat/videocall/controller_video_call.dart';

class BindingVideoCall implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerVideoCall());
  }
}
