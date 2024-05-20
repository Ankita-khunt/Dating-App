import '../../../../../imports.dart';
import 'controller_change_password.dart';

class ScreenChangePassword extends StatelessWidget {
  ScreenChangePassword({Key? key}) : super(key: key);

  final changePasswordController = Get.find<ChangePasswordController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(58.0),
          child: CustomAppBar(
            isGradientAppBar: true,
            isBackVisible: true,
            title: toLabelValue(StringConstants.change_password),
            titleColor: ColorConstants().white,
            backIconColor: ColorConstants().white,
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomText(
              text: toLabelValue(StringConstants.enter_current_password),
              style: TextStyleConfig.regularTextStyle(
                  color: ColorConstants().black,
                  fontWeight: FontWeight.w400,
                  fontSize: TextStyleConfig.bodyText14),
            ),
            Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: CustomTextfieldWidget(
                    placeholder:
                        toLabelValue(StringConstants.enter_current_password),
                    isSecuretext:
                        changePasswordController.isCurrentPassword.value,
                    suffixIcon: InkWell(
                        onTap: changePasswordController.currentPasswordToggle,
                        child: SvgPicture.asset(
                          !changePasswordController.isCurrentPassword.value
                              ? ImageConstants.icon_eye_visible
                              : ImageConstants.icon_eye_hide,
                          color: ColorConstants().grey,
                          height: 20,
                          width: 20,
                          fit: BoxFit.scaleDown,
                        )),
                    controller:
                        changePasswordController.currentPasswordController,
                    borderColor: ColorConstants().lightgrey,
                    inputformater: [
                      // FilteringTextInputFormatter.deny(regexToRemoveEmoji),

                      NoLeadingSpaceFormatter(),
                      FilteringTextInputFormatter.deny(RegExp('  ')),
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 7.0),
              child: CustomText(
                text: toLabelValue(StringConstants.new_pass),
                style: TextStyleConfig.regularTextStyle(
                    color: ColorConstants().black,
                    fontWeight: FontWeight.w400,
                    fontSize: TextStyleConfig.bodyText14),
              ),
            ),
            Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    key: changePasswordController.formnewpassKey,
                    controller: changePasswordController.newPasswordController,
                    obscureText: changePasswordController.isNewPassword.value,
                    inputFormatters: [
                      NoLeadingSpaceFormatter(),
                      FilteringTextInputFormatter.deny(RegExp('  ')),
                    ],
                    cursorColor: ColorConstants().grey1,
                    onChanged: (value) {
                      String isValidatePass = Validator.validatePassword(
                          changePasswordController
                              .newPasswordController.value.text,
                          toLabelValue(StringConstants.password));
                      if (isValidatePass != "") {
                        changePasswordController.ispasswordNotValid.value =
                            true;
                        changePasswordController.passValidationMsg!.value =
                            isValidatePass;
                      } else {
                        changePasswordController.ispasswordNotValid.value =
                            false;
                        changePasswordController.passValidationMsg!.value = "";
                      }
                      changePasswordController.update();
                    },
                    style: TextStyleConfig.regularTextStyle(
                      color: ColorConstants().black,
                      fontSize: TextStyleConfig.bodyText14,
                    ),
                    decoration: InputDecoration(
                      hintText: toLabelValue(StringConstants.enter_new_pass),
                      errorText: changePasswordController
                              .ispasswordNotValid.value
                          ? changePasswordController.passValidationMsg!.value
                          : null,
                      contentPadding: const EdgeInsets.only(
                          left: 16, bottom: 4, top: 4, right: 4),
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
                          onTap: changePasswordController.newPasswordToggle,
                          child: SvgPicture.asset(
                            changePasswordController.isNewPassword.value
                                ? ImageConstants.icon_eye_hide
                                : ImageConstants.icon_eye_visible,
                            color: ColorConstants().grey,
                            height: 20,
                            width: 20,
                            fit: BoxFit.scaleDown,
                          )),
                      focusedErrorBorder:
                          changePasswordController.ispasswordNotValid.value
                              ? OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(49 / 2),
                                  borderSide: BorderSide(
                                      color: ColorConstants().errorRed,
                                      width: 1))
                              : OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(49 / 2),
                                  borderSide: BorderSide(
                                      color: ColorConstants().errorRed,
                                      width: 1)),
                      errorBorder: changePasswordController
                              .ispasswordNotValid.value
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(49 / 2),
                              borderSide: BorderSide(
                                  color: ColorConstants().errorRed, width: 1))
                          : OutlineInputBorder(
                              borderRadius: BorderRadius.circular(49 / 2),
                              borderSide: BorderSide(
                                  color: ColorConstants().errorRed, width: 1)),
                      focusedBorder:
                          changePasswordController.ispasswordNotValid.value
                              ? OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(49 / 2),
                                  borderSide: BorderSide(
                                      color: ColorConstants().errorRed,
                                      width: 1))
                              : OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(49 / 2),
                                  borderSide: BorderSide(
                                      color: ColorConstants().lightgrey,
                                      width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(49 / 2),
                          borderSide: BorderSide(
                              color: ColorConstants().lightgrey, width: 1)),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: CustomText(
                text: toLabelValue(StringConstants.confirm_pass),
                style: TextStyleConfig.regularTextStyle(
                    color: ColorConstants().black,
                    fontWeight: FontWeight.w400,
                    fontSize: TextStyleConfig.bodyText14),
              ),
            ),
            Obx(() => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  key: changePasswordController.formconfirmpassKey,
                  controller:
                      changePasswordController.confirmPasswordController,
                  obscureText: changePasswordController.isConfirmPassword.value,
                  inputFormatters: [
                    NoLeadingSpaceFormatter(),
                    FilteringTextInputFormatter.deny(RegExp('  ')),
                  ],
                  cursorColor: ColorConstants().grey1,
                  onChanged: (value) {
                    String isValidateConfirmPass =
                        Validator.validateConfirmPassword(
                      changePasswordController.newPasswordController.value.text,
                      changePasswordController.confirmPasswordController.text,
                    );
                    if (isValidateConfirmPass != "") {
                      changePasswordController.isConfirmpassNotValid.value =
                          true;
                      changePasswordController.confirmPassValidationMsg!.value =
                          isValidateConfirmPass;
                    } else {
                      changePasswordController.isConfirmpassNotValid.value =
                          false;
                      changePasswordController.confirmPassValidationMsg!.value =
                          "";
                    }
                    changePasswordController.update();
                  },
                  style: TextStyleConfig.regularTextStyle(
                    color: ColorConstants().black,
                    fontSize: TextStyleConfig.bodyText14,
                  ),
                  decoration: InputDecoration(
                    hintText: toLabelValue(StringConstants.enter_confirm_pass),
                    errorText:
                        changePasswordController.isConfirmpassNotValid.value
                            ? changePasswordController
                                .confirmPassValidationMsg!.value
                            : null,
                    contentPadding: const EdgeInsets.only(
                        left: 16, bottom: 4, top: 4, right: 4),
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
                        onTap: changePasswordController.confirmPasswordToggle,
                        child: SvgPicture.asset(
                          changePasswordController.isConfirmPassword.value
                              ? ImageConstants.icon_eye_hide
                              : ImageConstants.icon_eye_visible,
                          color: ColorConstants().grey,
                          height: 20,
                          width: 20,
                          fit: BoxFit.scaleDown,
                        )),
                    focusedErrorBorder:
                        changePasswordController.isConfirmpassNotValid.value
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(49 / 2),
                                borderSide: BorderSide(
                                    color: ColorConstants().errorRed, width: 1))
                            : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(49 / 2),
                                borderSide: BorderSide(
                                    color: ColorConstants().errorRed,
                                    width: 1)),
                    errorBorder:
                        changePasswordController.isConfirmpassNotValid.value
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(49 / 2),
                                borderSide: BorderSide(
                                    color: ColorConstants().errorRed, width: 1))
                            : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(49 / 2),
                                borderSide: BorderSide(
                                    color: ColorConstants().errorRed,
                                    width: 1)),
                    focusedBorder:
                        changePasswordController.isConfirmpassNotValid.value
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(49 / 2),
                                borderSide: BorderSide(
                                    color: ColorConstants().errorRed, width: 1))
                            : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(49 / 2),
                                borderSide: BorderSide(
                                    color: ColorConstants().lightgrey,
                                    width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(49 / 2),
                        borderSide: BorderSide(
                            color: ColorConstants().lightgrey, width: 1)),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                ))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: PrimaryButton(
                btnTitle: StringConstants.submit,
                onClicked: () {
                  changePasswordController.validate();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
