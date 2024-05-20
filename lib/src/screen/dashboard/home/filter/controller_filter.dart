import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/authentication/setup_profile_model.dart';
import 'package:dating_app/src/model/dashboard/user_detail_model.dart';
import 'package:dating_app/src/model/label_model/common_chip_model.dart';
import 'package:dating_app/src/model/profile/edit_profile.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/binding_card_swipe.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/controller_card_swipe.dart';
import 'package:dating_app/src/services/repository/authentication_webservice/setup_profile_webservice.dart';
import 'package:dating_app/src/services/repository/profile_webservice/profile_webservice.dart';
import 'package:dating_app/src/widgets/card_swipe/swipable_stack.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ControllerFilter extends GetxController {
  GetSetUpProfileResponse? getSetupProfile;
  RxBool isDataLoaded = false.obs;
  EditProfileResponse? editProfileResponse;

  String? selectedValue;
  SelectedFilter selectedFilterOption = SelectedFilter();
  RxList<ChipModel> booleanList = [
    ChipModel(
      id: "1",
      name: toLabelValue(StringConstants.yes),
    ),
    ChipModel(
      id: "0",
      name: toLabelValue(StringConstants.no),
    )
  ].obs;

  SfRangeValues values = const SfRangeValues(4.0, 8.0);

  RxDouble locationRange = 0.0.obs;
  RxDouble minIncome = 0.0.obs;
  RxDouble maxIncome = 0.0.obs;
  RxDouble minNetWorth = 0.0.obs;
  RxDouble maxNetWorth = 0.0.obs;

  RxBool isHeightinCM = true.obs;
  RxBool isWeightinKG = true.obs;

//selected Filter IDs
  String? occupationID;
  String? ethinicityID;
  String? castID;
  String? locationrange;
  String? hobbies;

  String? carYouOwnID;
  String? selectedHeight;
  String? selectedWeight;
  String? maritalStatusID;
  String? datingAgeGroupID;

  String? childrenID;
  String? dating_group_id;
  String? datingTYpeID;
  String? dietPrefsID;
  String? startSignID;
  String? politicalLeaningID;
  String? smokeID;
  String? drinkID;
  String? exerciseID;
  String? religiousViewID;
  String? personalityTYpeID;
  String? bodyTypeID;

  //
  Rxn<dynamic> selectedCarOwn = Rxn<dynamic>();
  Rxn<dynamic> selectedChildren = Rxn<dynamic>();
  Rxn<dynamic> selectedDiet = Rxn<dynamic>();
  Rxn<dynamic> selectedSmock = Rxn<dynamic>();
  Rxn<dynamic> selectedDrink = Rxn<dynamic>();
  Rxn<dynamic> selectedExercise = Rxn<dynamic>();

//
  Rx<TextEditingController> heightController = TextEditingController().obs;
  final GlobalKey<FormState> formpheightKey = GlobalKey();

  Rx<TextEditingController> weightController = TextEditingController().obs;
  final GlobalKey<FormState> formweightKey = GlobalKey();
  UserDetailResponse? userdata;

  List<ProfileFieldResponse> selectedHobbyList = [];
  RxList<String> arrSelectedHobbyName = <String>[].obs;
  RxList<String> arrSelectedHobbyID = <String>[].obs;

