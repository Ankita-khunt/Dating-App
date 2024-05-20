import 'dart:io';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/authentication/register_model.dart';
import 'package:dating_app/src/services/repository/authentication_webservice/register_webservice.dart';
import 'package:flutter/foundation.dart';

class ControllerRegister extends GetxController {
  //TEXTFIELDS
  Rx<TextEditingController> usernameController = TextEditingController().obs;
  final GlobalKey<FormState> formusernameKey = GlobalKey();

  final passwordController = TextEditingController();
  final GlobalKey<FormState> formpasswordKey = GlobalKey();

  final fullNameController = TextEditingController();
  final GlobalKey<FormState> formufullnameKey = GlobalKey();

  final emailController = TextEditingController();
  final GlobalKey<FormState> formemailKey = GlobalKey();

  final dobController = TextEditingController();
  final GlobalKey<FormState> formdobKey = GlobalKey();

  final confirmpasswordController = TextEditingController();
  final GlobalKey<FormState> formconfirmpasswordKey = GlobalKey();

  RxString isValidEmail = "".obs;
  RxBool isNewPassSecuretext = true.obs;
  RxBool isconfirmPassSecuretext = true.obs;
  DateTime? selectedDOBDate;
  RxBool isUserAdult = false.obs;
  RxBool isAcceptTermsCondition = false.obs;
  RxBool isOver18 = false.obs;

//User Already Exist Validation
//Validate Pass
  RxBool ispasswordNotValid = false.obs;
  RxBool isConfirmpassNotValid = false.obs;

  RxString? passValidationMsg = "".obs;
  RxString? confirmPassValidationMsg = "".obs;

  RxBool isAlreadyExistUser = false.obs;
  RxBool isAlreadyExistEmail = false.obs;

  String username = "Preksha";
  String email = "preksha@gmail.com";

//Profile picture

  File? profileImage;

  newPasswordToggle() {
    isNewPassSecuretext.value = !isNewPassSecuretext.value;
    update();
  }

  confirmPasswordToggle() {
    isconfirmPassSecuretext.value = !isconfirmPassSecuretext.value;
    update();
  }

  //ISUSER EXIST API
  userExistAPI(bool isEmail) async {
    ResponseModel? response = await RegisterRepository()
        .isUserExist(isEmail ? emailController.text.toLowerCase() : "", isEmail ? "" : usernameController.value.text);
    if (response!.code == CODE_SUCCESS_CODE) {
      if (response.message != "success") {
        if (isEmail) {
          isAlreadyExistEmail(false);
        } else {
          isAlreadyExistUser(false);
        }
      } else {
        if (isEmail) {
          isAlreadyExistEmail(true);
        } else {
          isAlreadyExistUser(true);
        }
      }
      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }

  bool isAdult(DateTime date) {
    final DateTime today = DateTime.now();
    final DateTime adultDate = DateTime(
      date.year + 18,
      date.month,
      date.day,
    );

    return adultDate.isBefore(today);
  }

//Register API
  registerAPI() async {
    showLoader();
    uploadS3Image(profileImage!).then((value) async {
      if (kDebugMode) {
        print(value);
      }
      if (value != null) {
        ApiResponse<RegisterResponse>? response = await RegisterRepository().register(
            usernameController.value.text,
            fullNameController.text,
            emailController.value.text.toLowerCase(),
            dobController.text,
            passwordController.text,
            value.split("/").last);
        if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
          SharedPref.setBool(PreferenceConstants.isregistered, true);
          SharedPref.setBool(PreferenceConstants.setupProfileDone, false);
          SharedPref.setString(PreferenceConstants.userID, response.result!.userId);
          SharedPref.setString(PreferenceConstants.token, response.result!.token);
          Future.delayed(
            const Duration(seconds: 3),
            () {
              hideLoader();
              Get.offAllNamed(Routes.registerSuccess);
            },
          );
        } else {
          hideLoader();

          showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
        }
      }
    }).onError((error, stackTrace) {
      hideLoader();
      if (kDebugMode) {
        print('$error ==> Error Occured While Uploading Image To Bucket');
      }
    });

    hideLoader();
  }

  //VALIDATE TEXTFIELDS
  validation() {
    dismissKeyboard();

    String isblankusername = Validator.blankValidation(usernameController.value.text, StringConstants.username);

    String isValidatefullname = Validator.blankValidation(fullNameController.value.text, StringConstants.fullname);

    String isValidateEmail = Validator.validateEmail(emailController.value.text);

    String isValidateDOB = Validator.blankValidation(dobController.value.text, StringConstants.date_of_birth);

    String isValidatePassBlank = Validator.blankValidation(passwordController.value.text, StringConstants.password);
    String isValidateConfirmPassBlank =
        Validator.blankValidation(confirmpasswordController.value.text, StringConstants.confirm_pass);

    String isValidatePass = Validator.validatePassword(passwordController.value.text);

    String isValidateConfirmPass = Validator.validateConfirmPassword(
      passwordController.value.text,
      confirmpasswordController.text,
    );

    if (isblankusername != "") {
      showSnackBar(Get.overlayContext, isblankusername);
    } else if (isValidatefullname != "") {
      formufullnameKey.currentState!.validate();
      showSnackBar(Get.overlayContext, isValidatefullname);
    } else if (isValidateEmail != "") {
      formemailKey.currentState!.validate();
      showSnackBar(Get.overlayContext, isValidateEmail);
    } else if (isValidateDOB != "") {
      formdobKey.currentState!.validate();
      showSnackBar(Get.overlayContext,
          "${toLabelValue(StringConstants.please_select)} ${toLabelValue(StringConstants.date_of_birth)}");
    } else if (isValidatePass != "") {
      ispasswordNotValid.value = true;
      passValidationMsg?.value = isValidatePassBlank != "" ? isValidatePassBlank : isValidatePass;
      update();
    } else if (isValidateConfirmPass != "") {
      isConfirmpassNotValid.value = true;
      confirmPassValidationMsg!.value =
          isValidateConfirmPassBlank != "" ? isValidateConfirmPassBlank : isValidateConfirmPass;
      update();
    } else if (!isAcceptTermsCondition.value) {
      showSnackBar(Get.overlayContext, toLabelValue(StringConstants.accept_terms_condition));
    } else if (!isOver18.value) {
      showSnackBar(Get.overlayContext, toLabelValue(StringConstants.confirm_you_are_18_above));
    } else if (profileImage == null) {
      showSnackBar(Get.overlayContext, toLabelValue(StringConstants.upload_your_profile_pic));
    } else if (!isAlreadyExistUser.value) {
      showSnackBar(Get.overlayContext, toLabelValue(StringConstants.user_already_exist));
    } else if (!isAlreadyExistEmail.value) {
      showSnackBar(Get.overlayContext, toLabelValue(StringConstants.email_already_exist));
    } else {
      registerAPI();
    }
  }
}
