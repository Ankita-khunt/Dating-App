import 'dart:async';
import 'dart:io';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/my_boost_model.dart';
import 'package:dating_app/src/services/repository/profile_webservice/boost_webservice.dart';
import 'package:flutter/foundation.dart';

class ControllerMyBoost extends GetxController {
  BoostResponse? bootResponse;
  RxBool isDataLoaded = false.obs;
  RxInt selectedBoostPlan = (-1).obs;
  String selectedBoostPlanProductID = "";

  // String availabelboostTime = "";

  //To show popup timer
  // RxBool isShowTimePopUpDialogue = false.obs;
  Timer? timer;
  RxInt boostTimerstart = 1800.obs;

  RxInt minutes = 29.obs;
  RxInt second = 60.obs;
  List<String> boost_productIDs = Platform.isAndroid
      ? ["com.dating.1boost", "com.dating.3boost", "com.dating.5boost", "com.dating.10boost"]
      : [StringConstants.one_boost, StringConstants.three_boost, StringConstants.five_boost, StringConstants.ten_boost];

  convertboostTimeToMinute(String createdTime) {
    final dt1 = DateTime.parse(dateformate(createdTime, "yyyy-MM-dd hh:mm:ss"));
    if (kDebugMode) {
      print("d1==== $dt1");
    }
    final dt2 = DateTime.parse(dateformate(DateTime.now().toString(), "yyyy-MM-dd hh:mm:ss"));
    if (kDebugMode) {
      print("d2==== $dt2");
    }

    Duration diff1 = dt1.difference(dt2);
    if (kDebugMode) {
      print('Difference: ${diff1.inMinutes}');
    }

    if (int.parse(diff1.inMinutes.toString().replaceAll("-", "")) < (30)) {
      boostTimerstart.value = (boostTimerstart.toInt() - int.parse(diff1.inSeconds.toString().replaceAll("-", "")));

      if (kDebugMode) {
        print("Boost Seconds => ${second.value}");
      }

      startTimer();
      SharedPref.setBool(PreferenceConstants.isShowTimePopUp, true);
      isShowTimePopUp.value = true;
    } else {
      timer?.cancel();
      SharedPref.setBool(PreferenceConstants.isShowTimePopUp, false);
      isShowTimePopUp.value = false;
    }
    update();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (boostTimerstart.value == 0) {
          timer.cancel();
          endBoostAPI();

          update();
        } else {
          boostTimerstart.value--;
          update();
        }
      },
    );
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  //get MyBoost API
  getMyBoostAPI() async {
    if (!isDataLoaded.value) showLoader();

    ApiResponse<BoostResponse>? response = await MyBoostRepository().getMyBoost();

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      bootResponse = response.result;

      if (bootResponse!.myBoost != null && bootResponse?.myBoost?.createdat != "") {
        minutes.value = int.parse(bootResponse!.boost_time != "" ? bootResponse!.boost_time.toString() : "30") - 1;
        boostTimerstart.value =
            int.parse(bootResponse!.boost_time != "" ? bootResponse!.boost_time.toString() : "30") * 60;

        convertboostTimeToMinute(bootResponse!.myBoost!.createdat!);
        hideLoader();
      } else {
        SharedPref.setBool(PreferenceConstants.isShowTimePopUp, false);

        isShowTimePopUp.value = false;
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

  //Boost Profile API
  boostProfileAPI() async {
    showLoader();

    ResponseModel? response = await MyBoostRepository().boostProfile(
        addone_planID: bootResponse!.myBoost!.add_on_plan_id,
        addone_type: bootResponse!.myBoost!.addonType,
        addon_totalCount: bootResponse!.myBoost!.totalBoost);

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      showSnackBar(Get.overlayContext, toLabelValue(StringConstants.boost_profile_success));
      SharedPref.setBool(PreferenceConstants.isShowTimePopUp, true);
      isShowTimePopUp.value = true;

      hideLoader();
      getMyBoostAPI();
    } else {
      hideLoader();

      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }

  //End Boost Profile API
  endBoostAPI() async {
    ResponseModel? response = await MyBoostRepository().endBoost(bootResponse!.myBoost!.add_on_plan_id.toString());

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      SharedPref.setBool(PreferenceConstants.isShowTimePopUp, false);

      isShowTimePopUp.value = false;
      hideLoader();
    } else {
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }

  //Boost Purchase Plan API
  Future<void> boostpurchasePlan(String transactionReceipt, transactionID) async {
    showLoader();

    ResponseModel? response = await MyBoostRepository().boost_plan_purchase(
      addonPlanID: bootResponse?.boostList![selectedBoostPlan.value].boostId,
      addonCount: bootResponse?.boostList![selectedBoostPlan.value].boostCount,
      addonType: "0",
      transactionReceipt: transactionReceipt,
      totalAmount: bootResponse?.boostList![selectedBoostPlan.value].boostPrice.toString(),
      transactionID: transactionID,
    );

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      showSnackBar(Get.overlayContext, toLabelValue(response.message!));

      getMyBoostAPI();
      hideLoader();
    } else {
      hideLoader();

      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    hideLoader();
  }
}
