import 'package:dating_app/imports.dart';

import 'controller_faq.dart';

class BindingFaq implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerFaq());
  }
}
