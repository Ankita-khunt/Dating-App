import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/subscriptions/controller_subscription.dart';

class BindingSubscription implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerSubscription());
  }
}
