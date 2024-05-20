import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/boost_history_model.dart';
import 'package:dating_app/src/services/repository/profile_webservice/boost_history_webservice.dart';

class ControllerBoostHistory extends GetxController {
  RxBool isDataLoaded = false.obs;
  BoostHistoryResponse? historyResponse;
  RxInt addonTypeID = 0.obs;

  //get Boost History API
  getMyBoostHistoryAPI(String addonTYpe) async {
    if (!isDataLoaded.value) showLoader();

    ApiResponse<BoostHistoryResponse>? response =
        await BoostHistoryRepository().getBoostHistory(addonTYpe);

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      historyResponse = response.result;
      addonTypeID.value = int.parse(addonTYpe);
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
