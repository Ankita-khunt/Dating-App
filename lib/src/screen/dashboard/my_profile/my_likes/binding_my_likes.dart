import 'package:dating_app/imports.dart';

import 'controller_my_likes.dart';

class BindingMyLikes implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerMyLikes());
  }
}
