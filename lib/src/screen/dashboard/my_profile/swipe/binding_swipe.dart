import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/swipe/controller_swipe.dart';

class BindingMySwipe extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerMySwipe());
  }
}
