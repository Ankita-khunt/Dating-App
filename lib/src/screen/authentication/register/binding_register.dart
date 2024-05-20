import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/authentication/register/controller_register.dart';

class BindingRegister implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerRegister());
  }
}
