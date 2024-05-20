import 'dart:async';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/authentication/setup_profile_model.dart';
import 'package:dating_app/src/model/profile/edit_profile.dart';
import 'package:dating_app/src/screen/setupprofile/controller_setup_profile.dart';
import 'package:dating_app/src/services/repository/authentication_webservice/setup_profile_webservice.dart';
import 'package:dating_app/src/services/repository/profile_webservice/profile_webservice.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class ControllerEditProfile extends GetxController {
  RxList<ProfileFieldResponse> booleanList = [
    ProfileFieldResponse(id: 1.toString(), name: toLabelValue(StringConstants.yes)),
    ProfileFieldResponse(id: 0.toString(), name: toLabelValue(StringConstants.no)),
  ].obs;

  SelectedStepsData? selectedSetupData = SelectedStepsData();

//HObbie Ids
  List<String> selectedHobbiesIDs = [];
  Rx<ProfileFieldResponse> hobbiesList = ProfileFieldResponse().obs;
  Rx<ProfileFieldResponse> dietList = ProfileFieldResponse().obs;
  Rx<ProfileFieldResponse> starSignList = ProfileFieldResponse().obs;
  RxList<ProfileFieldResponse> selectedHobbyList = <ProfileFieldResponse>[].obs;

  Rxn<ProfileFieldResponse> selectedGender = Rxn<ProfileFieldResponse>();
  Rxn<ProfileFieldResponse> selectedInterestedInID = Rxn<ProfileFieldResponse>();
  Rxn<String> profilHeading = Rxn<String>();
  Rxn<String> aboutemySelf = Rxn<String>();

  Rxn<ProfileFieldResponse> selectedRelationshipStatus = Rxn<ProfileFieldResponse>();
  Rxn<ProfileFieldResponse> selectedChildren = Rxn<ProfileFieldResponse>();
  Rxn<ProfileFieldResponse> selectedOccupation = Rxn<ProfileFieldResponse>();
  Rxn<ProfileFieldResponse> selectedDiet = Rxn<ProfileFieldResponse>();
  Rxn<ProfileFieldResponse> selectedStarSign = Rxn<ProfileFieldResponse>();
  Rxn<ProfileFieldResponse> selectedSmock = Rxn<ProfileFieldResponse>();
  Rxn<ProfileFieldResponse> selectedDrink = Rxn<ProfileFieldResponse>();
  Rxn<ProfileFieldResponse> selectedExercise = Rxn<ProfileFieldResponse>();
  Rxn<ProfileFieldResponse> selectedPersonalityType = Rxn<ProfileFieldResponse>();
  Rxn<ProfileFieldResponse> selectedBodyType = Rxn<ProfileFieldResponse>();
  Rxn<ProfileFieldResponse> selectedDatingAgeGroup = Rxn<ProfileFieldResponse>();

  Rxn<String> selectedDatingGap = Rxn<String>();

  Rxn<String> selectedIncome = Rxn<String>();
  Rxn<String> selectedNetworth = Rxn<String>();

  Rxn<ProfileFieldResponse> selectedCarOwn = Rxn<ProfileFieldResponse>();
  Rxn<ProfileFieldResponse> selectedDatingType = Rxn<ProfileFieldResponse>();

  Rxn<ProfileFieldResponse> selectedEthnicity = Rxn<ProfileFieldResponse>();
  Rxn<ProfileFieldResponse> selectedCast = Rxn<ProfileFieldResponse>();
  Rxn<ProfileFieldResponse> selectedPoliticalLeaning = Rxn<ProfileFieldResponse>();
  Rxn<ProfileFieldResponse> selectedReligiousViews = Rxn<ProfileFieldResponse>();

  Rxn<DateTime> selectedDOB = Rxn<DateTime>();
  Rxn<String> selectedLocation = Rxn<String>();

  //Search controller for MAP
  Rx<TextEditingController> searchController = TextEditingController().obs;

  Rx<TextEditingController> incomeController = TextEditingController().obs;
  Rx<TextEditingController> networthController = TextEditingController().obs;

//LOCATION DATA
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  List<Marker> markers = <Marker>[];

  String? currentAddress = "";

  Completer<GoogleMapController> mapController = Completer();

  LatLng? center;
  Prediction? prediction;

  Rx<TextEditingController> heightController = TextEditingController().obs;
  final GlobalKey<FormState> formpheightKey = GlobalKey();

  Rx<TextEditingController> weightController = TextEditingController().obs;
  final GlobalKey<FormState> formweightKey = GlobalKey();
  Rx<TextEditingController> profileHeadlineController = TextEditingController().obs;
  Rx<TextEditingController> aboutUsController = TextEditingController().obs;

