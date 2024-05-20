import 'package:dating_app/imports.dart';

class ScreenSplash extends StatelessWidget {
  ScreenSplash({super.key});

  final splashController = Get.find<ControllerSplash>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
        widgetsScaffold: Scaffold(
      body: SizedBox(
        width: Get.width,
        child: Image.asset(
          ImageConstants.splash,
          fit: BoxFit.cover,
        ),
      ),
    ));
  }
}
