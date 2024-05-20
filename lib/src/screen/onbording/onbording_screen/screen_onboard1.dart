import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/onbording/onbording_screen/controller_onboard.dart';
import 'package:sizer/sizer.dart';

class ScreenOnboard1 extends StatelessWidget {
  ScreenOnboard1({super.key});

  final onboardController = Get.find<ControllerOnboard>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
      widgetsScaffold: Scaffold(
        bottomNavigationBar: bottomNavigationView(),
        body: Image.asset(
          ImageConstants.icon_bg_onboarding,
          width: Get.width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget bottomNavigationView() {
    double hh = (51).h;

    return SizedBox(
      height: hh,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: CustomText(
                text: toLabelValue(StringConstants.find_your_partner),
                style: TextStyleConfig.boldTextStyle(
                  color: ColorConstants().greyWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: TextStyleConfig.bodyText32,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomText(
              text: toLabelValue(StringConstants.onboard_desc),
              textAlign: TextAlign.left,
              maxlines: 3,
              style: TextStyleConfig.boldTextStyle(
                color: ColorConstants().greyWhite,
                fontWeight: FontWeight.w600,
                fontSize: TextStyleConfig.bodyText16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 10),
            child: PlanButton(
              btnTitle: StringConstants.join_now,
              onClicked: () {
                Get.toNamed(Routes.onboard2);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: toLabelValue(StringConstants.already_have_acc),
                      style: TextStyleConfig.regularTextStyle(
                        color: ColorConstants().greyWhite,
                        fontSize: TextStyleConfig.bodyText14,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(Routes.login);
                      },
                      child: CustomText(
                        text: " ${toLabelValue(StringConstants.login)}",
                        style: TextStyleConfig.boldTextStyle(
                          color: ColorConstants().white,
                          fontSize: TextStyleConfig.bodyText14,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
