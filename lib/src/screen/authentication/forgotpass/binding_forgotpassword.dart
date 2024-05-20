import 'package:dating_app/imports.dart';

class BindingForgotPassword implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerForgotpassword());
    Get.lazyPut(() => ControllerCreateNewPass());
  }
}
