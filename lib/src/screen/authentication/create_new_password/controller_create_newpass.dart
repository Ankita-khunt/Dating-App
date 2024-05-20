import 'package:dating_app/imports.dart';
import 'package:dating_app/src/services/repository/authentication_webservice/forgot_password_webservice.dart';

class ControllerCreateNewPass extends GetxController {
  final newpassController = TextEditingController();

  final confirmPassController = TextEditingController();

  RxBool isNewPassSecuretext = true.obs;
  RxBool isconfirmPassSecuretext = true.obs;

  newPasswordToggle() {
    isNewPassSecuretext.value = !isNewPassSecuretext.value;
  }

  confirmPasswordToggle() {
    isconfirmPassSecuretext.value = !isconfirmPassSecuretext.value;
  }

  //reset Pass API
  resetPassAPI() async {
    showLoader();
    ResponseModel? response = await ForgotPasswordRepository()
        .resetPass(newpassController.text, confirmPassController.text);
    if (response!.code.toString() == CODE_SUCCESS_CODE.toString()) {
      hideLoader();
      Get.offAllNamed(Routes.login);
      showSnackBar(Get.overlayContext, toLabelValue(response.message!));
      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }

  validation() {
    dismissKeyboard();

    String isValidatePass = Validator.validatePassword(
        newpassController.value.text, toLabelValue(StringConstants.new_pass));

    String isValidateConfirmPass = Validator.validateConfirmPassword(
      newpassController.value.text,
      confirmPassController.text,
    );

    if (isValidatePass != "") {
      showSnackBar(Get.overlayContext, isValidatePass);
    } else if (isValidateConfirmPass != "") {
      showSnackBar(Get.overlayContext, isValidateConfirmPass);
    } else {
      resetPassAPI();
    }
  }
}
