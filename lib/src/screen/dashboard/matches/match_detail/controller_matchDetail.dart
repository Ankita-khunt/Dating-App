import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/profile_model.dart';
import 'package:dating_app/src/services/repository/profile_webservice/profile_webservice.dart';

class ControllerMatchDetail extends GetxController {
  MatchList? matchedUser;
  ProfileResponse? profileresponse;
  RxBool isDataLoaded = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  //get Profile API
  getprofileAPI() async {
    if (!isDataLoaded.value) showLoader();

    ApiResponse<ProfileResponse>? response =
        await ProfileRepository().getProfile();

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      profileresponse = response.result;

      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    hideLoader();
  }
}
