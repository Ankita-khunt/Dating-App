import 'dart:io';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/subscriptions/controller_subscription.dart';
import 'package:dating_app/src/widgets/payment_inapp.dart';
import 'package:dating_app/src/widgets/widget.card.dart';
import 'package:flutter/foundation.dart';

import '../../model/subscription/subscription_reponse_model.dart';

class ScreenSubscription extends StatelessWidget {
  ScreenSubscription({super.key});

  final subscriptionController = Get.find<ControllerSubscription>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants().white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(58.0),
            child: CustomAppBar(
              isGradientAppBar: true,
              isBackVisible: true,
              title: toLabelValue(StringConstants.subscription_plan),
              titleColor: ColorConstants().white,
              backIconColor: ColorConstants().white,
            )),
        body: GetBuilder<ControllerSubscription>(
          builder: (controller) {
            return controller.subscriptionsData != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            child: CustomText(
                              text: toLabelValue(StringConstants.choose_plan),
                              style: TextStyleConfig.boldTextStyle(
                                  fontSize: TextStyleConfig.bodyText16,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstants().black),
                            ),
                          ),
                          planView(),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: PrimaryButton(
                                  btnTitle: StringConstants.pay,
                                  onClicked: subscriptionController.selectedPlanpackage?.value == (-1)
                                      ? () {
                                          showSnackBar(context, toLabelValue(StringConstants.select_plan_duration));
                                        }
                                      : () {
                                          PaymentService().productIds = [subscriptionController.selectedProuctID];
                                          showLoader();

                                          PaymentService().initConnection(subscriptionController.selectedProuctID,
                                              isFromSubscription:
                                                  subscriptionController.isFromSetUpProfile ? false : true,
                                              isFromSetUpProfile: subscriptionController.isFromSetUpProfile,
                                              isFRomChatScreen: subscriptionController.isFromChatScreen);

                                          SharedPref.setBool(PreferenceConstants.isFromBoost, false);
                                          SharedPref.setBool(
                                              PreferenceConstants.isFromChat, subscriptionController.isFromChatScreen);
                                          SharedPref.setBool(PreferenceConstants.isFromSetupProfile,
                                              subscriptionController.isFromSetUpProfile);
                                          SharedPref.setBool(PreferenceConstants.isFromSubscription,
                                              subscriptionController.isFromSetUpProfile ? false : true);
                                          SharedPref.setBool(PreferenceConstants.isFromSwipe, false);
                                        })),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ],
                  )
                : controller.isDataLoaded.value
                    ? noDataView(StringConstants.no_data_found)
                    : const SizedBox();
          },
        ));
  }

  Widget planView() {
    return GetBuilder<ControllerSubscription>(
      builder: (controller) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 54,
                child: CustomCard(
                  shadowColor: Colors.transparent,
                  isGradientCard: false,
                  borderradius: 27,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: ColorConstants().white,
                        borderRadius: BorderRadius.circular(
                          25.0,
                        ),
                      ),
                      child: TabBar(
                        controller: subscriptionController.planTabController,
                        physics: const NeverScrollableScrollPhysics(),
                        // give the indicator a decoration (color and border radius)
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            25.0,
                          ),
                          color: ColorConstants().primaryGradient,
                        ),
                        labelStyle: TextStyleConfig.boldTextStyle(
                            fontSize: TextStyleConfig.bodyText14,
                            color: ColorConstants().white,
                            fontWeight: FontWeight.w700),
                        labelColor: ColorConstants().white,
                        dividerHeight: 0,
                        unselectedLabelColor: ColorConstants().black,
                        onTap: (value) {
                          controller.planTabController.index = value;
                          //Clear plan selection on tab change

                          controller.selectedSubsriptionPlan!.value = value;
                          controller.selectedPlanpackage!.value = (-1);

                          controller.update();
                        },
                        tabs: [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  controller.planTabController.index == 0
                                      ? ImageConstants.icon_premium
                                      : ImageConstants.icon_primium_black,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                CustomText(
                                    text: toLabelValue(StringConstants.premium),
                                    style: TextStyleConfig.boldTextStyle(
                                        color: controller.planTabController.index == 0
                                            ? ColorConstants().white
                                            : ColorConstants().black,
                                        fontSize: TextStyleConfig.bodyText14,
                                        fontWeight: FontWeight.w700))
                              ],
                            ),
                          ),
                          Tab(
                            height: 20,
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(controller.planTabController.index == 1
                                    ? ImageConstants.icon_vip_white
                                    : ImageConstants.icon_VIP),
                                const SizedBox(
                                  width: 6,
                                ),
                                CustomText(
                                    text: toLabelValue(StringConstants.vip),
                                    style: TextStyleConfig.boldTextStyle(
                                        color: controller.planTabController.index == 1
                                            ? ColorConstants().white
                                            : ColorConstants().black,
                                        fontSize: TextStyleConfig.bodyText14,
                                        fontWeight: FontWeight.w700))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //  tab bar view here
            Center(
              child: [
                planTabView(controller.subscriptionsData!.plans!.premiumPlan!, controller.premiumSubscriptionBenefits),
                planTabView(controller.subscriptionsData!.plans!.vIPPlan!, controller.vipSubscriptionBenefits)
              ][subscriptionController.planTabController.index],
            ),
          ],
        );
      },
    );
  }

  Widget planTabView(PremiumPlan planData, List<String> featurePlan) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: featurePlan.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                SvgPicture.asset(ImageConstants.icon_right_check),
                const SizedBox(
                  width: 8,
                ),
                CustomText(
                  margin: const EdgeInsets.all(4),
                  text: featurePlan[index],
                  style: TextStyleConfig.regularTextStyle(fontSize: TextStyleConfig.bodyText16),
                ),
              ],
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: CustomText(
            margin: const EdgeInsets.all(4),
            text: toLabelValue(StringConstants.select_duration),
            style: TextStyleConfig.regularTextStyle(fontWeight: FontWeight.w600, fontSize: TextStyleConfig.bodyText16),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        plansCard(planData.planDuration!)
      ]),
    );
  }

  Widget plansCard(List<PlanDuration> plan) {
    return Obx(() => Row(
        mainAxisAlignment: (plan.length == 2) ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(plan.length, (index) {
          return plan[index].discount != ""
              ? InkWell(
                  onTap: () {
                    subscriptionController.selectedPlanpackage!.value = index;
                    subscriptionController.isFreePlanSelected(false);
                    subscriptionController.totalPrice!.value =
                        subscriptionController.selectedSubsriptionPlan!.value == 0
                            ? subscriptionController.subscriptionsData!.plans!.premiumPlan!.planDuration![index].price
                                .toString()
                            : subscriptionController.subscriptionsData!.plans!.vIPPlan!.planDuration![index].price
                                .toString();

                    //Select ProductID
                    if (subscriptionController.selectedSubsriptionPlan?.value == 0) {
                      if (Platform.isAndroid) {
                        subscriptionController.selectedProuctID = subscriptionController.productKeyPremiums[index];
                      } else {
                        subscriptionController.selectedProuctID =
                            toLabelValue(subscriptionController.productKeyPremiums[index]);
                      }
                    } else {
                      if (Platform.isAndroid) {
                        subscriptionController.selectedProuctID = subscriptionController.productKeyVIPs[index];
                      } else {
                        subscriptionController.selectedProuctID =
                            toLabelValue(subscriptionController.productKeyVIPs[index]);
                      }
                    }
                    if (kDebugMode) {
                      print(subscriptionController.selectedProuctID);
                    }

                    ///
                    ///
                    subscriptionController.update();

                    //InAPP purchase
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: (plan.length == 2) ? 14 : 0),
                    child: SizedBox(
                      height: Get.height * 0.17,
                      width: Get.width / 3.5,
                      child: CustomGradientCard(
                          isgradientBorder: index == subscriptionController.selectedPlanpackage!.value ? true : false,
                          borderradius: 13,
                          bordercolor: plan[index].isActivePlan == "1" ? ColorConstants().grey : null,
                          shadowColor: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: ColorConstants().primaryLight,
                                    gradient: index == subscriptionController.selectedPlanpackage!.value
                                        ? LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                                ColorConstants().primaryGradient,
                                                ColorConstants().secondaryGradient
                                              ])
                                        : null,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  width: Get.width,
                                  height: 30,
                                  child: Center(
                                    child: CustomText(
                                      text: "${toLabelValue(StringConstants.save)} ${plan[index].discount}",
                                      style: TextStyleConfig.regularTextStyle(
                                          color: index == subscriptionController.selectedPlanpackage!.value
                                              ? ColorConstants().white
                                              : ColorConstants().black,
                                          fontSize: TextStyleConfig.bodyText10,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                CustomText(
                                  text: plan[index].duration,
                                  style: TextStyleConfig.regularTextStyle(
                                      color: plan[index].isActivePlan == "1"
                                          ? ColorConstants().grey
                                          : ColorConstants().black,
                                      fontSize: TextStyleConfig.bodyText14,
                                      fontWeight: FontWeight.w500),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16, bottom: 2),
                                  child: CustomText(
                                    text: "${generalSetting?.currency}${plan[index].price}",
                                    style: TextStyleConfig.regularTextStyle(
                                        color: plan[index].isActivePlan == "1"
                                            ? ColorConstants().grey
                                            : ColorConstants().black,
                                        fontSize: TextStyleConfig.bodyText14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                CustomText(
                                  text: plan[index].duration?.toLowerCase() == "weekly"
                                      ? "Per week"
                                      : plan[index].duration?.toLowerCase() == "monthly"
                                          ? "Per month"
                                          : "Per year",
                                  style: TextStyleConfig.regularTextStyle(
                                      color: ColorConstants().grey1,
                                      fontSize: TextStyleConfig.bodyText12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                )
              : InkWell(
                  onTap: plan[index].isActivePlan == "1"
                      ? null
                      : () {
                          subscriptionController.selectedPlanpackage!.value = index;
                          subscriptionController.isFreePlanSelected(false);
                          subscriptionController.totalPrice!.value =
                              subscriptionController.selectedSubsriptionPlan?.value == 0
                                  ? subscriptionController
                                      .subscriptionsData!.plans!.premiumPlan!.planDuration![index].price
                                      .toString()
                                  : subscriptionController.subscriptionsData!.plans!.vIPPlan!.planDuration![index].price
                                      .toString();

                          //Select ProductID
                          if (subscriptionController.selectedSubsriptionPlan?.value == 0) {
                            if (Platform.isAndroid) {
                              subscriptionController.selectedProuctID =
                                  subscriptionController.productKeyPremiums[index];
                            } else {
                              subscriptionController.selectedProuctID =
                                  toLabelValue(subscriptionController.productKeyPremiums[index]);
                            }
                          } else {
                            if (Platform.isAndroid) {
                              subscriptionController.selectedProuctID = subscriptionController.productKeyVIPs[index];
                            } else {
                              subscriptionController.selectedProuctID =
                                  toLabelValue(subscriptionController.productKeyVIPs[index]);
                            }
                          }
                          if (kDebugMode) {
                            print(subscriptionController.selectedProuctID);
                          }

                          ///
                          subscriptionController.update();
                        },
                  child: Padding(
                    padding: EdgeInsets.only(right: (plan.length == 2) ? 14 : 0),
                    child: SizedBox(
                      height: Get.height * 0.149,
                      width: Get.width / 3.5,
                      child: CustomGradientCard(
                          isgradientBorder: index == subscriptionController.selectedPlanpackage!.value ? true : false,
                          borderradius: 13,
                          bordercolor: plan[index].isActivePlan == "1" ? ColorConstants().grey : null,
                          shadowColor: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: plan[index].duration,
                                style: TextStyleConfig.regularTextStyle(
                                    color: plan[index].isActivePlan == "1"
                                        ? ColorConstants().grey
                                        : ColorConstants().black,
                                    fontSize: TextStyleConfig.bodyText14,
                                    fontWeight: FontWeight.w500),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12, bottom: 2),
                                child: CustomText(
                                  text: "${generalSetting?.currency}${plan[index].price}",
                                  style: TextStyleConfig.regularTextStyle(
                                      color: plan[index].isActivePlan == "1"
                                          ? ColorConstants().grey
                                          : ColorConstants().black,
                                      fontSize: TextStyleConfig.bodyText14,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              CustomText(
                                text: plan[index].duration?.toLowerCase() == "weekly"
                                    ? "Per week"
                                    : plan[index].duration?.toLowerCase() == "monthly"
                                        ? "Per month"
                                        : "Per year",
                                style: TextStyleConfig.regularTextStyle(
                                    color: ColorConstants().grey1,
                                    fontSize: TextStyleConfig.bodyText12,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          )),
                    ),
                  ),
                );
        })));
  }
}
