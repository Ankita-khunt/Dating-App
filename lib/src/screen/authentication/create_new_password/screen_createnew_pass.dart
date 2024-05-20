import 'package:dating_app/imports.dart';

class ScreenCreateNewPassword extends StatelessWidget {
  ScreenCreateNewPassword({super.key});

  final createPassController = Get.find<ControllerCreateNewPass>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
        widgetsScaffold: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstants().white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(58.0),
          child: CustomAppBar(title: '', isBackVisible: false)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [createPassView(), passFields()],
        ),
      ),
    ));
  }

  Widget createPassView() {
    return CustomText(
      text: toLabelValue(StringConstants.create_new_pass),
      textAlign: TextAlign.left,
      style: TextStyleConfig.boldTextStyle(
          color: ColorConstants().black,
          fontWeight: FontWeight.w700,
          fontSize: TextStyleConfig.bodyText24),
    );
  }

  Widget passFields() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: toLabelValue(StringConstants.new_pass),
                style: TextStyleConfig.regularTextStyle(
                    color: ColorConstants().black,
                    fontWeight: FontWeight.w400,
                    fontSize: TextStyleConfig.bodyText14),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: CustomTextfieldWidget(
                  placeholder: toLabelValue(StringConstants.enter_new_pass),
                  controller: createPassController.newpassController,
                  isSecuretext: createPassController.isNewPassSecuretext.value,
                  inputformater: [NoLeadingSpaceFormatter()],
                  suffixIcon: InkWell(
                      onTap: createPassController.newPasswordToggle,
                      child: SvgPicture.asset(
                        createPassController.isNewPassSecuretext.value
                            ? ImageConstants.icon_eye_hide
                            : ImageConstants.icon_eye_visible,
                        color: ColorConstants().grey,
                        height: 20,
                        width: 20,
                        fit: BoxFit.scaleDown,
                      )),
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
                    fontSize: TextStyleConfig.bodyText14),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: CustomTextfieldWidget(
                  placeholder: toLabelValue(StringConstants.enter_confirm_pass),
                  controller: createPassController.confirmPassController,
                  isSecuretext:
                      createPassController.isconfirmPassSecuretext.value,
                  inputformater: [NoLeadingSpaceFormatter()],
                  suffixIcon: InkWell(
                      onTap: createPassController.confirmPasswordToggle,
                      child: SvgPicture.asset(
                        createPassController.isconfirmPassSecuretext.value
                            ? ImageConstants.icon_eye_hide
                            : ImageConstants.icon_eye_visible,
                        color: ColorConstants().grey,
                        height: 20,
                        width: 20,
                        fit: BoxFit.scaleDown,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: PrimaryButton(
                  btnTitle: StringConstants.submit,
                  onClicked: () {
                    createPassController.validation();
                  },
                ),
              ),
            ],
          );
        }));
  }
}
