import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/controller_card_swipe.dart';
import 'package:dating_app/src/screen/dashboard/home/filter/controller_filter.dart';
import 'package:dating_app/src/widgets/card_swipe/widgets/widget_customdropdown.dart';
import 'package:dating_app/src/widgets/custom_chip.dart';
import 'package:dating_app/src/widgets/widget_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ScreenFilter extends StatelessWidget {
  ScreenFilter({super.key});

  final controller = Get.find<ControllerFilter>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
        widgetsScaffold: Scaffold(
      backgroundColor: ColorConstants().white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(58.0),
        child: CustomAppBar(
          isGradientAppBar: true,
          title: toLabelValue(StringConstants.filter),
          titleColor: ColorConstants().white,
          backIconColor: ColorConstants().white,
          isBackVisible: true,
          firstTrailing: Center(
            child: CustomText(
              text: toLabelValue(StringConstants.clear_all),
              style: TextStyleConfig.boldTextStyle(
                  fontSize: TextStyleConfig.bodyText16, fontWeight: FontWeight.w700, color: ColorConstants().white),
            ),
          ),
          onfirstOnclick: () {
            showLoader();
            controller.ethinicityID = null;

            controller.maritalStatusID = null;

            controller.datingAgeGroupID = null;

            controller.religiousViewID = null;

            controller.politicalLeaningID = null;
            controller.startSignID = null;
            controller.personalityTYpeID = null;
            controller.bodyTypeID = null;
            controller.occupationID = null;
            controller.castID = null;
            controller.selectedHobbyList = [];
            controller.datingTYpeID = null;

            /////
            controller.hobbies = "";
            controller.selectedHobbyList = [];
            controller.arrSelectedHobbyID.value = [];
            controller.arrSelectedHobbyName.value = [];
            controller.heightController.value.text = "";
            controller.weightController.value.text = "";

            controller.locationRange.value = double.parse(controller.getSetupProfile?.maxLocationRange ?? "0");
            controller.maxIncome.value = double.parse(controller.getSetupProfile!.maxIncome.toString());
            controller.maxNetWorth.value = double.parse(controller.getSetupProfile!.maxNetworth.toString());

            controller.getAlreadySetUpData().then((value) {
              controller.selectedFilterOption = SelectedFilter();
              Get.find<ControllerCard>().selectedFilterOption = controller.selectedFilterOption;
              Get.find<ControllerCard>().onInit();
            });
            controller.update();
            Future.delayed(
              const Duration(seconds: 2),
              () {
                hideLoader();
              },
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: GetBuilder<ControllerFilter>(
              builder: (controller) {
                return controller.editProfileResponse != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titleLabel(StringConstants.ethinicity),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              child: CustomDropdownButton2(
                                value: controller.ethinicityID,
                                onTapClose: () {
                                  controller.ethinicityID = null;
                                  controller.update();
                                },
                                onChanged: (value) {
                                  controller.ethinicityID = value!;
                                  controller.update();
                                },
                                dropdownItems: controller.getSetupProfile!.ethnicity!,
                                hint: toLabelValue(StringConstants.select_option),
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                          titleLabel(StringConstants.occupation),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              child: CustomDropdownButton2(
                                value: controller.occupationID,
                                onTapClose: () {
                                  controller.occupationID = null;
                                  controller.update();
                                },
                                onChanged: (value) {
                                  controller.occupationID = value!;
                                  controller.update();
                                },
                                dropdownItems: controller.getSetupProfile!.occupation!,
                                hint: toLabelValue(StringConstants.select_option),
                              )),
                          const SizedBox(
                            height: 12,
                          ),
                          titleLabel(StringConstants.caste),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              child: CustomDropdownButton2(
                                value: controller.castID,
                                onTapClose: () {
                                  controller.castID = null;
                                  controller.update();
                                },
                                onChanged: (value) {
                                  controller.castID = value!;
                                  controller.update();
                                },
                                dropdownItems: controller.getSetupProfile!.cast!,
                                hint: toLabelValue(StringConstants.select_option),
                              )),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              titleLabel(StringConstants.location_range),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: CustomText(
                                  text:
                                      "${controller.locationRange.value.toStringAsFixed(0)} ${toLabelValue(StringConstants.mile)}${int.parse(controller.locationRange.value.toStringAsFixed(0)) < 1 ? "" : "s"}",
                                  textAlign: TextAlign.center,
                                  style: TextStyleConfig.boldTextStyle(
                                      fontSize: TextStyleConfig.bodyText14,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstants().primaryGradient),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                            child: SliderTheme(
                              data: SliderThemeData(
                                  trackHeight: 6.0,
                                  inactiveTrackColor: ColorConstants().lightBGgrey,
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
                                  thumbShape: const SliderThumbShape()),
                              child: Slider(
                                min: double.parse(controller.getSetupProfile!.minLocationRange.toString()),
                                max: double.parse(controller.getSetupProfile!.maxLocationRange.toString()),
                                activeColor: ColorConstants().primaryGradient,
                                thumbColor: ColorConstants().lightBGgrey,
                                value: controller.locationRange.value,
                                onChanged: (value) {
                                  controller.locationRange.value = value;
                                  controller.update();
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          titleLabel(StringConstants.hobbies),
                          Obx(() => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              child: MultiSelectDropdown(
                                selectedItems: controller.arrSelectedHobbyName.value,
                                selectedItemsIDs: controller.arrSelectedHobbyID.value,
                                items: controller.getSetupProfile!.hobbies!,
                                onchanged: (value) {
                                  if (kDebugMode) {
                                    print(value);
                                  }
                                  controller.hobbies = value.join(",").toString();
                                  controller.update();
                                },
                              ))),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              titleLabel(StringConstants.income),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: CustomText(
                                  text:
                                      "\$${currencyFormatter(controller.minIncome.value.toStringAsFixed(2))} - \$${currencyFormatter(controller.maxIncome.value.toStringAsFixed(2))}${controller.maxIncome.value.toStringAsFixed(0).toString() == controller.getSetupProfile!.maxIncome.toString() ? "+" : ""}",
                                  textAlign: TextAlign.center,
                                  style: TextStyleConfig.boldTextStyle(
                                      fontSize: TextStyleConfig.bodyText14,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstants().primaryGradient),
                                ),
                              )
                            ],
                          ),
                          Obx(() => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                              child: SfRangeSliderTheme(
                                data: SfRangeSliderThemeData(
                                  inactiveTrackHeight: 6.0,
                                  activeTrackHeight: 6.0,
                                  thumbRadius: 12,
                                  thumbColor: ColorConstants().white,
                                  activeTrackColor: ColorConstants().primaryGradient,
                                  inactiveTrackColor: ColorConstants().lightBGgrey,
                                  thumbStrokeWidth: 2,
                                  thumbStrokeColor: ColorConstants().primaryGradient,
                                ),
                                child: SfRangeSlider(
                                  min: double.parse(controller.getSetupProfile!.minIncome!),
                                  max: double.parse(controller.getSetupProfile!.maxIncome!),
                                  stepSize: ((double.parse(controller.getSetupProfile?.maxIncome ?? "1") * 10) / 100),
                                  showTicks: false,
                                  showLabels: false,
                                  values: SfRangeValues(controller.minIncome.value, controller.maxIncome.value),
                                  onChanged: (SfRangeValues newValues) {
                                    controller.minIncome.value = newValues.start;
                                    controller.maxIncome.value = newValues.end;
                                    controller.update();
                                  },
                                ),
                              ))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              titleLabel(StringConstants.net_worth),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: CustomText(
                                  text:
                                      "\$${currencyFormatter(controller.minNetWorth.value.toStringAsFixed(2))} - \$${currencyFormatter(controller.maxNetWorth.value.toStringAsFixed(2))}${controller.maxNetWorth.value.toStringAsFixed(0).toString() == controller.getSetupProfile!.maxNetworth.toString() ? "+" : ""}",
                                  textAlign: TextAlign.center,
                                  style: TextStyleConfig.boldTextStyle(
                                      fontSize: TextStyleConfig.bodyText14,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstants().primaryGradient),
                                ),
                              )
                            ],
                          ),
                          Obx(() => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                              child: SfRangeSliderTheme(
                                data: SfRangeSliderThemeData(
                                  inactiveTrackHeight: 6.0,
                                  activeTrackHeight: 6.0,
                                  thumbRadius: 12,
                                  thumbColor: ColorConstants().white,
                                  activeTrackColor: ColorConstants().primaryGradient,
                                  inactiveTrackColor: ColorConstants().lightBGgrey,
                                  thumbStrokeWidth: 2,
                                  thumbStrokeColor: ColorConstants().primaryGradient,
                                ),
                                child: SfRangeSlider(
                                  min: double.parse(controller.getSetupProfile!.minNetworth!),
                                  max: double.parse(controller.getSetupProfile!.maxNetworth!),
                                  stepSize: ((double.parse(controller.getSetupProfile?.maxNetworth ?? "1") * 10) / 100),
                                  showTicks: false,
                                  showLabels: false,
                                  values: SfRangeValues(controller.minNetWorth.value, controller.maxNetWorth.value),
                                  onChanged: (SfRangeValues newValues) {
                                    controller.minNetWorth.value = newValues.start;
                                    controller.maxNetWorth.value = newValues.end;
                                    controller.update();
                                  },
                                ),
                              ))),
                          titleLabel(StringConstants.car_you_own),
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: MultiSelectChip(
                              selectedChoices: [controller.selectedCarOwn.value],
                              isMultiSelection: false,
                              controller.booleanList,
                              onSelectionChanged: (selectedList) {
                                controller.carYouOwnID = selectedList.first.id.toString();
                                controller.selectedCarOwn.value = selectedList.first;
                                controller.update();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          titleLabel(StringConstants.height),
                          const SizedBox(
                            height: 4,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: CustomTextfieldWidget(
                                      controller: controller.heightController.value,
                                      formkey: controller.formpheightKey,
                                      placeholder: toLabelValue(StringConstants.enter_height),
                                      maxLines: 1,
                                      inputformater: [
                                        NoLeadingSpaceFormatter(),
                                        FilteringTextInputFormatter.allow(RegExp('[0-9./]')),
                                        LengthLimitingTextInputFormatter(250)
                                      ],
                                      onchanged: (value) {
                                        controller.selectedHeight = value;
                                        controller.update();
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
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
                                        controller.isHeightinCM.value
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
                                                        controller.isHeightinCM(false);
                                                        controller.update();
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Center(
                                                          child: CustomText(
                                                            text: toLabelValue(StringConstants.inches),
                                                            style: TextStyleConfig.regularTextStyle(
                                                                fontSize: TextStyleConfig.bodyText12,
                                                                fontWeight: FontWeight.w500),
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
                                                        controller.isHeightinCM(true);
                                                        controller.update();
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Center(
                                                          child: CustomText(
                                                            text: toLabelValue(StringConstants.cm),
                                                            style: TextStyleConfig.regularTextStyle(
                                                                fontSize: TextStyleConfig.bodyText12,
                                                                fontWeight: FontWeight.w500),
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
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          titleLabel(StringConstants.weight),
                          const SizedBox(
                            height: 4,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: CustomTextfieldWidget(
                                      controller: controller.weightController.value,
                                      formkey: controller.formweightKey,
                                      placeholder: toLabelValue(StringConstants.enter_weight),
                                      maxLines: 10,
                                      contentPadding: const EdgeInsets.only(left: 4, bottom: 4, top: 24, right: 4),
                                      inputformater: [
                                        NoLeadingSpaceFormatter(),
                                        FilteringTextInputFormatter.allow(RegExp('[0-9./]')),
                                        LengthLimitingTextInputFormatter(250)
                                      ],
                                      onchanged: (value) {
                                        controller.selectedWeight = value;
                                        controller.update();
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
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
                                        controller.isWeightinKG.value
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
                                                        controller.isWeightinKG(false);
                                                        controller.update();
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Center(
                                                          child: CustomText(
                                                            text: toLabelValue(StringConstants.lbs),
                                                            style: TextStyleConfig.regularTextStyle(
                                                                fontSize: TextStyleConfig.bodyText12,
                                                                fontWeight: FontWeight.w500),
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
                                                        controller.isWeightinKG(true);
                                                        controller.update();
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Center(
                                                          child: CustomText(
                                                            text: toLabelValue(StringConstants.kg),
                                                            style: TextStyleConfig.regularTextStyle(
                                                                fontSize: TextStyleConfig.bodyText12,
                                                                fontWeight: FontWeight.w500),
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
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          titleLabel(StringConstants.marital_status),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              child: CustomDropdownButton2(
                                value: controller.maritalStatusID,
                                onTapClose: () {
                                  controller.maritalStatusID = null;
                                  controller.update();
                                },
                                onChanged: (value) {
                                  controller.maritalStatusID = value!;
                                  controller.update();
                                },
                                dropdownItems: controller.getSetupProfile!.maritalStatus!,
                                hint: toLabelValue(StringConstants.select_option),
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                          titleLabel(StringConstants.children),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: MultiSelectChip(
                              controller.booleanList,
                              selectedChoices: [controller.selectedChildren.value],
                              isMultiSelection: false,
                              onSelectionChanged: (selectedList) {
                                controller.childrenID = selectedList.first.id.toString();
                                controller.selectedChildren.value = selectedList.first;
                                controller.update();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          titleLabel(StringConstants.dating_person_age_group),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              child: CustomDropdownButton2(
                                value: controller.datingAgeGroupID,
                                onTapClose: () {
                                  controller.datingAgeGroupID = null;
                                  controller.update();
                                },
                                onChanged: (value) {
                                  controller.datingAgeGroupID = value!;
                                  controller.update();
                                },
                                dropdownItems: controller.getSetupProfile!.datingGroup!,
                                hint: toLabelValue(StringConstants.select_option),
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                          titleLabel(StringConstants.dating_type),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              child: CustomDropdownButton2(
                                value: controller.datingTYpeID,
                                onTapClose: () {
                                  controller.datingTYpeID = null;
                                  controller.update();
                                },
                                onChanged: (value) {
                                  controller.datingTYpeID = value!;
                                  controller.update();
                                },
                                dropdownItems: controller.getSetupProfile!.datingType!,
                                hint: toLabelValue(StringConstants.select_option),
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                          titleLabel(StringConstants.diet_preference),
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: MultiSelectChip(
                              controller.getSetupProfile!.diePreference!,
                              selectedChoices: [controller.selectedDiet.value],
                              isMultiSelection: false,
                              onSelectionChanged: (selectedList) {
                                controller.dietPrefsID = selectedList.first.id.toString();
                                controller.selectedDiet.value = selectedList.first;
                                controller.update();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          titleLabel(StringConstants.star_sign),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              child: CustomDropdownButton2(
                                value: controller.startSignID,
                                onTapClose: () {
                                  controller.startSignID = null;
                                  controller.update();
                                },
                                onChanged: (value) {
                                  controller.startSignID = value!;
                                  controller.update();
                                },
                                dropdownItems: controller.getSetupProfile!.starSign!,
                                hint: toLabelValue(StringConstants.select_option),
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                          titleLabel(StringConstants.political_leaning),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              child: CustomDropdownButton2(
                                value: controller.politicalLeaningID,
                                onTapClose: () {
                                  controller.politicalLeaningID = null;
                                  controller.update();
                                },
                                onChanged: (value) {
                                  controller.politicalLeaningID = value!;
                                  controller.update();
                                },
                                dropdownItems: controller.getSetupProfile!.politicalLeaningTypes!,
                                hint: toLabelValue(StringConstants.select_option),
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                          titleLabel(StringConstants.smoke),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: MultiSelectChip(
                              controller.booleanList,
                              selectedChoices: [controller.selectedSmock.value],
                              isMultiSelection: false,
                              onSelectionChanged: (selectedList) {
                                controller.smokeID = selectedList.first.id.toString();
                                controller.selectedSmock.value = selectedList.first;
                                controller.update();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          titleLabel(StringConstants.drink),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: MultiSelectChip(
                              controller.booleanList,
                              selectedChoices: [controller.selectedDrink.value],
                              isMultiSelection: false,
                              onSelectionChanged: (selectedList) {
                                controller.drinkID = selectedList.first.id.toString();
                                controller.selectedDrink.value = selectedList.first;
                                controller.update();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          titleLabel(StringConstants.exercise),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: MultiSelectChip(
                              controller.booleanList,
                              selectedChoices: [controller.selectedExercise.value],
                              isMultiSelection: false,
                              onSelectionChanged: (selectedList) {
                                controller.exerciseID = selectedList.first.id.toString();
                                controller.selectedExercise.value = selectedList.first;
                                controller.update();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          titleLabel(StringConstants.religious_views),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              child: CustomDropdownButton2(
                                value: controller.religiousViewID,
                                onTapClose: () {
                                  controller.religiousViewID = null;
                                  controller.update();
                                },
                                onChanged: (value) {
                                  controller.religiousViewID = value!;
                                  controller.update();
                                },
                                dropdownItems: controller.getSetupProfile!.religiousViews!,
                                hint: toLabelValue(StringConstants.select_option),
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                          titleLabel(StringConstants.personality_type),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              child: CustomDropdownButton2(
                                value: controller.personalityTYpeID,
                                onTapClose: () {
                                  controller.personalityTYpeID = null;
                                  controller.update();
                                },
                                onChanged: (value) {
                                  controller.personalityTYpeID = value!;
                                  controller.update();
                                },
                                dropdownItems: controller.getSetupProfile!.personalityType!,
                                hint: toLabelValue(StringConstants.select_option),
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                          titleLabel(StringConstants.body_type),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              child: CustomDropdownButton2(
                                value: controller.bodyTypeID,
                                onTapClose: () {
                                  controller.bodyTypeID = null;
                                  controller.update();
                                },
                                onChanged: (value) {
                                  controller.bodyTypeID = value!;
                                  controller.update();
                                },
                                dropdownItems: controller.getSetupProfile!.bodyType!,
                                hint: toLabelValue(StringConstants.select_option),
                              )),
                          actionButton()
                        ],
                      )
                    : controller.isDataLoaded.value
                        ? noDataView(StringConstants.no_data_found)
                        : const SizedBox();
              },
            )),
      ),
    ));
  }

  Widget actionButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PrimaryButton(btnTitle: StringConstants.apply, onClicked: () => controller.applyFilter()),
    );
  }

  Widget titleLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomText(
        text: toLabelValue(label),
        textAlign: TextAlign.center,
        style: TextStyleConfig.boldTextStyle(
            fontSize: TextStyleConfig.bodyText14, fontWeight: FontWeight.w700, color: ColorConstants().black),
      ),
    );
  }
}
