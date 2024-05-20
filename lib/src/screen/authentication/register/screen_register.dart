import 'dart:io';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/authentication/register/controller_register.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/cms/binding_cms.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/cms/controller_cms.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';

class ScreenRegister extends StatelessWidget {
  ScreenRegister({super.key});

  final registerController = Get.find<ControllerRegister>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
      widgetsScaffold: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorConstants().white,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      welcomeView(),
                      const SizedBox(
                        height: 24,
                      ),
                      Center(child: profilePicView()),
                      const SizedBox(
                        height: 30,
                      ),
                      fieldView(context),
                      termsConditionView(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: PrimaryButton(
                          btnTitle: StringConstants.register,
                          onClicked: () {
                            registerController.validation();
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: (20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: toLabelValue(StringConstants.already_have_acc),
                          style: TextStyleConfig.regularTextStyle(
                            color: ColorConstants().black,
                            fontSize: TextStyleConfig.bodyText14,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.offNamed(Routes.login);
                          },
                          child: CustomText(
                            text: " ${toLabelValue(StringConstants.login)}",
                            style: TextStyleConfig.boldTextStyle(
                              color: ColorConstants().primaryGradient,
                              fontSize: TextStyleConfig.bodyText14,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget welcomeView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: toLabelValue(StringConstants.create_acc),
          style: TextStyleConfig.boldTextStyle(
            color: ColorConstants().black,
            fontWeight: FontWeight.w700,
            fontSize: TextStyleConfig.bodyText24,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: CustomText(
            text: toLabelValue(StringConstants.register_to_get_start),
            style: TextStyleConfig.regularTextStyle(
              color: ColorConstants().grey1,
              fontWeight: FontWeight.w400,
              fontSize: TextStyleConfig.bodyText16,
            ),
          ),
        ),
      ],
    );
  }

  Widget profilePicView() {
    return GetBuilder<ControllerRegister>(
      builder: (controller) {
        return Column(
          children: [
            InkWell(
              onTap: () async {
                List<File> pickedImage = await showImageSelectionBottomSheet();
                controller.profileImage = pickedImage.first;
                controller.update();
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(Get.width * 0.25 / 2)),
                    child: registerController.profileImage != null
                        ? Image.file(
                            File(registerController.profileImage!.path),
                            fit: BoxFit.cover,
                            height: Get.width * 0.25,
                            width: Get.width * 0.25,
                            alignment: Alignment.topCenter,
                          )
                        : SvgPicture.asset(
                            ImageConstants.icon_person,
                            fit: BoxFit.cover,
                            height: Get.width * 0.25,
                            width: Get.width * 0.25,
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: SvgPicture.asset(
                      ImageConstants.icon_camera,
                      fit: BoxFit.scaleDown,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomText(
              text: toLabelValue(StringConstants.upload_profile_pic),
              style: TextStyleConfig.boldTextStyle(
                color: ColorConstants().black,
                fontWeight: FontWeight.w700,
                fontSize: TextStyleConfig.bodyText14,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget fieldView(context) {
    return GetBuilder<ControllerRegister>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: toLabelValue(StringConstants.username),
              style: TextStyleConfig.regularTextStyle(
                color: ColorConstants().black,
                fontWeight: FontWeight.w400,
                fontSize: TextStyleConfig.bodyText14,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: CustomTextfieldWidget(
                textcapitalization: TextCapitalization.none,
                placeholder: toLabelValue(StringConstants.enter_username),
                controller: controller.usernameController.value,
                suffixIcon: controller.usernameController.value.text != ""
                    ? registerController.isAlreadyExistUser.value
                        ? SvgPicture.asset(
                            ImageConstants.icon_right,
                            fit: BoxFit.scaleDown,
                          )
                        : SizedBox(
                            width: Get.width * 0.28,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: CustomText(
                                  text: toLabelValue(StringConstants.already_taken),
                                  textAlign: TextAlign.center,
                                  style: TextStyleConfig.regularTextStyle(
                                    fontSize: TextStyleConfig.bodyText12,
                                    color: ColorConstants().errorRed,
                                  ),
                                ),
                              ),
                            ),
                          )
                    : const SizedBox(),
                isValid:
                    (controller.usernameController.value.text != "" && !registerController.isAlreadyExistUser.value)
                        ? false
                        : true,
                onchanged: (value) {
                  registerController.userExistAPI(false);

                  controller.update();
                },
                inputformater: [
                  NoLeadingSpaceFormatter(),
                  LengthLimitingTextInputFormatter(30),
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z_. 0-9]')),
                  FilteringTextInputFormatter.deny(RegExp(' ')),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            CustomText(
              text: toLabelValue(StringConstants.fullname),
              style: TextStyleConfig.regularTextStyle(
                color: ColorConstants().black,
                fontWeight: FontWeight.w400,
                fontSize: TextStyleConfig.bodyText14,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: CustomTextfieldWidget(
                formkey: registerController.formufullnameKey,
                placeholder: toLabelValue(StringConstants.enter_fullname),
                controller: registerController.fullNameController,
                inputformater: [
                  NoLeadingSpaceFormatter(),
                  LengthLimitingTextInputFormatter(30),
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                  FilteringTextInputFormatter.deny(RegExp('  ')),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            CustomText(
              text: toLabelValue(StringConstants.email_address),
              style: TextStyleConfig.regularTextStyle(
                color: ColorConstants().black,
                fontWeight: FontWeight.w400,
                fontSize: TextStyleConfig.bodyText14,
              ),
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: CustomTextfieldWidget(
                  placeholder: toLabelValue(StringConstants.enter_email_address),
                  textcapitalization: TextCapitalization.none,
                  controller: registerController.emailController,
                  formkey: registerController.formemailKey,
                  keyboardType: TextInputType.emailAddress,
                  inputformater: [
                    NoLeadingSpaceFormatter(),
                    LengthLimitingTextInputFormatter(30),
                    FilteringTextInputFormatter.deny(RegExp('  ')),
                  ],
                  suffixIcon: (registerController.emailController.value.text != "" &&
                          registerController.isValidEmail.value == "")
                      ? (registerController.isAlreadyExistEmail.value)
                          ? SvgPicture.asset(
                              ImageConstants.icon_right,
                              fit: BoxFit.scaleDown,
                            )
                          : SizedBox(
                              width: Get.width * 0.24,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: CustomText(
                                    text: toLabelValue(StringConstants.already_taken),
                                    textAlign: TextAlign.center,
                                    style: TextStyleConfig.regularTextStyle(
                                        fontSize: TextStyleConfig.bodyText12, color: ColorConstants().errorRed),
                                  ),
                                ),
                              ),
                            )
                      : const SizedBox(),
                  isValid: !registerController.isAlreadyExistEmail.value ? false : true,
                  onchanged: (value) {
                    registerController.isValidEmail.value = Validator.validateEmail(value);
                    if (registerController.isValidEmail.value == "") {
                      registerController.userExistAPI(true);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            CustomText(
              text: toLabelValue(StringConstants.dob),
              style: TextStyleConfig.regularTextStyle(
                color: ColorConstants().black,
                fontWeight: FontWeight.w400,
                fontSize: TextStyleConfig.bodyText14,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: InkWell(
                onTap: () async {
                  DateTime? pickedDate = await dobDatePicker(context, controller.selectedDOBDate);
                  dismissKeyboard();
                  if (pickedDate != null) {
                    controller.selectedDOBDate = pickedDate;

                    //pickedDate output format => 2021-03-10 00:00:00.000
                    debugPrint("$pickedDate");
                    String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                    debugPrint(formattedDate); //formatted date output using intl package =>  2021-03-16
                    //you can implement different kind of Date Format here according to your requirement

                    var isAbove18 = registerController.isAdult(pickedDate);
                    registerController.isUserAdult.value = isAbove18;
                    registerController.dobController.text = formattedDate;
                  } else {
                    if (kDebugMode) {
                      print("Date is not selected");
                    }
                  }
                },
                child: IgnorePointer(
                  ignoring: true,
                  child: CustomTextfieldWidget(
                    placeholder: toLabelValue(StringConstants.enter_date_birth),
                    controller: registerController.dobController,
                    readOnly: true,
                    formkey: registerController.formdobKey,
                    onchanged: (value) {
                      DateTime parseDate = DateFormat("dd-MM-yyyy").parse(value);
                      var inputDate = DateTime.parse(parseDate.toString());
                      var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
                      var outputDate = outputFormat.format(inputDate);
                      debugPrint(outputDate);
                      debugPrint("$parseDate");
                    },
                    suffixIcon: SvgPicture.asset(
                      ImageConstants.icon_calender,
                      color: ColorConstants().grey,
                      height: 20,
                      width: 20,
                      fit: BoxFit.scaleDown,
                    ),
                    keyboardType: TextInputType.datetime,
                    inputformater: [
                      DateFormatter(),
                      NoLeadingSpaceFormatter(),
                      FilteringTextInputFormatter.allow(RegExp('[0-9/]')),
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.deny(RegExp('  ')),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            CustomText(
              text: toLabelValue(StringConstants.password),
              style: TextStyleConfig.regularTextStyle(
                color: ColorConstants().black,
                fontWeight: FontWeight.w400,
                fontSize: TextStyleConfig.bodyText14,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: TextFormField(
                key: controller.formpasswordKey,
                controller: controller.passwordController,
                obscureText: controller.isNewPassSecuretext.value,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  NoLeadingSpaceFormatter(),
                  FilteringTextInputFormatter.deny(RegExp('  ')),
                ],
                cursorColor: ColorConstants().grey1,
                onTap: () {
                  Scrollable.ensureVisible(
                    controller.formufullnameKey.currentContext!,
                    duration: const Duration(seconds: 0),
                  );
                  controller.update();
                },
                onFieldSubmitted: (value) {
                  Scrollable.ensureVisible(controller.formufullnameKey.currentContext!,
                      duration: const Duration(seconds: 0));

                  controller.update();

                  FocusScope.of(context).nextFocus();
                },
                onChanged: (value) {
                  String isValidatePass = Validator.validatePassword(
                    registerController.passwordController.value.text,
                    toLabelValue(StringConstants.password),
                  );
                  if (isValidatePass != "") {
                    controller.ispasswordNotValid.value = true;
                    controller.passValidationMsg!.value = isValidatePass;
                  } else {
                    controller.ispasswordNotValid.value = false;
                    controller.passValidationMsg!.value = "";
                  }
                  controller.update();
                },
                style: TextStyleConfig.regularTextStyle(
                  color: ColorConstants().black,
                  fontSize: TextStyleConfig.bodyText14,
                ),
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: toLabelValue(StringConstants.enter_pass),
                  errorText: controller.ispasswordNotValid.value ? controller.passValidationMsg!.value : null,
                  contentPadding: const EdgeInsets.only(left: 16, bottom: 4, top: 4, right: 4),
                  hintStyle: TextStyleConfig.regularTextStyle(
                    fontSize: TextStyleConfig.bodyText14,
                    color: ColorConstants().grey,
                  ),
                  errorMaxLines: 3,
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 24,
                  ),
                  suffixIcon: InkWell(
                    onTap: controller.newPasswordToggle,
                    child: SvgPicture.asset(
                      controller.isNewPassSecuretext.value
                          ? ImageConstants.icon_eye_hide
                          : ImageConstants.icon_eye_visible,
                      color: ColorConstants().grey,
                      height: 20,
                      width: 20,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  focusedErrorBorder: controller.ispasswordNotValid.value
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(49 / 2),
                          borderSide: BorderSide(
                            color: ColorConstants().errorRed,
                            width: 1,
                          ),
                        )
                      : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(49 / 2),
                          borderSide: BorderSide(
                            color: ColorConstants().errorRed,
                            width: 1,
                          ),
                        ),
                  errorBorder: controller.ispasswordNotValid.value
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(49 / 2),
                          borderSide: BorderSide(
                            color: ColorConstants().errorRed,
                            width: 1,
                          ),
                        )
                      : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(49 / 2),
                          borderSide: BorderSide(
                            color: ColorConstants().errorRed,
                            width: 1,
                          ),
                        ),
                  focusedBorder: controller.ispasswordNotValid.value
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(49 / 2),
                          borderSide: BorderSide(
                            color: ColorConstants().errorRed,
                            width: 1,
                          ),
                        )
                      : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(49 / 2),
                          borderSide: BorderSide(
                            color: ColorConstants().lightgrey,
                            width: 1,
                          ),
                        ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(49 / 2),
                    borderSide: BorderSide(
                      color: ColorConstants().lightgrey,
                      width: 1,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            CustomText(
              text: toLabelValue(StringConstants.confirm_pass),
              style: TextStyleConfig.regularTextStyle(
                color: ColorConstants().black,
                fontWeight: FontWeight.w400,
                fontSize: TextStyleConfig.bodyText14,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: TextFormField(
                key: controller.formconfirmpasswordKey,
                controller: controller.confirmpasswordController,
                obscureText: controller.isconfirmPassSecuretext.value,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.sentences,
                inputFormatters: [
                  NoLeadingSpaceFormatter(),
                  FilteringTextInputFormatter.deny(RegExp('  ')),
                ],
                cursorColor: ColorConstants().grey1,
                onTap: () {
                  Scrollable.ensureVisible(
                    controller.formufullnameKey.currentContext!,
                    duration: const Duration(seconds: 0),
                  );
                  controller.update();
                },
                onChanged: (value) {
                  String isValidateConfirmPass = Validator.validateConfirmPassword(
                    controller.passwordController.value.text,
                    controller.confirmpasswordController.text,
                  );
                  if (isValidateConfirmPass != "") {
                    controller.isConfirmpassNotValid.value = true;
                    controller.confirmPassValidationMsg!.value = isValidateConfirmPass;
                  } else {
                    controller.isConfirmpassNotValid.value = false;
                    controller.confirmPassValidationMsg!.value = "";
                  }

                  controller.update();
                },
                style: TextStyleConfig.regularTextStyle(
                  color: ColorConstants().black,
                  fontSize: TextStyleConfig.bodyText14,
                ),
                decoration: InputDecoration(
                  hintText: toLabelValue(StringConstants.enter_confirm_pass),
                  errorText: controller.isConfirmpassNotValid.value ? controller.confirmPassValidationMsg!.value : null,
                  contentPadding: const EdgeInsets.only(left: 16, bottom: 4, top: 4, right: 4),
                  hintStyle: TextStyleConfig.regularTextStyle(
                    fontSize: TextStyleConfig.bodyText14,
                    color: ColorConstants().grey,
                  ),
                  errorMaxLines: 3,
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 24,
                  ),
                  suffixIcon: InkWell(
                    onTap: controller.confirmPasswordToggle,
                    child: SvgPicture.asset(
                      controller.isconfirmPassSecuretext.value
                          ? ImageConstants.icon_eye_hide
                          : ImageConstants.icon_eye_visible,
                      color: ColorConstants().grey,
                      height: 20,
                      width: 20,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  focusedErrorBorder: controller.isConfirmpassNotValid.value
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(49 / 2),
                          borderSide: BorderSide(
                            color: ColorConstants().errorRed,
                            width: 1,
                          ),
                        )
                      : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(49 / 2),
                          borderSide: BorderSide(
                            color: ColorConstants().errorRed,
                            width: 1,
                          ),
                        ),
                  errorBorder: controller.isConfirmpassNotValid.value
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(49 / 2),
                          borderSide: BorderSide(
                            color: ColorConstants().errorRed,
                            width: 1,
                          ),
                        )
                      : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(49 / 2),
                          borderSide: BorderSide(
                            color: ColorConstants().errorRed,
                            width: 1,
                          ),
                        ),
                  focusedBorder: controller.isConfirmpassNotValid.value
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(49 / 2),
                          borderSide: BorderSide(
                            color: ColorConstants().errorRed,
                            width: 1,
                          ),
                        )
                      : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(49 / 2),
                          borderSide: BorderSide(
                            color: ColorConstants().lightgrey,
                            width: 1,
                          ),
                        ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(49 / 2),
                    borderSide: BorderSide(
                      color: ColorConstants().lightgrey,
                      width: 1,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget termsConditionView() {
    return Obx(
      () {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 16,
                child: CustomCheckBox(
                  value: registerController.isAcceptTermsCondition.value,
                  onChanged: (value) {
                    registerController.isAcceptTermsCondition.value = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: Get.width * 0.7,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: toLabelValue(StringConstants.i_agree),
                          style: TextStyleConfig.regularTextStyle(
                            color: ColorConstants().grey,
                            fontSize: TextStyleConfig.bodyText14,
                          ),
                        ),
                        TextSpan(
                          text: " ",
                          children: [
                            TextSpan(
                              text: "${toLabelValue(StringConstants.terms_condition)} ",
                              style: TextStyle(
                                color: ColorConstants().black,
                                fontSize: TextStyleConfig.bodyText15,
                                decoration: TextDecoration.underline,
                                decorationThickness: 1.5,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  BindingCMS().dependencies();
                                  Get.find<ControllerCMS>().cmsAPI("3");
                                },
                            ),
                          ],
                          style: TextStyleConfig.boldTextStyle(
                            color: ColorConstants().black,
                            fontSize: TextStyleConfig.bodyText15,
                          ),
                        ),
                        TextSpan(
                          text: toLabelValue(StringConstants.and),
                          style: TextStyleConfig.regularTextStyle(
                            color: ColorConstants().grey,
                            fontSize: TextStyleConfig.bodyText14,
                          ),
                        ),
                        TextSpan(
                          text: " ",
                          style: TextStyleConfig.boldTextStyle(
                            color: ColorConstants().black,
                            fontSize: TextStyleConfig.bodyText15,
                          ),
                          children: [
                            TextSpan(
                              text: "${toLabelValue(StringConstants.privacy_policy)}.",
                              style: TextStyle(
                                color: ColorConstants().black,
                                fontSize: TextStyleConfig.bodyText15,
                                decoration: TextDecoration.underline,
                                decorationThickness: 1.5,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  BindingCMS().dependencies();
                                  Get.find<ControllerCMS>().cmsAPI("2");
                                },
                            ),
                          ],
                        ),
                      ],
                    ),
                    maxLines: 3,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 16,
                child: CustomCheckBox(
                  value: registerController.isOver18.value,
                  onChanged: (value) {
                    registerController.isOver18.value = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(11),
                child: CustomText(
                  text: toLabelValue(StringConstants.over_eighteen),
                  style: TextStyleConfig.regularTextStyle(
                    color: ColorConstants().black,
                    fontWeight: FontWeight.w500,
                    fontSize: TextStyleConfig.bodyText14,
                  ),
                ),
              ),
            ],
          )
        ]);
      },
    );
  }
}
