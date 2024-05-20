import 'dart:io';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/my_swipe_model.dart';
import 'package:dating_app/src/widgets/payment_inapp.dart';
import 'package:dating_app/src/widgets/widget.card.dart';

import 'controller_swipe.dart';

class ScreenMySwipe extends StatelessWidget {
  ScreenMySwipe({super.key});

  final mySwipeController = Get.find<ControllerMySwipe>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
        widgetsScaffold: Scaffold(
      bottomNavigationBar: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Obx(() {
              return PrimaryButton(
                btnTitle: StringConstants.pay,
                onClicked: mySwipeController.selectedSwipePlan.value == (-1)
                    ? () {
                        showSnackBar(Get.overlayContext, toLabelValue(StringConstants.select_plan_duration));
                      }
                    : () {
                        PaymentService().productIds = [mySwipeController.selectedSwipePlanProductID];
                        showLoader();
                        PaymentService().initConnection(
                          mySwipeController.selectedSwipePlanProductID,
                          isFromBoost: false,
                          isFromSwipe: true,
                          isFromSubscription: false,
                          isFromSetUpProfile: false,
                          isFRomChatScreen: false,
                        );
                        SharedPref.setBool(PreferenceConstants.isFromBoost, false);
                        SharedPref.setBool(PreferenceConstants.isFromChat, false);
                        SharedPref.setBool(PreferenceConstants.isFromSetupProfile, false);
                        SharedPref.setBool(PreferenceConstants.isFromSubscription, false);
                        SharedPref.setBool(PreferenceConstants.isFromSwipe, true);
                      },
              );
            })),
      ),
      backgroundColor: ColorConstants().white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(58.0),
          child: CustomAppBar(
            isGradientAppBar: true,
            isBackVisible: true,
            backIconColor: ColorConstants().white,
            title: toLabelValue(StringConstants.my_swipe),
            titleColor: ColorConstants().white,
          )),
      body: GetBuilder<ControllerMySwipe>(
        builder: (controller) {
          return controller.mySwipeResponse != null
              ? controller.mySwipeResponse?.mySwipe != null
                  ? available_swipes()
                  : swipe_Desc()
              : controller.isDataLoaded.value
                  ? noDataView(StringConstants.no_data_found)
                  : const SizedBox();
        },
      ),
    ));
  }

  Widget available_swipes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomCard(
              shadowColor: Colors.transparent,
              isGradientCard: false,
              borderradius: 12,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: toLabelValue(StringConstants.my_swipe),
                          style: TextStyleConfig.boldTextStyle(
                              fontSize: TextStyleConfig.bodyText16, fontWeight: FontWeight.w600),
                        ),
                        CustomCard(
                            isGradientCard: true,
                            primaryGradient: ColorConstants().primaryGradient,
                            secondaryGradient: ColorConstants().secondaryGradient,
                            shadowColor: Colors.transparent,
                            borderradius: 50,
                            bordercolor: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: "${int.parse(mySwipeController.mySwipeResponse!.mySwipe!.totalSwipe!)}",
                                    style: TextStyleConfig.boldTextStyle(
                                        color: ColorConstants().white,
                                        fontSize: TextStyleConfig.bodyText16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              )),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 36,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomText(
                    text: toLabelValue(StringConstants.choose_your_plan),
                    style: TextStyleConfig.boldTextStyle(
                        fontSize: TextStyleConfig.bodyText16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomText(
                    text: toLabelValue(StringConstants.swipe_desc),
                    textAlign: TextAlign.left,
                    style: TextStyleConfig.regularTextStyle(
                        color: ColorConstants().grey1, fontSize: TextStyleConfig.bodyText16),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                swipe_plans(),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget swipe_Desc() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              Center(
                child: SvgPicture.asset(
                  ImageConstants.icon_like_detail,
                  fit: BoxFit.scaleDown,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: CustomText(
                    text: toLabelValue(StringConstants.get_swipes),
                    style: TextStyleConfig.boldTextStyle(
                        fontSize: TextStyleConfig.bodyText24, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: Get.width * 0.8,
                  child: CustomText(
                    text: toLabelValue(StringConstants.swipe_desc),
                    textAlign: TextAlign.center,
                    style: TextStyleConfig.regularTextStyle(
                        color: ColorConstants().grey1, fontSize: TextStyleConfig.bodyText16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: swipe_plans(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget swipe_plans() {
    return SizedBox(
      height: Get.height * 0.16,
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: mySwipeController.mySwipeResponse?.swipeList?.length,
        itemBuilder: (context, index) {
          SwipeList? swipedata = mySwipeController.mySwipeResponse?.swipeList?[index];
          return Obx(() => Padding(
                padding: EdgeInsets.fromLTRB((index == 0) ? 16 : 0, 0,
                    (index == (mySwipeController.mySwipeResponse!.swipeList!.length - 1)) ? 0 : 16, 0),
                child: InkWell(
                  onTap: () {
                    mySwipeController.selectedSwipePlan.value = index;
                    if (Platform.isAndroid) {
                      mySwipeController.selectedSwipePlanProductID = mySwipeController.productKeySwipes[index];
                    } else {
                      mySwipeController.selectedSwipePlanProductID =
                          toLabelValue(mySwipeController.productKeySwipes[index]);
                    }

                    mySwipeController.update();
                  },
                  child: SizedBox(
                    width: Get.width * 0.25,
                    child: CustomCard(
                        shadowColor: Colors.transparent,
                        isGradientCard: false,
                        borderradius: 12,
                        bordercolor: index == mySwipeController.selectedSwipePlan.value
                            ? ColorConstants().primaryGradient
                            : ColorConstants().lightgrey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: swipedata?.swipeCount,
                              textAlign: TextAlign.center,
                              style: TextStyleConfig.boldTextStyle(
                                  fontWeight: FontWeight.w700, fontSize: TextStyleConfig.bodyText20),
                            ),
                            CustomText(
                              text: toLabelValue(StringConstants.swipe),
                              textAlign: TextAlign.center,
                              style: TextStyleConfig.regularTextStyle(
                                  fontWeight: FontWeight.w500, fontSize: TextStyleConfig.bodyText14),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            CustomText(
                              text: "\$${swipedata?.swipePrice}",
                              textAlign: TextAlign.center,
                              style: TextStyleConfig.boldTextStyle(
                                  fontWeight: FontWeight.w700, fontSize: TextStyleConfig.bodyText14),
                            ),
                          ],
                        )),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
