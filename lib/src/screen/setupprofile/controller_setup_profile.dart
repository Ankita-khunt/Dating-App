import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/authentication/setup_profile_model.dart';
import 'package:dating_app/src/screen/setupprofile/setup_profile_success/screen_profile_setup_success.dart';
import 'package:dating_app/src/services/repository/authentication_webservice/setup_profile_webservice.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class ControllerSetUpProfile extends GetxController {
  List<SelectedStep> steps = [];
  RxInt selectedStepIndex = 1.obs;
  RxList<File> pickedImageList = <File>[].obs;

  //Search controller for MAP
  Rx<TextEditingController> searchController = TextEditingController().obs;

//LOCATION DATA
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  List<Marker> markers = <Marker>[];

  String? currentAddress = "";
  Position? currentPosition;

//
  Rxn<dynamic> selectedGender = Rxn<dynamic>();
  Rxn<dynamic> selectedInterestedGender = Rxn<dynamic>();
  Rxn<List<dynamic>> selectedHobbies = Rxn<List<dynamic>>();
  Rxn<dynamic> selectedCarOwn = Rxn<dynamic>();

  Rxn<dynamic> selectedChildren = Rxn<dynamic>();
  Rxn<dynamic> selectedDiet = Rxn<dynamic>();
  Rxn<dynamic> selectedSmock = Rxn<dynamic>();
  Rxn<dynamic> selectedDrink = Rxn<dynamic>();
  Rxn<dynamic> selectedExercise = Rxn<dynamic>();

  Rxn<String> selectedOccupation = Rxn<String>();
  Rxn<String> selectedRelationshipStatus = Rxn<String>();
  Rxn<String> selectedStartSign = Rxn<String>();
  Rxn<String> selectedPersonalityType = Rxn<String>();
  Rxn<String> selectedBodyType = Rxn<String>();
  Rxn<String> selectedDatingType = Rxn<String>();

//

  Completer<GoogleMapController> mapController = Completer();

  LatLng? center;
  Prediction? prediction;

  void onMapCreated(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      //first calling is false
      //call "completer()"
      mapController.complete(controller);
    } else {}
  }

  List<dynamic> selectedHobbyList = [];

  RxBool isHeightInCM = true.obs;
  RxBool isWeightInKG = true.obs;

//SetupProfile variable
  GetSetUpProfileResponse? getSetupProfile;

