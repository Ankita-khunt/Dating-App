import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/controller_card_swipe.dart';
import 'package:dating_app/src/screen/dashboard/home/filter/binding_filter.dart';
import 'package:dating_app/src/screen/dashboard/home/filter/controller_filter.dart';
import 'package:dating_app/src/screen/dashboard/home/notification/binding_notification.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/binding_user_detail.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/controller_user_detail.dart';
import 'package:dating_app/src/widgets/card_swipe/swipable_stack.dart';
import 'package:dating_app/src/widgets/card_swipe/widgets/bottom_buttons_row.dart';
import 'package:dating_app/src/widgets/card_swipe/widgets/card_overlay.dart';
import 'package:dating_app/src/widgets/card_swipe/widgets/example_card.dart';
import 'package:flutter/foundation.dart';
import 'package:lottie/lottie.dart';

class ScreenCardWipe extends StatelessWidget {
  ScreenCardWipe({super.key});

  final cardController = Get.find<ControllerCard>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
        widgetsScaffold: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(58.0),
              child: Obx(() {
                if (kDebugMode) {
                  print(isShowTimePopUp.value);
                }
                return CustomAppBar(
                  isTitleWidget: isShowTimePopUp.value
                      ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          InkWell(
                            key: cardController.btnKey,
                            onTap: () {
                              Future.delayed(
                                const Duration(milliseconds: 500),
                                () {
                                  cardController.onShowBoostPopup(context);
                                },
                              );
                            },
                            child: SvgPicture.asset(ImageConstants.icon_boost_round),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, left: isUserSubscribe == true ? 0 : 50),
                            child: CustomText(
                              text: toLabelValue(StringConstants.dating),
                              style: TextStyle(
                                  fontSize: 24,
                                  color: ColorConstants().white,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: "datinghistoria"),
                            ),
                          ),
                          const SizedBox()
                        ])
                      : null,
                  title: toLabelValue(StringConstants.dating),
                  isCenterTitle: true,
                  titleColor: ColorConstants().white,
                  textstyle: TextStyle(
                      fontSize: 24,
                      color: ColorConstants().white,
                      fontWeight: FontWeight.w900,
                      fontFamily: "datinghistoria"),
                  isBackVisible: isUserSubscribe ?? false,
                  backWidgetIcon: ImageConstants.icon_incognito,
                  isFromDashBoard: false,
                  backIconColor:
                      !cardController.isIncognitoModeON.value ? ColorConstants().white : ColorConstants().black,
                  onBack: isUserSubscribe == false
                      ? () {
                          Get.toNamed(Routes.subscription);
                        }
                      : () {
                          dismissSnackBar();
                          cardController.isIncognitoModeON.value = !cardController.isIncognitoModeON.value;

                          if (cardController.isIncognitoModeON.value) {
                            showSnackBar(context, toLabelValue(StringConstants.incognito_mode_on));
                          } else {
                            showSnackBar(context, toLabelValue(StringConstants.incognito_mode_off));
                          }

                          cardController.update();
                        },
                  firstTrailing: SvgPicture.asset(ImageConstants.icon_filter),
                  onfirstOnclick: () async {
                    BindingFilter().dependencies();

                    Get.find<ControllerFilter>().getSetUpProfileAPI();

                    Get.find<ControllerFilter>().isDataLoaded(false);

                    Get.find<ControllerFilter>().editProfileResponse = null;

                    Get.toNamed(Routes.filter)!.then((value) {});
                  },
                  secondTrailing: Obx(() {
                    return cardController.notificationCount.value != 0
                        ? badges.Badge(
                            position: badges.BadgePosition.topEnd(top: 8, end: -10),
                            badgeAnimation: const badges.BadgeAnimation.slide(
                              curve: Curves.easeInCubic,
                            ),
                            showBadge: true,
                            badgeStyle: const badges.BadgeStyle(
                              padding: EdgeInsets.all(5),
                              badgeColor: Colors.red,
                            ),
                            badgeContent: Text(
                              cardController.notificationCount.value.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SvgPicture.asset(ImageConstants.icon_notification),
                            ))
                        : SvgPicture.asset(ImageConstants.icon_notification);
                  }),
                  onSecondOnclick: () {
                    BindingNotification().dependencies();
                    Get.toNamed(Routes.notification)!.then((value) {
                      cardController.userCardAPI();
                    });
                  },
                );
              }),
            ),
            body: SafeArea(
              top: false,
              child: Obx(
                () {
                  if (kDebugMode) {
                    print(cardController.isDataLoaded.value);
                  }
                  return ((cardController.cardlistResponse != null &&
                          cardController.cardlist.isNotEmpty &&
                          ((cardController.lastIndex.value != cardController.cardlist.length - 1))))
                      ? Center(
                          child: SizedBox(
                            height: Platform.isAndroid ? Get.height * 0.73 : Get.height * 0.68,
                            width: Get.width * 0.92,
                            child: Stack(
                              alignment: AlignmentDirectional.topCenter,
                              children: [
                                Positioned.fill(
                                  child: SwipableStack(
                                    itemCount: cardController.cardlist.length,
                                    dragStartCurve: Curves.linear,
                                    detectableSwipeDirections: const {
                                      SwipeDirection.right,
                                      SwipeDirection.left,
                                      SwipeDirection.up
                                    },
                                    swipeAnchor: SwipeAnchor.bottom,
                                    allowVerticalSwipe: false,
                                    controller: cardController.swipeCardController,
                                    stackClipBehaviour: Clip.none,
                                    onWillMoveNext: (index, swipeDirection) {
                                      //index get
                                      if (index == (cardController.cardlist.length - 4)) {
                                        cardController.pageIndex += 1;
                                        cardController.isDataLoaded.value = false;
                                        cardController.userCardAPI().then((value) {
                                          cardController.isDataLoaded.value = true;

                                          cardController.lastIndex.value = index;
                                          cardController.update();

                                          if (cardController.planSwipCount.value != (-1) &&
                                              (cardController.countSwipeLimit > (cardController.planSwipCount.value))) {
                                            Get.toNamed(Routes.subscription);
                                            return false;
                                          } else {
                                            cardController.countSwipeLimit.value += 1;
                                            //Store available swipes

                                            SharedPref.setInt(PreferenceConstants.availableSwipeCount,
                                                cardController.countSwipeLimit.value);

                                            if (swipeDirection.toString() == SwipeDirection.left.toString()) {
                                              if (cardController.lastIndex.value ==
                                                  (cardController.cardlist.length - 1)) {
                                                Get.find<ControllerCard>().isDataLoaded(false);
                                                Get.find<ControllerCard>()
                                                    .cardActionAPI(cardController.cardlist[index].id!, 0);
                                              }

                                              return true;
                                            } else {
                                              cardController.update();
                                              if (cardController.lastIndex.value ==
                                                  (cardController.cardlist.length - 1)) {
                                                cardController.isDataLoaded(false);

                                                cardController.cardActionAPI(cardController.cardlist[index].id!, 1);
                                              }

                                              return true;
                                            }
                                          }
                                        });
                                        return true;
                                      } else {
                                        cardController.isDataLoaded.value = true;

                                        cardController.lastIndex.value = index;
                                        cardController.update();

                                        if (cardController.planSwipCount.value != (-1) &&
                                            (cardController.countSwipeLimit > (cardController.planSwipCount.value))) {
                                          Get.toNamed(Routes.subscription);
                                          return false;
                                        } else {
                                          cardController.countSwipeLimit.value += 1;
                                          //Store available swipes

                                          SharedPref.setInt(PreferenceConstants.availableSwipeCount,
                                              cardController.countSwipeLimit.value);

                                          if (swipeDirection.toString() == SwipeDirection.left.toString()) {
                                            if (cardController.lastIndex.value ==
                                                (cardController.cardlist.length - 1)) {
                                              cardController.isDataLoaded(false);
                                              cardController.cardActionAPI(cardController.cardlist[index].id!, 0);
                                            }

                                            return true;
                                          } else {
                                            cardController.update();
                                            if (cardController.lastIndex.value ==
                                                (cardController.cardlist.length - 1)) {
                                              cardController.isDataLoaded(false);

                                              cardController.cardActionAPI(cardController.cardlist[index].id!, 1);
                                            }

                                            return true;
                                          }
                                        }
                                      }
                                    },
                                    onSwipeCompleted: (index, direction) {
                                      cardController.isDataLoaded.value = true;

                                      if (kDebugMode) {
                                        print("Print=== onSwipeCompleted");
                                      }
                                      if (isClickFromButtonView.value == false) {
                                        if (cardController.planSwipCount.value != (-1) &&
                                            (cardController.countSwipeLimit.value >
                                                cardController.planSwipCount.value)) {
                                          Get.toNamed(Routes.subscription);
                                        } else {
                                          cardController.isDataLoaded(false);

                                          if (direction.toString() == SwipeDirection.left.toString()) {
                                            cardController.cardActionAPI(cardController.cardlist[index].id!, 0);
                                          } else {
                                            cardController.cardActionAPI(
                                                cardController
                                                        .cardlist[cardController.swipeCardController!.currentIndex]
                                                        .id ??
                                                    "",
                                                1);
                                          }
                                        }
                                      }
                                    },
                                    horizontalSwipeThreshold: 0.1,
                                    builder: (context, properties) {
                                      final itemIndex = properties.index % cardController.cardlist.length;
                                      cardController.update();
                                      return Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              BindingUserdetail().dependencies();
                                              Get.find<ControllerUserDetail>().userdata = null;
                                              Get.find<ControllerUserDetail>().isIncognitoModeON.value =
                                                  cardController.isIncognitoModeON.value;
                                              Get.find<ControllerUserDetail>().isDataLoaded(false);
                                              Get.find<ControllerUserDetail>().isShowLikeButtom(true);

                                              Get.find<ControllerUserDetail>().getSetUpProfileAPI().then((value) {
                                                Get.find<ControllerUserDetail>().getUserDetailAPI(
                                                    cardController.cardlist[itemIndex].id.toString(),
                                                    latitude,
                                                    longitude,
                                                    cardController.isIncognitoModeON.value);
                                                Get.toNamed(Routes.user_detail)!.then(
                                                  (value) {
                                                    cardController.isDataLoaded(false);
                                                  },
                                                );
                                              });
                                            },
                                            child: SizedBox(
                                              height: Platform.isAndroid ? Get.height * 0.6 : Get.height * 0.56,
                                              child: ExampleCard(
                                                cardlist: cardController.cardlist[itemIndex],
                                                name: '',
                                                assetPath:
                                                    "${generalSetting?.s3Url}${cardController.cardlist[itemIndex].image!}",
                                              ),
                                            ),
                                          ),
                                          // more )custom overlay possible than with overlayBuilder
                                          if (properties.stackIndex == 0 && properties.direction != null)
                                            CardOverlay(
                                              swipeProgress: properties.swipeProgress,
                                              direction: properties.direction!,
                                            )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                BottomButtonsRow(
                                  isMatchedUser: false,
                                  isFromCardList: true,
                                  likeIcon: ImageConstants.icon_like_only_heart,
                                  dislikeIcon: ImageConstants.icon_cross_like,
                                  countRightSwipe: cardController.countSwipeLimit.toInt(),
                                  planSwipCount: 0,
                                  onSwipe: (direction) {
                                    isClickFromButtonView.value = true;

                                    cardController.swipeCardController!
                                        .next(swipeDirection: direction, duration: const Duration(milliseconds: 500));
                                    cardController.listenController();
                                    cardController.update();

                                    if (direction == SwipeDirection.left) {
                                      isClickFromButtonView.value = true;
                                      if (kDebugMode) {
                                        print(
                                            "==== count ${Get.find<ControllerCard>().countSwipeLimit.value},+++${isClickFromButtonView.value} ");
                                      }
                                      Get.find<ControllerCard>().isDataLoaded(false);

                                      if ((cardController.planSwipCount.value != (-1) &&
                                          (cardController.countSwipeLimit.value >
                                              cardController.planSwipCount.value))) {
                                        Get.toNamed(Routes.subscription);
                                      } else {
                                        cardController.isDataLoaded(false);
                                        cardController.cardActionAPI(
                                            cardController
                                                    .cardlist[cardController.swipeCardController!.currentIndex].id ??
                                                "",
                                            0);
                                      }

                                      cardController.update();
                                    } else {
                                      if (cardController.planSwipCount.value != (-1) &&
                                          (cardController.countSwipeLimit.value > cardController.planSwipCount.value)) {
                                        Get.toNamed(Routes.subscription);
                                      } else {
                                        cardController.isDataLoaded(false);

                                        cardController.cardActionAPI(
                                            cardController
                                                    .cardlist[cardController.swipeCardController!.currentIndex].id ??
                                                "",
                                            1);
                                      }
                                      cardController.update();
                                    }
                                  },
                                  onRewindTap: isUserSubscribe == true
                                      ? cardController.swipeCardController!.rewind
                                      : () {
                                          Get.toNamed(Routes.subscription);
                                        },
                                  canRewind: cardController.swipeCardController!.canRewind,
                                ),
                                if (cardController.isAppLaunched.value)
                                  if (cardController.showSuggestionOverlay.value)
                                    GestureDetector(
                                      onTap: () {
                                        cardController.showSuggestionOverlay(false);
                                        cardController.update();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(24)),
                                          color: ColorConstants().userGuideBG.withOpacity(0.70),
                                        ),
                                        child: Lottie.asset(
                                          ImageConstants.lottiDirection_guide,
                                          fit: BoxFit.cover,
                                          height: Platform.isAndroid ? Get.height * 0.74 : Get.height * 0.7,
                                          width: Get.width * 0.92,
                                        ),
                                      ),
                                    )
                              ],
                            ),
                          ),
                        )
                      : cardController.isDataLoaded.value
                          ? (cardController.cardlist.isEmpty)
                              ? Center(
                                  child: CustomText(
                                    text: toLabelValue(StringConstants.no_data_found),
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.0,
                                    style: TextStyleConfig.boldTextStyle(
                                        color: ColorConstants().white.withOpacity(0.5),
                                        fontSize: TextStyleConfig.bodyText16),
                                  ),
                                )
                              : Center(
                                  child: CustomText(
                                    text: toLabelValue(StringConstants.no_data_found),
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.0,
                                    style: TextStyleConfig.boldTextStyle(
                                        color: ColorConstants().white.withOpacity(0.5),
                                        fontSize: TextStyleConfig.bodyText16),
                                  ),
                                )
                          : const SizedBox();
                },
              ),
            )));
  }
}
