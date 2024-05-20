import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/matches/match_detail/controller_matchDetail.dart';

class BindingMatchDetail implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerMatchDetail());
  }
}