//Get filter  API
  getSetUpProfileAPI() async {
    showLoader();
    ApiResponse<GetSetUpProfileResponse>? response = await SetupProfileRepository().getSetupProfile();
    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      getSetupProfile = response.result;
      minIncome.value = double.parse(getSetupProfile!.minIncome.toString());
      maxIncome.value = double.parse(getSetupProfile!.maxIncome.toString());
      minNetWorth.value = double.parse(getSetupProfile!.minNetworth.toString());
      maxNetWorth.value = double.parse(getSetupProfile!.maxNetworth.toString());
      locationRange.value = double.parse(getSetupProfile?.maxLocationRange ?? "0");
      selectedFilterOption = SelectedFilter();

      getAlreadySetUpData();

      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }

  Future<void> getAlreadySetUpData() async {
    selectedHobbyList = [];
    ApiResponse<EditProfileResponse>? response = await ProfileRepository().getEditProfile();

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      editProfileResponse = response.result;

//Height
      heightController.value.text = editProfileResponse!.userSelectedData!.height!;
      selectedFilterOption.height = editProfileResponse!.userSelectedData!.height!;
      //Weight
      weightController.value.text = editProfileResponse!.userSelectedData!.weight!;
      selectedFilterOption.weight = editProfileResponse!.userSelectedData!.weight!;

      //height measurement
      isHeightinCM.value = editProfileResponse!.userSelectedData!.heightMeasurementType == "0" ? true : false;
      selectedFilterOption.selected_heightMeasurement = isHeightinCM.value ? "0" : "1";

//weight measurement
      isWeightinKG.value = editProfileResponse!.userSelectedData!.weightMeasurementType == "1" ? true : false;
      selectedFilterOption.selected_weight_measurement = isWeightinKG.value ? "1" : "0";

      selectedHeight = editProfileResponse!.userSelectedData!.height;
      selectedWeight = editProfileResponse!.userSelectedData!.weight;

      selectedFilterOption.max_income = maxIncome.value.toString();
      selectedFilterOption.max_networth = maxNetWorth.value.toString();

      //ETHINICITY
      if (editProfileResponse!.userSelectedData!.ethinicity!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.ethinicity != "0") {
        ethinicityID = getSetupProfile!.ethnicity!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.ethinicity.toString())
            .name;
        selectedFilterOption.selected_ethinicity = editProfileResponse?.userSelectedData?.ethinicity.toString();
      }
      //MARITAL STATUS
      if (editProfileResponse!.userSelectedData!.relationshipStatus!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.relationshipStatus! != "0") {
        maritalStatusID = getSetupProfile!.maritalStatus!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.relationshipStatus.toString())
            .name;
        selectedFilterOption.marital_status = editProfileResponse?.userSelectedData?.relationshipStatus.toString();
      }

      //DATING PERSON AGE GROUP
      if (editProfileResponse!.userSelectedData!.datingPersonAgeGroup!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.datingPersonAgeGroup! != "0") {
        datingAgeGroupID = getSetupProfile!.datingGroup!
            .firstWhere(
                (element) => element.id == editProfileResponse?.userSelectedData?.datingPersonAgeGroup.toString())
            .name;
        selectedFilterOption.selected_DatingGroupID =
            editProfileResponse?.userSelectedData?.datingPersonAgeGroup.toString();
      }

      //POLITICAL LEANING
      if (editProfileResponse!.userSelectedData!.politicalLeaning!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.politicalLeaning! != "0") {
        politicalLeaningID = getSetupProfile!.politicalLeaningTypes!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.politicalLeaning.toString())
            .name;
        selectedFilterOption.politicalLeaning = editProfileResponse?.userSelectedData?.politicalLeaning.toString();
      }

      //RELIGIOUS VIEW
      if (editProfileResponse!.userSelectedData!.religeousView!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.religeousView! != "0") {
        religiousViewID = getSetupProfile!.religiousViews!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.religeousView.toString())
            .name;
        selectedFilterOption.religiousView = editProfileResponse?.userSelectedData?.religeousView.toString();
      }

      //OCCUPAATION
      if (editProfileResponse!.userSelectedData!.occupation!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.occupation! != "0") {
        occupationID = getSetupProfile!.occupation!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.occupation.toString())
            .name;
        selectedFilterOption.selected_occupationID = editProfileResponse?.userSelectedData?.occupation.toString();
      }
      if (editProfileResponse!.userSelectedData!.cast!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.cast! != "0") {
        castID = getSetupProfile?.cast!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.cast.toString())
            .name;
      }

      selectedFilterOption.cast = editProfileResponse?.userSelectedData?.cast.toString();
      // CarYouOwn
      if (editProfileResponse!.userSelectedData!.carYouOwn!.isNotEmpty) {
        selectedCarOwn.value = booleanList
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.carYouOwn.toString());
        selectedFilterOption.selected_CarYouOwnID = editProfileResponse?.userSelectedData?.carYouOwn.toString();
      }

      //Children
      if (editProfileResponse!.userSelectedData!.children!.isNotEmpty) {
        selectedChildren.value = booleanList
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.children.toString());
        selectedFilterOption.selected_childrenID = editProfileResponse?.userSelectedData?.children.toString();
      }

      //dietPreference
      if (editProfileResponse!.userSelectedData!.dietPreference!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.dietPreference! != "0") {
        selectedDiet.value = getSetupProfile!.diePreference!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.dietPreference.toString());
        selectedFilterOption.selected_DietPrefsID = editProfileResponse?.userSelectedData?.dietPreference.toString();
      }
      //DATINGTYPE
      if (editProfileResponse!.userSelectedData!.datingType!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.datingType! != "0") {
        datingTYpeID = getSetupProfile!.datingType!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.datingType.toString())
            .name;
        selectedFilterOption.selected_DatingTypeID = editProfileResponse?.userSelectedData?.datingType.toString();
      }

      //STARTSIGN
      if (editProfileResponse!.userSelectedData!.startSign!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.startSign! != "0") {
        startSignID = getSetupProfile!.starSign!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.startSign.toString())
            .name;
        selectedFilterOption.selected_StartSignID = editProfileResponse?.userSelectedData?.startSign.toString();
      }

