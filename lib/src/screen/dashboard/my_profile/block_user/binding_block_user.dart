import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/block_user/controller_block_user.dart';

class BindingBlockUser extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerBlockUser());
  }
}
