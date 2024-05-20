import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/authentication/setup_profile_model.dart';
import 'package:dating_app/src/model/label_model/common_chip_model.dart';
import 'package:dating_app/src/screen/dashboard/chat/chat_detail/controller_chat_detail.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/controller_card_swipe.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/controller_user_detail.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/preview_image/binding_preview.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/preview_image/controller_preview.dart';
import 'package:dating_app/src/widgets/card_swipe/widgets/bottom_buttons_row.dart';
import 'package:dating_app/src/widgets/custom_chip.dart';
import 'package:dating_app/src/widgets/custom_divider.dart';
import 'package:dating_app/src/widgets/widget.card.dart';
import 'package:flutter/foundation.dart';

import '../../../../widgets/card_swipe/swipable_stack.dart';

class ScreenUserDetail extends StatelessWidget {
  ScreenUserDetail({super.key});

  final userDetailController = Get.find<ControllerUserDetail>();
  final cardController = Get.find<ControllerCard>();
  final chatDetailController = Get.find<ControllerChatDetail>();
  final tabbarController = Get.find<TabbarController>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
        widgetsScaffold: Scaffold(
            backgroundColor: ColorConstants().white,
            body: GetBuilder<ControllerUserDetail>(
              builder: (controller) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: controller.userdata != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  height: Get.height * 0.53,
                                  child: imageView(),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: -14,
                                  child: InkWell(
                                    onTap: () async {
                                      bool isChatAvailable =
                                          await SharedPref.getBool(PreferenceConstants.isChatAvailable);
                                      if (isUserSubscribe == true && isChatAvailable) {
                                        bottomNavigationBackgroundColor = ColorConstants().white;
                                        tabbarController.currentIndex.value = 2;
                                        Get.back();
                                        PushNotificationService().enableIOSNotifications(false);
                                        chatDetailController.chatDetailResponse = null;
                                        chatDetailController.isDataLoaded.value = false;
                                        chatDetailController.messagelist = [];
                                        chatDetailController.chatdetailAPI(
                                            controller.userdata!.chatId!, controller.userdata!.cardID!);
                                        Get.toNamed(Routes.chat_detail)!.then((value) {
                                          PushNotificationService().enableIOSNotifications(true);
                                        });
                                      } else {
                                        Get.toNamed(Routes.subscription);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: SvgPicture.asset(
                                        ImageConstants.icon_chat,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            detailView()
                          ],
                        )
                      : userDetailController.isDataLoaded.value
                          ? noDataView(StringConstants.no_data_found)
                          : Container(
                              color: Colors.amber,
                            ),
                );
              },
            )));
  }

  Widget imageView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            SizedBox(
              height: Get.height * 0.5,
              child: userDetailController.buildPageView(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: CustomCard(
                          isGradientCard: false,
                          bordercolor: Colors.transparent,
                          backgroundColor: ColorConstants().white,
                          borderradius: 15,
                          child: SvgPicture.asset(
                            ImageConstants.icon_back,
                            color: ColorConstants().primaryGradient,
                            fit: BoxFit.scaleDown,
                          )),
                    ),
                  ),
                  if (userDetailController.userdata?.isOnline == "1" && userDetailController.userdata?.is_block == "0")
                    Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                          height: 28,
                          width: 60,
                          child: CustomCard(
                              isGradientCard: false,
                              backgroundColor: ColorConstants().green,
                              bordercolor: ColorConstants().white,
                              borderradius: 28,
                              child: Center(
                                child: CustomText(
                                  text: toLabelValue(StringConstants.online),
                                  style: TextStyleConfig.regularTextStyle(
                                      styleLineHeight: 1.0, fontSize: 11, color: ColorConstants().white),
                                ),
                              ))),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget detailView() {
    return Column(children: [
      aboutInfoView(),
      CustomDivider(),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: blockView(),
      ),
      CustomDivider(),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "${toLabelValue(StringConstants.report)} ${userDetailController.userdata?.name}",
              style: TextStyleConfig.boldTextStyle(
                  fontSize: TextStyleConfig.bodyText16, fontWeight: FontWeight.w700, color: ColorConstants().black),
            ),
            InkWell(
              onTap: () {
                userDetailController.show_report_dialogue(userDetailController.userdata!.cardID.toString());
              },
              child: CustomText(
                text: toLabelValue(StringConstants.report),
                style: TextStyleConfig.boldTextStyle(
                    fontSize: TextStyleConfig.bodyText14,
                    fontWeight: FontWeight.w700,
                    color: ColorConstants().primaryGradient),
              ),
            ),
          ],
        ),
      ),
      BottomButtonsRow(
        isFromUserdetail: true,
        isFromCardList: userDetailController.isShowLikeButtom.value,
        isMatchedUser: userDetailController.userdata?.is_match_user == "0" ? false : true,
        likeIcon: ImageConstants.icon_white_heart,
        dislikeIcon: ImageConstants.icon_cross_like,
        countRightSwipe: cardController.countSwipeLimit.toInt(),
        planSwipCount: 0,
        onSwipe: (direction) {
          cardController.swipeCardController!
              .next(swipeDirection: direction, duration: const Duration(milliseconds: 500));
          cardController.listenController();
          cardController.update();
          Get.back();

          if (direction == SwipeDirection.left) {
            isClickFromButtonView.value = true;
            if (kDebugMode) {
              print(
                  "==== count ${Get.find<ControllerCard>().countSwipeLimit.value},+++${isClickFromButtonView.value} ");
            }

            if (cardController.planSwipCount.value != (-1) &&
                cardController.countSwipeLimit.value > Get.find<ControllerCard>().planSwipCount.value) {
              Get.toNamed(Routes.subscription);
            } else {
              cardController.cardActionAPI(userDetailController.userdata?.cardID ?? "", 0);
            }

            Get.find<ControllerCard>().update();
          } else {
            if (cardController.planSwipCount.value != (-1) &&
                (cardController.countSwipeLimit.value > cardController.planSwipCount.value)) {
              Get.toNamed(Routes.subscription);

              // onSwipe(SwipeDirection.right);
            } else {
              Get.find<ControllerCard>().cardActionAPI(userDetailController.userdata?.cardID ?? "", 1);
            }
            Get.find<ControllerCard>().update();
          }
        },
        onRewindTap: isUserSubscribe == true
            ? cardController.swipeCardController!.rewind
            : () {
                Get.toNamed(Routes.subscription);
              },
        canRewind: cardController.swipeCardController!.canRewind,
      ),
      const SizedBox(
        height: 24,
      )
    ]);
  }

  Widget aboutInfoView() {
    return SizedBox(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: userDetailController.userdata?.profileShortDesc,
            style: TextStyleConfig.regularTextStyle(
                fontSize: TextStyleConfig.bodyText14,
                fontWeight: FontWeight.w500,
                color: ColorConstants().primaryGradient),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: CustomText(
              text: "${userDetailController.userdata?.name}, ${userDetailController.userdata?.age}",
              style: TextStyleConfig.regularTextStyle(
                  fontSize: TextStyleConfig.bodyText20, fontWeight: FontWeight.w700, color: ColorConstants().black),
            ),
          ),
          CustomText(
            text: userDetailController.userdata?.profession,
            style: TextStyleConfig.regularTextStyle(
                fontSize: TextStyleConfig.bodyText14, fontWeight: FontWeight.w400, color: ColorConstants().grey1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: toLabelValue(StringConstants.location),
                      style: TextStyleConfig.regularTextStyle(
                          fontSize: TextStyleConfig.bodyText16,
                          fontWeight: FontWeight.w600,
                          color: ColorConstants().black),
                    ),
                    CustomCard(
                        isGradientCard: false,
                        backgroundColor: ColorConstants().primaryLight,
                        borderradius: 300,
                        bordercolor: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Row(
                            children: [
                              SvgPicture.asset(ImageConstants.icon_map_pin),
                              const SizedBox(
                                width: 4,
                              ),
                              CustomText(
                                text:
                                    "${userDetailController.userdata?.distance.toString()} ${toLabelValue(StringConstants.km)}",
                                style: TextStyleConfig.regularTextStyle(
                                    fontSize: TextStyleConfig.bodyText12,
                                    fontWeight: FontWeight.w500,
                                    color: ColorConstants().black),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                SizedBox(
                  width: Get.width * 0.65,
                  child: CustomText(
                    text: userDetailController.userdata?.loaction,
                    maxlines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyleConfig.regularTextStyle(
                        fontSize: TextStyleConfig.bodyText14,
                        fontWeight: FontWeight.w400,
                        color: ColorConstants().grey1),
                  ),
                ),
              ],
            ),
          ),
          CustomText(
            text: toLabelValue(StringConstants.about_bio),
            style: TextStyleConfig.regularTextStyle(
                fontSize: TextStyleConfig.bodyText16, fontWeight: FontWeight.w600, color: ColorConstants().black),
          ),
          const SizedBox(
            height: 4,
          ),
          ReadMoreText(
            userDetailController.userdata!.aboutBio!,
            trimLines: 4,
            trimLength: 400,
            preDataTextStyle:
                TextStyleConfig.regularTextStyle(fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
            style: TextStyleConfig.regularTextStyle(
                fontSize: TextStyleConfig.bodyText14, styleLineHeight: 1.6, color: ColorConstants().grey1),
            trimMode: TrimMode.Line,
            trimCollapsedText: toLabelValue(StringConstants.read_more),
            trimExpandedText: ' ${toLabelValue(StringConstants.read_less)}',
            moreStyle: TextStyleConfig.boldTextStyle(
                fontSize: TextStyleConfig.bodyText14, color: ColorConstants().primaryGradient),
            lessStyle: TextStyleConfig.boldTextStyle(
                fontSize: TextStyleConfig.bodyText14, color: ColorConstants().primaryGradient),
          ),
          const SizedBox(
            height: 16,
          ),
          CustomText(
            text: toLabelValue(StringConstants.hobbies),
            style: TextStyleConfig.regularTextStyle(
                fontSize: TextStyleConfig.bodyText16, fontWeight: FontWeight.w600, color: ColorConstants().black),
          ),
          const SizedBox(
            height: 4,
          ),
          MultiSelectChip(
            userDetailController.userdata!.hobbies!,
            isSelectable: false,
            onSelectionChanged: (selectedList) {
              userDetailController.update();
            },
          ),
          basicInfo()
        ],
      ),
    ));
  }

  Widget basicInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: toLabelValue(StringConstants.basic_information),
            style: TextStyleConfig.regularTextStyle(
                fontSize: TextStyleConfig.bodyText16, fontWeight: FontWeight.w600, color: ColorConstants().black),
          ),
          const SizedBox(
            height: 12,
          ),
          CustomCard(
              isGradientCard: false,
              borderradius: 12,
              shadowColor: Colors.transparent,
              child: Table(
                border: TableBorder(
                    bottom: BorderSide.none, horizontalInside: BorderSide(color: ColorConstants().lightBGgrey)),
                children: [
                  tabelRow(
                      StringConstants.height,
                      userDetailController.userdata?.height != ""
                          ? "${userDetailController.userdata?.height} ${userDetailController.userdata?.height_type == "0" ? "CM" : "IN"}"
                          : "-"),
                  tabelRow(
                      StringConstants.weight,
                      userDetailController.userdata?.weight != ""
                          ? "${userDetailController.userdata?.weight}   ${userDetailController.userdata?.weight_type == "0" ? "LBS" : "KG"}"
                          : "-"),
                  tabelRow(
                      StringConstants.marital_status,
                      userDetailController.userdata?.maritalStatus != ""
                          ? userDetailController.userdata?.maritalStatus
                          : "-"),
                  tabelRow(
                      StringConstants.dating_type,
                      userDetailController.userdata?.datingType != ""
                          ? userDetailController.userdata?.datingType
                          : "-"),
                  tabelRow(
                      StringConstants.dating_person_age_group,
                      userDetailController.userdata?.datingPersonAgeGroup != ""
                          ? userDetailController.userdata?.datingPersonAgeGroup
                          : "-"),
                  tabelRow(
                      StringConstants.diet_preference,
                      userDetailController.userdata?.diePreference != ""
                          ? userDetailController.getSetupProfile?.diePreference!
                              .firstWhere((element) => element.id == userDetailController.userdata?.diePreference)
                              .name
                          : "-"),
                  tabelRow(
                      StringConstants.income,
                      userDetailController.userdata?.income != ""
                          ? "${generalSetting?.currency}${userDetailController.userdata?.income}"
                          : "-"),
                  tabelRow(
                      StringConstants.net_worth,
                      userDetailController.userdata?.netWorth != ""
                          ? "${generalSetting?.currency}${userDetailController.userdata?.netWorth}"
                          : "-"),
                  tabelRow(
                      StringConstants.car_you_own,
                      userDetailController.userdata?.isCarOwn != ""
                          ? getBoolValue(userDetailController.userdata!.isCarOwn.toString())
                          : "-"),
                  tabelRow(StringConstants.star_sign,
                      userDetailController.userdata?.starSign != "" ? userDetailController.userdata?.starSign : "-"),
                  tabelRow(
                      StringConstants.smoke,
                      userDetailController.userdata?.isSmoke != ""
                          ? getBoolValue(userDetailController.userdata!.isSmoke.toString())
                          : "-"),
                  tabelRow(
                      StringConstants.drink,
                      userDetailController.userdata?.isDrink != ""
                          ? getBoolValue(userDetailController.userdata!.isDrink.toString())
                          : "-"),
                  tabelRow(
                      StringConstants.exercise,
                      userDetailController.userdata?.isExercise != ""
                          ? getBoolValue(userDetailController.userdata!.isExercise.toString())
                          : "-"),
                  tabelRow(StringConstants.body_type,
                      userDetailController.userdata?.bodyType != "" ? userDetailController.userdata?.bodyType : "-"),
                  tabelRow(
                      StringConstants.personality_type,
                      userDetailController.userdata?.personalityType != ""
                          ? userDetailController.userdata?.personalityType
                          : "-"),
                ],
              )),
          if (isUserSubscribe == true)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                CustomText(
                  text: toLabelValue(StringConstants.other_information),
                  style: TextStyleConfig.regularTextStyle(
                      fontSize: TextStyleConfig.bodyText16, fontWeight: FontWeight.w600, color: ColorConstants().black),
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomCard(
                    isGradientCard: false,
                    borderradius: 12,
                    shadowColor: Colors.transparent,
                    child: Table(
                      border: TableBorder(
                          bottom: BorderSide.none, horizontalInside: BorderSide(color: ColorConstants().lightBGgrey)),
                      children: [
                        tabelRow(
                            StringConstants.ethinicity,
                            userDetailController.userdata?.ethnicity != ""
                                ? userDetailController.userdata?.ethnicity
                                : "-"),
                        tabelRow(StringConstants.caste,
                            userDetailController.userdata?.cast != "" ? userDetailController.userdata?.cast : "-"),
                        tabelRow(
                            StringConstants.occupation,
                            userDetailController.userdata?.profession != ""
                                ? userDetailController.userdata?.profession
                                : "-"),
                        tabelRow(
                            StringConstants.political_leaning,
                            userDetailController.userdata?.politicalLeaning != ""
                                ? userDetailController.userdata?.politicalLeaning
                                : "-"),
                      ],
                    )),
              ],
            ),
          if (userDetailController.userdata!.images!.isNotEmpty) galleryView(),
          if (userDetailController.userdata!.images!.isEmpty)
            const SizedBox(
              height: 16,
            )
        ],
      ),
    );
  }

  String? getBoolValue(String id) {
    ChipModel str = booleanList.value.firstWhere((element) => element.id == id);
    return str.name;
  }

  String? getMultiSelectionValue(String id, dynamic list) {
    ProfileFieldResponse str = list.value.firstWhere((element) => element.id == id);
    return str.name;
  }

  TableRow tabelRow(String title, value) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: CustomText(
          text: toLabelValue(title),
          style: TextStyleConfig.regularTextStyle(
              fontSize: TextStyleConfig.bodyText14, fontWeight: FontWeight.w400, color: ColorConstants().grey1),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: CustomText(
          text: value,
          textAlign: TextAlign.end,
          style: TextStyleConfig.regularTextStyle(
              fontSize: TextStyleConfig.bodyText14, fontWeight: FontWeight.w500, color: ColorConstants().black),
        ),
      ),
    ]);
  }

  Widget galleryView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: toLabelValue(StringConstants.gallery),
                style: TextStyleConfig.boldTextStyle(
                    fontSize: TextStyleConfig.bodyText14, fontWeight: FontWeight.w600, color: ColorConstants().black),
              ),
              userDetailController.userdata!.images!.length > 3
                  ? InkWell(
                      onTap: () {
                        BindingPreview().dependencies();
                        Get.find<ControllerPreview>().productImages = userDetailController.userdata!.images!;
                        Get.find<ControllerPreview>().currentPageNotifier.value = 0;

                        Get.toNamed(Routes.preview_image);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                          text: toLabelValue(StringConstants.see_all),
                          style: TextStyleConfig.boldTextStyle(
                              fontSize: TextStyleConfig.bodyText14,
                              fontWeight: FontWeight.w700,
                              color: ColorConstants().primaryGradient),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          StaggeredGrid.count(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: List.generate(
                userDetailController.userdata!.images!.length,
                (index) {
                  return index == 0
                      ? StaggeredGridTile.count(
                          crossAxisCellCount: 2, mainAxisCellCount: 2, child: InkWell(child: photoView(index)))
                      : StaggeredGridTile.count(crossAxisCellCount: 1, mainAxisCellCount: 1, child: photoView(index));
                },
              )),
        ],
      ),
    );
  }

  Widget photoView(int index) {
    return InkWell(
      onTap: () {
        BindingPreview().dependencies();
        Get.find<ControllerPreview>().currentPageNotifier.value = index;
        Get.find<ControllerPreview>().productImages = userDetailController.userdata!.images!;
        Get.find<ControllerPreview>().changePageIndex(index);
        Get.toNamed(Routes.preview_image);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: CachedNetworkImage(
          imageUrl: "${generalSetting?.s3Url}${userDetailController.userdata!.images![index].imageUrl}",
          height: 500,
          width: 500,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget blockView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "${toLabelValue(StringConstants.block)} ${userDetailController.userdata?.name}",
              style: TextStyleConfig.regularTextStyle(
                  fontSize: TextStyleConfig.bodyText16, fontWeight: FontWeight.w700, color: ColorConstants().black),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomText(
              text: toLabelValue(StringConstants.you_wonts_see_them_again),
              style: TextStyleConfig.regularTextStyle(
                  fontSize: TextStyleConfig.bodyText14, fontWeight: FontWeight.w400, color: ColorConstants().grey1),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            if (userDetailController.userdata?.is_block == "0") {
              userDetailController.blockUserDialogue(
                  userDetailController.userdata!.cardID!.toString(), "1", userDetailController.userdata?.name);
            } else {
              userDetailController.blockUserAPI(userDetailController.userdata!.cardID!.toString(), "0");
            }
          },
          child: CustomText(
            text: toLabelValue(
                userDetailController.userdata?.is_block == "0" ? StringConstants.block : StringConstants.unblock),
            style: TextStyleConfig.boldTextStyle(
                fontSize: TextStyleConfig.bodyText14,
                fontWeight: FontWeight.w700,
                color: ColorConstants().primaryGradient),
          ),
        ),
      ],
    );
  }
}