//SMOKE
      if (editProfileResponse!.userSelectedData!.smoke!.isNotEmpty) {
        selectedSmock.value =
            booleanList.firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.smoke.toString());
        selectedFilterOption.selected_SmokeID = editProfileResponse?.userSelectedData?.smoke.toString();
      }

      //Drink
      if (editProfileResponse!.userSelectedData!.drink!.isNotEmpty) {
        selectedDrink.value =
            booleanList.firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.drink.toString());
        selectedFilterOption.selected_DrinkID = editProfileResponse?.userSelectedData?.drink.toString();
      }
      //Exercise
      if (editProfileResponse!.userSelectedData!.exercise!.isNotEmpty) {
        selectedExercise.value = booleanList
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.exercise.toString());
        selectedFilterOption.selected_ExerciseID = editProfileResponse?.userSelectedData?.exercise.toString();
      }

//PersonalityType
      if (editProfileResponse!.userSelectedData!.personalityType!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.personalityType! != "0") {
        personalityTYpeID = getSetupProfile!.personalityType!
            .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.personalityType.toString())
            .name;
        selectedFilterOption.selected_PersonalityTYpeID = editProfileResponse?.userSelectedData?.personalityType;
      }

      //BodyType
      if (editProfileResponse!.userSelectedData!.bodyType!.isNotEmpty &&
          editProfileResponse!.userSelectedData!.bodyType != "0") {
        bodyTypeID = getSetupProfile!.bodyType!
                .firstWhere((element) => element.id == editProfileResponse?.userSelectedData?.bodyType.toString())
                .name ??
            "";
        selectedFilterOption.selected_BodyTypeID = editProfileResponse?.userSelectedData?.bodyType;
      }