//TextFields
  Rx<TextEditingController> profileDescController = TextEditingController().obs;
  final GlobalKey<FormState> formProfileDescKey = GlobalKey();

  Rx<TextEditingController> writeAboutDescController = TextEditingController().obs;
  final GlobalKey<FormState> formWriteAboutDescKey = GlobalKey();

  Rx<TextEditingController> heightController = TextEditingController().obs;
  final GlobalKey<FormState> formHeightKey = GlobalKey();

  Rx<TextEditingController> incomeController = TextEditingController().obs;
  Rx<TextEditingController> netWorthController = TextEditingController().obs;

  Rx<TextEditingController> weightController = TextEditingController().obs;
  final GlobalKey<FormState> formWeightKey = GlobalKey();
  SelectedStepsData? selectedSetupData = SelectedStepsData();

  String latitude = "";
  String longitude = "";
  RxInt uploadImageCount = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    addCustomIcon();
    getSetUpProfileAPI();
    pickedImageList.value = List.generate(6, (index) => File(""));

    selectedSetupData!.selectedWeightMeasurement = 1.toString();
    selectedSetupData!.selectedHeightMeasurement = 0.toString();

    steps = List.generate(
      (isUserSubscribe == true ? 9 : 7),
      (index) => SelectedStep(
        step: index,
        isSelected: index == 0 ? true : false,
      ),
    );
  }

  @override
  void dispose() {
    mapController = Completer();
    super.dispose();
  }

  //LOCATION PERMISSION
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      openSettingsDialog(Get.overlayContext!).then((value) {
        getCurrentPosition();
      });

      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        openSettingsDialog(Get.overlayContext!).then((value) {
          getCurrentPosition();
        });
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      openSettingsDialog(Get.overlayContext!).then((value) {
        getCurrentPosition();
      });
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      if (latitude == "") {
        currentPosition = position;
        center = LatLng(
          currentPosition!.latitude,
          currentPosition!.longitude,
        );

        ///STORE CURRENT LAT LONG
        SharedPref.setString(
          PreferenceConstants.currentLAT,
          currentPosition!.latitude.toString(),
        );
        SharedPref.setString(
          PreferenceConstants.currentLONG,
          currentPosition!.longitude.toString(),
        );

        latitude = currentPosition!.latitude.toString();
        longitude = currentPosition!.longitude.toString();
        handleTap(center!);
        _getAddressFromLatLng(
          LatLng(
            currentPosition!.latitude,
            currentPosition!.longitude,
          ),
        );
      } else {
        center = LatLng(
          double.parse(latitude),
          double.parse(longitude),
        );

        ///STORE CURRENT LAT LONG
        SharedPref.setString(
          PreferenceConstants.currentLAT,
          latitude.toString(),
        );
        SharedPref.setString(
          PreferenceConstants.currentLONG,
          longitude.toString(),
        );

        handleTap(center!);
        _getAddressFromLatLng(
          LatLng(
            double.parse(latitude),
            double.parse(longitude),
          ),
        );
        update();
      }
    }).catchError((Object e) async {});
  }

  Future<void> _getAddressFromLatLng(LatLng latLong) async {
    await placemarkFromCoordinates(latLong.latitude, latLong.longitude).then((List<Placemark> placeMarks) {
      selectedSetupData?.selectedLat = latLong.latitude.toString();
      selectedSetupData?.selectedLong = latLong.longitude.toString();

      Placemark place = placeMarks[0];
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
      selectedSetupData!.selectedAddress = currentAddress;
      update();
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void addCustomIcon() async {
    final Uint8List mapicon = await getBytesFromAsset(ImageConstants.icon_pin_png, Platform.isAndroid ? 80 : 130);
    markerIcon = BitmapDescriptor.fromBytes(mapicon);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
  }

  handleTap(LatLng point) {
    markers = [];
    markers.add(Marker(
      markerId: MarkerId(point.toString()),
      position: point,
      icon: markerIcon,
    ));
    _getAddressFromLatLng(
      LatLng(
        point.latitude,
        point.longitude,
      ),
    );
    latitude = point.latitude.toString();
    longitude = point.longitude.toString();

    update();
  }

//Get SETUP PROFILE API
  getSetUpProfileAPI() async {
    uploadImageCount.value = await SharedPref.getInt(PreferenceConstants.uploadImageCount);

    pickedImageList.value = List.generate(uploadImageCount.value, (index) => File(""));

    isUserSubscribe = await SharedPref.getBool(PreferenceConstants.isUserSubscribed);

    ApiResponse<GetSetUpProfileResponse>? response = await SetupProfileRepository().getSetupProfile();
    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      getSetupProfile = response.result;

      update();
    } else {
      hideLoader();
      showDialogBox(
        Get.overlayContext!,
        toLabelValue(response.message!),
      );
    }
  }

  //UPDATE SETUP PROFILE

  updateSetUpProfileAPI(String is_full_setupProfileData) async {
    if (selectedStepIndex.value == 7) {
      showLoader();
      String userID = await SharedPref.getString(PreferenceConstants.userID);
      ResponseModel? response = await SetupProfileRepository().updateSetupProfile(
          user_id: userID,
          about_yourself: writeAboutDescController.value.text,
          address: currentAddress,
          body_type: selectedBodyType.value,
          children: selectedSetupData?.selectedChildrenID,
          dating_type: selectedDatingType.value,
          diet_preference: selectedSetupData?.selectedDietPrefsID,
          drink: selectedSetupData?.selectedDrinkID,
          excerise: selectedSetupData?.selectedExerciseID,
          height: selectedSetupData?.height,
          height_measurment_type_id: selectedSetupData?.selectedHeightMeasurement,
          interested_in_id: selectedSetupData?.selectedInterestedInID,
          lat: selectedSetupData?.selectedLat,
          long: selectedSetupData?.selectedLong,
          selected_gender_id: selectedSetupData?.selectedGenderID,
          personality_type: selectedPersonalityType.value,
          profile_headline: selectedSetupData?.profileHeadline,
          selected_hobbies_id: selectedSetupData?.selectedHobbiesId!.join(","),
          selected_occupation_id: selectedOccupation.value,
          selected_relationship_status: selectedRelationshipStatus.value,
          star_sign: selectedStartSign.value,
          weight_measurment_type_id: selectedSetupData?.selectedWeightMeasurement,
          smoke: selectedSetupData?.selectedSmokeID,
          weight: selectedSetupData?.weight,
          image_name: selectedSetupData?.selectedImages?.join(","),
          income: selectedSetupData?.income,
          networth: selectedSetupData?.netWorth,
          own_car: selectedSetupData?.selectedCarYouOwnID,
          is_full_setupProfile: "0");
      if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
        SharedPref.setBool(PreferenceConstants.setupProfileDone, true);
        isUserSubscribe == true
            ? Get.to(
                ScreenSuccessProfileSetUP(
                  title: StringConstants.awesome,
                  subTitle: "",
                  subDescription: StringConstants.your_profile_looks_ready,
                  btnTitle: StringConstants.discover,
                ),
              )
            : Get.to(
                ScreenSuccessProfileSetUP(
                  title: StringConstants.your_profile_setup,
                  subDescription: StringConstants.subscribe_desc,
                  subTitle: StringConstants.subscribe_to_get_more_matches,
                  btnTitle: StringConstants.subscribe_now,
                ),
              );
        hideLoader();
        update();
      } else {
        hideLoader();
        showDialogBox(
          Get.overlayContext!,
          toLabelValue(response.message!),
        );
      }
    } else {
      showLoader();
      selectedSetupData?.selectedImages = [];
      if (pickedImageList.isNotEmpty) {
        var count = pickedImageList.where((element) => element.path != "");
        debugPrint("====== ${count.length}");

        for (var image in pickedImageList) {
          uploadS3Image(File(image.path)).then((value) async {
            debugPrint("success => $value");
            selectedSetupData?.selectedImages!.add(value.split("/").last);

            if (count.length == selectedSetupData?.selectedImages?.length) {
              showLoader();
              String userID = await SharedPref.getString(PreferenceConstants.userID);
              ResponseModel? response = await SetupProfileRepository().updateSetupProfile(
                  user_id: userID,
                  about_yourself: writeAboutDescController.value.text,
                  address: currentAddress,
                  body_type: selectedBodyType.value,
                  children: selectedSetupData?.selectedChildrenID,
                  dating_type: selectedDatingType.value,
                  diet_preference: selectedSetupData?.selectedDietPrefsID,
                  drink: selectedSetupData?.selectedDrinkID,
                  excerise: selectedSetupData?.selectedExerciseID,
                  height: selectedSetupData?.height,
                  height_measurment_type_id: selectedSetupData?.selectedHeightMeasurement,
                  interested_in_id: selectedSetupData?.selectedInterestedInID,
                  lat: selectedSetupData?.selectedLat,
                  long: selectedSetupData?.selectedLong,
                  selected_gender_id: selectedSetupData?.selectedGenderID,
                  personality_type: selectedPersonalityType.value,
                  profile_headline: selectedSetupData?.profileHeadline,
                  selected_hobbies_id: selectedSetupData?.selectedHobbiesId!.join(","),
                  selected_occupation_id: selectedOccupation.value,
                  selected_relationship_status: selectedRelationshipStatus.value,
                  star_sign: selectedStartSign.value,
                  weight_measurment_type_id: selectedSetupData?.selectedWeightMeasurement,
                  smoke: selectedSetupData?.selectedSmokeID,
                  weight: selectedSetupData?.weight,
                  image_name: selectedSetupData?.selectedImages?.join(","),
                  income: selectedSetupData?.income,
                  networth: selectedSetupData?.netWorth,
                  own_car: selectedSetupData?.selectedCarYouOwnID,
                  is_full_setupProfile: "1");
              if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
                SharedPref.setBool(PreferenceConstants.setupProfileDone, true);
                isUserSubscribe == true
                    ? Get.to(
                        ScreenSuccessProfileSetUP(
                          title: StringConstants.awesome,
                          subTitle: "",
                          subDescription: StringConstants.your_profile_looks_ready,
                          btnTitle: StringConstants.discover,
                        ),
                      )
                    : Get.to(
                        ScreenSuccessProfileSetUP(
                          title: StringConstants.your_profile_setup,
                          subDescription: StringConstants.subscribe_desc,
                          subTitle: StringConstants.subscribe_to_get_more_matches,
                          btnTitle: StringConstants.subscribe_now,
                        ),
                      );
                hideLoader();
                update();
              } else {
                hideLoader();
                showDialogBox(
                  Get.overlayContext!,
                  toLabelValue(response.message!),
                );
              }
            }
          });
        }
      } else {
        hideLoader();
      }
    }

    debugPrint("--=======");
  }

