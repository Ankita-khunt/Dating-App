import 'dart:io';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/my_swipe_model.dart';
import 'package:dating_app/src/services/repository/profile_webservice/my_swipe_webservice.dart';

class ControllerMySwipe extends GetxController {
  RxBool isDataLoaded = false.obs;
  MySwipeRespons? mySwipeResponse;
  RxInt selectedSwipePlan = (-1).obs;

  String selectedSwipePlanProductID = "";

  List<String> productKeySwipes = Platform.isAndroid
      ? ["com.dating.1swipe", "com.dating.3swipe", "com.dating.6swipe", "com.dating.8swipe"]
      : [
          StringConstants.one_swipe,
          StringConstants.three_swipe,
          StringConstants.six_swipe,
          StringConstants.eight_swipe
        ];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  //get MySwipe API
  getMySwipeAPI() async {
    if (!isDataLoaded.value) showLoader();

    ApiResponse<MySwipeRespons>? response = await MySwipeRepository().getMySwipe();

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      mySwipeResponse = response.result;
      selectedSwipePlan.value = (-1);
      isDataLoaded(true);

      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    isDataLoaded(true);

    hideLoader();
  }

  //Purchase Plan API
  Future<void> swipepurchasePlan(String transactionReceipt, transactionID) async {
    showLoader();

    ResponseModel? response = await MySwipeRepository().swipe_plan_purchase(
      addonPlanID: mySwipeResponse?.swipeList![selectedSwipePlan.value].swipeId,
      addonCount: mySwipeResponse?.swipeList![selectedSwipePlan.value].swipeCount,
      addonType: "1",
      transactionReceipt: transactionReceipt,
      totalAmount: mySwipeResponse?.swipeList![selectedSwipePlan.value].swipePrice.toString(),
      transactionID: transactionID,
    );

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      showSnackBar(Get.overlayContext, toLabelValue(response.message!));

      getMySwipeAPI();
      hideLoader();
    } else {
      hideLoader();

      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    hideLoader();
  }
}
