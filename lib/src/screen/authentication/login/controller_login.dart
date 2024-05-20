import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/authentication/login_model.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/binding_card_swipe.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/controller_card_swipe.dart';
import 'package:dating_app/src/services/repository/authentication_webservice/login_webservice.dart';
import 'package:geolocator/geolocator.dart';

class ControllerLogin extends GetxController {
//TEXTFIELDS
  final usernameController = TextEditingController();
  final GlobalKey<FormState> formusernameKey = GlobalKey();

  final passwordController = TextEditingController();
  final GlobalKey<FormState> formpasswordKey = GlobalKey();

  RxBool isSecuretext = true.obs;
  RxBool isRemember = false.obs;
  RxBool isEmailLogin = false.obs;
  Position? currentPosition;

//PASSWORD TOGGOLE FOR SECURE
  passwordToggle() {
    isSecuretext.value = !isSecuretext.value;
  }

//Login API
  loginAPI() async {
    showLoader();
    ApiResponse<LoginResponse>? response = await LoginRepository().login(
        isEmailLogin.value ? usernameController.text.toLowerCase() : "",
        isEmailLogin.value ? "" : usernameController.text,
        passwordController.text);
    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      getCurrentPosition();

      String userID = await SharedPref.getString(PreferenceConstants.userID);
      if (userID.toString() != response.result!.userId.toString()) {
        SharedPref.setInt(PreferenceConstants.availableSwipeCount, 0);
      }
      SharedPref.removekeysFromPref(PreferenceConstants.userID);

      if (isRemember.value) {
        SharedPref.setBool(PreferenceConstants.isrememberMe, true);
        SharedPref.setString(PreferenceConstants.rememberUser, usernameController.text);
        SharedPref.setString(PreferenceConstants.rememberPass, passwordController.text);
      } else {
        SharedPref.setBool(PreferenceConstants.isrememberMe, false);
        SharedPref.setString(PreferenceConstants.rememberUser, "");
        SharedPref.setString(PreferenceConstants.rememberPass, "");
      }

      SharedPref.setBool(PreferenceConstants.islogin, true);
      loginresponse = response.result;
      SharedPref.setString(PreferenceConstants.userID, response.result!.userId);
      SharedPref.setString(PreferenceConstants.token, response.result!.token);

      if ((loginresponse?.is_subscribed == "0" &&
              loginresponse?.is_full_setupProfile == "0" &&
              loginresponse?.isSetUpProfile == "1") ||
          (loginresponse?.is_subscribed == "1" && loginresponse?.is_full_setupProfile == "1")) {
        hideLoader();

        SharedPref.setBool(PreferenceConstants.setupProfileDone, true);
        Get.offNamed(Routes.customTabbar);
      } else {
        BindingSplash().dependencies;
        BindingCard().dependencies();
        Get.find<ControllerCard>().getMySubscriptionAPI();
        Future.delayed(
          const Duration(seconds: 2),
          () async {
            bool isUserSubscrib = await SharedPref.getBool(PreferenceConstants.isUserSubscribed);
            isUserSubscribe = (loginresponse?.is_subscribed == "0") ? false : true;
            SharedPref.setBool(PreferenceConstants.isUserSubscribed, isUserSubscribe);

            hideLoader();
            SharedPref.setBool(PreferenceConstants.setupProfileDone, false);
            Get.offNamed(Routes.setupprofile);
          },
        );
      }
    } else {
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }

  getRememberMeCreds() async {
    bool? isRememberUser = await SharedPref.getBool(PreferenceConstants.isrememberMe);
    if (isRememberUser == true) {
      isRemember.value = true;
      String? rememberUser = await SharedPref.getString(PreferenceConstants.rememberUser);
      String? rememberUserPass = await SharedPref.getString(PreferenceConstants.rememberPass);

      if (rememberUser.contains("@")) {
        isEmailLogin.value = true;
      }
      usernameController.text = isEmailLogin.value ? rememberUser.toLowerCase() : rememberUser;
      passwordController.text = rememberUserPass;
    }
  }

  //LOCATION PERMISSION
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      openSettingsDialog(Get.overlayContext!).then((value) {
        getCurrentPosition();
      });
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        openSettingsDialog(Get.overlayContext!).then((value) {
          getCurrentPosition();
        });
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      openSettingsDialog(Get.overlayContext!).then((value) {
        getCurrentPosition();
      });
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      currentPosition = position;

      ///STORE CURRENT LAT LONG
      SharedPref.setString(PreferenceConstants.currentLAT, currentPosition!.latitude.toString());
      SharedPref.setString(PreferenceConstants.currentLONG, currentPosition!.longitude.toString());
      BindingSplash().dependencies();
      latitude = currentPosition!.latitude.toString();
      longitude = currentPosition!.longitude.toString();
      Get.find<ControllerCard>().onInit();
    }).catchError((e) {
      debugPrint("error usercard ==> $e");
    });
  }

//VALIDATE TEXTFIELDS
  validation() {
    dismissKeyboard();

    String isValidateusername = Validator.blankValidation(usernameController.text, StringConstants.username);

    String isblankemail = Validator.blankValidation(usernameController.text, StringConstants.email);

    String isValidateEmail = Validator.validateEmail(usernameController.text);

    String isValidatePass = Validator.blankValidation(passwordController.text, StringConstants.password);

    if (isEmailLogin.value) {
      if (isblankemail != "") {
        showSnackBar(Get.overlayContext, isblankemail);
      } else if (isValidateEmail != "") {
        showSnackBar(Get.overlayContext, isValidateEmail);
      } else if (isValidatePass != "") {
        showSnackBar(Get.overlayContext, isValidatePass);
      } else {
        loginAPI();
      }
    } else {
      if (isValidateusername != "") {
        showSnackBar(Get.overlayContext, isValidateusername);
      } else if (isValidatePass != "") {
        showSnackBar(Get.overlayContext, isValidatePass);
      } else {
        loginAPI();
      }
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getRememberMeCreds();
  }
}
