import 'package:dating_app/imports.dart';

import 'controller_contact_us.dart';

class BindingContactUs implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerConcatUs());
  }
}