//CHECK VALIDATIONS

  validateSetupProfile() {
    if (selectedStepIndex.value == 1) {
      //Validate Step 1
      if (selectedSetupData!.selectedGenderID == null) {
        showSnackBar(Get.overlayContext,
            "${toLabelValue(StringConstants.please_select)} ${toLabelValue(StringConstants.gender)}");
      } else if (selectedSetupData!.selectedInterestedInID == null) {
        showSnackBar(Get.overlayContext,
            "${toLabelValue(StringConstants.please_select)} ${toLabelValue(StringConstants.interested_in)}");
      } else {
        changeStepIndex();
      }
    } else if (selectedStepIndex.value == 2) {
      //Validate Step 2

      String isProfileHeadlineValidate =
          Validator.blankValidation(profileDescController.value.text, StringConstants.profile_headline);

      if (isProfileHeadlineValidate != "") {
        showSnackBar(Get.overlayContext, isProfileHeadlineValidate);
      } else {
        changeStepIndex();
      }
    } else if (selectedStepIndex.value == 3) {
      //Validate Step 3

      String isAboutSelfValidate =
          Validator.blankValidation(writeAboutDescController.value.text, StringConstants.abou_myself);

      if (isAboutSelfValidate != "") {
        showSnackBar(Get.overlayContext, isAboutSelfValidate);
      } else {
        changeStepIndex();
      }
    } else if (selectedStepIndex.value == 4) {
      //Validate Step 4

      String isHeightValidate = Validator.blankValidation(heightController.value.text, StringConstants.height);
      String isWeightValidate = Validator.blankValidation(weightController.value.text, StringConstants.weight);

      if (isHeightValidate != "") {
        showSnackBar(Get.overlayContext, isHeightValidate);
      } else if (isWeightValidate != "") {
        showSnackBar(Get.overlayContext, isWeightValidate);
      } else {
        changeStepIndex();
      }
    } else if (selectedStepIndex.value == 5) {
      if (selectedSetupData!.selectedHobbiesId == null || selectedSetupData!.selectedHobbiesId!.isEmpty) {
        showSnackBar(Get.overlayContext,
            "${toLabelValue(StringConstants.please_select)} ${toLabelValue(StringConstants.hobbies)}.");
      } else {
        changeStepIndex();
      }
      //Validate Step 5
    } else if (selectedStepIndex.value == 6) {
      if (selectedSetupData!.selectedOccupationID == null) {
        showSnackBar(Get.overlayContext,
            "${toLabelValue(StringConstants.please_select)} ${toLabelValue(StringConstants.occupation)}.");
      } else if (selectedSetupData!.selectedRelationShipID == null) {
        showSnackBar(Get.overlayContext,
            "${toLabelValue(StringConstants.please_select)} ${toLabelValue(StringConstants.relationship_status)}.");
      } else if (selectedSetupData!.selectedChildrenID == null) {
        showSnackBar(Get.overlayContext,
            "${toLabelValue(StringConstants.please_select)} ${toLabelValue(StringConstants.children)} ${toLabelValue(StringConstants.option)}.");
      } else if (selectedSetupData!.selectedDietPrefsID == null) {
        showSnackBar(Get.overlayContext,
            "${toLabelValue(StringConstants.please_select)} ${toLabelValue(StringConstants.diet_preference)}.");
      } else if (selectedSetupData!.selectedStartSignID == null) {
        showSnackBar(Get.overlayContext,
            "${toLabelValue(StringConstants.please_select)} ${toLabelValue(StringConstants.star_sign)}.");
      } else if (selectedSetupData!.selectedSmokeID == null) {
        showSnackBar(Get.overlayContext,
            "${toLabelValue(StringConstants.please_select)} ${toLabelValue(StringConstants.smoke)} ${toLabelValue(StringConstants.option)}");
      } else if (selectedSetupData!.selectedDrinkID == null) {
        showSnackBar(Get.overlayContext,
            "${toLabelValue(StringConstants.please_select)} ${toLabelValue(StringConstants.drink)} ${toLabelValue(StringConstants.option)}");
      } else if (selectedSetupData!.selectedExerciseID == null) {
        showSnackBar(Get.overlayContext,
            "${toLabelValue(StringConstants.please_select)}  ${toLabelValue(StringConstants.exercise)} ${toLabelValue(StringConstants.option)}");
      } else if (selectedSetupData!.selectedPersonalityTypeID == null) {
        showSnackBar(Get.overlayContext,
            "${toLabelValue(StringConstants.please_select)} ${toLabelValue(StringConstants.personality_type)}.");
      } else if (selectedSetupData!.selectedBodyTypeID == null) {
        showSnackBar(Get.overlayContext,
            "${toLabelValue(StringConstants.please_select)} ${toLabelValue(StringConstants.body_type)}.");
      } else {
        changeStepIndex();
        mapController = Completer();
        getCurrentPosition();
      }
    } else if (selectedStepIndex.value == 7) {
      showLoader();
      Future.delayed(
        const Duration(seconds: 1),
        () {
          if (isUserSubscribe == false) {
            updateSetUpProfileAPI("0");
          } else {
            mapController = Completer();
            changeStepIndex();
          }
          hideLoader();
        },
      );
    } else if (selectedStepIndex.value == 8) {
      if (selectedSetupData!.selectedImages == null || selectedSetupData!.selectedImages!.isEmpty) {
        showSnackBar(
          Get.overlayContext,
          toLabelValue(StringConstants.add_2_images),
        );
      } else {
        changeStepIndex();
      }
    }
  }

  changeStepIndex() {
    addCustomIcon();
    steps[selectedStepIndex.value].isSelected = true;
    selectedStepIndex.value += 1;
    update();
  }
}