//Hobbies
      for (var element in editProfileResponse!.userSelectedData!.hobbies!) {
        selectedHobbyList.add(element);
      }

      arrSelectedHobbyName.value = List.generate(selectedHobbyList.length, (index) => selectedHobbyList[index].name!);
      arrSelectedHobbyID.value = List.generate(selectedHobbyList.length, (index) => selectedHobbyList[index].id!);
      hobbies = arrSelectedHobbyID.join(",");
      selectedFilterOption.selected_hobbies_id = hobbies;
      hideLoader();
      isDataLoaded(true);
      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    update();
    // hideLoader();
  }

  applyFilter() {
    selectedFilterOption.loactionRange = locationRange.value != 0.0 ? locationRange.value.toString() : "";
    selectedFilterOption.selected_hobbies_id = hobbies ?? "";
    selectedFilterOption.min_income = minIncome.value != 0.0 ? minIncome.value.toString() : "";
    selectedFilterOption.max_income = maxIncome.value != 0.0 ? maxIncome.value.toString() : "";
    selectedFilterOption.min_networth = minNetWorth.value != 0.0 ? minNetWorth.value.toString() : "";
    selectedFilterOption.max_networth = maxNetWorth.value != 0.0 ? maxNetWorth.value.toString() : "";
    selectedFilterOption.selected_childrenID = childrenID ?? selectedChildren.value.id;
    selectedFilterOption.selected_DietPrefsID = dietPrefsID ?? selectedDiet.value.id;
    selectedFilterOption.selected_SmokeID = smokeID ?? selectedSmock.value.id;
    selectedFilterOption.selected_DrinkID = drinkID ?? selectedDrink.value.id;

    selectedFilterOption.selected_ExerciseID = exerciseID ?? selectedExercise.value.id;
    selectedFilterOption.selected_CarYouOwnID =
        carYouOwnID ?? ((selectedCarOwn.value != null) ? selectedCarOwn.value.id : "");
    selectedFilterOption.height = heightController.value.text;
    selectedFilterOption.weight = weightController.value.text;
    selectedFilterOption.selected_heightMeasurement = isHeightinCM.value ? "0" : "1";
    selectedFilterOption.selected_weight_measurement = isWeightinKG.value ? "1" : "0";

    selectedFilterOption.marital_status = maritalStatusID != null
        ? getSetupProfile!.maritalStatus!.where((element) => element.name == maritalStatusID).first.id ?? ""
        : "";

    selectedFilterOption.selected_StartSignID = startSignID != null
        ? getSetupProfile!.starSign!.where((element) => element.name == startSignID).first.id ?? ""
        : "";

    selectedFilterOption.selected_ethinicity = ethinicityID != null
        ? getSetupProfile!.ethnicity!.where((element) => element.name == ethinicityID).first.id ?? ""
        : "";

    selectedFilterOption.selected_occupationID = occupationID != null
        ? getSetupProfile!.occupation!.where((element) => element.name == occupationID).first.id ?? ""
        : "";
    selectedFilterOption.cast =
        castID != null ? getSetupProfile!.cast!.where((element) => element.name == castID).first.id ?? "" : "";
    selectedFilterOption.selected_DatingTypeID = datingTYpeID != null
        ? getSetupProfile!.datingType!.where((element) => element.name == datingTYpeID).first.id ?? ""
        : "";
    selectedFilterOption.selected_DatingGroupID = datingAgeGroupID != null
        ? getSetupProfile!.datingGroup!.where((element) => element.name == datingAgeGroupID).first.id ?? ""
        : "";
    selectedFilterOption.religiousView = religiousViewID != null
        ? getSetupProfile!.religiousViews!.where((element) => element.name == religiousViewID).first.id ?? ""
        : "";
    selectedFilterOption.selected_PersonalityTYpeID = personalityTYpeID != null
        ? getSetupProfile!.personalityType!.where((element) => element.name == personalityTYpeID).first.id ?? ""
        : "";
    selectedFilterOption.politicalLeaning = politicalLeaningID != null
        ? getSetupProfile!.politicalLeaningTypes!.where((element) => element.name == politicalLeaningID).first.id ?? ""
        : "";

    selectedFilterOption.selected_BodyTypeID = bodyTypeID != null
        ? getSetupProfile!.bodyType!.where((element) => element.name == bodyTypeID).first.id ?? ""
        : "";

    Get.back();

    BindingCard().dependencies();
    Get.find<ControllerCard>().isDataLoaded.value = false;
    Get.find<ControllerCard>().selectedFilterOption = selectedFilterOption;
    Get.find<ControllerCard>().swipeCardController = SwipableStackController()
      ..addListener(Get.find<ControllerCard>().listenController);
    Get.find<ControllerCard>().isDataLoaded.value = false;
    Get.find<ControllerCard>().pageIndex.value = 1;
    Get.find<ControllerCard>().cardlist = [];
    Get.find<ControllerCard>().userCardAPI();
  }
}

class SelectedFilter {
  String? selected_heightMeasurement;
  String? selected_weight_measurement;
  String? height;
  String? weight;
  String? loactionRange;
  String? selected_hobbies_id;
  String? selected_occupationID;
  String? selected_childrenID;
  String? selected_DietPrefsID;
  String? marital_status;
  String? selected_StartSignID;
  String? selected_SmokeID;
  String? selected_DrinkID;
  String? selected_ExerciseID;
  String? selected_PersonalityTYpeID;
  String? selected_BodyTypeID;

  //optional
  String? min_income;
  String? max_income;
  String? min_networth;
  String? max_networth;
  String? selected_CarYouOwnID;
  String? selected_DatingTypeID;
  String? selected_DatingGroupID;
  String? selected_ethinicity;
  String? cast;
  String? politicalLeaning;
  String? religiousView;

  SelectedFilter(
      {this.selected_heightMeasurement,
      this.selected_weight_measurement,
      this.height,
      this.weight,
      this.marital_status,
      this.loactionRange,
      this.selected_hobbies_id,
      this.selected_occupationID,
      this.selected_childrenID,
      this.selected_DietPrefsID,
      this.selected_StartSignID,
      this.selected_SmokeID,
      this.selected_DrinkID,
      this.selected_ExerciseID,
      this.max_income,
      this.max_networth,
      this.min_income,
      this.min_networth,
      this.selected_PersonalityTYpeID,
      this.selected_BodyTypeID,
      this.selected_CarYouOwnID,
      this.selected_DatingTypeID,
      this.selected_DatingGroupID,
      this.cast,
      this.politicalLeaning,
      this.religiousView,
      this.selected_ethinicity});
}
