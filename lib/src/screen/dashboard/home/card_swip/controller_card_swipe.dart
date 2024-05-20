// ignore_for_file: avoid_print

import 'dart:async';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/dashboard/cardlist_model.dart';
import 'package:dating_app/src/model/profile/boost_history_model.dart';
import 'package:dating_app/src/model/profile/my_subscription_model.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/binding_card_swipe.dart';
import 'package:dating_app/src/screen/dashboard/home/filter/controller_filter.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/boost/my_boost/controller_my_boost.dart';
import 'package:dating_app/src/services/repository/dashboard_webservice/card_list_webservice.dart';
import 'package:dating_app/src/services/repository/profile_webservice/boost_webservice.dart';
import 'package:dating_app/src/services/repository/profile_webservice/my_subscription_webservice.dart';
import 'package:dating_app/src/widgets/card_swipe/swipable_stack.dart';
import 'package:popover/popover.dart';

class ControllerCard extends GetxController {
  SwipableStackController? swipeCardController;

  // Position? currentPosition;
  RxBool isIncognitoModeON = false.obs;
  SelectedFilter selectedFilterOption = SelectedFilter();
  GlobalKey btnKey = GlobalKey();
  RxInt planSwipCount = 0.obs;
  RxInt countSwipeLimit = 0.obs;
  RxBool showSuggestionOverlay = false.obs;
  RxInt pageIndex = 1.obs;
  RxInt notificationCount = 0.obs;
  RxInt lastIndex = (-1).obs;
  RxBool isAppLaunched = false.obs;

  void listenController() {
    update();
  }

//Timer for boost
  Timer? timer;
  RxInt boostTimerstart = 1800.obs;

  RxInt minutes = 29.obs;
  RxInt second = 60.obs;

  RxBool isDataLoaded = false.obs;
  RxBool isBoostCalled = false.obs;
  CardListResponse? cardlistResponse;
  List<CardList> cardlist = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // getCurrentPosition();

    getMySubscriptionAPI();