//GLOBALS Keys
  GlobalKey heightKey = GlobalKey();
  GlobalKey weightKey = GlobalKey();
  GlobalKey occupationKey = GlobalKey();
  GlobalKey dietPrefsKey = GlobalKey();
  GlobalKey starsignKey = GlobalKey();
  GlobalKey smokeKey = GlobalKey();
  GlobalKey drinkKey = GlobalKey();
  GlobalKey exerciseKey = GlobalKey();
  GlobalKey personalitytypeKey = GlobalKey();
  GlobalKey bodytypeKey = GlobalKey();
  GlobalKey datingAgeGrouptKey = GlobalKey();

  GlobalKey incomkey = GlobalKey();
  GlobalKey carownKey = GlobalKey();
  GlobalKey datingtypeKey = GlobalKey();
  GlobalKey ethinicityKey = GlobalKey();
  GlobalKey castKey = GlobalKey();
  GlobalKey politicalLeaningKey = GlobalKey();
  GlobalKey religiousViewKey = GlobalKey();

  RxnString selectedHeight = RxnString();
  RxnString selectedWeight = RxnString();

  RxBool isHeightinCM = true.obs;
  RxBool isWeightinKG = true.obs;
  RxDouble minAge = 20.0.obs;
  RxDouble maxAge = 20.0.obs;

  RxBool isDataLoaded = false.obs;
  EditProfileResponse? editProfileResponse;
  GetSetUpProfileResponse? getSetupProfile;

  void onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
  }

//LOCATION PERMISSION
  handleTap(LatLng point) {
    markers = [];
    markers.add(Marker(
      markerId: MarkerId(point.toString()),
      position: point,
      icon: markerIcon,
    ));
    _getAddressFromLatLng(LatLng(point.latitude, point.longitude));
    update();
  }

  Future<void> _getAddressFromLatLng(LatLng latLong) async {
    await placemarkFromCoordinates(latLong.latitude, latLong.longitude).then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      String address = "";
      if (place.street != "") {
        address = "${place.street}";
      }
      if (place.subLocality != "") {
        address = "$address,${place.subLocality}";
      }
      if (place.locality != "") {
        address = "$address,${place.locality}";
      }
      if (place.postalCode != "") {
        address = "$address,${place.postalCode}";
      }
      if (place.administrativeArea != "") {
        address = "$address,${place.administrativeArea}";
      }
      if (place.country != "") {
        address = "$address,${place.country}";
      }
      currentAddress = address;
      update();
    }).catchError((e) {
      debugPrint(e);
    });
  }