class GenderOption {
  String? id;
  String? name;

  GenderOption({
    this.id,
    this.name,
  });
}

class SelectedStep {
  int? step;
  bool? isSelected;

  SelectedStep({
    this.step,
    this.isSelected,
  });
}

class SelectedStepsData {
  String? selectedGenderID;
  String? selectedInterestedInID;
  String? profileHeadline;
  String? aboutYourself;
  String? selectedHeightMeasurement;
  String? selectedWeightMeasurement;
  String? height;
  String? weight;
  List<String>? selectedHobbiesId;
  String? selectedOccupationID;
  String? selectedRelationShipID;
  String? selectedChildrenID;
  String? selectedDietPrefsID;
  String? selectedStartSignID;
  String? selectedSmokeID;
  String? selectedDrinkID;
  String? selectedExerciseID;
  String? selectedPersonalityTypeID;
  String? selectedBodyTypeID;
  String? selectedLat;
  String? selectedLong;
  String? selectedAddress;

  //optional
  List<String>? selectedImages;
  String? income;
  String? netWorth;
  String? selectedCarYouOwnID;
  String? selectedDatingTypeID;
  String? selectedDatingGroupID;
  String? selectedEthniCity;
  String? cast;
  String? politicalLeaning;
  String? religiousView;

  SelectedStepsData({
    this.selectedGenderID,
    this.selectedInterestedInID,
    this.profileHeadline,
    this.aboutYourself,
    this.selectedHeightMeasurement,
    this.selectedWeightMeasurement,
    this.height,
    this.weight,
    this.selectedHobbiesId,
    this.selectedOccupationID,
    this.selectedRelationShipID,
    this.selectedChildrenID,
    this.selectedDietPrefsID,
    this.selectedStartSignID,
    this.selectedSmokeID,
    this.selectedDrinkID,
    this.selectedExerciseID,
    this.selectedLat,
    this.selectedLong,
    this.selectedAddress,
    this.selectedImages,
    this.income,
    this.netWorth,
    this.selectedPersonalityTypeID,
    this.selectedBodyTypeID,
    this.selectedCarYouOwnID,
    this.selectedDatingTypeID,
    this.selectedDatingGroupID,
    this.cast,
    this.politicalLeaning,
    this.religiousView,
    this.selectedEthniCity,
  });
}
