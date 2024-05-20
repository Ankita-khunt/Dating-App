import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/cms/faqs/controller_faq.dart';

import 'controller_cms.dart';

class BindingCMS implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerCMS());
    Get.lazyPut(() => ControllerFaq());
  }
}
