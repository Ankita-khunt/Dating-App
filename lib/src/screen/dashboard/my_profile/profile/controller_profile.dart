import 'dart:io';

import 'package:dating_app/src/model/profile/profile_model.dart';
import 'package:dating_app/src/services/repository/profile_webservice/logout.dart';
import 'package:dating_app/src/services/repository/profile_webservice/profile_webservice.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../../imports.dart';

class ControllerProfile extends GetxController with GetSingleTickerProviderStateMixin {
  List<String> profileOptions = [];
  RxBool isHideProfile = false.obs;
  RxBool isDataLoaded = false.obs;

  RxString appVersion = ''.obs;

  Rxn<File> selectedProfileImage = Rxn<File>();
  ProfileResponse? profileresponse;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    profileOptions = [];

    profileOptions.add(toLabelValue(StringConstants.change_password));
    profileOptions.add(toLabelValue(StringConstants.my_gallery));
    if (isUserSubscribe == true) {
      profileOptions.add(toLabelValue(StringConstants.my_recently_view));
    }
    profileOptions.add(toLabelValue(StringConstants.my_likes));
    profileOptions.add(toLabelValue(StringConstants.block_users));
    profileOptions.add(toLabelValue(StringConstants.hide_profile));
    profileOptions.add(toLabelValue(StringConstants.more));

    WidgetsFlutterBinding.ensureInitialized();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
    if (profileresponse == null) {
      getprofileAPI();
    }
  }

  //get Profile API
  getprofileAPI() async {
    if (!isDataLoaded.value) showLoader();
    isUserSubscribe = await SharedPref.getBool(PreferenceConstants.isUserSubscribed);
    ApiResponse<ProfileResponse>? response = await ProfileRepository().getProfile();

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      profileresponse = response.result;
      isHideProfile.value = profileresponse?.isProfileHide! == "1" ? true : false;
      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    hideLoader();
  }

// hide profile
  hideProfileAPI(bool isProfileHide) async {
    ResponseModel? response = await ProfileRepository().hideProfile(isProfileHide);

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      Get.back();
      isHideProfile.value = isProfileHide;
      update();
    } else {
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }

  // Update profile iameg
  updateProfileImageAPI() async {
    uploadS3Image(selectedProfileImage.value!).then((value) async {
      if (kDebugMode) {
        print(value);
      }
      showLoader();
      ResponseModel? response = await ProfileRepository().updateProfileImage(value.split("/").last);

      if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
        showSnackBar(Get.overlayContext, toLabelValue(response.message!));
        getprofileAPI();
        hideLoader();
        update();
      } else {
        showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
      }
    }).onError((error, stackTrace) {
      hideLoader();
      if (kDebugMode) {
        print('$error ==> Error Occured While Uploading Image To Bucket');
      }
    });
  }

  //Logout API
  logoutAPI() async {
    showLoader();

    ResponseModel? response = await LogoutRepository().logout();

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      Get.back();
      logoutUser(Get.overlayContext);
    } else {
      hideLoader();

      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }

  //Delete API
  deleteAPI() async {
    showLoader();

    ResponseModel? response = await LogoutRepository().deleteAccount();

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      hideLoader();
      SharedPref.removekeysFromPref(PreferenceConstants.token);
      SharedPref.removekeysFromPref(PreferenceConstants.islogin);
      SharedPref.removekeysFromPref(PreferenceConstants.userID);
      Get.back();
      Get.offAllNamed(Routes.login);
      showSnackBar(Get.overlayContext, toLabelValue(StringConstants.account_successfully_deleted));
    } else {
      hideLoader();

      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }

  logout() {
    showDialogBox(
        Get.overlayContext!,
        toLabelValue(StringConstants.are_you_sure_to_logout),
        () {
          Get.back();
        },
        StringConstants.no,
        () {
          logoutAPI();
        },
        StringConstants.yes);
  }

  deleteAccount() {
    showDialogBox(
        Get.overlayContext!,
        toLabelValue(StringConstants.are_you_sure_to_delete_account),
        () {
          Get.back();
        },
        StringConstants.no,
        () {
          deleteAPI();
        },
        StringConstants.yes);
  }

  hideProfile(bool isHideProfile) {
    showDialogBox(
        Get.overlayContext!,
        toLabelValue(isHideProfile == true
            ? StringConstants.if_you_hide_no_one_see_profile
            : StringConstants.if_you_unhide_everyone_see_profile),
        () {
          Get.back();
        },
        StringConstants.no,
        () {
          hideProfileAPI(isHideProfile);
        },
        StringConstants.yes,
        toLabelValue(isHideProfile == true
            ? StringConstants.are_you_sure_to_hide_profile
            : StringConstants.are_you_sure_to_unhide_profile));
  }
}
