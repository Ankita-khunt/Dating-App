import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_subscription/controller_my_subscription.dart';

class BindingMySubscription extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerMySubscription());
  }
}
