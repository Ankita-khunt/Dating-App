import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/my_subscription_model.dart';
import 'package:dating_app/src/services/repository/profile_webservice/my_subscription_webservice.dart';

class ControllerMySubscription extends GetxController {
  MySubscriptionPlanResponse? mysubscription;
  RxBool isDataLoaded = false.obs;

//Plan Benefits
  List<String> subscriptionBenefits = [];

//get MySubscription API
  getMySubscriptionAPI() async {
    if (!isDataLoaded.value) showLoader();

    ApiResponse<MySubscriptionPlanResponse>? response = await MySubscriptionRepository().getMySubscription();

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      hideLoader();
      mysubscription = response.result;
      currentSubscriptionData = response.result;
      if (currentSubscriptionData!.plan!.planExpireDate != "" &&
          DateTime.parse(currentSubscriptionData!.plan!.planExpireDate!).isBefore(DateTime.now())) {
        SharedPref.setBool(PreferenceConstants.isUserSubscribed, false);
      } else {
        SharedPref.setBool(PreferenceConstants.isUserSubscribed, (response.result?.plan?.planId == "1") ? false : true);
      }

      subscriptionBenefits = [];
      if (response.result!.plan!.planId == "2") {
        if (mysubscription!.plan!.benefits!.isNotEmpty) {
          if (mysubscription!.plan!.benefits!.first.imageUpload != null &&
              mysubscription!.plan!.benefits!.first.imageUpload!.isNotEmpty) {
            subscriptionBenefits.add(mysubscription!.plan!.benefits!.first.imageUpload!);
          } else {
            subscriptionBenefits.add(mysubscription!.plan!.benefits!.first.unlimitedImage!);
          }

          if (mysubscription!.plan!.benefits!.first.chat!.isNotEmpty) {
            if (mysubscription!.plan!.benefits!.first.videoCall!.isNotEmpty) {
              subscriptionBenefits.add("Chat and Video call");
            } else {
              subscriptionBenefits.add(mysubscription!.plan!.benefits!.first.chat!);
            }
          } else {
            if (mysubscription!.plan!.benefits!.first.videoCall!.isNotEmpty) {
              subscriptionBenefits.add("Video call");
            }
          }

          if (mysubscription!.plan!.benefits!.first.swipecount != null &&
              mysubscription!.plan!.benefits!.first.swipecount!.isNotEmpty) {
            subscriptionBenefits.add(mysubscription!.plan!.benefits!.first.swipecount!);
          } else {
            subscriptionBenefits.add(mysubscription!.plan!.benefits!.first.swipe!);
          }
          if (mysubscription!.plan!.benefits!.first.myBoostDuration!.isNotEmpty) {
            subscriptionBenefits.add(mysubscription!.plan!.benefits!.first.myBoostDuration!);
          }
        }
      } else if (response.result!.plan!.planId == "3") {
        if (mysubscription!.plan!.benefits!.isNotEmpty) {
          if (mysubscription!.plan!.benefits!.first.imageUpload != null &&
              mysubscription!.plan!.benefits!.first.imageUpload!.isNotEmpty) {
            subscriptionBenefits.add(mysubscription!.plan!.benefits!.first.imageUpload!);
          }
          if (mysubscription!.plan!.benefits!.first.unlimitedImage != null &&
              mysubscription!.plan!.benefits!.first.unlimitedImage != "") {
            subscriptionBenefits.add(mysubscription!.plan!.benefits!.first.unlimitedImage!);
          }

          if (mysubscription!.plan!.benefits!.first.chat!.isNotEmpty) {
            if (mysubscription!.plan!.benefits!.first.videoCall!.isNotEmpty) {
              subscriptionBenefits.add("Chat and Video call");
            } else {
              subscriptionBenefits.add(mysubscription!.plan!.benefits!.first.chat!);
            }
          } else {
            if (mysubscription!.plan!.benefits!.first.videoCall!.isNotEmpty) {
              subscriptionBenefits.add("Video call");
            }
          }

          if (mysubscription!.plan!.benefits!.first.swipecount != null &&
              mysubscription!.plan!.benefits!.first.swipecount!.isNotEmpty) {
            subscriptionBenefits.add(mysubscription!.plan!.benefits!.first.swipecount!);
          }
          if (mysubscription!.plan!.benefits!.first.swipe != null &&
              mysubscription!.plan!.benefits!.first.swipe != "") {
            subscriptionBenefits.add(mysubscription!.plan!.benefits!.first.swipe!);
          }
          if (mysubscription!.plan!.benefits!.first.myBoostDuration!.isNotEmpty) {
            subscriptionBenefits.add(mysubscription!.plan!.benefits!.first.myBoostDuration!);
          }
        }
      }

      isDataLoaded(true);
      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    isDataLoaded(true);

    hideLoader();
  }
}
