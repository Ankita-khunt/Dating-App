import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/block_user/controller_block_user.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/boost/my_boost/controller_my_boost.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_gallery/controller_my_gallery.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_subscription/controller_my_subscription.dart';

import 'controller_profile.dart';

class BindingProfile implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerProfile());
    Get.lazyPut(() => ControllerBlockUser());
    Get.lazyPut(() => ControllerMySubscription());
    Get.lazyPut(() => ControllerMyBoost());
    Get.lazyPut(() => ControllerMyGallery());
  }
}
