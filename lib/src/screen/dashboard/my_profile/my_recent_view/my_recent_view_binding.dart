import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_recent_view/my_recent_view_controller.dart';

class MyRecentViewBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => MyRecentViewController());
  }
}
