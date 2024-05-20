import 'package:get/get.dart';

import 'controller_change_password.dart';

class BindingChangePassword extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangePasswordController());
  }
}