    swipeCardController = SwipableStackController()..addListener(listenController);
  }

  onShowBoostPopup(contexts) {
    showPopover(
        context: btnKey.currentContext!,
        bodyBuilder: (context) => Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                    text: toLabelValue(StringConstants.time_remainig),
                    style: TextStyleConfig.regularTextStyle(
                        fontSize: TextStyleConfig.bodyText12, color: ColorConstants().grey1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomText(
                              text: toLabelValue(StringConstants.mins),
                              textAlign: TextAlign.center,
                              style: TextStyleConfig.boldTextStyle(
                                  color: ColorConstants().grey,
                                  fontSize: TextStyleConfig.bodyText12,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(),
                            CustomText(
                              text: toLabelValue(StringConstants.sec).capitalizeFirst,
                              textAlign: TextAlign.center,
                              style: TextStyleConfig.boldTextStyle(
                                  color: ColorConstants().grey,
                                  fontSize: TextStyleConfig.bodyText12,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomText(
                                text:
                                    "${formattedTime(timeInSecond: boostTimerstart.value).toString().split(":").first}",
                                textAlign: TextAlign.center,
                                style: TextStyleConfig.boldTextStyle(
                                  color: ColorConstants().black,
                                  fontSize: TextStyleConfig.bodyText16,
                                ),
                              ),
                              CustomText(
                                text: ":",
                                style: TextStyleConfig.boldTextStyle(
                                  color: ColorConstants().black,
                                  fontSize: TextStyleConfig.bodyText16,
                                ),
                              ),
                              Obx(() => CustomText(
                                    text:
                                        "${formattedTime(timeInSecond: boostTimerstart.value).toString().split(":").last}",
                                    textAlign: TextAlign.center,
                                    style: TextStyleConfig.boldTextStyle(
                                      color: ColorConstants().black,
                                      fontSize: TextStyleConfig.bodyText16,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
        onPop: () => print('Popover was popped!'),
        direction: PopoverDirection.bottom,
        width: 200,
        barrierColor: Colors.transparent,
        height: Get.height * 0.13,
        arrowHeight: 15,
        arrowWidth: 20,
        arrowDyOffset: 15);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    swipeCardController = SwipableStackController()..addListener(listenController);
    timer!.cancel();
  }

//BoostTime pop up show
  convertboostTimeToMinute(String createdTime) {
    final dt1 = DateTime.parse(dateformate(createdTime, "yyyy-MM-dd hh:mm:ss"));
    print("d1==== $dt1");
    final dt2 = DateTime.parse(dateformate(DateTime.now().toString(), "yyyy-MM-dd hh:mm:ss"));
    print("d2==== $dt2");

    Duration diff1 = dt1.difference(dt2);
    print('Difference: ${diff1.inMinutes}');

    if (int.parse(diff1.inMinutes.toString().replaceAll("-", "")) < (30)) {
      boostTimerstart.value = (boostTimerstart.toInt() - int.parse(diff1.inSeconds.toString().replaceAll("-", "")));

      startTimer();
      SharedPref.setBool(PreferenceConstants.isShowTimePopUp, true);

      isShowTimePopUp.value = true;
      update();
    } else {
      SharedPref.setBool(PreferenceConstants.isShowTimePopUp, false);

      isShowTimePopUp.value = false;
      update();
    }
  }

  void startTimer() {
    timer?.cancel();
    const oneSec = Duration(seconds: 1);

    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (boostTimerstart.value == 0) {
          timer.cancel();
          if (isShowTimePopUp.value == true) {
            Get.find<ControllerMyBoost>().endBoostAPI();
          }
        } else {
          boostTimerstart.value--;
          print("boost seconds ${boostTimerstart.value}");
        }
        update();
      },
    );
  }

//get Boost Time API
  getMyBoostAPI() async {
    ApiResponse<GetBoostTime>? response = await MyBoostRepository().getBoostTime();
    BindingCard().dependencies();
    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      bool popUpValue = await SharedPref.getBool(PreferenceConstants.isShowTimePopUp);
      isShowTimePopUp.value = popUpValue;

      if (response.result!.createdBoostTime.toString() != "") {
        minutes.value = int.parse(response.result!.boost_time ?? "30") - 1;
        boostTimerstart.value = int.parse(response.result!.boost_time ?? "30") * 60;

        if (isShowTimePopUp.value) {
          convertboostTimeToMinute(response.result!.createdBoostTime.toString());
        }
        update();
      } else {
        SharedPref.setBool(PreferenceConstants.isShowTimePopUp, false);
        isShowTimePopUp.value = false;
      }

      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }

    hideLoader();
  }

//get MySubscription API
  Future<void> getMySubscriptionAPI() async {
    isDataLoaded(false);
    isAppLaunched.value = await SharedPref.getBool(PreferenceConstants.isAppLaunched);
    if (cardlist.isEmpty) {
      userCardAPI();
    }

    ApiResponse<MySubscriptionPlanResponse>? response = await MySubscriptionRepository().getMySubscription();

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      currentSubscriptionData = response.result;

      if (currentSubscriptionData?.plan?.benefits?.first.chat == "" &&
          currentSubscriptionData?.plan?.benefits?.first.videoCall == "") {
        SharedPref.setBool(PreferenceConstants.isChatAvailable, false);
        SharedPref.setBool(PreferenceConstants.isVideoAvailable, false);
      } else if (currentSubscriptionData?.plan?.benefits?.first.chat == "") {
        SharedPref.setBool(PreferenceConstants.isChatAvailable, false);
        SharedPref.setBool(PreferenceConstants.isVideoAvailable, true);
      } else if (currentSubscriptionData?.plan?.benefits?.first.videoCall == "") {
        SharedPref.setBool(PreferenceConstants.isChatAvailable, true);
        SharedPref.setBool(PreferenceConstants.isVideoAvailable, false);
      } else {
        SharedPref.setBool(PreferenceConstants.isChatAvailable, true);
        SharedPref.setBool(PreferenceConstants.isVideoAvailable, true);
      }

      if (currentSubscriptionData!.plan!.planExpireDate != "" &&
          DateTime.parse(currentSubscriptionData!.plan!.planExpireDate!).isBefore(DateTime.now()) &&
          (currentSubscriptionData!.plan!.benefits?.first.add_on_swipe_count != null &&
              currentSubscriptionData!.plan!.benefits?.first.add_on_swipe_count == "0")) {
        planSwipCount.value = 0;

        countSwipeLimit.value = 1;

        SharedPref.setBool(PreferenceConstants.isUserSubscribed, false).then((value) async {
          isUserSubscribe = false;
        });
      } else {
        SharedPref.setBool(PreferenceConstants.isUserSubscribed, (response.result?.plan?.planId == "1") ? false : true)
            .then((value) async {
          isUserSubscribe = (response.result?.plan?.planId == "1") ? false : true;
        });

        if (currentSubscriptionData!.plan!.planExpireDate != "" &&
            DateTime.parse(currentSubscriptionData!.plan!.planExpireDate!).isBefore(DateTime.now())) {
          planSwipCount.value = int.parse(currentSubscriptionData!.plan!.benefits!.first.add_on_swipe_count.toString());
          SharedPref.setBool(PreferenceConstants.isUserSubscribed, false).then((value) async {
            isUserSubscribe = false;
          });
        } else {
          if (currentSubscriptionData!.plan!.benefits!.first.swipecount == null) {
            planSwipCount.value = (-1);
          } else {
            planSwipCount.value = int.parse(currentSubscriptionData!.plan!.benefits!.first.swipecount!
                    .replaceAll("(", " ")
                    .replaceAll(")", "")
                    .split(" ")
                    .last) +
                int.parse(currentSubscriptionData!.plan!.benefits!.first.add_on_swipe_count.toString());
          }
        }

        if (currentSubscriptionData!.plan!.benefits!.first.imageUpload != null) {
          SharedPref.setInt(
              PreferenceConstants.uploadImageCount,
              currentSubscriptionData!.plan!.benefits!.first.imageUpload != null
                  ? int.parse(currentSubscriptionData!.plan!.benefits!.first.imageUpload!.split(" ").first)
                  : 0);
          uploadImageCount = currentSubscriptionData!.plan!.benefits!.first.imageUpload != null
              ? int.parse(currentSubscriptionData!.plan!.benefits!.first.imageUpload!.split(" ").first)
              : 0;
        } else {
          SharedPref.setInt(PreferenceConstants.uploadImageCount, 9);
          uploadImageCount = 9;
        }

        //uncomment this when swipe issue has been test

        countSwipeLimit.value = await SharedPref.getInt(PreferenceConstants.availableSwipeCount);
      }

      update();
    } else {
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }

  //CardList API
  Future<void> userCardAPI() async {
    if (pageIndex.value == 1) {
      cardlist.clear();
    }
    latitude = await SharedPref.getString(PreferenceConstants.currentLAT);
    longitude = await SharedPref.getString(PreferenceConstants.currentLONG);
    bool popUpValue = await SharedPref.getBool(PreferenceConstants.isShowTimePopUp);
    isShowTimePopUp.value = popUpValue;

    ApiResponse<CardListResponse>? response = await UserCardRepository().cardlist(
        pageIndex: pageIndex.toString(),
        lat: latitude.toString(),
        long: longitude.toString(),
        ethinicity: selectedFilterOption.selected_ethinicity ?? "",
        occupation: selectedFilterOption.selected_occupationID ?? "",
        cast: selectedFilterOption.cast ?? "",
        locationRange: selectedFilterOption.loactionRange ?? "",
        selectedhobbiewIDs: selectedFilterOption.selected_hobbies_id ?? "",
        min_income: selectedFilterOption.min_income ?? "",
        max_income: selectedFilterOption.max_income ?? "",
        min_networth: selectedFilterOption.min_networth ?? "",
        max_networth: selectedFilterOption.max_networth ?? "",
        own_car: selectedFilterOption.selected_CarYouOwnID ?? "",
        height: selectedFilterOption.height ?? "",
        weight: selectedFilterOption.weight ?? "",
        height_measurment_type_id: selectedFilterOption.selected_heightMeasurement ?? "",
        weight_measurment_type_id: selectedFilterOption.selected_weight_measurement ?? "",
        children: selectedFilterOption.selected_childrenID ?? "",
        dating_type: selectedFilterOption.selected_DatingTypeID ?? "",
        diet_prefs: selectedFilterOption.selected_DietPrefsID ?? "",
        marital_status: selectedFilterOption.marital_status ?? "",
        dating_group_id: selectedFilterOption.selected_DatingGroupID ?? "",
        star_sign: selectedFilterOption.selected_StartSignID ?? "",
        political_leaning: selectedFilterOption.politicalLeaning ?? "",
        smoke: selectedFilterOption.selected_SmokeID ?? "",
        drink: selectedFilterOption.selected_DrinkID ?? "",
        exercise: selectedFilterOption.selected_ExerciseID ?? "",
        personality_type: selectedFilterOption.selected_PersonalityTYpeID ?? "",
        bodytype: selectedFilterOption.selected_BodyTypeID ?? "",
        religiousview: selectedFilterOption.religiousView ?? "");
    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      if (!isDataLoaded.value) {
        getMyBoostAPI();
      }
      isDataLoaded(true);
      hideLoader();
      debugPrint("pageIndex ==>> ${pageIndex.value}");
      if (pageIndex.value == 1) {
        cardlist = [];
      }
      cardlistResponse = response.result;
      notificationCount.value = int.parse(response.result!.notificationCount.toString());
      chatUnreadCount.value = response.result?.unread_message_count;
      if (response.result!.cardList!.isNotEmpty) {
        if (cardlist.isNotEmpty) {
          for (var i = 0; i < response.result!.cardList!.length; i++) {
            if (response.result!.cardList![i].id == cardlist.last.id) {
              cardlist.removeLast();
            }
            if (response.result!.cardList![i].id == cardlist[cardlist.length - 2].id) {
              cardlist.removeAt(cardlist.length - 2);
            }
            if (response.result!.cardList![i].id == cardlist[cardlist.length - 3].id) {
              cardlist.removeAt(cardlist.length - 3);
            }
            if (response.result!.cardList![i].id == cardlist[cardlist.length - 4].id) {
              cardlist.removeAt(cardlist.length - 4);
            }
          }
        }

        cardlist.addAll(response.result!.cardList!);
      }

      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }

//Card like/dislike
  Future<void> cardActionAPI(String cardID, actionID) async {
    ResponseModel? response = await UserCardRepository().userLikeCard(cardID, actionID);
    if (response!.code == CODE_SUCCESS_CODE) {
      if (response.message != "success") {
        isDataLoaded(true);
        print("Print== $actionID");
        isClickFromButtonView.value = false;
        update();

        print("Print== card like API success");
        print(response.message);
      } else {
        print("card like API error");
      }
      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }
}
