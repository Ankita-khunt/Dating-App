import 'package:dating_app/imports.dart';
import 'package:dating_app/src/services/repository/profile_webservice/cms_webservice.dart';

class ControllerConcatUs extends GetxController {
  //TEXTFIELDS
  final nameController = TextEditingController();
  final GlobalKey<FormState> formNameKey = GlobalKey();
  final emailController = TextEditingController();
  final GlobalKey<FormState> formEmailKey = GlobalKey();
  final messageController = TextEditingController();
  final GlobalKey<FormState> formMessageKey = GlobalKey();

  final GlobalKey<FormState> sendKey = GlobalKey();

  //CONTACTUS API
  contactUS() async {
    showLoader();
    ResponseModel? response =
        await CMSRepository().contactUs(nameController.text, emailController.text, messageController.text);
    if (response!.code == CODE_SUCCESS_CODE) {
      showSnackBar(Get.overlayContext, toLabelValue(response.message!));
      Future.delayed(
        const Duration(seconds: 2),
        () {
          Get.back();
        },
      );
      hideLoader();

      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }

//VALIDATE TEXTFIELDS
  validation() {
    dismissKeyboard();

    String isValidatename = Validator.blankValidation(nameController.text, StringConstants.name);

    String isblankemail = Validator.blankValidation(emailController.text, StringConstants.email);

    String isValidateEmail = Validator.validateEmail(emailController.text);

    String isValidateMessage = Validator.blankValidation(messageController.text, StringConstants.message);

    if (isValidatename != "") {
      showSnackBar(Get.overlayContext, isValidatename);
    } else if (isblankemail != "") {
      showSnackBar(Get.overlayContext, isblankemail);
    } else if (isValidateEmail != "") {
      showSnackBar(Get.overlayContext, isValidateEmail);
    } else if (isValidateMessage != "") {
      showSnackBar(Get.overlayContext, isValidateMessage);
    } else {
      contactUS();
    }
  }
}
