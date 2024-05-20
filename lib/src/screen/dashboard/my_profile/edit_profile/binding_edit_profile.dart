import 'package:dating_app/imports.dart';

import 'controller_edit_profile.dart';

class BindingEditProfile implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerEditProfile());
  }
}
