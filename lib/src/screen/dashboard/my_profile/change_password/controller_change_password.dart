import 'package:dating_app/imports.dart';
import 'package:dating_app/src/services/repository/profile_webservice/change_assword_webservice.dart';

class ChangePasswordController extends GetxController {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formnewpassKey = GlobalKey();
  final GlobalKey<FormState> formconfirmpassKey = GlobalKey();

  RxBool isCurrentPassword = true.obs;
  RxBool isNewPassword = true.obs;
  RxBool isConfirmPassword = true.obs;

//Validate Pass
  RxBool ispasswordNotValid = false.obs;
  RxBool isConfirmpassNotValid = false.obs;

  RxString? passValidationMsg = "".obs;
  RxString? confirmPassValidationMsg = "".obs;

//Current PASSWORD TOGGOLE FOR SECURE
  currentPasswordToggle() {
    isCurrentPassword.toggle();
  }

// New PASSWORD TOGGOLE FOR SECURE
  newPasswordToggle() {
    isNewPassword.toggle();
  }

// Confirm PASSWORD TOGGOLE FOR SECURE
  confirmPasswordToggle() {
    isConfirmPassword.toggle();
  }

  validate() {
    String isValidateCurrentPass = Validator.blankValidation(
        currentPasswordController.value.text, StringConstants.current_password);

    String isValidateNewPass = Validator.blankValidation(
        newPasswordController.value.text, StringConstants.new_pass);

    String isValidateConfirmPass = Validator.blankValidation(
      confirmPasswordController.text,
      StringConstants.confirm_pass,
    );
    String isConfirmPassValidate = Validator.validateConfirmPassword(
        newPasswordController.text, confirmPasswordController.text);

    if (isValidateCurrentPass != "") {
      showSnackBar(Get.overlayContext, isValidateCurrentPass);
    } else if (isValidateNewPass != "" || passValidationMsg != "") {
      ispasswordNotValid.value = true;
      passValidationMsg!.value = isValidateNewPass != ""
          ? isValidateNewPass
          : passValidationMsg!.value;
      update();
    } else if (isValidateConfirmPass != "" || confirmPassValidationMsg != "") {
      isConfirmpassNotValid.value = true;
      confirmPassValidationMsg!.value = isValidateConfirmPass != ""
          ? isValidateConfirmPass
          : confirmPassValidationMsg!.value;
      update();
    } else if (isConfirmPassValidate != "") {
      showSnackBar(Get.overlayContext, isConfirmPassValidate);
    } else {
      changepassAPI();
    }
  }

  //changePassword API
  changepassAPI() async {
    showLoader();

    ResponseModel? response = await ChangepasswordRepository().changePassword(
        currentPasswordController.value.text, newPasswordController.value.text);

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      hideLoader();
      Get.back();
      showSnackBar(Get.overlayContext!, toLabelValue(response.message!));
    } else {
      hideLoader();

      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }
}
