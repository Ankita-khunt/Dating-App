import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/onbording/onbording_screen/controller_onboard.dart';

class BindingSplash implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerSplash());
    Get.lazyPut(() => ControllerOnboard());
    // Get.lazyPut(() => ControllerCard());
  }
}
