import 'dart:async';
import 'dart:io';

import 'package:dating_app/src/model/profile/edit_profile.dart';
import 'package:dating_app/src/model/subscription/subscription_reponse_model.dart';
import 'package:dating_app/src/screen/dashboard/chat/chats/binding_chats.dart';
import 'package:dating_app/src/screen/dashboard/chat/chats/controller_chats.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/binding_card_swipe.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/controller_card_swipe.dart';
import 'package:dating_app/src/screen/setupprofile/controller_setup_profile.dart';
import 'package:dating_app/src/services/repository/authentication_webservice/setup_profile_webservice.dart';
import 'package:dating_app/src/services/repository/profile_webservice/profile_webservice.dart';
import 'package:dating_app/src/services/repository/subscription_webservice/subscription_webservice.dart';
import 'package:dating_app/src/services/repository/subscriptions_purchase_webservice/subscription_plan_webservice.dart';

import '../../../imports.dart';

class ControllerSubscription extends GetxController with GetTickerProviderStateMixin {
  late TabController planTabController;
  late TabController addOnsTabController;
  bool isFromSetUpProfile = false;
  bool isFromChatScreen = false;

  RxString? totalPrice = "0".obs;
  String planPrice = "";
  String addonPrice = "";

  List<String> premiumSubscriptionBenefits = [];
  List<String> vipSubscriptionBenefits = [];

  List<String> premiumAddons = [];
  List<String> vipAddons = [];

  Subscriptions? premiumSubscriptionPlanData;
  Subscriptions? vipSubscriptionPlanData;

  RxBool isFreePlanSelected = false.obs;
  RxBool isAddOnsSelected = false.obs;

  RxInt? selectedPlanpackage = (-1).obs;
  RxInt? selectedSubsriptionPlan = 0.obs;
  RxInt? selectedAddOns = (-1).obs;
  RxBool isDataLoaded = false.obs;

  SubscriptionPlanResponse? subscriptionsData;

  List<String> productKeyPremiums = Platform.isAndroid
      ? ["com.dating.weeklypremium", "com.dating.monthlypremium", "com.dating.yearlypremium"]
      : [
          StringConstants.weekly_premium,
          StringConstants.monthly_premium,
          StringConstants.yearly_premium,
        ];
  List<String> productKeyVIPs = Platform.isAndroid
      ? ["com.dating.weeklyvip", "com.dating.monthlyvip", "com.dating.yearlyvip"]
      : [
          StringConstants.weekly_VIP,
          StringConstants.monthly_VIP,
          StringConstants.yearly_VIP,
        ];
  String selectedProuctID = "";

//INapp

