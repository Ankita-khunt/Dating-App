import 'package:dating_app/src/screen/dashboard/home/card_swip/binding_card_swipe.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/controller_card_swipe.dart';
import 'package:dating_app/src/screen/subscriptions/binding_subscription.dart';
import 'package:dating_app/src/screen/subscriptions/controller_subscription.dart';

import '../../../../imports.dart';

class ScreenSuccessProfileSetUP extends StatelessWidget {
  String? title;
  String? subTitle;
  String? subDescription;
  String? btnTitle;

  ScreenSuccessProfileSetUP(
      {super.key,
      this.btnTitle,
      this.subDescription,
      this.subTitle,
      this.title});

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
                text: toLabelValue(title!),
                textAlign: TextAlign.center,
                style: TextStyleConfig.boldTextStyle(
                    color: ColorConstants().white,
                    fontWeight: FontWeight.w700,
                    fontSize: TextStyleConfig.bodyText24)),
            subTitle != ""
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: CustomText(
                        text: toLabelValue(subTitle!),
                        textAlign: TextAlign.center,
                        style: TextStyleConfig.regularTextStyle(
                            color: ColorConstants().white,
                            fontWeight: FontWeight.w600,
                            fontSize: TextStyleConfig.bodyText16)),
                  )
                : const SizedBox(
                    height: 4,
                  ),
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 8, 36, 24),
              child: CustomText(
                  text: toLabelValue(subDescription ?? ""),
                  textAlign: TextAlign.center,
                  style: TextStyleConfig.regularTextStyle(
                      color: ColorConstants().white,
                      fontWeight: FontWeight.w400,
                      fontSize: TextStyleConfig.bodyText14)),
            ),
            PlanButton(
              btnWidth: Get.width * 0.56,
              btnTitle: btnTitle!,
              foregroundcolor: ColorConstants().primaryGradient,
              onClicked: () {
                if (subTitle!.isEmpty) {
                  BindingCard().dependencies();
                  Get.find<ControllerCard>().showSuggestionOverlay.value = true;

                  Get.toNamed(Routes.customTabbar);
                } else {
                  BindingSubscription().dependencies();
                  SharedPref.setBool(
                      PreferenceConstants.isFromSetupProfile, true);
                  Get.find<ControllerSubscription>().isFromSetUpProfile = true;
                  Get.toNamed(Routes.subscription);
                }
              },
            ),
            if (subTitle != "")
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    CustomText(
                        text: "OR",
                        textAlign: TextAlign.center,
                        style: TextStyleConfig.regularTextStyle(
                            color: ColorConstants().white,
                            fontWeight: FontWeight.w600,
                            fontSize: TextStyleConfig.bodyText16)),
                    const SizedBox(height: 16),
                    PlanButton(
                      btnWidth: Get.width * 0.56,
                      btnTitle: StringConstants.continue_free,
                      foregroundcolor: ColorConstants().primaryGradient,
                      onClicked: () {
                        Get.offAllNamed(Routes.customTabbar);
                      },
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    ));
  }
}
