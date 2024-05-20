import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/matches/match/controller_match.dart';

class BindingMatch implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerMatch());
  }
}
