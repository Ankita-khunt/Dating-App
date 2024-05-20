import 'package:dating_app/src/screen/dashboard/my_profile/cms/contact_us/controller_contact_us.dart';
import 'package:dating_app/src/widgets/widget.card.dart';

import '../../../../../../imports.dart';

class ScreenContactUs extends StatelessWidget {
  ScreenContactUs({Key? key}) : super(key: key);

  final contactUsController = Get.find<ControllerConcatUs>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
        widgetsScaffold: SafeArea(
            bottom: false,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: Container(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: Get.height,
                        child: Column(
                          children: [
                            SizedBox(
                              height: Get.height * .34,
                              child: topWidget(),
                            ),
                            Expanded(
                                child: Container(
                              color: Colors.white,
                            )),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        top: Get.height * .15,
                        child: contactFieldsCard(context),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget contactFieldsCard(BuildContext context) {
    return CustomCard(
      isGradientCard: false,
      bordercolor: Colors.transparent,
      borderradius: 24,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: CustomText(
                text: toLabelValue(StringConstants.get_in_touch),
                overflow: TextOverflow.ellipsis,
                style: TextStyleConfig.regularTextStyle(
                  color: ColorConstants().black,
                  fontWeight: FontWeight.w700,
                  fontSize: TextStyleConfig.bodyText20,
                ),
              ),
            ),
            SizedBox(height: Get.height * .04),
            CustomText(
              text: toLabelValue(StringConstants.name),
              style: TextStyleConfig.regularTextStyle(
                  color: ColorConstants().black, fontWeight: FontWeight.w400, fontSize: TextStyleConfig.bodyText14),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: CustomTextfieldWidget(
                placeholder: toLabelValue(StringConstants.enter_name),
                controller: contactUsController.nameController,
                formkey: contactUsController.formNameKey,
                keyboardType: TextInputType.name,
                borderColor: ColorConstants().lightgrey,
                inputformater: [
                  NoLeadingSpaceFormatter(),
                  LengthLimitingTextInputFormatter(30),
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z_0-9 ]'))
                ],
                textInputAction: TextInputAction.next,
              ),
            ),
            SizedBox(height: Get.height * .014),
            CustomText(
              text: toLabelValue(StringConstants.email_address),
              style: TextStyleConfig.regularTextStyle(
                  color: ColorConstants().black, fontWeight: FontWeight.w400, fontSize: TextStyleConfig.bodyText14),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: CustomTextfieldWidget(
                placeholder: toLabelValue(StringConstants.enter_email_address),
                controller: contactUsController.emailController,
                formkey: contactUsController.formEmailKey,
                keyboardType: TextInputType.emailAddress,
                borderColor: ColorConstants().lightgrey,
                inputformater: [
                  NoLeadingSpaceFormatter(),
                  LengthLimitingTextInputFormatter(30),
                  FilteringTextInputFormatter.deny(RegExp('  ')),
                ],
                textInputAction: TextInputAction.next,
              ),
            ),
            SizedBox(height: Get.height * .014),
            CustomText(
              text: toLabelValue(StringConstants.message),
              style: TextStyleConfig.regularTextStyle(
                  color: ColorConstants().black, fontWeight: FontWeight.w400, fontSize: TextStyleConfig.bodyText14),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SizedBox(
                height: Get.height * .14,
                child: CustomTextfieldWidget(
                  controller: contactUsController.messageController,
                  formkey: contactUsController.formMessageKey,
                  placeholder: toLabelValue(StringConstants.enter_message),
                  maxLines: 10,
                  inputformater: [NoLeadingSpaceFormatter()],
                  contentPadding: const EdgeInsets.only(left: 4, bottom: 4, top: 24, right: 4),
                  borderRadius: 20,
                  borderColor: ColorConstants().lightgrey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 8),
              child: PrimaryButton(
                btnTitle: StringConstants.send,
                onClicked: () {
                  contactUsController.validation();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container topWidget() {
    return Container(
      height: Get.height * .38,
      width: Get.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorConstants().primaryGradient, ColorConstants().secondaryGradient],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0, 1],
        ),
      ),
      child: SizedBox(
          height: Get.height * .06,
          child: CustomAppBar(
            title: toLabelValue(StringConstants.contact_us),
            titleColor: ColorConstants().white,
            backIconColor: ColorConstants().white,
            isBackVisible: true,
          )),
    );
  }
}
