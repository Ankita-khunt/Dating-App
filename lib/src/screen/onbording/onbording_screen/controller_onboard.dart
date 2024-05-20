import 'package:dating_app/imports.dart';

class ControllerOnboard extends GetxController {
  @override
  void onInit() {
    super.onInit();
    isAppLaunched();
  }

  isAppLaunched() async {
    await SharedPref.setBool(PreferenceConstants.isAppLaunched, true);
  }
}
