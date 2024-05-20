import 'dart:async';
import 'dart:io';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/setupprofile/controller_setup_profile.dart';
import 'package:dating_app/src/widgets/card_swipe/widgets/widget_customdropdown.dart';
import 'package:dating_app/src/widgets/custom_chip.dart';
import 'package:dating_app/src/widgets/custom_searchBar.dart';
import 'package:dating_app/src/widgets/widget.card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class ScreenSetupProfile extends StatelessWidget {
  ScreenSetupProfile({super.key});

  final setupProfileController = Get.find<ControllerSetUpProfile>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (setupProfileController.selectedStepIndex.value >= 2) {
          setupProfileController.selectedStepIndex -= 1;
          setupProfileController.steps[setupProfileController.selectedStepIndex.value].isSelected = false;

          setupProfileController.update();

          return false;
        } else {
          return true;
        }
      },
      child: BaseController(
          widgetsScaffold: Scaffold(
              backgroundColor: ColorConstants().white,
              resizeToAvoidBottomInset: false,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(58.0),
                child: Obx(() => CustomAppBar(
                      title: toLabelValue(StringConstants.setup_profile),
                      textstyle: TextStyleConfig.regularTextStyle(
                          fontSize: TextStyleConfig.bodyText16, fontWeight: FontWeight.w600),
                      isBackVisible: setupProfileController.selectedStepIndex.value != 1 ? true : false,
                      onBack: () {
                        if (setupProfileController.selectedStepIndex.value >= 2) {
                          setupProfileController.selectedStepIndex -= 1;
                          setupProfileController.steps[setupProfileController.selectedStepIndex.value].isSelected =
                              false;

                          setupProfileController.update();
                        } else {
                          Get.back();
                        }
                      },
                    )),
              ),
              bottomNavigationBar: SafeArea(child: bottomView()),
              body: GetBuilder<ControllerSetUpProfile>(
                builder: (controller) {
                  return controller.getSetupProfile != null
                      ? SafeArea(
                          child: ListView(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            children: isUserSubscribe == true
                                ? [
                                    setupProfileController.selectedStepIndex.value == 1
                                        ? genderSelectionView()
                                        : setupProfileController.selectedStepIndex.value == 2
                                            ? profileHeadline()
                                            : setupProfileController.selectedStepIndex.value == 3
                                                ? aboutYourself()
                                                : setupProfileController.selectedStepIndex.value == 4
                                                    ? physicalInfoView(context)
                                                    : setupProfileController.selectedStepIndex.value == 5
                                                        ? hobbiesView()
                                                        : setupProfileController.selectedStepIndex.value == 6
                                                            ? otherInfoView()
                                                            : setupProfileController.selectedStepIndex.value == 7
                                                                ? mapView()
                                                                : setupProfileController.selectedStepIndex.value == 8
                                                                    ? uploadPhotoView()
                                                                    : informationView()
                                    //mapView(),
                                  ]
                                : [
                                    setupProfileController.selectedStepIndex.value == 1
                                        ? genderSelectionView()
                                        : setupProfileController.selectedStepIndex.value == 2
                                            ? profileHeadline()
                                            : setupProfileController.selectedStepIndex.value == 3
                                                ? aboutYourself()
                                                : setupProfileController.selectedStepIndex.value == 4
                                                    ? physicalInfoView(context)
                                                    : setupProfileController.selectedStepIndex.value == 5
                                                        ? hobbiesView()
                                                        : setupProfileController.selectedStepIndex.value == 6
                                                            ? otherInfoView()
                                                            : mapView()
                                    //mapView(),
                                  ],
                          ),
                        )
                      : const SizedBox();
                },
              ))),
    );
  }

  Widget bottomView() {
    return Obx(
      () {
        return SizedBox(
          height: Get.height * 0.16,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              CustomText(
                text: "${setupProfileController.selectedStepIndex.value} of ${setupProfileController.steps.length}",
                textAlign: TextAlign.center,
                style: TextStyleConfig.regularTextStyle(
                    fontSize: TextStyleConfig.bodyText12, color: ColorConstants().grey1),
              ),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: SizedBox(
                  height: 3,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: setupProfileController.steps.length,
                    itemBuilder: (context, index) {
                      SelectedStep step = setupProfileController.steps[index];
                      return Container(
                        width: 16,
                        height: 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(index == 0 ? 2.0 : 0.0),
                              bottomLeft: Radius.circular(index == 0 ? 2.0 : 0.0),
                              topRight: Radius.circular((index == (isUserSubscribe == true ? 8 : 6) ||
                                      (index == (setupProfileController.selectedStepIndex.value - 1)))
                                  ? 2.0
                                  : 0.0),
                              bottomRight: Radius.circular((index == (isUserSubscribe == true ? 8 : 6) ||
                                      (index == (setupProfileController.selectedStepIndex.value - 1)))
                                  ? 2.0
                                  : 0.0)),
                          color: step.isSelected == true
                              ? ColorConstants().primaryGradient
                              : ColorConstants().steppercolor,
                        ),
                      );
                    },
                  ),
                ),
              ),
              setupProfileController.selectedStepIndex.value == (isUserSubscribe == true ? 9 : 7)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      child: PrimaryButton(
                        btnWidth: Get.width * 0.44,
                        btnTitle: StringConstants.done,
                        onClicked: () {
                          if (setupProfileController.selectedStepIndex.value == 7) {
                            setupProfileController.updateSetUpProfileAPI("0");
                          } else {
                            String isIncomeValidate = Validator.blankValidation(
                                setupProfileController.incomeController.value.text, StringConstants.income);
                            String isNetWorthValidate = Validator.blankValidation(
                                setupProfileController.netWorthController.value.text, StringConstants.net_worth);
                            if (isIncomeValidate != "") {
                              showSnackBar(Get.overlayContext, isIncomeValidate);
                            } else if (isNetWorthValidate != "") {
                              showSnackBar(Get.overlayContext, isNetWorthValidate);
                            } else if (setupProfileController.selectedSetupData!.selectedCarYouOwnID == null) {
                              showSnackBar(Get.overlayContext,
                                  "${toLabelValue(StringConstants.please_select)} ${toLabelValue(StringConstants.option)}");
                            } else if (setupProfileController.selectedSetupData!.selectedDatingTypeID == null) {
                              showSnackBar(Get.overlayContext,
                                  "${toLabelValue(StringConstants.please_select)} ${toLabelValue(StringConstants.option)}");
                            } else {
                              setupProfileController.updateSetUpProfileAPI("1");
                            }
                          }
                        },
                      ),
                    )
                  : setupProfileController.selectedStepIndex.value == 1
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                          child: PrimaryButton(
                            btnWidth: Get.width,
                            btnTitle: StringConstants.next,
                            onClicked: () {
                              setupProfileController.validateSetupProfile();
                            },
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PlanButton(
                                btnWidth: Get.width * 0.44,
                                btnTitle: StringConstants.prev,
                                onClicked: () {
                                  if (setupProfileController.selectedStepIndex > 1) {
                                    setupProfileController.mapController = Completer();
                                    showLoader();
                                    Future.delayed(
                                      const Duration(seconds: 1),
                                      () {
                                        setupProfileController.selectedStepIndex -= 1;
                                        setupProfileController
                                            .steps[setupProfileController.selectedStepIndex.value].isSelected = false;

                                        setupProfileController.update();
                                        hideLoader();
                                      },
                                    );
                                  }
                                },
                              ),
                              PrimaryButton(
                                btnWidth: Get.width * 0.44,
                                btnTitle: StringConstants.next,
                                onClicked: () {
                                  //Blank Validation Check

                                  setupProfileController.validateSetupProfile();
                                },
                              ),
                            ],
                          ),
                        ),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        );
      },
    );
  }

  Widget genderSelectionView() {
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: toLabelValue(StringConstants.what_your_gender),
              textAlign: TextAlign.center,
              style: TextStyleConfig.boldTextStyle(
                  fontSize: TextStyleConfig.bodyText20, fontWeight: FontWeight.w700, color: ColorConstants().black),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: MultiSelectChip(
                isMultiSelection: false,
                selectedChoices: [setupProfileController.selectedGender],
                setupProfileController.getSetupProfile!.gender!,
                onSelectionChanged: (selectedList) {
                  setupProfileController.update();
                  setupProfileController.selectedGender.value = selectedList.first;
                  setupProfileController.selectedSetupData!.selectedGenderID = selectedList.first.id;
                },
              ),
            ),
            const SizedBox(height: 16),
            CustomText(
              text: toLabelValue(StringConstants.interested_in),
              textAlign: TextAlign.center,
              style: TextStyleConfig.boldTextStyle(
                  fontSize: TextStyleConfig.bodyText20, fontWeight: FontWeight.w700, color: ColorConstants().black),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: MultiSelectChip(
                isMultiSelection: false,
                selectedChoices: [setupProfileController.selectedInterestedGender],
                setupProfileController.getSetupProfile!.gender!,
                onSelectionChanged: (selectedList) {
                  setupProfileController.update();
                  setupProfileController.selectedInterestedGender.value = selectedList.first;
                  setupProfileController.selectedSetupData!.selectedInterestedInID = selectedList.first.id;
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget profileHeadline() {
    return GetBuilder<ControllerSetUpProfile>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: toLabelValue(StringConstants.whats_profile_headline),
                textAlign: TextAlign.center,
                style: TextStyleConfig.boldTextStyle(
                    fontSize: TextStyleConfig.bodyText20, fontWeight: FontWeight.w700, color: ColorConstants().black),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 150,
                child: CustomTextfieldWidget(
                  controller: controller.profileDescController.value,
                  formkey: controller.formProfileDescKey,
                  placeholder: toLabelValue(StringConstants.penter_profile_headline),
                  maxLines: 10,
                  inputformater: [LengthLimitingTextInputFormatter(50), NoLeadingSpaceFormatter()],
                  contentPadding: const EdgeInsets.only(left: 4, bottom: 4, top: 24, right: 4),
                  borderColor: ColorConstants().grey1,
                  borderRadius: 16,
                  onchanged: (value) {
                    controller.update();
                    controller.selectedSetupData!.profileHeadline = controller.profileDescController.value.text;
                  },
                ),
              ),
              SizedBox(
                width: Get.width,
                child: Obx(() {
                  return CustomText(
                    text: "${controller.profileDescController.value.text.characters.length}/50",
                    textAlign: TextAlign.right,
                    style: TextStyleConfig.regularTextStyle(
                        fontSize: TextStyleConfig.bodyText14, color: ColorConstants().grey1),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget aboutYourself() {
    return GetBuilder<ControllerSetUpProfile>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: toLabelValue(StringConstants.abou_myself),
                textAlign: TextAlign.center,
                style: TextStyleConfig.boldTextStyle(
                    fontSize: TextStyleConfig.bodyText20, fontWeight: FontWeight.w700, color: ColorConstants().black),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CustomText(
                  text: toLabelValue(StringConstants.about_myself_desc),
                  textAlign: TextAlign.left,
                  style: TextStyleConfig.regularTextStyle(
                      fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
                ),
              ),
              SizedBox(
                height: 200,
                child: CustomTextfieldWidget(
                  controller: controller.writeAboutDescController.value,
                  formkey: controller.formWriteAboutDescKey,
                  placeholder: toLabelValue(StringConstants.write_about_yourself),
                  maxLines: 10,
                  contentPadding: const EdgeInsets.only(left: 4, bottom: 4, top: 24, right: 4),
                  borderColor: ColorConstants().grey1,
                  borderRadius: 16,
                  inputformater: [LengthLimitingTextInputFormatter(250), NoLeadingSpaceFormatter()],
                  onchanged: (value) {
                    controller.update();
                    controller.selectedSetupData!.aboutYourself = controller.writeAboutDescController.value.text;
                  },
                ),
              ),
              SizedBox(
                width: Get.width,
                child: CustomText(
                  text: "${controller.writeAboutDescController.value.text.characters.length}/250",
                  textAlign: TextAlign.right,
                  style: TextStyleConfig.regularTextStyle(
                      fontSize: TextStyleConfig.bodyText14, color: ColorConstants().grey1),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget physicalInfoView(context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: toLabelValue(StringConstants.physical_info),
            textAlign: TextAlign.center,
            style: TextStyleConfig.boldTextStyle(
                fontSize: TextStyleConfig.bodyText20, fontWeight: FontWeight.w700, color: ColorConstants().black),
          ),
          const SizedBox(
            height: 16,
          ),
          CustomText(
            text: toLabelValue(StringConstants.height),
            textAlign: TextAlign.center,
            style:
                TextStyleConfig.regularTextStyle(fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  child: CustomTextfieldWidget(
                    controller: setupProfileController.heightController.value,
                    onFieldSubmitted: (p0) {
                      FocusScope.of(context).nextFocus();
                    },
                    formkey: setupProfileController.formHeightKey,
                    placeholder: toLabelValue(StringConstants.enter_height),
                    maxLines: 1,
                    keyboardType: const TextInputType.numberWithOptions(signed: true),
                    inputformater: [
                      NoLeadingSpaceFormatter(),
                      LengthLimitingTextInputFormatter(6),
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                      FilteringTextInputFormatter.allow(RegExp('[0-9./]')),
                    ],
                    onchanged: (value) {
                      setupProfileController.selectedSetupData!.height =
                          setupProfileController.heightController.value.text;
                    },
                  ),
                ),
              ),
              Obx(() => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Stack(
                      children: [
                        Container(
                          height: 49,
                          width: 95,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                              border: Border.all(color: ColorConstants().lightgrey)),
                        ),
                        setupProfileController.isHeightInCM.value
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
                                        setupProfileController.isHeightInCM(false);
                                        setupProfileController.update();

                                        setupProfileController.selectedSetupData!.selectedHeightMeasurement =
                                            1.toString();
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
                                        setupProfileController.isHeightInCM(true);

                                        setupProfileController.selectedSetupData!.selectedHeightMeasurement =
                                            0.toString();
                                        setupProfileController.update();
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
                    ),
                  )),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          CustomText(
            text: toLabelValue(StringConstants.weight),
            textAlign: TextAlign.center,
            style:
                TextStyleConfig.regularTextStyle(fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  child: CustomTextfieldWidget(
                    controller: setupProfileController.weightController.value,
                    formkey: setupProfileController.formWeightKey,
                    placeholder: toLabelValue(StringConstants.enter_weight),
                    textInputAction: TextInputAction.done,
                    maxLines: 10,
                    contentPadding: const EdgeInsets.only(left: 4, bottom: 4, top: 24, right: 4),
                    keyboardType: const TextInputType.numberWithOptions(signed: true),
                    inputformater: [
                      NoLeadingSpaceFormatter(),
                      LengthLimitingTextInputFormatter(5),
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                      FilteringTextInputFormatter.allow(RegExp('[0-9./]')),
                    ],
                    onchanged: (value) {
                      setupProfileController.selectedSetupData!.weight = value;
                    },
                  ),
                ),
              ),
              Obx(() => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Stack(
                      children: [
                        Container(
                          height: 49,
                          width: 95,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                              border: Border.all(color: ColorConstants().lightgrey)),
                        ),
                        setupProfileController.isWeightInKG.value
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
                                        setupProfileController.isWeightInKG(false);
                                        setupProfileController.update();

                                        setupProfileController.selectedSetupData!.selectedWeightMeasurement =
                                            0.toString();
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
                                        setupProfileController.isWeightInKG(true);
                                        setupProfileController.update();

                                        setupProfileController.selectedSetupData!.selectedWeightMeasurement =
                                            1.toString();
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
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget hobbiesView() {
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: toLabelValue(StringConstants.your_hobbies),
              textAlign: TextAlign.center,
              style: TextStyleConfig.boldTextStyle(
                  fontSize: TextStyleConfig.bodyText20, fontWeight: FontWeight.w700, color: ColorConstants().black),
            ),
            const SizedBox(
              height: 16,
            ),
            MultiSelectChip(
              setupProfileController.getSetupProfile!.hobbies!,
              selectedChoices: setupProfileController.selectedHobbies.value ?? [],
              isMultiSelection: true,
              onSelectionChanged: (selectedList) {
                setupProfileController.selectedHobbyList = selectedList;
                setupProfileController.update();
                setupProfileController.selectedHobbies.value = selectedList;
                setupProfileController.selectedSetupData!.selectedHobbiesId =
                    List.generate(selectedList.length, (index) => selectedList[index].id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget otherInfoView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: toLabelValue(StringConstants.other_information),
            textAlign: TextAlign.center,
            style: TextStyleConfig.boldTextStyle(
                fontSize: TextStyleConfig.bodyText20, fontWeight: FontWeight.w700, color: ColorConstants().black),
          ),
          const SizedBox(
            height: 18,
          ),
          CustomText(
            text: toLabelValue(StringConstants.occupation),
            textAlign: TextAlign.center,
            style:
                TextStyleConfig.regularTextStyle(fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: CustomDropdownButton2(
                value: setupProfileController.selectedSetupData?.selectedOccupationID,
                onChanged: (value) {
                  var d = setupProfileController.getSetupProfile!.occupation!
                      .where((element) => element.name.toString() == value.toString());
                  debugPrint(d.first.name);
                  setupProfileController.selectedOccupation.value = d.first.id;
                  setupProfileController.selectedSetupData?.selectedOccupationID = d.first.name;

                  setupProfileController.update();
                },
                dropdownItems: setupProfileController.getSetupProfile!.occupation!,
                hint: setupProfileController.selectedSetupData?.selectedOccupationID != null
                    ? setupProfileController.selectedSetupData!.selectedOccupationID!
                    : toLabelValue(StringConstants.select_option),
              )),
          const SizedBox(
            height: 12,
          ),
          CustomText(
            text: toLabelValue(StringConstants.relationship_status),
            textAlign: TextAlign.center,
            style:
                TextStyleConfig.regularTextStyle(fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: CustomDropdownButton2(
                value: setupProfileController.selectedSetupData?.selectedRelationShipID,
                onChanged: (value) {
                  var d = setupProfileController.getSetupProfile!.relationshipStatus!
                      .where((element) => element.name.toString() == value.toString());
                  debugPrint(d.first.name);
                  setupProfileController.selectedRelationshipStatus.value = d.first.id;
                  setupProfileController.selectedSetupData?.selectedRelationShipID = d.first.name;

                  setupProfileController.update();
                },
                dropdownItems: setupProfileController.getSetupProfile!.relationshipStatus!,
                hint: setupProfileController.selectedSetupData?.selectedRelationShipID != null
                    ? setupProfileController.selectedSetupData!.selectedRelationShipID!
                    : toLabelValue(StringConstants.select_option),
              )),
          const SizedBox(
            height: 8,
          ),
          CustomText(
            text: toLabelValue(StringConstants.children),
            textAlign: TextAlign.center,
            style:
                TextStyleConfig.regularTextStyle(fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: MultiSelectChip(
              isMultiSelection: false,
              selectedChoices: [setupProfileController.selectedChildren],
              booleanList,
              onSelectionChanged: (selectedList) {
                setupProfileController.update();
                setupProfileController.selectedChildren.value = selectedList.first;
                setupProfileController.selectedSetupData!.selectedChildrenID = selectedList.first.id;
              },
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          CustomText(
            text: toLabelValue(StringConstants.diet_preference),
            textAlign: TextAlign.center,
            style:
                TextStyleConfig.regularTextStyle(fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: MultiSelectChip(
              isMultiSelection: false,
              selectedChoices: [setupProfileController.selectedDiet],
              setupProfileController.getSetupProfile!.diePreference!.toList(),
              onSelectionChanged: (selectedList) {
                setupProfileController.update();
                setupProfileController.selectedDiet.value = selectedList.first;
                setupProfileController.selectedSetupData!.selectedDietPrefsID = selectedList.first.id;
              },
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          CustomText(
            text: toLabelValue(StringConstants.star_sign),
            textAlign: TextAlign.center,
            style:
                TextStyleConfig.regularTextStyle(fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: CustomDropdownButton2(
              value: setupProfileController.selectedSetupData?.selectedStartSignID,
              onChanged: (value) {
                var d = setupProfileController.getSetupProfile!.starSign!
                    .where((element) => element.name.toString() == value.toString());
                debugPrint(d.first.name);
                setupProfileController.selectedStartSign.value = d.first.id;
                setupProfileController.selectedSetupData?.selectedStartSignID = d.first.name;

                setupProfileController.update();
              },
              dropdownItems: setupProfileController.getSetupProfile!.starSign!,
              hint: setupProfileController.selectedSetupData?.selectedStartSignID != null
                  ? setupProfileController.selectedSetupData!.selectedStartSignID!
                  : toLabelValue(StringConstants.select_option),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          CustomText(
            text: toLabelValue(StringConstants.smoke),
            textAlign: TextAlign.center,
            style:
                TextStyleConfig.regularTextStyle(fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: MultiSelectChip(
              isMultiSelection: false,
              selectedChoices: [setupProfileController.selectedSmock],
              booleanList,
              onSelectionChanged: (selectedList) {
                setupProfileController.update();
                setupProfileController.selectedSmock.value = selectedList.first;
                setupProfileController.selectedSetupData!.selectedSmokeID = selectedList.first.id;
              },
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          CustomText(
            text: toLabelValue(StringConstants.drink),
            textAlign: TextAlign.center,
            style:
                TextStyleConfig.regularTextStyle(fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: MultiSelectChip(
              isMultiSelection: false,
              selectedChoices: [setupProfileController.selectedDrink],
              booleanList,
              onSelectionChanged: (selectedList) {
                setupProfileController.update();
                setupProfileController.selectedDrink.value = selectedList.first;
                setupProfileController.selectedSetupData!.selectedDrinkID = selectedList.first.id;
              },
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          CustomText(
            text: toLabelValue(StringConstants.exercise),
            textAlign: TextAlign.center,
            style:
                TextStyleConfig.regularTextStyle(fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: MultiSelectChip(
              isMultiSelection: false,
              selectedChoices: [setupProfileController.selectedExercise],
              booleanList,
              onSelectionChanged: (selectedList) {
                setupProfileController.update();
                setupProfileController.selectedExercise.value = selectedList.first;
                setupProfileController.selectedSetupData!.selectedExerciseID = selectedList.first.id;
              },
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          CustomText(
            text: toLabelValue(StringConstants.personality_type),
            textAlign: TextAlign.center,
            style:
                TextStyleConfig.regularTextStyle(fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: CustomDropdownButton2(
                value: setupProfileController.selectedSetupData?.selectedPersonalityTypeID,
                onChanged: (value) {
                  var d = setupProfileController.getSetupProfile!.personalityType!
                      .where((element) => element.name.toString() == value.toString());
                  debugPrint(d.first.name);
                  setupProfileController.selectedPersonalityType.value = d.first.id;
                  setupProfileController.selectedSetupData?.selectedPersonalityTypeID = d.first.name;

                  setupProfileController.update();
                },
                dropdownItems: setupProfileController.getSetupProfile!.personalityType!,
                hint: setupProfileController.selectedSetupData?.selectedPersonalityTypeID != null
                    ? setupProfileController.selectedSetupData!.selectedPersonalityTypeID!
                    : toLabelValue(StringConstants.select_option),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          CustomText(
            text: toLabelValue(StringConstants.body_type),
            textAlign: TextAlign.center,
            style:
                TextStyleConfig.regularTextStyle(fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: CustomDropdownButton2(
              value: setupProfileController.selectedSetupData?.selectedBodyTypeID,
              onChanged: (value) {
                var d = setupProfileController.getSetupProfile!.bodyType!
                    .where((element) => element.name.toString() == value.toString());
                debugPrint(d.first.name);
                setupProfileController.selectedBodyType.value = d.first.id;
                setupProfileController.selectedSetupData?.selectedBodyTypeID = d.first.name;

                setupProfileController.update();
              },
              dropdownItems: setupProfileController.getSetupProfile!.bodyType!,
              hint: setupProfileController.selectedSetupData?.selectedBodyTypeID != null
                  ? setupProfileController.selectedSetupData!.selectedBodyTypeID!
                  : toLabelValue(StringConstants.select_option),
            ),
          ),
        ],
      ),
    );
  }

  Widget mapView() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: InkWell(
              onTap: () async {
                var place = await PlacesAutocomplete.show(
                    context: Get.overlayContext!,
                    apiKey: googleAPIKey,
                    mode: Mode.overlay,
                    types: [],
                    strictbounds: false,
                    components: [Component(Component.country, 'au'), Component(Component.country, 'in')],
                    //google_map_webservice package
                    onError: (err) {
                      debugPrint("$err");
                    });
                if (place != null) {
                  setupProfileController.currentAddress = place.description.toString();

                  //form google_maps_webservice package
                  final plist = GoogleMapsPlaces(
                    apiKey: googleAPIKey,
                  );
                  String placeId = place.placeId ?? "0";
                  final detail = await plist.getDetailsByPlaceId(placeId);
                  final geometry = detail.result.geometry!;
                  final lat = geometry.location.lat;
                  final lang = geometry.location.lng;
                  var newLatLang = LatLng(lat, lang);

                  //move map camera to selected place with animation
                  setupProfileController.center = newLatLang;

                  setupProfileController.markers = [];

                  setupProfileController.handleTap(newLatLang);

                  try {
                    final GoogleMapController controller = await setupProfileController.mapController.future;

                    if (kDebugMode) {
                      print("=======> ${controller}");
                    }
                    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                      target: newLatLang,
                      zoom: 16,
                      tilt: 50.0,
                      bearing: 45.0,
                    )));
                  } catch (e) {
                    if (kDebugMode) {
                      print("==err ====> ${e}");
                    }
                  }

                  setupProfileController.update();
                }
              },
              child: CustomSearchBar(
                isEnable: false,
                controller: setupProfileController.searchController.value,
                hintText: toLabelValue(StringConstants.search_for_your_location),
                onRemoveValue: () {
                  setupProfileController.searchController.value.clear();
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: CustomText(
              text: toLabelValue(StringConstants.you_can_drp_pin),
              textAlign: TextAlign.center,
              style: TextStyleConfig.boldTextStyle(
                  fontSize: TextStyleConfig.bodyText20, fontWeight: FontWeight.w700, color: ColorConstants().black),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: toLabelValue(StringConstants.current_location),
                      textAlign: TextAlign.center,
                      style: TextStyleConfig.regularTextStyle(
                          fontSize: TextStyleConfig.bodyText14,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants().grey1),
                    ),
                    InkWell(
                      onTap: () async {
                        setupProfileController.update();
                        setupProfileController.selectedSetupData!.selectedAddress =
                            setupProfileController.currentAddress;

                        setupProfileController.validateSetupProfile();
                      },
                      child: CustomText(
                        text: toLabelValue(StringConstants.use_this),
                        textAlign: TextAlign.center,
                        style: TextStyleConfig.boldTextStyle(
                            fontSize: TextStyleConfig.bodyText14,
                            fontWeight: FontWeight.w700,
                            color: ColorConstants().primaryGradient),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              setupProfileController.currentAddress != ""
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: SvgPicture.asset(
                              ImageConstants.icon_map_pin,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            width: Get.width * 0.71,
                            child: CustomText(
                              text: setupProfileController.currentAddress != ""
                                  ? setupProfileController.currentAddress
                                  : "",
                              maxlines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyleConfig.boldTextStyle(
                                  fontSize: TextStyleConfig.bodyText16,
                                  fontWeight: FontWeight.w700,
                                  color: ColorConstants().primaryGradient),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 12,
              ),
              setupProfileController.currentAddress != ""
                  ? Container(
                      height: Get.height * 0.49,
                      child: GoogleMap(
                          onMapCreated: setupProfileController.onMapCreated,
                          zoomGesturesEnabled: true,
                          zoomControlsEnabled: true,
                          gestureRecognizers: Set()
                            ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                            ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
                            ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer())),
                          initialCameraPosition: CameraPosition(
                            target: setupProfileController.center!,
                            zoom: 17.0,
                          ),
                          onCameraMove: ((newPosition) {
                            debugPrint("${newPosition.target.latitude}");
                            debugPrint("${newPosition.target.longitude}");
                          }),
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          onTap: setupProfileController.handleTap,
                          markers: setupProfileController.markers.toSet()),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ColorConstants().primaryGradient,
                        ),
                      ),
                    )
            ],
          ),
        ],
      );
    });
  }

  Widget informationView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "${toLabelValue(StringConstants.income)} (In USD only)",
            textAlign: TextAlign.center,
            style: TextStyleConfig.regularTextStyle(
                fontSize: TextStyleConfig.bodyText14, fontWeight: FontWeight.w400, color: ColorConstants().black),
          ),
          const SizedBox(
            height: 8,
          ),
          CustomTextfieldWidget(
            controller: setupProfileController.incomeController.value,
            placeholder: toLabelValue(StringConstants.enter_income),
            keyboardType: TextInputType.number,
            inputformater: [
              NoLeadingSpaceFormatter(),
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
            ],
            onchanged: (value) {
              setupProfileController.selectedSetupData!.income = value;
            },
          ),
          const SizedBox(
            height: 16,
          ),
          CustomText(
            text: toLabelValue(StringConstants.net_worth),
            textAlign: TextAlign.center,
            style: TextStyleConfig.regularTextStyle(
                fontSize: TextStyleConfig.bodyText14, fontWeight: FontWeight.w400, color: ColorConstants().black),
          ),
          const SizedBox(
            height: 6,
          ),
          CustomTextfieldWidget(
            controller: setupProfileController.netWorthController.value,
            keyboardType: TextInputType.number,
            inputformater: [
              LengthLimitingTextInputFormatter(10),
              NoLeadingSpaceFormatter(),
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
            ],
            placeholder: toLabelValue(StringConstants.enter_net_worth),
            onchanged: (value) {
              setupProfileController.selectedSetupData!.netWorth = value;
            },
          ),
          const SizedBox(
            height: 16,
          ),
          CustomText(
            text: toLabelValue(StringConstants.car_you_own),
            textAlign: TextAlign.center,
            style:
                TextStyleConfig.regularTextStyle(fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: MultiSelectChip(
              isMultiSelection: false,
              selectedChoices: [setupProfileController.selectedCarOwn],
              booleanList,
              onSelectionChanged: (selectedList) {
                setupProfileController.update();
                setupProfileController.selectedCarOwn.value = selectedList.first;
                setupProfileController.selectedSetupData!.selectedCarYouOwnID = selectedList.first.id;
              },
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          CustomText(
            text: toLabelValue(StringConstants.dating_type),
            textAlign: TextAlign.center,
            style:
                TextStyleConfig.regularTextStyle(fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: CustomDropdownButton2(
                value: setupProfileController.selectedSetupData?.selectedDatingTypeID,
                onChanged: (value) {
                  var d = setupProfileController.getSetupProfile!.datingType!
                      .where((element) => element.name.toString() == value.toString());
                  debugPrint(d.first.name);

                  setupProfileController.selectedDatingType.value = d.first.id;
                  setupProfileController.selectedSetupData?.selectedDatingTypeID = d.first.name;

                  setupProfileController.update();
                },
                dropdownItems: setupProfileController.getSetupProfile!.datingType!,
                hint: setupProfileController.selectedSetupData?.selectedDatingTypeID != null
                    ? setupProfileController.selectedSetupData!.selectedDatingTypeID!
                    : toLabelValue(StringConstants.select_option),
              )),
        ],
      ),
    );
  }

  uploadPhotoView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: toLabelValue(StringConstants.upload_your_photos),
            style: TextStyleConfig.boldTextStyle(
                fontSize: TextStyleConfig.bodyText20, fontWeight: FontWeight.w700, color: ColorConstants().black),
          ),
          const SizedBox(
            height: 24,
          ),
          StaggeredGrid.count(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: List.generate(
                uploadImageCount ?? 6,
                (index) {
                  return index == 0
                      ? StaggeredGridTile.count(
                          crossAxisCellCount: 2, mainAxisCellCount: 2, child: InkWell(child: photoView(index)))
                      : StaggeredGridTile.count(crossAxisCellCount: 1, mainAxisCellCount: 1, child: photoView(index));
                },
              )),
          const SizedBox(
            height: 24,
          ),
          CustomText(
            text: toLabelValue(StringConstants.photos_note),
            style: TextStyleConfig.boldTextStyle(
                fontSize: TextStyleConfig.bodyText12, fontWeight: FontWeight.w400, color: ColorConstants().grey),
          ),
        ],
      ),
    );
  }

  Widget photoView(int index) {
    return (setupProfileController.pickedImageList[index].path != "")
        ? Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.file(
                  File(setupProfileController.pickedImageList[index].path),
                  height: 500,
                  width: 500,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              Positioned(
                right: 0,
                child: InkWell(
                  onTap: () {
                    setupProfileController.pickedImageList[index] = File("");

                    setupProfileController.update();
                    setupProfileController.selectedSetupData!.selectedImages!.removeAt(index);
                  },
                  child: SvgPicture.asset(
                    ImageConstants.icon_close,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ],
          )
        : InkWell(
            onTap: () async {
              List<File> pickedImage = await showImageSelectionBottomSheet();
              setupProfileController.pickedImageList[index] = pickedImage.first;

              setupProfileController.update();
              if (setupProfileController.selectedSetupData!.selectedImages == null) {
                setupProfileController.selectedSetupData!.selectedImages = [pickedImage.first.path];
              } else {
                setupProfileController.selectedSetupData!.selectedImages!.add(pickedImage.first.path);
              }
            },
            child: CustomCard(
              isGradientCard: false,
              borderradius: 12,
              bordercolor: Colors.transparent,
              shadowColor: Colors.transparent,
              backgroundColor: ColorConstants().steppercolor,
              child: SvgPicture.asset(
                ImageConstants.icon_add,
                fit: BoxFit.scaleDown,
              ),
            ),
          );
  }
}
