import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/controller_user_detail.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/preview_image/controller_preview.dart';

class BindingUserdetail implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerUserDetail());
    Get.lazyPut(() => ControllerPreview());
  }
}
