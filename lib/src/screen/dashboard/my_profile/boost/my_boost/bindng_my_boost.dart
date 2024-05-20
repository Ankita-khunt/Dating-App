import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/boost/my_boost/controller_my_boost.dart';

class BindingMyBoost extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerMyBoost());
  }
}
