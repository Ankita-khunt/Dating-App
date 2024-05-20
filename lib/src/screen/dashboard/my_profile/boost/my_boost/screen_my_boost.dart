import 'dart:io';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/my_boost_model.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/boost/boost_history/binding_boost_history.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/boost/boost_history/controller_boost_history.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/boost/my_boost/controller_my_boost.dart';
import 'package:dating_app/src/widgets/custom_divider.dart';
import 'package:dating_app/src/widgets/payment_inapp.dart';
import 'package:dating_app/src/widgets/widget.card.dart';

class ScreenMyBoost extends StatelessWidget {
  ScreenMyBoost({super.key});

  final myBoostController = Get.find<ControllerMyBoost>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
        widgetsScaffold: Scaffold(
      backgroundColor: ColorConstants().white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(58.0),
          child: CustomAppBar(
            isGradientAppBar: true,
            isBackVisible: true,
            backIconColor: ColorConstants().white,
            title: toLabelValue(StringConstants.my_boost),
            titleColor: ColorConstants().white,
            thirdTrailing: SvgPicture.asset(ImageConstants.icon_history),
            onThirdOnclick: () {
              BindingBoostHistory().dependencies();
              Get.find<ControllerBoostHistory>().getMyBoostHistoryAPI("0");
              Get.toNamed(Routes.boost_history);
            },
          )),
      body: GetBuilder<ControllerMyBoost>(
        builder: (controller) {
          return controller.bootResponse != null
              ? controller.bootResponse!.myBoost != null
                  ? (controller.bootResponse!.myBoost!.remainingBoost == controller.bootResponse?.myBoost?.totalBoost &&
                          isShowTimePopUp.value == false)
                      ? no_boost_remains_view(controller.bootResponse!.myBoost!)
                      : available_boost_view()
                  : boost_plan_view()
              : controller.isDataLoaded.value
                  ? noDataView(StringConstants.no_data_found)
                  : const SizedBox();
        },
      ),
    ));
  }

  Widget boost_plan_view() {
    return Column(
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
                ImageConstants.icon_boost_logo,
                fit: BoxFit.scaleDown,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: CustomText(
                  text: toLabelValue(StringConstants.boost_profile),
                  style:
                      TextStyleConfig.boldTextStyle(fontSize: TextStyleConfig.bodyText24, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: Get.width * 0.8,
                child: CustomText(
                  text: toLabelValue(StringConstants.boost_desc),
                  textAlign: TextAlign.center,
                  style: TextStyleConfig.regularTextStyle(
                      color: ColorConstants().grey1, fontSize: TextStyleConfig.bodyText16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: boost_plans(myBoostController.bootResponse!),
            ),
          ],
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: SizedBox(
              height: Get.height * 0.17,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // SizedBox(
                  //   width: Get.width * 0.8,
                  //   child: CustomText(
                  //     text: toLabelValue(StringConstants.subscr_plan_desc),
                  //     textAlign: TextAlign.center,
                  //     style: TextStyleConfig.regularTextStyle(
                  //         color: ColorConstants().grey,
                  //         fontSize: TextStyleConfig.bodyText12),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 16,
                  ),
                  PrimaryButton(
                    btnTitle: StringConstants.strContinue,
                    onClicked: myBoostController.selectedBoostPlanProductID != ""
                        ? () {
                            PaymentService().productIds = [myBoostController.selectedBoostPlanProductID];
                            showLoader();
                            PaymentService()
                                .initConnection(myBoostController.selectedBoostPlanProductID, isFromBoost: true);

                            SharedPref.setBool(PreferenceConstants.isFromBoost, true);
                            SharedPref.setBool(PreferenceConstants.isFromChat, false);
                            SharedPref.setBool(PreferenceConstants.isFromSetupProfile, false);
                            SharedPref.setBool(PreferenceConstants.isFromSubscription, false);
                            SharedPref.setBool(PreferenceConstants.isFromSwipe, false);
                          }
                        : () {
                            showSnackBar(Get.overlayContext, toLabelValue(StringConstants.select_plan_duration));
                          },
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget boost_plans(BoostResponse boost) {
    return SizedBox(
      height: Get.height * 0.16,
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: boost.boostList!.length,
        itemBuilder: (context, index) {
          BoostList boostdata = boost.boostList![index];
          return Obx(() => Padding(
                padding:
                    EdgeInsets.fromLTRB((index == 0) ? 16 : 0, 0, (index == (boost.boostList!.length - 1)) ? 0 : 16, 0),
                child: InkWell(
                  onTap: () {
                    if (Platform.isAndroid) {
                      myBoostController.selectedBoostPlanProductID = myBoostController.boost_productIDs[index];
                    } else {
                      myBoostController.selectedBoostPlanProductID =
                          toLabelValue(myBoostController.boost_productIDs[index]);
                    }

                    myBoostController.selectedBoostPlan.value = index;
                    myBoostController.update();
                  },
                  child: SizedBox(
                    width: Get.width * 0.25,
                    child: CustomCard(
                        shadowColor: Colors.transparent,
                        isGradientCard: false,
                        borderradius: 12,
                        bordercolor: index == myBoostController.selectedBoostPlan.value
                            ? ColorConstants().primaryGradient
                            : ColorConstants().lightgrey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: boostdata.boostCount,
                              textAlign: TextAlign.center,
                              style: TextStyleConfig.boldTextStyle(
                                  fontWeight: FontWeight.w700, fontSize: TextStyleConfig.bodyText20),
                            ),
                            CustomText(
                              text: toLabelValue(StringConstants.boost),
                              textAlign: TextAlign.center,
                              style: TextStyleConfig.regularTextStyle(
                                  fontWeight: FontWeight.w500, fontSize: TextStyleConfig.bodyText14),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            CustomText(
                              text: "\$${boostdata.boostPrice}",
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

  Widget no_boost_remains_view(MyBoost boostdata) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
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
                              text: toLabelValue(StringConstants.my_boost),
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
                                      SvgPicture.asset(
                                        ImageConstants.icon_boosts,
                                        fit: BoxFit.scaleDown,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      CustomText(
                                        text:
                                            "${int.parse(boostdata.remainingBoost.toString())}/${boostdata.totalBoost}",
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
                      CustomDivider(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomText(
                          text: toLabelValue(StringConstants.boost_complete_dsc),
                          style: TextStyleConfig.boldTextStyle(
                              fontSize: TextStyleConfig.bodyText14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomText(
                text: toLabelValue(StringConstants.choose_your_plan),
                style: TextStyleConfig.boldTextStyle(fontSize: TextStyleConfig.bodyText16, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: Get.width * 0.8,
                child: CustomText(
                  text: toLabelValue(StringConstants.choose_your_plan_desc),
                  textAlign: TextAlign.left,
                  style: TextStyleConfig.regularTextStyle(
                      color: ColorConstants().grey1, fontSize: TextStyleConfig.bodyText14),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            boost_plans(myBoostController.bootResponse!),
          ],
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: SizedBox(
              height: Get.height * 0.17,
              child: Column(
                children: [
                  SizedBox(
                    width: Get.width * 0.8,
                    child: CustomText(
                      text: "",
                      textAlign: TextAlign.center,
                      style: TextStyleConfig.regularTextStyle(
                          color: ColorConstants().grey, fontSize: TextStyleConfig.bodyText12),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  PrimaryButton(
                    btnTitle: StringConstants.strContinue,
                    onClicked: myBoostController.selectedBoostPlanProductID != ""
                        ? () {
                            PaymentService().productIds = [myBoostController.selectedBoostPlanProductID];
                            showLoader();
                            PaymentService()
                                .initConnection(myBoostController.selectedBoostPlanProductID, isFromBoost: true);

                            SharedPref.setBool(PreferenceConstants.isFromBoost, true);
                            SharedPref.setBool(PreferenceConstants.isFromChat, false);
                            SharedPref.setBool(PreferenceConstants.isFromSetupProfile, false);
                            SharedPref.setBool(PreferenceConstants.isFromSubscription, false);
                            SharedPref.setBool(PreferenceConstants.isFromSwipe, false);
                          }
                        : () {
                            showSnackBar(Get.overlayContext, toLabelValue(StringConstants.select_plan_duration));
                          },
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget available_boost_view() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomCard(
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
                          text: toLabelValue(StringConstants.my_boost),
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
                                  SvgPicture.asset(
                                    ImageConstants.icon_boosts,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  CustomText(
                                    text:
                                        "${int.parse(myBoostController.bootResponse!.myBoost!.remainingBoost.toString())}/${myBoostController.bootResponse!.myBoost!.totalBoost}",
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
                  CustomDivider(),
                  Obx(() => Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: toLabelValue(StringConstants.current_boost),
                                  style: TextStyleConfig.boldTextStyle(
                                      fontSize: TextStyleConfig.bodyText14, fontWeight: FontWeight.w500),
                                ),
                                if (isShowTimePopUp.value)
                                  CustomText(
                                    text: toLabelValue(StringConstants.time_remainig),
                                    style: TextStyleConfig.boldTextStyle(
                                        color: ColorConstants().grey1,
                                        fontSize: TextStyleConfig.bodyText14,
                                        fontWeight: FontWeight.w400),
                                  ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            isShowTimePopUp.value
                                ? SizedBox(
                                    width: Get.width * 0.28,
                                    child: CustomCard(
                                        isGradientCard: false,
                                        borderradius: 10,
                                        shadowColor: Colors.transparent,
                                        backgroundColor: ColorConstants().secondaryGradient,
                                        bordercolor: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  CustomText(
                                                    text: toLabelValue(StringConstants.mins),
                                                    style: TextStyleConfig.boldTextStyle(
                                                        color: ColorConstants().white,
                                                        fontSize: TextStyleConfig.bodyText12,
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                  const SizedBox(),
                                                  CustomText(
                                                    text: toLabelValue(StringConstants.sec).capitalizeFirst,
                                                    style: TextStyleConfig.boldTextStyle(
                                                        color: ColorConstants().white,
                                                        fontSize: TextStyleConfig.bodyText12,
                                                        fontWeight: FontWeight.w400),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  CustomText(
                                                    text:
                                                        "${formattedTime(timeInSecond: myBoostController.boostTimerstart.value).toString().split(":").first}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyleConfig.boldTextStyle(
                                                        color: ColorConstants().white,
                                                        fontSize: TextStyleConfig.bodyText12,
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                  CustomText(
                                                    text: ":",
                                                    style: TextStyleConfig.boldTextStyle(
                                                        color: ColorConstants().white,
                                                        fontSize: TextStyleConfig.bodyText12,
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                  Obx(() => CustomText(
                                                        text:
                                                            "${formattedTime(timeInSecond: myBoostController.boostTimerstart.value).toString().split(":").last}",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyleConfig.boldTextStyle(
                                                            color: ColorConstants().white,
                                                            fontSize: TextStyleConfig.bodyText12,
                                                            fontWeight: FontWeight.w400),
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                                        )),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Center(
                                      child: CustomText(
                                        text: toLabelValue(StringConstants.no_boost_started),
                                        style: TextStyleConfig.boldTextStyle(
                                            color: ColorConstants().grey,
                                            fontSize: TextStyleConfig.bodyText14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      )),
                ],
              )),
          !isShowTimePopUp.value
              ? SafeArea(
                  child: PrimaryButton(
                    btnTitle: StringConstants.boost_profile,
                    onClicked: () {
                      myBoostController.boostProfileAPI();
                    },
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
