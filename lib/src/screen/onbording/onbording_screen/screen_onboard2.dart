import 'package:dating_app/imports.dart';
import 'package:sizer/sizer.dart';

class ScreenOnboard2 extends StatelessWidget {
  const ScreenOnboard2({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseController(
        widgetsScaffold: Scaffold(
      backgroundColor: ColorConstants().white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: Get.height * 0.6,
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  Image.asset(
                    ImageConstants.icon_onboardBG2,
                    height: Get.height * 0.58,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.scaleDown,
                  ),
                ],
              ),
            ),
            IntrinsicHeight(
              child: Container(
                height: (Get.height * 0.4) - kBottomNavigationBarHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: CustomText(
                        text: toLabelValue(StringConstants.find_amaz_people),
                        style: TextStyleConfig.boldTextStyle(
                            color: ColorConstants().black,
                            fontWeight: FontWeight.w700,
                            fontSize: TextStyleConfig.bodyText32),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 2.h),
                      child: PrimaryButton(
                        btnTitle: StringConstants.login,
                        onClicked: () {
                          Get.toNamed(Routes.login);
                        },
                      ),
                    ),
                    bottomNavigationView()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget bottomNavigationView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        CustomText(
            text: toLabelValue(StringConstants.dont_have_acc),
            style:
                TextStyleConfig.regularTextStyle(color: ColorConstants().black, fontSize: TextStyleConfig.bodyText14)),
        InkWell(
          onTap: () {
            Get.toNamed(Routes.register);
          },
          child: CustomText(
              text: " ${toLabelValue(StringConstants.register)}",
              style: TextStyleConfig.boldTextStyle(
                  color: ColorConstants().primaryGradient, fontSize: TextStyleConfig.bodyText14)),
        )
      ]),
    );
  }
}
