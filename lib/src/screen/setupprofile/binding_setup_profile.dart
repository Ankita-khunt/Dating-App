import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/setupprofile/controller_setup_profile.dart';

class BindingSetUpProfile implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerSetUpProfile());
  }
}
