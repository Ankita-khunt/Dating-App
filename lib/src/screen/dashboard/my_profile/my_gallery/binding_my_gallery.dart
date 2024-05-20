import 'package:dating_app/imports.dart';

import 'controller_my_gallery.dart';

class BindingMyGallery implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerMyGallery());
  }
}
