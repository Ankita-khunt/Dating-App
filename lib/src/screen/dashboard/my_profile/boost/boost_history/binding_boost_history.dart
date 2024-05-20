import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/boost/boost_history/controller_boost_history.dart';

class BindingBoostHistory extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerBoostHistory());
  }
}
