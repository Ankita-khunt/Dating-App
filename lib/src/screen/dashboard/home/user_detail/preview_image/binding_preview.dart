import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/preview_image/controller_preview.dart';

class BindingPreview implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerPreview());
  }
}
