import 'package:dating_app/imports.dart';

class ScreenSuccessAccCreate extends StatefulWidget {
  const ScreenSuccessAccCreate({super.key});

  @override
  State<ScreenSuccessAccCreate> createState() => _ScreenSuccessAccCreateState();
}

class _ScreenSuccessAccCreateState extends State<ScreenSuccessAccCreate> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(
      const Duration(seconds: 3),
      () {
        Get.offAllNamed(Routes.login);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseController(
        widgetsScaffold: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ImageConstants.icon_success,
              height: 94,
              width: 94,
            ),
            const SizedBox(
              height: 24,
            ),
            CustomText(
                text:
                    toLabelValue(StringConstants.account_successfully_created),
                textAlign: TextAlign.center,
                style: TextStyleConfig.boldTextStyle(
                    color: ColorConstants().white,
                    fontSize: TextStyleConfig.bodyText24)),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: CustomText(
                  text: toLabelValue(StringConstants.acc_create_success_desc),
                  textAlign: TextAlign.center,
                  style: TextStyleConfig.regularTextStyle(
                      color: ColorConstants().white,
                      fontWeight: FontWeight.w500,
                      fontSize: TextStyleConfig.bodyText14)),
            ),
          ],
        ),
      ),
    ));
  }
}
