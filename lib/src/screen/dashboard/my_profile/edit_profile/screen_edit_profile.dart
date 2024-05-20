import 'dart:async';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/edit_profile/mapView/binding_mapview.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/edit_profile/mapView/controller_mapview.dart';
import 'package:dating_app/src/widgets/card_swipe/widgets/widget_customdropdown.dart';
import 'package:dating_app/src/widgets/custom_chip.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'controller_edit_profile.dart';

class ScreenEditProfile extends StatelessWidget {
  ScreenEditProfile({super.key});

  final editProfileController = Get.find<ControllerEditProfile>();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: ColorConstants().white,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(58.0),
              child: CustomAppBar(
                isGradientAppBar: true,
                isBackVisible: true,
                title: toLabelValue(StringConstants.edit_profile),
                titleColor: ColorConstants().white,
                backIconColor: ColorConstants().white,
              )),
          body: GetBuilder<ControllerEditProfile>(
            builder: (controller) {
              return controller.editProfileResponse != null
                  ? SingleChildScrollView(
                      child: SafeArea(
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: Column(
                            children: [
                              headlineWidget(StringConstants.profile_headline),
                              Obx(
                                () => childWidget(controller.profileHeadlineController.value,
                                    controller.profileHeadlineController.value.text, 50),
                              ),
                              headlineWidget(StringConstants.about_myself),
                              Obx(() => childWidget(controller.aboutUsController.value,
                                  controller.editProfileResponse!.userSelectedData!.aboutMyself!, 250)),
                              headlineWidget(StringConstants.your_gender),
                              Obx(() {
                                return childSelectionWidget(toLabelValue(StringConstants.gender),
                                    selectedDescription: editProfileController.selectedGender.value?.name ?? '', () {
                                  bottomBarSelection(
                                      toLabelValue(StringConstants.gender),
                                      false,
                                      editProfileController.selectedGender,
                                      editProfileController.getSetupProfile!.gender!);
                                });
                              }),
                              headlineWidget(StringConstants.interested_in),
                              childSelectionWidget(toLabelValue(StringConstants.interested_in),
                                  selectedDescription: editProfileController.selectedInterestedInID.value?.name ?? '',
                                  () {
                                bottomBarSelection(
                                    toLabelValue(StringConstants.interested_in),
                                    false,
                                    editProfileController.selectedInterestedInID,
                                    editProfileController.getSetupProfile!.gender!);
                              }),
                              headlineWidget(StringConstants.my_hobbies),
                              childSelectionWidget(
                                  controller.selectedHobbiesIDs.isNotEmpty
                                      ? editProfileController.selectedHobbiesIDs.join(', ')
                                      : toLabelValue(StringConstants.my_hobbies), () {
                                bottomBarSelection(
                                    toLabelValue(StringConstants.my_hobbies),
                                    true,
                                    editProfileController.selectedHobbyList,
                                    editProfileController.getSetupProfile!.hobbies!,
                                    isFromHobbies: true);

                                controller.update();
                              }),
                              headlineWidget(StringConstants.date_of_birth),
                              childSelectionWidget(toLabelValue(StringConstants.date),
                                  selectedDescription: editProfileController.selectedDOB.value != null
                                      ? dateformate(editProfileController.selectedDOB.value!.toString(), "dd/MM/yyyy")
                                      : '', () async {
                                dismissKeyboard();
                                DateTime? pickedDate =
                                    await dobDatePicker(context, editProfileController.selectedDOB.value);

                                if (pickedDate != null) {
                                  //pickedDate output format => 2021-03-10 00:00:00.000
                                  debugPrint("$pickedDate");

                                  editProfileController.selectedDOB.value = DateTime.parse(pickedDate.toString());
                                  controller.update();
                                }
                              }),
                              headlineWidget(StringConstants.location),
                              childSelectionWidget(
                                  editProfileController.selectedLocation.value ??
                                      toLabelValue(StringConstants.location), () {
                                BindingMapView().dependencies();
                                Get.find<ControllerMapView>().mapController = Completer();

                                Get.find<ControllerMapView>().center = LatLng(
                                    double.parse(editProfileController.center!.latitude.toString()),
                                    double.parse(editProfileController.center!.longitude.toString()));

                                dismissKeyboard();
                                Get.toNamed(Routes.mapview)!.then((value) {
                                  if (editProfileController.selectedLocation.value!.isEmpty) {
                                    editProfileController.selectedLocation.value =
                                        editProfileController.editProfileResponse?.userSelectedData?.location;
                                  }
                                });

                                Get.find<ControllerMapView>().getCurrentPosition();
                              }),
                              headlineWidget(StringConstants.relationship_status),
                              Obx(() {
                                return childSelectionWidget(toLabelValue(StringConstants.status),
                                    selectedDescription:
                                        editProfileController.selectedRelationshipStatus.value?.name ?? '', () {
                                  bottomBarSelection(
                                      toLabelValue(StringConstants.relationship_status),
                                      false,
                                      editProfileController.selectedRelationshipStatus,
                                      editProfileController.getSetupProfile!.relationshipStatus!);
                                });
                              }),
                              headlineWidget(StringConstants.children),
                              Obx(() {
                                debugPrint("${editProfileController.selectedChildren}");
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: MultiSelectChip(
                                      editProfileController.booleanList,
                                      isMultiSelection: false,
                                      selectedChoices: [editProfileController.selectedChildren],
                                      onSelectionChanged: (userSelectedValue) {
                                        editProfileController.selectedChildren.value = userSelectedValue.first;

                                        editProfileController.update();
                                      },
                                    ),
                                  ),
                                );
                              }),
                              headlineWidget(StringConstants.basic_information),
                              const SizedBox(height: 10),
                              Obx(() {
                                return childSelectionWidget(toLabelValue(StringConstants.height),
                                    selectedDescription: (editProfileController.selectedHeight.value != null &&
                                            editProfileController.selectedHeight.value!.isNotEmpty)
                                        ? "${editProfileController.selectedHeight.value} ${editProfileController.isHeightinCM.value ? toLabelValue(StringConstants.cm) : toLabelValue(StringConstants.inches)}"
                                        : '',
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12), () {
                                  basicInfoView();
                                  scrollToWidget(editProfileController.heightKey);
                                });
                              }),
                              Obx(() {
                                return childSelectionWidget(toLabelValue(StringConstants.weight),
                                    selectedDescription: (editProfileController.selectedWeight.value != null &&
                                            editProfileController.selectedWeight.value!.isNotEmpty)
                                        ? '${editProfileController.selectedWeight.value} ${editProfileController.isWeightinKG.value ? toLabelValue(StringConstants.kg) : toLabelValue(StringConstants.lbs)}'
                                        : '',
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12), () {
                                  basicInfoView();
                                  scrollToWidget(editProfileController.weightKey);
                                });
                              }),
                              Obx(() {
                                return childSelectionWidget(toLabelValue(StringConstants.occupation),
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                    selectedDescription: editProfileController.selectedOccupation.value != null
                                        ? editProfileController.selectedOccupation.value?.name
                                        : ""
                                            '', () {
                                  basicInfoView();
                                  scrollToWidget(editProfileController.occupationKey);
                                });
                              }),
                              Obx(() {
                                return childSelectionWidget(toLabelValue(StringConstants.diet_preference),
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                    selectedDescription: editProfileController.selectedDiet.value?.name ?? '', () {
                                  basicInfoView();
                                  scrollToWidget(editProfileController.dietPrefsKey);
                                });
                              }),
                              Obx(() {
                                return childSelectionWidget(toLabelValue(StringConstants.star_sign),
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                    selectedDescription: editProfileController.selectedStarSign.value?.name ?? '', () {
                                  basicInfoView();
                                  scrollToWidget(editProfileController.starsignKey);
                                });
                              }),
                              Obx(() {
                                return childSelectionWidget(toLabelValue(StringConstants.smoke),
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                    selectedDescription: editProfileController.selectedSmock.value?.name ?? '', () {
                                  basicInfoView();
                                  scrollToWidget(editProfileController.smokeKey);
                                });
                              }),
                              Obx(() {
                                return childSelectionWidget(toLabelValue(StringConstants.drink),
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                    selectedDescription: editProfileController.selectedDrink.value?.name ?? '', () {
                                  basicInfoView();
                                  scrollToWidget(editProfileController.drinkKey);
                                });
                              }),
                              Obx(() {
                                return childSelectionWidget(toLabelValue(StringConstants.exercise),
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                    selectedDescription: editProfileController.selectedExercise.value?.name ?? '', () {
                                  basicInfoView();
                                  scrollToWidget(editProfileController.exerciseKey);
                                });
                              }),
                              Obx(() {
                                return childSelectionWidget(toLabelValue(StringConstants.personality_type),
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                    selectedDescription:
                                        editProfileController.selectedPersonalityType.value?.name ?? '', () {
                                  basicInfoView();
                                  scrollToWidget(editProfileController.personalitytypeKey);
                                });
                              }),
                              Obx(() {
                                return childSelectionWidget(toLabelValue(StringConstants.body_type),
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                    selectedDescription: editProfileController.selectedBodyType.value?.name ?? '', () {
                                  basicInfoView();
                                  scrollToWidget(editProfileController.bodytypeKey);
                                });
                              }),
                              Obx(() {
                                return childSelectionWidget(toLabelValue(StringConstants.dating_person_age_group),
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                    selectedDescription: editProfileController.selectedDatingAgeGroup.value != null
                                        ? editProfileController.selectedDatingAgeGroup.value!.name
                                        : "", () {
                                  basicInfoView();
                                  scrollToWidget(editProfileController.datingAgeGrouptKey);
                                });
                              }),
                              if (isUserSubscribe == true) headlineWidget(StringConstants.advance_option),
                              if (isUserSubscribe == true)
                                Obx(() {
                                  return childSelectionWidget(
                                    toLabelValue(StringConstants.income),
                                    () {
                                      advanceOptions(context);
                                    },
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                    selectedDescription: editProfileController.selectedIncome.value != ""
                                        ? currencyFormatter(editProfileController.selectedIncome.value ?? '0')
                                        : "",
                                  );
                                }),
                              if (isUserSubscribe == true)
                                Obx(() {
                                  return childSelectionWidget(toLabelValue(StringConstants.net_worth), () {
                                    advanceOptions(context);
                                  },
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                      selectedDescription: editProfileController.selectedNetworth.value != ""
                                          ? currencyFormatter(editProfileController.selectedNetworth.value ?? "0")
                                          : "");
                                }),
                              if (isUserSubscribe == true)
                                Obx(() {
                                  return childSelectionWidget(toLabelValue(StringConstants.car_you_own),
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                      selectedDescription: editProfileController.selectedCarOwn.value?.name ?? '', () {
                                    advanceOptions(context);
                                  });
                                }),
                              if (isUserSubscribe == true)
                                Obx(() {
                                  return childSelectionWidget(toLabelValue(StringConstants.dating_type),
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                      selectedDescription: editProfileController.selectedDatingType.value?.name ?? '',
                                      () {
                                    advanceOptions(context);
                                  });
                                }),
                              headlineWidget(StringConstants.other_information, isOptional: true),
                              Obx(() {
                                return childSelectionWidget(toLabelValue(StringConstants.ethnicity),
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                    selectedDescription: editProfileController.selectedEthnicity.value?.name ?? '', () {
                                  otherOptions();
                                });
                              }),
                              Obx(() {
                                return childSelectionWidget(toLabelValue(StringConstants.cast),
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                    selectedDescription: editProfileController.selectedCast.value?.name ?? '', () {
                                  otherOptions();
                                });
                              }),
                              Obx(() {
                                return childSelectionWidget(toLabelValue(StringConstants.political_leaning),
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                    selectedDescription:
                                        editProfileController.selectedPoliticalLeaning.value?.name ?? '', () {
                                  otherOptions();
                                });
                              }),
                              Obx(() {
                                return childSelectionWidget(toLabelValue(StringConstants.religious_views),
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                    selectedDescription: editProfileController.selectedReligiousViews.value?.name ?? '',
                                    () {
                                  otherOptions();
                                });
                              }),
                              headlineWidget(StringConstants.account_setting, isContactAdmin: true, context: context),
                              userCredentialWidget(StringConstants.username,
                                  editProfileController.editProfileResponse!.userSelectedData!.username!),
                              userCredentialWidget(StringConstants.email_address,
                                  editProfileController.editProfileResponse!.userSelectedData!.userEmail!),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: Get.height * .05, horizontal: 16),
                                child: updateBtnAction(context, false),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : controller.isDataLoaded.value
                      ? noDataView(StringConstants.no_data_found)
                      : const SizedBox();
            },
          )),
    );
  }

  Widget titleLabel(String label, [GlobalKey? key]) {
    return CustomText(
      key: key,
      text: toLabelValue(label),
      textAlign: TextAlign.center,
      style: TextStyleConfig.boldTextStyle(
          fontSize: TextStyleConfig.bodyText14, fontWeight: FontWeight.w700, color: ColorConstants().black),
    );
  }

  scrollToWidget(GlobalKey key) {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () {
        Scrollable.ensureVisible(key.currentContext!, duration: const Duration(seconds: 1));
      },
    );
  }

  basicInfoView() {
    dismissKeyboard();
    return Get.bottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ), StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
                color: ColorConstants().white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                )),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 6,
                      decoration:
                          BoxDecoration(color: const Color(0XFFCFD2D8), borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(child: GetBuilder<ControllerEditProfile>(
                      builder: (controller) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Obx(() {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: toLabelValue(StringConstants.basic_information),
                                      textAlign: TextAlign.center,
                                      style: TextStyleConfig.boldTextStyle(
                                          fontSize: TextStyleConfig.bodyText18, color: ColorConstants().black),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    titleLabel(
                                      StringConstants.height,
                                      controller.heightKey,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            child: CustomTextfieldWidget(
                                              textInputAction: TextInputAction.next,
                                              controller: controller.heightController.value,
                                              formkey: controller.formpheightKey,
                                              placeholder: toLabelValue(StringConstants.enter_height),
                                              keyboardType: TextInputType.number,
                                              onFieldSubmitted: (p0) {
                                                FocusScope.of(context).nextFocus();
                                              },
                                              maxLines: 1,
                                              inputformater: [
                                                NoLeadingSpaceFormatter(),
                                                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                                                FilteringTextInputFormatter.allow(RegExp('[0-9./]')),
                                                LengthLimitingTextInputFormatter(6)
                                              ],
                                              onchanged: (value) {
                                                controller.selectedHeight.value = value;
                                                controller.update();
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
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
                                                                  borderRadius:
                                                                      const BorderRadius.all(Radius.circular(24.0)),
                                                                  border: Border.all(
                                                                      color: ColorConstants().primaryGradient)),
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
                                                                  borderRadius:
                                                                      const BorderRadius.all(Radius.circular(24.0)),
                                                                  border: Border.all(
                                                                      color: ColorConstants().primaryGradient)),
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
                                    titleLabel(
                                      StringConstants.weight,
                                      controller.weightKey,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            child: CustomTextfieldWidget(
                                              textInputAction: TextInputAction.done,
                                              controller: controller.weightController.value,
                                              formkey: controller.formweightKey,
                                              keyboardType: TextInputType.number,
                                              placeholder: toLabelValue(StringConstants.enter_weight),
                                              maxLines: 10,
                                              contentPadding:
                                                  const EdgeInsets.only(left: 4, bottom: 4, top: 24, right: 4),
                                              inputformater: [
                                                NoLeadingSpaceFormatter(),
                                                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                                                FilteringTextInputFormatter.allow(RegExp('[0-9./]')),
                                                LengthLimitingTextInputFormatter(6)
                                              ],
                                              onchanged: (value) {
                                                controller.selectedWeight.value = value;
                                                controller.update();
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
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
                                                                  borderRadius:
                                                                      const BorderRadius.all(Radius.circular(24.0)),
                                                                  border: Border.all(
                                                                      color: ColorConstants().primaryGradient)),
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
                                                                  borderRadius:
                                                                      const BorderRadius.all(Radius.circular(24.0)),
                                                                  border: Border.all(
                                                                      color: ColorConstants().primaryGradient)),
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
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    titleLabel(
                                      StringConstants.occupation,
                                      controller.occupationKey,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        child: CustomDropdownButton2(
                                          value: controller.selectedSetupData?.selectedOccupationID,
                                          onChanged: (value) {
                                            var d = controller.getSetupProfile!.occupation!
                                                .where((element) => element.name.toString() == value.toString());
                                            debugPrint(d.first.name);

                                            controller.selectedOccupation.value = d.first;
                                            controller.selectedSetupData?.selectedOccupationID = d.first.name;

                                            controller.update();
                                          },
                                          dropdownItems: controller.getSetupProfile!.occupation!,
                                          hint: controller.selectedSetupData?.selectedOccupationID != null
                                              ? controller.selectedSetupData!.selectedOccupationID!
                                              : toLabelValue(StringConstants.select_option),
                                        )),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    titleLabel(
                                      StringConstants.diet_preference,
                                      controller.dietPrefsKey,
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    MultiSelectChip(
                                      isMultiSelection: false,
                                      controller.getSetupProfile!.diePreference!,
                                      selectedChoices: [editProfileController.selectedDiet],
                                      onSelectionChanged: (selectedList) {
                                        controller.selectedDiet.value = selectedList.first;
                                        controller.update();
                                      },
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    titleLabel(
                                      StringConstants.star_sign,
                                      controller.starsignKey,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        child: CustomDropdownButton2(
                                          value: controller.selectedSetupData?.selectedStartSignID,
                                          onChanged: (value) {
                                            var d = controller.getSetupProfile!.starSign!
                                                .where((element) => element.name.toString() == value.toString());
                                            debugPrint(d.first.name);

                                            controller.selectedStarSign.value = d.first;
                                            controller.selectedSetupData?.selectedStartSignID = d.first.name;

                                            controller.update();
                                          },
                                          dropdownItems: controller.getSetupProfile!.starSign!,
                                          hint: controller.selectedSetupData?.selectedStartSignID != null
                                              ? controller.selectedSetupData!.selectedStartSignID!
                                              : toLabelValue(StringConstants.select_option),
                                        )),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    titleLabel(
                                      StringConstants.smoke,
                                      controller.smokeKey,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    MultiSelectChip(
                                      isMultiSelection: false,
                                      controller.booleanList,
                                      selectedChoices: [editProfileController.selectedSmock],
                                      onSelectionChanged: (selectedList) {
                                        controller.selectedSmock.value = selectedList.first;
                                        controller.update();
                                      },
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    titleLabel(
                                      StringConstants.drink,
                                      controller.drinkKey,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    MultiSelectChip(
                                      isMultiSelection: false,
                                      controller.booleanList,
                                      selectedChoices: [editProfileController.selectedDrink],
                                      onSelectionChanged: (selectedList) {
                                        controller.selectedDrink.value = selectedList.first;
                                        controller.update();
                                      },
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    titleLabel(
                                      StringConstants.exercise,
                                      controller.exerciseKey,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    MultiSelectChip(
                                      isMultiSelection: false,
                                      controller.booleanList,
                                      selectedChoices: [editProfileController.selectedExercise],
                                      onSelectionChanged: (selectedList) {
                                        controller.selectedExercise.value = selectedList.first;
                                        controller.update();
                                      },
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    titleLabel(
                                      StringConstants.personality_type,
                                      controller.personalitytypeKey,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        child: CustomDropdownButton2(
                                          value: controller.selectedSetupData?.selectedPersonalityTypeID,
                                          onChanged: (value) {
                                            var d = controller.getSetupProfile!.personalityType!
                                                .where((element) => element.name.toString() == value.toString());
                                            debugPrint(d.first.name);

                                            controller.selectedPersonalityType.value = d.first;
                                            controller.selectedSetupData?.selectedPersonalityTypeID = d.first.name;

                                            controller.update();
                                          },
                                          dropdownItems: controller.getSetupProfile!.personalityType!,
                                          hint: controller.selectedSetupData?.selectedPersonalityTypeID != null
                                              ? controller.selectedSetupData!.selectedPersonalityTypeID!
                                              : toLabelValue(StringConstants.select_option),
                                        )),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    titleLabel(
                                      StringConstants.body_type,
                                      controller.bodytypeKey,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        child: CustomDropdownButton2(
                                          value: controller.selectedSetupData?.selectedBodyTypeID,
                                          onChanged: (value) {
                                            var d = controller.getSetupProfile!.bodyType!
                                                .where((element) => element.name.toString() == value.toString());
                                            debugPrint(d.first.name);

                                            controller.selectedBodyType.value = d.first;
                                            controller.selectedSetupData?.selectedBodyTypeID = d.first.name;

                                            controller.update();
                                          },
                                          dropdownItems: controller.getSetupProfile!.bodyType!,
                                          hint: controller.selectedSetupData?.selectedBodyTypeID != null
                                              ? controller.selectedSetupData!.selectedBodyTypeID!
                                              : toLabelValue(StringConstants.select_option),
                                        )),
                                    titleLabel(
                                      StringConstants.dating_person_age_group,
                                      controller.datingAgeGrouptKey,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: CustomDropdownButton2(
                                          value: controller.selectedSetupData?.selectedDatingGroupID,
                                          onChanged: (value) {
                                            var d = controller.getSetupProfile!.datingGroup!
                                                .where((element) => element.name.toString() == value.toString());
                                            debugPrint(d.first.name);

                                            controller.selectedDatingAgeGroup.value = d.first;
                                            controller.selectedSetupData?.selectedDatingGroupID = d.first.name;

                                            controller.update();
                                          },
                                          dropdownItems: controller.getSetupProfile!.datingGroup!,
                                          hint: controller.selectedSetupData?.selectedDatingGroupID != null
                                              ? controller.selectedSetupData!.selectedDatingGroupID!
                                              : toLabelValue(StringConstants.select_option),
                                        )),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        );
                      },
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: updateBtnAction(context, true),
                  )
                ],
              ),
            ));
      },
    ));
  }

  advanceOptions(contexts) {
    dismissKeyboard();
    return showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        context: contexts,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              height: MediaQuery.of(context).size.height * 0.67,
              decoration: BoxDecoration(
                  color: ColorConstants().white,
                  borderRadius:
                      const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 6,
                    decoration: BoxDecoration(color: const Color(0XFFCFD2D8), borderRadius: BorderRadius.circular(12)),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: GetBuilder<ControllerEditProfile>(builder: (controller) {
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: toLabelValue(StringConstants.advance_option),
                              textAlign: TextAlign.center,
                              style: TextStyleConfig.boldTextStyle(
                                  fontSize: TextStyleConfig.bodyText18, color: ColorConstants().black),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            titleLabel(StringConstants.income),
                            const SizedBox(
                              height: 8,
                            ),
                            CustomTextfieldWidget(
                              controller: controller.incomeController.value,
                              inputformater: [
                                NoLeadingSpaceFormatter(),
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                              ],
                              placeholder: toLabelValue(StringConstants.enter_income),
                              keyboardType: TextInputType.number,
                              onchanged: (value) {
                                controller.selectedIncome.value = value;

                                controller.update();
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            titleLabel(StringConstants.net_worth),
                            const SizedBox(
                              height: 8,
                            ),
                            CustomTextfieldWidget(
                              controller: controller.networthController.value,
                              inputformater: [
                                NoLeadingSpaceFormatter(),
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                              ],
                              placeholder: toLabelValue(StringConstants.enter_net_worth),
                              keyboardType: TextInputType.number,
                              onchanged: (value) {
                                controller.selectedNetworth.value = value;

                                controller.update();
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            titleLabel(StringConstants.car_you_own),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: MultiSelectChip(
                                isMultiSelection: false,
                                controller.booleanList,
                                selectedChoices: [editProfileController.selectedCarOwn],
                                onSelectionChanged: (selectedList) {
                                  controller.selectedCarOwn.value = selectedList.first;
                                  controller.update();
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            titleLabel(
                              StringConstants.dating_type,
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: CustomDropdownButton2(
                                  value: controller.selectedSetupData?.selectedDatingTypeID,
                                  onChanged: (value) {
                                    var d = controller.getSetupProfile!.datingType!
                                        .where((element) => element.name.toString() == value.toString());
                                    debugPrint(d.first.name);

                                    controller.selectedDatingType.value = d.first;
                                    controller.selectedSetupData?.selectedDatingTypeID = d.first.name;

                                    controller.update();
                                  },
                                  dropdownItems: controller.getSetupProfile!.datingType!,
                                  hint: controller.selectedSetupData?.selectedDatingTypeID != null
                                      ? controller.selectedSetupData!.selectedDatingTypeID!
                                      : toLabelValue(StringConstants.select_option),
                                )),
                          ],
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: updateBtnAction(context, true),
                  )
                ],
              ));
        });
  }

  Widget updateBtnAction(context, bool isFromPopUp) {
    return PrimaryButton(
      btnTitle: StringConstants.update,
      onClicked: () {
        dismissKeyboard();
        if (editProfileController.profileHeadlineController.value.text.trim().isEmpty) {
          showSnackBar(context,
              "${toLabelValue(StringConstants.please_enter)} ${toLabelValue(StringConstants.profile_headline)}.");
        } else if (editProfileController.aboutUsController.value.text.trim().isEmpty) {
          showSnackBar(
              context, "${toLabelValue(StringConstants.please_enter)} ${toLabelValue(StringConstants.abou_myself)}.");
        } else if (editProfileController.selectedSetupData!.selectedHobbiesId!.isEmpty) {
          showSnackBar(context, toLabelValue(StringConstants.one_hobbie_select_atleast));
        } else if (editProfileController.heightController.value.text.trim().isEmpty) {
          showSnackBar(
              context, "${toLabelValue(StringConstants.please_enter)} ${toLabelValue(StringConstants.height)}.");
        } else if (editProfileController.weightController.value.text.trim().isEmpty) {
          showSnackBar(
              context, "${toLabelValue(StringConstants.please_enter)} ${toLabelValue(StringConstants.weight)}.");
        } else if (editProfileController.incomeController.value.text.trim().isEmpty && isUserSubscribe!) {
          showSnackBar(context, toLabelValue(StringConstants.please_enter_income));
        } else if (editProfileController.networthController.value.text.trim().isEmpty && isUserSubscribe!) {
          showSnackBar(context, toLabelValue(StringConstants.please_enter_networth));
        } else {
          editProfileController.updateProfile();
          if (isFromPopUp) {
            Get.back();
          }
        }
      },
    );
  }

  otherOptions() {
    dismissKeyboard();
    return showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        context: Get.overlayContext!,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
                color: ColorConstants().white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 6,
                  decoration: BoxDecoration(color: const Color(0XFFCFD2D8), borderRadius: BorderRadius.circular(12)),
                ),
                const SizedBox(
                  height: 24,
                ),
                GetBuilder<ControllerEditProfile>(
                  builder: (_) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: toLabelValue(StringConstants.other_information),
                          textAlign: TextAlign.center,
                          style: TextStyleConfig.boldTextStyle(
                              fontSize: TextStyleConfig.bodyText18, color: ColorConstants().black),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        titleLabel(
                          StringConstants.ethinicity,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: CustomDropdownButton2(
                              value: editProfileController.selectedSetupData?.selectedEthniCity,
                              onChanged: (value) {
                                var d = editProfileController.getSetupProfile!.ethnicity!
                                    .where((element) => element.name.toString() == value.toString());
                                debugPrint(d.first.name);

                                editProfileController.selectedEthnicity.value = d.first;
                                editProfileController.selectedSetupData?.selectedEthniCity = d.first.name;

                                editProfileController.update();
                              },
                              dropdownItems: editProfileController.getSetupProfile!.ethnicity!,
                              hint: editProfileController.selectedSetupData?.selectedEthniCity != null
                                  ? editProfileController.selectedSetupData!.selectedEthniCity!
                                  : toLabelValue(StringConstants.select_option),
                            )),
                        const SizedBox(
                          height: 8,
                        ),
                        titleLabel(
                          StringConstants.caste,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: CustomDropdownButton2(
                              value: editProfileController.selectedSetupData?.cast,
                              onChanged: (value) {
                                var d = editProfileController.getSetupProfile!.cast!
                                    .where((element) => element.name.toString() == value.toString());
                                debugPrint(d.first.name);

                                editProfileController.selectedCast.value = d.first;
                                editProfileController.selectedSetupData?.cast = d.first.name;

                                editProfileController.update();
                              },
                              dropdownItems: editProfileController.getSetupProfile!.cast!,
                              hint: editProfileController.selectedSetupData?.cast != null
                                  ? editProfileController.selectedSetupData!.cast!
                                  : toLabelValue(StringConstants.select_option),
                            )),
                        const SizedBox(
                          height: 12,
                        ),
                        titleLabel(
                          StringConstants.political_leaning,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: CustomDropdownButton2(
                              value: editProfileController.selectedSetupData?.politicalLeaning,
                              onChanged: (value) {
                                var d = editProfileController.getSetupProfile!.politicalLeaningTypes!
                                    .where((element) => element.name.toString() == value.toString());
                                debugPrint(d.first.name);

                                editProfileController.selectedPoliticalLeaning.value = d.first;
                                editProfileController.selectedSetupData?.politicalLeaning = d.first.name;

                                editProfileController.update();
                              },
                              dropdownItems: editProfileController.getSetupProfile!.politicalLeaningTypes!,
                              hint: editProfileController.selectedSetupData?.politicalLeaning != null
                                  ? editProfileController.selectedSetupData!.politicalLeaning!
                                  : toLabelValue(StringConstants.select_option),
                            )),
                        const SizedBox(
                          height: 8,
                        ),
                        titleLabel(
                          StringConstants.religious_views,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: CustomDropdownButton2(
                              value: editProfileController.selectedSetupData?.religiousView,
                              onChanged: (value) {
                                var d = editProfileController.getSetupProfile!.religiousViews!
                                    .where((element) => element.name.toString() == value.toString());
                                debugPrint(d.first.name);

                                editProfileController.selectedReligiousViews.value = d.first;
                                editProfileController.selectedSetupData?.religiousView = d.first.name;

                                editProfileController.update();
                              },
                              dropdownItems: editProfileController.getSetupProfile!.religiousViews!,
                              hint: editProfileController.selectedSetupData?.religiousView != null
                                  ? editProfileController.selectedSetupData!.religiousView!
                                  : toLabelValue(StringConstants.select_option),
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: updateBtnAction(context, true),
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        });
  }

  Padding userCredentialWidget(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: toLabelValue(title),
            overflow: TextOverflow.ellipsis,
            maxlines: 1,
            style: TextStyleConfig.regularTextStyle(
              color: ColorConstants().grey,
              fontWeight: FontWeight.w400,
              fontSize: TextStyleConfig.bodyText14,
            ),
          ),
          CustomText(
            text: value,
            overflow: TextOverflow.ellipsis,
            maxlines: 1,
            style: TextStyleConfig.regularTextStyle(
              color: ColorConstants().grey,
              fontWeight: FontWeight.w400,
              fontSize: TextStyleConfig.bodyText14,
            ),
          ),
        ],
      ),
    );
  }

  Widget headlineWidget(String title, {bool? isOptional, bool? isContactAdmin, BuildContext? context}) {
    return Container(
        padding: const EdgeInsets.all(16),
        color: ColorConstants().light1,
        width: Get.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: toLabelValue(title).capitalizeFirst,
                    style: TextStyleConfig.regularTextStyle(
                      color: ColorConstants().black,
                      fontWeight: FontWeight.w700,
                      fontSize: TextStyleConfig.bodyText16,
                    ),
                  ),
                  if (isOptional != null && isOptional)
                    TextSpan(
                      text: '(${toLabelValue(StringConstants.optional).capitalizeFirst})',
                      style: TextStyleConfig.regularTextStyle(
                        color: ColorConstants().black,
                        fontWeight: FontWeight.w700,
                        fontSize: TextStyleConfig.bodyText16,
                      ),
                    ),
                ],
              ),
            ),
            if (isContactAdmin != null)
              InkWell(
                onTap: () {
                  openEmail(generalSetting!.email);
                },
                child: CustomText(
                  text: toLabelValue(StringConstants.contact_admin).capitalizeFirst,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleConfig.boldTextStyle(
                      color: ColorConstants().primaryGradient,
                      fontWeight: FontWeight.w700,
                      fontSize: TextStyleConfig.bodyText14),
                ),
              ),
          ],
        ));
  }

  Column childWidget(
    TextEditingController fieldController,
    String description,
    int maxLength,
    // Function(String) onchange
  ) {
    RxInt descriptionTextLength = fieldController.text.length.obs;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 300.0,
            ),
            child: TextField(
              keyboardType: TextInputType.multiline,
              controller: fieldController,
              maxLines: null,
              maxLength: maxLength,
              onChanged: (value) {
                editProfileController.update();
              },
              inputFormatters: [
                NoLeadingSpaceFormatter(),
              ],
              decoration: InputDecoration(
                  counterText: '${descriptionTextLength.value}/$maxLength',
                  counterStyle: TextStyleConfig.boldTextStyle(
                      color: ColorConstants().grey, fontWeight: FontWeight.w400, fontSize: TextStyleConfig.bodyText12),
                  border: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero),
            ),
          ),
        ),
      ],
    );
  }

  InkWell childSelectionWidget(String description, VoidCallback onTap,
      {String? selectedDescription, EdgeInsetsGeometry? padding}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: (padding != null || (padding != null)) ? padding : const EdgeInsets.all(16),
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: CustomText(
                text: description,
                overflow: TextOverflow.ellipsis,
                maxlines: 2,
                style: TextStyleConfig.regularTextStyle(
                  color: ColorConstants().black,
                  fontWeight: FontWeight.w400,
                  fontSize: TextStyleConfig.bodyText14,
                ),
              ),
            ),
            Row(
              children: [
                if (selectedDescription != null)
                  SizedBox(
                    width: Get.width * .35,
                    child: CustomText(
                      text: selectedDescription.isNotEmpty ? selectedDescription : 'Add',
                      overflow: TextOverflow.ellipsis,
                      maxlines: 1,
                      textAlign: TextAlign.right,
                      style: TextStyleConfig.regularTextStyle(
                        color: selectedDescription.isNotEmpty ? ColorConstants().black : ColorConstants().grey1,
                        fontWeight: selectedDescription.isNotEmpty ? FontWeight.w400 : FontWeight.w700,
                        fontSize: TextStyleConfig.bodyText14,
                      ),
                    ),
                  ),
                const SizedBox(width: 6),
                SvgPicture.asset(
                  ImageConstants.icon_arrow_forward,
                  fit: BoxFit.scaleDown,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  bottomBarSelection(String title, bool isMultiSelect, dynamic selectedValue, List optionList,
      {List? preselectedValues, bool? isFromHobbies = false}) {
    dismissKeyboard();
    return showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        context: Get.overlayContext!,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                  color: ColorConstants().white,
                  borderRadius:
                      const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 6,
                    decoration: BoxDecoration(color: const Color(0XFFCFD2D8), borderRadius: BorderRadius.circular(12)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: title.capitalizeFirst,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleConfig.boldTextStyle(
                              color: ColorConstants().black,
                              fontWeight: FontWeight.w600,
                              fontSize: TextStyleConfig.bodyText16),
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                  GetBuilder<ControllerEditProfile>(
                    builder: (controller) {
                      return Align(
                          alignment: Alignment.centerLeft,
                          child: isFromHobbies!
                              ? MultiSelectChip(
                                  optionList,
                                  selectedChoices: selectedValue,
                                  isMultiSelection: true,
                                  onSelectionChanged: (selectedList) {
                                    controller.selectedHobbiesIDs = List.generate(
                                        selectedList.length, (index) => selectedList[index].name.toString());
                                    selectedValue = selectedList;
                                    editProfileController.selectedSetupData!.selectedHobbiesId = List.generate(
                                        selectedList.length, (index) => selectedList[index].id.toString());
                                    editProfileController.update();
                                  },
                                )
                              : MultiSelectChip(optionList,
                                  isMultiSelection: isMultiSelect,
                                  selectedChoices: (selectedValue is List) ? selectedValue : [selectedValue],
                                  onSelectionChanged: (userSelectedValue) {
                                  if (selectedValue is List) {
                                    selectedValue.clear();
                                    selectedValue = userSelectedValue;
                                    controller.update();
                                  } else {
                                    selectedValue.value = userSelectedValue.first;
                                  }

                                  controller.update();
                                }));
                    },
                  )
                ],
              ));
        });
  }
}
