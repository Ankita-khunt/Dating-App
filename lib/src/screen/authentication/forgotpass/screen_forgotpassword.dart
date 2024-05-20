import 'package:dating_app/imports.dart';

class ScreenForgotPassword extends StatelessWidget {
  ScreenForgotPassword({super.key});

  final forgotpassController = Get.find<ControllerForgotpassword>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
        widgetsScaffold: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstants().white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(58.0),
          child: CustomAppBar(
            title: "",
            isBackVisible: true,
          )),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                forgotPassView(),
                emailFields(),
              ],
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CustomText(
                      text: " ${toLabelValue(StringConstants.back_to_login)}",
                      style: TextStyleConfig.boldTextStyle(
                          color: ColorConstants().primaryGradient, fontSize: TextStyleConfig.bodyText14)),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget forgotPassView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: toLabelValue(StringConstants.forgot_pass),
          style: TextStyleConfig.boldTextStyle(
              color: ColorConstants().black, fontWeight: FontWeight.w700, fontSize: TextStyleConfig.bodyText24),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: CustomText(
            text: toLabelValue(StringConstants.forgot_pass_desc),
            style: TextStyleConfig.regularTextStyle(
                color: ColorConstants().grey1, fontWeight: FontWeight.w400, fontSize: TextStyleConfig.bodyText16),
          ),
        ),
      ],
    );
  }

  Widget emailFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: toLabelValue(StringConstants.email_address),
            style: TextStyleConfig.regularTextStyle(
                color: ColorConstants().black, fontWeight: FontWeight.w400, fontSize: TextStyleConfig.bodyText14),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: CustomTextfieldWidget(
              placeholder: toLabelValue(StringConstants.enter_email_address),
              controller: forgotpassController.emailController,
              formkey: forgotpassController.formemailKey,
              keyboardType: TextInputType.emailAddress,
              inputformater: [
                NoLeadingSpaceFormatter(),
                LengthLimitingTextInputFormatter(30),
                FilteringTextInputFormatter.deny(RegExp('  ')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: PrimaryButton(
              btnTitle: StringConstants.submit,
              onClicked: () {
                forgotpassController.validation();
              },
            ),
          ),
        ],
      ),
    );
  }
}