  @override
  void onInit() {
    super.onInit();
    getSubscriptionPlanAPI();

    planTabController = TabController(length: 2, vsync: this, initialIndex: 0);
    addOnsTabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  getSubscriptionPlanAPI() async {
    premiumSubscriptionBenefits = [];
    vipSubscriptionBenefits = [];

    ApiResponse<SubscriptionPlanResponse>? response = await SubscriptionRepository().getSubscription();

    if ((response!.code) == CODE_SUCCESS_CODE) {
      subscriptionsData = response.result;
      isDataLoaded(true);

      //Premium Features
      if (response.result!.plans!.premiumPlan!.planName == "Premium") {
        if (response.result!.plans!.premiumPlan!.planDuration![1].duration == "Monthly" &&
            response.result!.plans!.premiumPlan!.planDuration![1].discount == "") {
          response.result!.plans!.premiumPlan!.planDuration![1].discount = "9.10";
        }
        if (response.result!.plans!.premiumPlan!.planDuration![2].duration == "Yearly" &&
            response.result!.plans!.premiumPlan!.planDuration![2].discount == "") {
          response.result!.plans!.premiumPlan!.planDuration![2].discount = "70.89";
        }
        List<AddOnplan> boostplan = [];
        List<AddOnplan> swipeplan = [];
        AddOn? boostaddon;
        AddOn? swipeaddon;

        for (var addonType in response.result!.plans!.premiumPlan!.addOns!) {
          if (addonType.addOnType == "0") {
            if (!premiumAddons.contains("Boost")) {
              premiumAddons.add("Boost");
            }
            boostplan.add(AddOnplan(id: addonType.id, price: addonType.price, description: addonType.addOnCount));
          } else {
            if (!premiumAddons.contains("Swipe")) {
              premiumAddons.add("Swipe");
            }
            swipeplan.add(AddOnplan(id: addonType.id, price: addonType.price, description: addonType.addOnCount));
          }
          boostaddon = AddOn(id: "0", addonPlan: boostplan);
          swipeaddon = AddOn(id: "1", addonPlan: swipeplan);
          premiumSubscriptionPlanData =
              Subscriptions(id: response.result!.plans!.premiumPlan!.id, addOns: [boostaddon, swipeaddon]);
        }

        if (response.result!.plans!.premiumPlan!.imageUploadUnlimited != "" &&
            response.result!.plans!.premiumPlan!.imageUploadUnlimited == "0") {
          premiumSubscriptionBenefits.add("Unlimited image upload");
        }
        if (response.result!.plans!.premiumPlan!.imageUploadCount != "" &&
            response.result!.plans!.premiumPlan!.imageUploadUnlimited == "1") {
          premiumSubscriptionBenefits.add(response.result!.plans!.premiumPlan!.imageUploadCount!);
        }
        if (response.result!.plans!.premiumPlan!.chat != "" && response.result!.plans!.premiumPlan!.chat == "0") {
          if (response.result!.plans!.premiumPlan!.videoCall != "" &&
              response.result!.plans!.premiumPlan!.videoCall == "0") {
            premiumSubscriptionBenefits.add("Chat and Video call");
          } else {
            premiumSubscriptionBenefits.add("Chat");
          }
        }
        if (response.result!.plans!.premiumPlan!.swipe != "" && response.result!.plans!.premiumPlan!.swipe == "0") {
          if (response.result!.plans!.premiumPlan!.isUnlimitedSwipe != "" &&
              response.result!.plans!.premiumPlan!.isUnlimitedSwipe == "0") {
            premiumSubscriptionBenefits.add("Unlimited swipe");
          } else {
            premiumSubscriptionBenefits.add(response.result!.plans!.premiumPlan!.swipeCount!);
          }
        }
        if (response.result!.plans!.premiumPlan!.myBoost != "" && response.result!.plans!.premiumPlan!.myBoost == "0") {
          premiumSubscriptionBenefits.add(response.result!.plans!.premiumPlan!.myBoostDuration!);
        }
      }

      //VIP Features

      if (response.result!.plans!.vIPPlan!.planName == "VIP") {
        if (response.result!.plans!.vIPPlan!.planDuration![1].duration == "Monthly" &&
            response.result!.plans!.vIPPlan!.planDuration![1].discount == "") {
          response.result!.plans!.vIPPlan!.planDuration![1].discount = "30.01";
        }
        if (response.result!.plans!.vIPPlan!.planDuration![2].duration == "Yearly" &&
            response.result!.plans!.vIPPlan!.planDuration![2].discount == "") {
          response.result!.plans!.vIPPlan!.planDuration![2].discount = "85.53";
        }

        List<AddOnplan> boostplan = [];
        List<AddOnplan> swipeplan = [];
        AddOn? boostaddon;
        AddOn? swipeaddon;

        for (var addonType in response.result!.plans!.vIPPlan!.addOns!) {
          if (addonType.addOnType == "0") {
            if (!vipAddons.contains("Boost")) {
              vipAddons.add("Boost");
            }
            boostplan.add(AddOnplan(id: addonType.id, price: addonType.price, description: addonType.addOnCount));
          } else {
            if (!vipAddons.contains("Swipe")) {
              vipAddons.add("Swipe");
            }
            swipeplan.add(AddOnplan(id: addonType.id, price: addonType.price, description: addonType.addOnCount));
          }
          boostaddon = AddOn(id: "0", addonPlan: boostplan);
          swipeaddon = AddOn(id: "1", addonPlan: swipeplan);
          vipSubscriptionPlanData =
              Subscriptions(id: response.result!.plans!.vIPPlan!.id, addOns: [boostaddon, swipeaddon]);
        }

        if (response.result!.plans!.vIPPlan!.imageUploadUnlimited != "" &&
            response.result!.plans!.vIPPlan!.imageUploadUnlimited == "0") {
          vipSubscriptionBenefits.add("Unlimited image upload");
        }
        if (response.result!.plans!.vIPPlan!.imageUploadCount != "" &&
            response.result!.plans!.vIPPlan!.imageUploadUnlimited == "1") {
          vipSubscriptionBenefits.add(response.result!.plans!.vIPPlan!.imageUploadCount!);
        }
        if (response.result!.plans!.vIPPlan!.chat != "" && response.result!.plans!.vIPPlan!.chat == "0") {
          if (response.result!.plans!.vIPPlan!.videoCall != "" && response.result!.plans!.vIPPlan!.videoCall == "0") {
            vipSubscriptionBenefits.add("Chat and Video call");
          } else {
            vipSubscriptionBenefits.add("Chat");
          }
        }
        if (response.result!.plans!.vIPPlan!.swipe != "" && response.result!.plans!.vIPPlan!.swipe == "0") {
          if (response.result!.plans!.vIPPlan!.isUnlimitedSwipe != "" &&
              response.result!.plans!.vIPPlan!.isUnlimitedSwipe == "0") {
            vipSubscriptionBenefits.add("Unlimited swipe");
          } else {
            vipSubscriptionBenefits.add(response.result!.plans!.vIPPlan!.swipeCount!);
          }
        }
        if (response.result!.plans!.vIPPlan!.myBoost != "" && response.result!.plans!.vIPPlan!.myBoost == "0") {
          vipSubscriptionBenefits.add(response.result!.plans!.vIPPlan!.myBoostDuration!);
        }
      }

      // add  response data in subscription plan model

      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    isDataLoaded(true);

    hideLoader();
  }

  //Purchase Plan API
  Future<void> purchasePlan(
      String transactionReceipt, transactionID, endDate, bool isFRomSetUpProfile, isFromChatScreen) async {
    showLoader();

    ResponseModel? response;
    if (planTabController.index == 0) {
      endDate = "";
      if (subscriptionsData!.plans!.premiumPlan?.planDuration![selectedPlanpackage!.value].duration?.toLowerCase() ==
          'weekly') {
        endDate = dateformate(DateTime.now().add(const Duration(days: 6)).toString(), "yyyy-MM-dd");
      } else if (subscriptionsData!.plans!.premiumPlan?.planDuration![selectedPlanpackage!.value].duration
              ?.toLowerCase() ==
          'monthly') {
        endDate = dateformate(DateTime.now().add(const Duration(days: 29)).toString(), "yyyy-MM-dd");
      } else {
        endDate = dateformate(DateTime.now().add(const Duration(days: 364)).toString(), "yyyy-MM-dd");
      }

      response = await PurchaseSubscriptionRepository().purchase(
          planID: subscriptionsData!.plans!.premiumPlan?.id,
          appReceipt: transactionReceipt,
          enddate: endDate,
          startDate: dateformate(DateTime.now().toString(), "yyyy-MM-dd"),
          totalAmount: subscriptionsData!.plans!.premiumPlan?.planDuration![selectedPlanpackage!.value].price,
          transactionID: transactionID,
          planDurationID: subscriptionsData!.plans!.premiumPlan?.planDuration![selectedPlanpackage!.value].id);
    } else {
      if (subscriptionsData!.plans!.vIPPlan?.planDuration![selectedPlanpackage!.value].duration?.toLowerCase() ==
          'weekly') {
        endDate = dateformate(DateTime.now().add(const Duration(days: 6)).toString(), "yyyy-MM-dd");
      } else if (subscriptionsData!.plans!.vIPPlan?.planDuration![selectedPlanpackage!.value].duration?.toLowerCase() ==
          'monthly') {
        endDate = dateformate(DateTime.now().add(const Duration(days: 29)).toString(), "yyyy-MM-dd");
      } else {
        endDate = dateformate(DateTime.now().add(const Duration(days: 364)).toString(), "yyyy-MM-dd");
      }
      response = response = await PurchaseSubscriptionRepository().purchase(
          planID: subscriptionsData!.plans!.vIPPlan?.id,
          appReceipt: transactionReceipt,
          enddate: endDate,
          startDate: dateformate(DateTime.now().toString(), "yyyy-MM-dd"),
          totalAmount: subscriptionsData!.plans!.vIPPlan?.planDuration![selectedPlanpackage!.value].price,
          transactionID: transactionID,
          planDurationID: subscriptionsData!.plans!.vIPPlan?.planDuration![selectedPlanpackage!.value].id);
    }
    bool isFromSetUpProfileScreen = await SharedPref.getBool(PreferenceConstants.isFromSetupProfile);

    bool isFRomChatScreen = await SharedPref.getBool(PreferenceConstants.isFromChat);
    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      hideLoader();
      showSnackBar(Get.overlayContext, toLabelValue(response.message!));
      SharedPref.setBool(PreferenceConstants.isUserSubscribed, true);
      isUserSubscribe = await SharedPref.getBool(PreferenceConstants.isUserSubscribed);
      SharedPref.setInt(PreferenceConstants.availableSwipeCount, 0);
      if (isFromSetUpProfileScreen) {
        SharedPref.setBool(PreferenceConstants.setupProfileDone, false);

        BindingCard().dependencies();

        Get.find<ControllerCard>().getMySubscriptionAPI().then((value) {
          Get.find<ControllerSetUpProfile>().pickedImageList.value =
              List.generate(uploadImageCount ?? 6, (index) => File(""));
          Get.find<ControllerSetUpProfile>().steps = List.generate(
            9,
            (index) => SelectedStep(
              step: index,
              isSelected: index < 7 ? true : false,
            ),
          );
          Get.find<ControllerSetUpProfile>().changeStepIndex();
          Get.find<ControllerSetUpProfile>().update();
          Get.offNamedUntil(Routes.setupprofile, (route) => true);
        });
      } else if (isFRomChatScreen) {
        BindingChats().dependencies();
        Get.find<ControllerChats>().chatlistAPI("0");
      } else {
        Get.back();
      }
      if (!isFromSetUpProfileScreen) {
        getEditProfile().then((responseEditprofile) {
          updateSetUpProfileAPI(
              user_id: responseEditprofile?.userSelectedData?.userId,
              selected_gender_id: responseEditprofile?.userSelectedData?.gender,
              interested_in_id: responseEditprofile?.userSelectedData?.interestedIn,
              profile_headline: responseEditprofile?.userSelectedData?.profileHeadline,
              about_yourself: responseEditprofile?.userSelectedData?.aboutMyself,
              height_measurment_type_id: responseEditprofile?.userSelectedData?.heightMeasurementType,
              height: responseEditprofile?.userSelectedData?.height,
              weight: responseEditprofile?.userSelectedData?.weight,
              weight_measurment_type_id: responseEditprofile?.userSelectedData?.weightMeasurementType,
              selected_hobbies_id: List.generate(responseEditprofile?.userSelectedData?.hobbies?.length ?? 0,
                  (index) => responseEditprofile?.userSelectedData?.hobbies![index].id.toString()).join(","),
              selected_occupation_id: responseEditprofile?.userSelectedData?.occupation,
              selected_relationship_status: responseEditprofile?.userSelectedData?.relationshipStatus,
              children: responseEditprofile?.userSelectedData?.children,
              diet_preference: responseEditprofile?.userSelectedData?.dietPreference,
              smoke: responseEditprofile?.userSelectedData?.smoke,
              drink: responseEditprofile?.userSelectedData?.drink,
              excerise: responseEditprofile?.userSelectedData?.exercise,
              personality_type: responseEditprofile?.userSelectedData?.personalityType,
              body_type: responseEditprofile?.userSelectedData?.bodyType,
              lat: responseEditprofile?.userSelectedData?.lat,
              long: responseEditprofile?.userSelectedData?.long,
              income: responseEditprofile?.userSelectedData?.income,
              networth: responseEditprofile?.userSelectedData?.networth,
              own_car: responseEditprofile?.userSelectedData?.carYouOwn,
              dating_type: responseEditprofile?.userSelectedData?.datingType,
              image_name: null,
              star_sign: responseEditprofile?.userSelectedData?.startSign,
              address: responseEditprofile?.userSelectedData?.location,
              is_full_setupProfile: "1");
        });
      }

      getSubscriptionPlanAPI();
    } else {
      hideLoader();

      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    hideLoader();
  }

  Future<EditProfileResponse?> getEditProfile() async {
    ApiResponse<EditProfileResponse>? response = await ProfileRepository().getEditProfile();
    return response?.result;

    // hideLoader();
  }

  updateSetUpProfileAPI(
      {String? user_id,
      selected_gender_id,
      interested_in_id,
      profile_headline,
      about_yourself,
      height_measurment_type_id,
      height,
      weight_measurment_type_id,
      selected_hobbies_id,
      selected_occupation_id,
      selected_relationship_status,
      children,
      diet_preference,
      smoke,
      drink,
      excerise,
      personality_type,
      body_type,
      lat,
      long,
      income,
      networth,
      own_car,
      dating_type,
      image_name,
      weight,
      star_sign,
      address,
      is_full_setupProfile}) async {
    showLoader();
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    ResponseModel? response = await SetupProfileRepository().updateSetupProfile(
        user_id: user_id,
        about_yourself: about_yourself,
        address: address,
        body_type: body_type,
        children: children,
        dating_type: dating_type,
        diet_preference: diet_preference,
        drink: drink,
        selected_gender_id: selected_gender_id,
        selected_hobbies_id: selected_hobbies_id,
        selected_occupation_id: selected_occupation_id,
        excerise: excerise ?? "",
        height: height,
        height_measurment_type_id: height_measurment_type_id,
        income: income,
        interested_in_id: interested_in_id,
        is_full_setupProfile: is_full_setupProfile,
        lat: lat,
        long: long,
        networth: networth,
        own_car: own_car,
        personality_type: personality_type,
        profile_headline: profile_headline,
        selected_relationship_status: selected_relationship_status,
        smoke: smoke,
        star_sign: star_sign,
        weight: weight,
        weight_measurment_type_id: weight_measurment_type_id,
        image_name: image_name);
    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      SharedPref.setBool(PreferenceConstants.setupProfileDone, true);

      hideLoader();
    } else {
      hideLoader();
      showDialogBox(
        Get.overlayContext!,
        toLabelValue(response.message!),
      );
    }
  }

//SUBSCRIPTION
}

class Subscriptions {
  String? id;
  List<String>? features;
  List<Plans>? plans;
  List<AddOn>? addOns;

  Subscriptions({this.id, this.plans, this.features, this.addOns});
}

class Plans {
  String? id;
  String? duration;
  String? price;
  String? perDuration;
  String? discount;

  Plans(this.id, this.discount, this.duration, this.perDuration, this.price);
}

class AddOn {
  String? id;
  String? name;
  List<AddOnplan>? addonPlan;

  AddOn({this.id, this.name, this.addonPlan});
}

class AddOnplan {
  String? id;
  String? description;
  String? price;

  AddOnplan({this.id, this.description, this.price});
}
