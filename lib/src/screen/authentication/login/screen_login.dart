import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/authentication/login/controller_login.dart';

class ScreenLogin extends StatelessWidget {
  ScreenLogin({super.key});

  final loginController = Get.find<ControllerLogin>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
        widgetsScaffold: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstants().white,
      bottomNavigationBar: bottomNavigationView(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 70, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                welcomeView(),
                const SizedBox(
                  height: 8,
                ),
                loginFields(),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget bottomNavigationView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        CustomText(
            text: toLabelValue(StringConstants.dont_have_acc),
            style: TextStyleConfig.regularTextStyle(
                color: ColorConstants().black,
                fontSize: TextStyleConfig.bodyText14)),
        InkWell(
          onTap: () {
            Get.offNamed(Routes.register);
          },
          child: CustomText(
              text: " ${toLabelValue(StringConstants.register)}",
              style: TextStyleConfig.boldTextStyle(
                  color: ColorConstants().primaryGradient,
                  fontSize: TextStyleConfig.bodyText14)),
        )
      ]),
    );
  }

  Widget welcomeView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: toLabelValue(StringConstants.welcome_back),
          style: TextStyleConfig.boldTextStyle(
              color: ColorConstants().black,
              fontWeight: FontWeight.w700,
              fontSize: TextStyleConfig.bodyText24),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: CustomText(
            text: toLabelValue(StringConstants.plesae_enter_your_details),
            style: TextStyleConfig.regularTextStyle(
                color: ColorConstants().grey1,
                fontWeight: FontWeight.w400,
                fontSize: TextStyleConfig.bodyText16),
          ),
        ),
      ],
    );
  }

  Widget loginFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: toLabelValue(loginController.isEmailLogin.value
                        ? StringConstants.email_address
                        : StringConstants.username),
                    style: TextStyleConfig.regularTextStyle(
                        color: ColorConstants().black,
                        fontWeight: FontWeight.w400,
                        fontSize: TextStyleConfig.bodyText14),
                  ),
                  InkWell(
                    onTap: () {
                      loginController.isEmailLogin.value =
                          !loginController.isEmailLogin.value;
                      loginController.usernameController.text = "";
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset(ImageConstants.icon_mail),
                        const SizedBox(
                          width: 4,
                        ),
                        CustomText(
                          text: toLabelValue(loginController.isEmailLogin.value
                              ? StringConstants.use_username
                              : StringConstants.use_email),
                          style: TextStyleConfig.regularTextStyle(
                              color: ColorConstants().grey,
                              fontWeight: FontWeight.w400,
                              fontSize: TextStyleConfig.bodyText14),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Obx(() => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: CustomTextfieldWidget(
                  textcapitalization: TextCapitalization.none,
                  placeholder: toLabelValue(loginController.isEmailLogin.value
                      ? StringConstants.enter_email_address
                      : StringConstants.enter_username),
                  controller: loginController.usernameController,
                  formkey: loginController.formusernameKey,
                  inputformater: [
                    NoLeadingSpaceFormatter(),
                    LengthLimitingTextInputFormatter(30),
                    FilteringTextInputFormatter.deny(RegExp(' ')),
                    if (!loginController.isEmailLogin.value)
                      FilteringTextInputFormatter.allow(
                          RegExp('[a-zA-Z_0-9.]')),
                  ],
                ),
              )),
          const SizedBox(
            height: 12,
          ),
          CustomText(
            text: toLabelValue(StringConstants.password),
            style: TextStyleConfig.regularTextStyle(
                color: ColorConstants().black,
                fontWeight: FontWeight.w400,
                fontSize: TextStyleConfig.bodyText14),
          ),
          Obx(() => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: CustomTextfieldWidget(
                  placeholder: toLabelValue(StringConstants.enter_pass),
                  isSecuretext: loginController.isSecuretext.value,
                  suffixIcon: InkWell(
                      onTap: loginController.passwordToggle,
                      child: SvgPicture.asset(
                        loginController.isSecuretext.value
                            ? ImageConstants.icon_eye_hide
                            : ImageConstants.icon_eye_visible,
                        // ignore: deprecated_member_use
                        color: ColorConstants().grey,
                        height: 20,
                        width: 20,
                        fit: BoxFit.scaleDown,
                      )),
                  controller: loginController.passwordController,
                  formkey: loginController.formpasswordKey,
                  inputformater: [
                    NoLeadingSpaceFormatter(),
                    FilteringTextInputFormatter.deny(RegExp('  ')),
                  ],
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Obx(() => SizedBox(
                        width: 25,
                        child: CustomCheckBox(
                          value: loginController.isRemember.value,
                          onChanged: (value) {
                            loginController.isRemember.value = value;
                          },
                        ),
                      )),
                  CustomText(
                    text: toLabelValue(StringConstants.remember_me),
                    style: TextStyleConfig.regularTextStyle(
                        color: ColorConstants().black,
                        fontWeight: FontWeight.w400,
                        fontSize: TextStyleConfig.bodyText14),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.forgotpass);
                },
                child: CustomText(
                  text: toLabelValue(StringConstants.forgot_pass),
                  style: TextStyleConfig.boldTextStyle(
                      color: ColorConstants().black,
                      fontWeight: FontWeight.w700,
                      fontSize: TextStyleConfig.bodyText14),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: PrimaryButton(
              btnTitle: StringConstants.login,
              onClicked: () {
                loginController.validation();
              },
            ),
          ),
        ],
      ),
    );
  }
}
