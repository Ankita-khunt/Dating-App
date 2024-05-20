import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/authentication/forgotpass_model.dart';
import 'package:dating_app/src/services/repository/authentication_webservice/forgot_password_webservice.dart';

class ControllerForgotpassword extends GetxController {
  //TEXTFIELDS
  final emailController = TextEditingController();
  final GlobalKey<FormState> formemailKey = GlobalKey();

  validation() {
    dismissKeyboard();

    String isValidateemail = Validator.validateEmail(emailController.text);

    if (isValidateemail != "") {
      formemailKey.currentState!.validate();
      showSnackBar(Get.overlayContext, isValidateemail);
    } else {
      forgotPassAPI();
    }
  }

  //forgot Pass API
  forgotPassAPI() async {
    showLoader();
    ApiResponse<ForgotPassResponse>? response =
        await ForgotPasswordRepository().forgotPass(emailController.value.text);
    if (response!.code.toString() == CODE_SUCCESS_CODE.toString()) {
      hideLoader();

      SharedPref.setString(
          PreferenceConstants.forgotToken, response.result!.token);
      SharedPref.setString(
          PreferenceConstants.forgotUserID, response.result!.userId);
      Get.back();
      showSnackBar(Get.overlayContext, toLabelValue(response.message!));

      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }
}