//Get SETUP PROFILE API
  getSetUpProfileAPI() async {
    showLoader();
    bool isSetupProfileCompleted = await SharedPref.getBool(PreferenceConstants.setupProfileDone);

    ApiResponse<GetSetUpProfileResponse>? response = await SetupProfileRepository().getSetupProfile();
    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      getSetupProfile = response.result;
      getEditProfile();

      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }

  getEditProfile() async {
    ApiResponse<EditProfileResponse>? response = await ProfileRepository().getEditProfile();

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      editProfileResponse = response.result;
      selectedHobbyList.value = [];
      selectedHobbiesIDs = [];
      //Set Profile Data

      isUserSubscribe = await SharedPref.getBool(PreferenceConstants.isUserSubscribed);

      profilHeading.value = editProfileResponse!.userSelectedData!.profileHeadline;
      aboutemySelf.value = editProfileResponse!.userSelectedData!.aboutMyself;

      profileHeadlineController.value.text = editProfileResponse!.userSelectedData!.profileHeadline!;
      aboutUsController.value.text = editProfileResponse!.userSelectedData!.aboutMyself!;

      heightController.value.text = editProfileResponse!.userSelectedData!.height!;
      weightController.value.text = editProfileResponse!.userSelectedData!.weight!;
      center = LatLng(double.parse(editProfileResponse!.userSelectedData!.lat.toString()),
          double.parse(editProfileResponse!.userSelectedData!.long.toString()));
      isHeightinCM.value = editProfileResponse!.userSelectedData!.heightMeasurementType == "0" ? true : false;
      isWeightinKG.value = editProfileResponse!.userSelectedData!.weightMeasurementType == "1" ? true : false;
      selectedHeight.value = editProfileResponse!.userSelectedData!.height;
      selectedWeight.value = editProfileResponse!.userSelectedData!.weight;

      selectedGender.value = getSetupProfile?.gender!
          .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.gender.toString());

      //INCOME
      if (editProfileResponse!.userSelectedData!.income!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.income! != "0") {
        selectedIncome.value = editProfileResponse!.userSelectedData!.income.toString();
        incomeController.value.text = selectedIncome.value.toString();
      }

      //Networth
      if (editProfileResponse!.userSelectedData!.networth!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.networth! != "0") {
        selectedNetworth.value = editProfileResponse!.userSelectedData!.networth.toString();
        networthController.value.text = selectedNetworth.value.toString();
      }
      for (var element in editProfileResponse!.userSelectedData!.hobbies!) {
        selectedHobbyList.add(element);
        selectedHobbiesIDs.add(element.name!);
        selectedSetupData!.selectedHobbiesId = List.generate(editProfileResponse!.userSelectedData!.hobbies!.length,
            (index) => editProfileResponse!.userSelectedData!.hobbies![index].id.toString());
      }
      if (editProfileResponse!.userSelectedData!.dateOfBirth!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.dateOfBirth! != "0") {
        selectedDOB.value = DateTime.parse(editProfileResponse!.userSelectedData!.dateOfBirth!.toString());
      }

      //Interested in
      selectedInterestedInID.value = getSetupProfile?.gender!
          .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.interestedIn.toString());

      //Location
      selectedLocation.value = editProfileResponse!.userSelectedData!.location;

      //CarYouOwn
      if (editProfileResponse!.userSelectedData!.carYouOwn!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.carYouOwn! != "0") {
        selectedCarOwn.value = booleanList
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.carYouOwn.toString());
      } else {
        selectedCarOwn.value = ProfileFieldResponse();
      }

      //DatingType
      if (editProfileResponse!.userSelectedData!.datingType!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.datingType! != "0") {
        selectedDatingType.value = getSetupProfile?.datingType
            ?.firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.datingType.toString());
      }
      //RELATIONSHIP STATUS
      if (editProfileResponse!.userSelectedData!.relationshipStatus!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.relationshipStatus! != "0") {
        selectedRelationshipStatus.value = getSetupProfile?.relationshipStatus!.firstWhere(
            (element) => element.id == editProfileResponse?.userSelectedData?.relationshipStatus.toString());
      }

      //Children
      if (editProfileResponse!.userSelectedData!.children!.isNotEmpty) {
        selectedChildren.value = booleanList
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.children.toString());
      }

      //OCCUPAATION
      if (editProfileResponse!.userSelectedData!.occupation!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.occupation! != "0") {
        selectedOccupation.value = getSetupProfile!.occupation!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.occupation.toString());
        selectedSetupData!.selectedOccupationID = selectedOccupation.value!.name;
      }

      //dietPreference
      if (editProfileResponse!.userSelectedData!.dietPreference!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.dietPreference! != "0") {
        selectedDiet.value = getSetupProfile!.diePreference!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.dietPreference.toString());
      }

      //STARTSIGN
      if (editProfileResponse!.userSelectedData!.startSign!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.startSign! != "0") {
        selectedStarSign.value = getSetupProfile!.starSign!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.startSign.toString());

        selectedSetupData!.selectedStartSignID = selectedStarSign.value!.name;
      }

      //SMOKE
      if (editProfileResponse!.userSelectedData!.smoke!.isNotEmpty) {
        selectedSmock.value =
            booleanList.firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.smoke.toString());
      }

      //Drink
      if (editProfileResponse!.userSelectedData!.drink!.isNotEmpty) {
        selectedDrink.value =
            booleanList.firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.drink.toString());
      }

      //Exercise
      if (editProfileResponse!.userSelectedData!.exercise!.isNotEmpty) {
        selectedExercise.value = booleanList
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.exercise.toString());
      }

      //PersonalityType
      if (editProfileResponse!.userSelectedData!.personalityType!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.personalityType! != "0") {
        selectedPersonalityType.value = getSetupProfile!.personalityType!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.personalityType.toString());
        selectedSetupData!.selectedPersonalityTypeID = selectedPersonalityType.value!.name;
      }

      //BodyType
      if (editProfileResponse!.userSelectedData!.bodyType!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.bodyType! != "0") {
        selectedBodyType.value = getSetupProfile!.bodyType!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.bodyType.toString());
        selectedSetupData!.selectedBodyTypeID = selectedBodyType.value!.name;
      }

      //DatingPersonAgeType
      if (editProfileResponse!.userSelectedData!.datingPersonAgeGroup!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.datingPersonAgeGroup! != "0") {
        selectedDatingAgeGroup.value = getSetupProfile!.datingGroup!.firstWhere(
            (element) => element.id == editProfileResponse?.userSelectedData?.datingPersonAgeGroup.toString());
        selectedSetupData!.selectedDatingGroupID = selectedDatingAgeGroup.value!.name;
      }

      //DatingType
      if (editProfileResponse!.userSelectedData!.datingType!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.datingType! != "0") {
        selectedDatingType.value = getSetupProfile!.datingType!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.datingType.toString());
        selectedSetupData!.selectedDatingTypeID = selectedDatingType.value!.name;
      }

      //CarYouOwn
      if (editProfileResponse!.userSelectedData!.carYouOwn!.isNotEmpty) {
        selectedCarOwn.value = booleanList
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.carYouOwn.toString());
      }

      //ETHINICITY
      if (editProfileResponse!.userSelectedData!.ethinicity!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.ethinicity! != "0") {
        selectedEthnicity.value = getSetupProfile!.ethnicity!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.ethinicity.toString());
        selectedSetupData!.selectedEthniCity = selectedEthnicity.value!.name;
      }

      //Cast
      if (editProfileResponse!.userSelectedData!.cast!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.cast! != "0") {
        selectedCast.value = getSetupProfile!.cast!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.cast.toString());
        selectedSetupData!.cast = selectedCast.value!.name;
      }

      //PoliticalLeaning
      if (editProfileResponse!.userSelectedData!.politicalLeaning!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.politicalLeaning! != "0") {
        selectedPoliticalLeaning.value = getSetupProfile!.politicalLeaningTypes!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.politicalLeaning.toString());
        selectedSetupData!.politicalLeaning = selectedPoliticalLeaning.value!.name;
      }

      //ReligiousViews
      if (editProfileResponse!.userSelectedData!.religeousView!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.religeousView! != "0") {
        selectedReligiousViews.value = getSetupProfile!.religiousViews!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.religeousView.toString());
        selectedSetupData!.religiousView = selectedReligiousViews.value!.name;
      }
      hideLoader();
      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }

    update();

    // hideLoader();
  }

  updateProfile() async {
    if (!isDataLoaded.value) showLoader();
    ResponseModel? response = await ProfileRepository().updateEditProfile(
        profile_headline: profileHeadlineController.value.text,
        aboutmyself: aboutUsController.value.text.isNotEmpty
            ? aboutUsController.value.text
            : editProfileResponse!.userSelectedData!.aboutMyself.toString(),
        genderID: selectedGender.value?.id ?? "",
        networth: networthController.value.text,
        interestedGenderID: selectedInterestedInID.value?.id ?? "",
        selectedHobbies: selectedSetupData!.selectedHobbiesId != null
            ? selectedSetupData!.selectedHobbiesId!.join(",").toString()
            : selectedHobbiesIDs.join(","),
        dob: selectedDOB.value != null ? dateformate(selectedDOB.toString(), 'yyyy-MM-dd') : "",
        location: selectedLocation.value ?? currentAddress,
        lat: center?.latitude.toString() ?? "",
        long: center?.longitude.toString() ?? "",
        relatioshipstatus: selectedRelationshipStatus.value?.id ?? "",
        childrenID: selectedChildren.value?.id ?? "",
        height: heightController.value.text.replaceAll(",", "") ?? "",
        heightMeasurementID: isHeightinCM.value ? "0" : "1",
        weight: weightController.value.text ?? "",
        weightMeasurementID: isWeightinKG.value ? "1" : "0",
        occupationID: selectedOccupation.value != null ? selectedOccupation.value?.id : "",
        dietprefs: selectedDiet.value != null ? selectedDiet.value?.id : "",
        starsign: selectedStarSign.value != null ? selectedStarSign.value?.id : "",
        smokeID: selectedSmock.value != null ? selectedSmock.value?.id : "",
        drinkID: selectedDrink.value != null ? selectedDrink.value?.id : "",
        exerciseID: selectedExercise.value != null ? selectedExercise.value?.id : "",
        personalitytypeID: selectedPersonalityType.value != null ? selectedPersonalityType.value?.id : "",
        bodyTypeID: selectedBodyType.value != null ? selectedBodyType.value?.id : "",
        datingPersonAgegroup: selectedDatingAgeGroup.value != null ? selectedDatingAgeGroup.value?.id : "",
        income: incomeController.value.text ?? "",
        ownCarID: selectedCarOwn.value?.id ?? "",
        datingTypeID: selectedDatingType.value != null ? selectedDatingType.value?.id : "",
        ethiicityID: selectedEthnicity.value != null ? selectedEthnicity.value?.id : "",
        castID: selectedCast.value != null ? selectedCast.value?.id : "",
        politicalLeaningID: selectedPoliticalLeaning.value != null ? selectedPoliticalLeaning.value?.id : "",
        religiousViewID: selectedReligiousViews.value != null ? selectedReligiousViews.value?.id : "");

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      update();
      hideLoader();

      Get.back();
      showSnackBar(Get.overlayContext, toLabelValue(response.message!));
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }
}

class GenderOption {
  String? id;
  String? name;

  GenderOption({this.id, this.name});
}
