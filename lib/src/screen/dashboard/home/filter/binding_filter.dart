import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/home/filter/controller_filter.dart';

class BindingFilter implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerFilter());
  }
}
