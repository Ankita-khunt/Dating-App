import 'package:dating_app/imports.dart';

import 'controller_edit_profile.dart';

class ScreenPhysicalInformation extends StatelessWidget {
  ScreenPhysicalInformation({super.key});

  final editProfileController = Get.find<ControllerEditProfile>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: SvgPicture.asset(ImageConstants.icon_back,
              color: ColorConstants().black, height: 13, width: 8, fit: BoxFit.scaleDown),
        ),
        centerTitle: false,
        titleSpacing: 0,
        title: CustomText(
          text: toLabelValue(StringConstants.physical_info),
          textAlign: TextAlign.center,
          style: TextStyleConfig.regularTextStyle(
            color: ColorConstants().black,
            fontWeight: FontWeight.w600,
            fontSize: TextStyleConfig.bodyText16,
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              CustomText(
                text: toLabelValue(StringConstants.height),
                textAlign: TextAlign.center,
                style: TextStyleConfig.regularTextStyle(
                    fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: Get.width * 0.65,
                    child: CustomTextfieldWidget(
                      controller: editProfileController.heightController.value,
                      formkey: editProfileController.formpheightKey,
                      placeholder: toLabelValue(StringConstants.enter_height),
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      onchanged: (value) {
                        editProfileController.selectedHeight.value = value;
                      },
                      inputformater: [LengthLimitingTextInputFormatter(250), NoLeadingSpaceFormatter()],
                    ),
                  ),
                  Obx(() => Stack(
                        children: [
                          Container(
                            height: 49,
                            width: 95,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                border: Border.all(color: ColorConstants().lightgrey)),
                          ),
                          editProfileController.isHeightinCM.value
                              ? Positioned(
                                  left: 0,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 49,
                                        width: 49,
                                        decoration: BoxDecoration(
                                            color: ColorConstants().primaryLight,
                                            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                            border: Border.all(color: ColorConstants().primaryGradient)),
                                        child: Center(
                                          child: CustomText(
                                            text: toLabelValue(StringConstants.cm),
                                            style: TextStyleConfig.regularTextStyle(
                                                fontSize: TextStyleConfig.bodyText12,
                                                fontWeight: FontWeight.w500,
                                                color: ColorConstants().primaryGradient),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          editProfileController.isHeightinCM(false);
                                          editProfileController.update();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: CustomText(
                                              text: toLabelValue(StringConstants.inches),
                                              style: TextStyleConfig.regularTextStyle(
                                                  fontSize: TextStyleConfig.bodyText12, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                              : Positioned(
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          editProfileController.isHeightinCM(true);
                                          editProfileController.update();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: CustomText(
                                              text: toLabelValue(StringConstants.cm),
                                              style: TextStyleConfig.regularTextStyle(
                                                  fontSize: TextStyleConfig.bodyText12, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 49,
                                        width: 49,
                                        decoration: BoxDecoration(
                                            color: ColorConstants().primaryLight,
                                            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                            border: Border.all(color: ColorConstants().primaryGradient)),
                                        child: Center(
                                          child: CustomText(
                                            text: toLabelValue(StringConstants.inches),
                                            style: TextStyleConfig.regularTextStyle(
                                                fontSize: TextStyleConfig.bodyText12,
                                                fontWeight: FontWeight.w500,
                                                color: ColorConstants().primaryGradient),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                        ],
                      )),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              CustomText(
                text: toLabelValue(StringConstants.weight),
                textAlign: TextAlign.center,
                style: TextStyleConfig.regularTextStyle(
                    fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: Get.width * 0.65,
                    child: CustomTextfieldWidget(
                      controller: editProfileController.weightController.value,
                      formkey: editProfileController.formweightKey,
                      placeholder: toLabelValue(StringConstants.enter_weight),
                      maxLines: 10,
                      keyboardType: TextInputType.number,
                      onchanged: (value) {
                        editProfileController.selectedWeight.value = value;
                      },
                      contentPadding: const EdgeInsets.only(left: 4, bottom: 4, top: 24, right: 4),
                      inputformater: [LengthLimitingTextInputFormatter(250), NoLeadingSpaceFormatter()],
                    ),
                  ),
                  Obx(() => Stack(
                        children: [
                          Container(
                            height: 49,
                            width: 95,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                border: Border.all(color: ColorConstants().lightgrey)),
                          ),
                          editProfileController.isWeightinKG.value
                              ? Positioned(
                                  left: 0,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 49,
                                        width: 49,
                                        decoration: BoxDecoration(
                                            color: ColorConstants().primaryLight,
                                            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                            border: Border.all(color: ColorConstants().primaryGradient)),
                                        child: Center(
                                          child: CustomText(
                                            text: toLabelValue(StringConstants.kg),
                                            style: TextStyleConfig.regularTextStyle(
                                                fontSize: TextStyleConfig.bodyText12,
                                                fontWeight: FontWeight.w500,
                                                color: ColorConstants().primaryGradient),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          editProfileController.isWeightinKG(false);
                                          editProfileController.update();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: CustomText(
                                              text: toLabelValue(StringConstants.lbs),
                                              style: TextStyleConfig.regularTextStyle(
                                                  fontSize: TextStyleConfig.bodyText12, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                              : Positioned(
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          editProfileController.isWeightinKG(true);
                                          editProfileController.update();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: CustomText(
                                              text: toLabelValue(StringConstants.kg),
                                              style: TextStyleConfig.regularTextStyle(
                                                  fontSize: TextStyleConfig.bodyText12, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 49,
                                        width: 49,
                                        decoration: BoxDecoration(
                                            color: ColorConstants().primaryLight,
                                            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                            border: Border.all(color: ColorConstants().primaryGradient)),
                                        child: Center(
                                          child: CustomText(
                                            text: toLabelValue(StringConstants.lbs),
                                            style: TextStyleConfig.regularTextStyle(
                                                fontSize: TextStyleConfig.bodyText12,
                                                fontWeight: FontWeight.w500,
                                                color: ColorConstants().primaryGradient),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                        ],
                      )),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: Get.height * .05),
                child: PrimaryButton(
                  btnTitle: StringConstants.done,
                  onClicked: () {
                    Get.back();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
