import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_subscription/controller_my_subscription.dart';
import 'package:dating_app/src/widgets/custom_divider.dart';
import 'package:dating_app/src/widgets/widget.card.dart';

class ScreenMySubscription extends StatelessWidget {
  ScreenMySubscription({super.key});

  final mysubscriptionController = Get.find<ControllerMySubscription>();

  @override
  Widget build(BuildContext context) {
    return BaseController(widgetsScaffold: GetBuilder<ControllerMySubscription>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: ColorConstants().white,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(58.0),
              child: CustomAppBar(
                isGradientAppBar: true,
                isBackVisible: true,
                title: toLabelValue(StringConstants.my_subscription),
                titleColor: ColorConstants().white,
                backIconColor: ColorConstants().white,
              )),
          body: controller.mysubscription?.plan != null
              ? Column(
                  children: [
                    my_plan_view(),
                  ],
                )
              : controller.isDataLoaded.value
                  ? noDataView(StringConstants.no_data_found)
                  : const SizedBox(),
          bottomNavigationBar: controller.mysubscription != null && controller.mysubscription!.plan!.planId == "1"
              ? selectPlanView()
              : const SizedBox(),
        );
      },
    ));
  }

  Widget selectPlanView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(
          btnTitle: StringConstants.select_plan,
          onClicked: () {
            Get.toNamed(Routes.subscription)!.then((value) {
              mysubscriptionController.getMySubscriptionAPI();
            });
          },
        ),
      ),
    );
  }

  Widget free_plan_view() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: toLabelValue(
                    StringConstants.your_current_plan,
                  ),
                  style: TextStyleConfig.boldTextStyle(
                    fontSize: TextStyleConfig.bodyText16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomCard(
                borderradius: 12,
                isGradientCard: false,
                bordercolor: ColorConstants().lightgrey,
                shadowColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "Free",
                        style: TextStyleConfig.boldTextStyle(
                          fontSize: TextStyleConfig.bodyText16,
                        ),
                      ),
                      CustomText(
                        text: r'$0.00',
                        style: TextStyleConfig.boldTextStyle(
                            color: ColorConstants().primaryGradient,
                            fontSize: TextStyleConfig.bodyText20,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }

  Widget my_plan_view() {
    return GetBuilder<ControllerMySubscription>(builder: (controller) {
      return controller.mysubscription != null
          ? controller.mysubscription!.plan!.planId == "1"
              ? free_plan_view()
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: toLabelValue(
                              StringConstants.your_current_plan,
                            ),
                            style: TextStyleConfig.boldTextStyle(
                              fontSize: TextStyleConfig.bodyText16,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(Routes.subscription)!.then((value) {
                                mysubscriptionController.getMySubscriptionAPI();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomText(
                                text: toLabelValue(
                                  StringConstants.upgrade,
                                ),
                                style: TextStyleConfig.boldTextStyle(
                                    fontSize: TextStyleConfig.bodyText16, color: ColorConstants().primaryGradient),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: CustomCard(
                            borderradius: 12,
                            isGradientCard: false,
                            bordercolor: ColorConstants().lightgrey,
                            shadowColor: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            controller.mysubscription!.plan!.planId == "2"
                                                ? ImageConstants.icon_primium_black
                                                : ImageConstants.icon_VIP,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          CustomText(
                                            text: controller.mysubscription!.plan!.planName,
                                            style: TextStyleConfig.boldTextStyle(
                                              fontSize: TextStyleConfig.bodyText16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      CustomText(
                                        text: DateTime.parse(controller.mysubscription!.plan!.planExpireDate!)
                                                .isBefore(DateTime.now())
                                            ? " Your current plan is expired."
                                            : controller.mysubscription!.plan!.planExpireDate! != ""
                                                ? "${toLabelValue(
                                                    StringConstants.plan_expire_on,
                                                  )} ${dateformate(controller.mysubscription!.plan!.planExpireDate!, "dd MMMM, yyyy")}"
                                                : "",
                                        style: TextStyleConfig.regularTextStyle(
                                            fontSize: DateTime.parse(controller.mysubscription!.plan!.planExpireDate!)
                                                    .isBefore(DateTime.now())
                                                ? TextStyleConfig.bodyText14
                                                : TextStyleConfig.bodyText12,
                                            color: DateTime.parse(controller.mysubscription!.plan!.planExpireDate!)
                                                    .isBefore(DateTime.now())
                                                ? ColorConstants().errorRed
                                                : ColorConstants().grey1),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        text: '\$${controller.mysubscription!.plan!.planPrice}',
                                        style: TextStyleConfig.boldTextStyle(
                                            color: ColorConstants().primaryGradient,
                                            fontSize: TextStyleConfig.bodyText20,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      CustomText(
                                        text: '/${controller.mysubscription!.plan!.planPerDuration!.toLowerCase()}',
                                        style: TextStyleConfig.regularTextStyle(
                                          color: ColorConstants().primaryGradient,
                                          fontSize: TextStyleConfig.bodyText14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ),
                      controller.subscriptionBenefits.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: toLabelValue(
                                    StringConstants.your_benefits,
                                  ),
                                  style: TextStyleConfig.boldTextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: TextStyleConfig.bodyText16,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: controller.subscriptionBenefits.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        SvgPicture.asset(ImageConstants.icon_right_check),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        CustomText(
                                          margin: const EdgeInsets.all(4),
                                          text: controller.subscriptionBenefits[index],
                                          style: TextStyleConfig.regularTextStyle(
                                              fontWeight: FontWeight.w400, fontSize: TextStyleConfig.bodyText16),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ))
          : controller.isDataLoaded.value
              ? noDataView(StringConstants.no_data_found)
              : const SizedBox();
    });
  }

  Widget addonsView() {
    return mysubscriptionController.mysubscription != null &&
            mysubscriptionController.mysubscription!.plan!.addons!.isNotEmpty
        ? Column(
            children: [
              CustomDivider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: toLabelValue(
                            StringConstants.your_addons,
                          ),
                          style: TextStyleConfig.boldTextStyle(
                            fontSize: TextStyleConfig.bodyText16,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.subscription);
                          },
                          child: CustomText(
                            text: toLabelValue(
                              StringConstants.get_more,
                            ),
                            style: TextStyleConfig.boldTextStyle(
                                fontSize: TextStyleConfig.bodyText16, color: ColorConstants().primaryGradient),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomCard(
                      isGradientCard: false,
                      borderradius: 16,
                      shadowColor: Colors.transparent,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: mysubscriptionController.mysubscription!.plan!.addons!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: mysubscriptionController.mysubscription!.plan!.addons![index].addonPlan == "0"
                                      ? toLabelValue(StringConstants.boost)
                                      : toLabelValue(StringConstants.swipe),
                                  style: TextStyleConfig.regularTextStyle(fontSize: TextStyleConfig.bodyText14),
                                ),
                                CustomText(
                                  text:
                                      "${mysubscriptionController.mysubscription!.plan!.addons![index].addonDetail} ${mysubscriptionController.mysubscription!.plan!.addons![index].addonPlan == "0" ? toLabelValue(StringConstants.boost) : toLabelValue(StringConstants.swipe)}",
                                  style: TextStyleConfig.boldTextStyle(
                                      fontWeight: FontWeight.w700, fontSize: TextStyleConfig.bodyText14),
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return CustomDivider();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}
