import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/edit_profile.dart';
import 'package:dating_app/src/model/profile/profile_model.dart';

class ProfileRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<ProfileResponse>?> getProfile() async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;

    final response = await _helper.post(APIConstants.get_profile_endpoint,
        formdata: _helper.body);

    ApiResponse<ProfileResponse>? data =
        ApiResponse.fromJson(response, (result) {
      return ProfileResponse.fromJson(result);
    });
    return data;
  }

  Future<ApiResponse<EditProfileResponse>?> getEditProfile() async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;

    final response = await _helper.post(
        APIConstants.get_edit_profile_data_endpoint,
        formdata: _helper.body);

    ApiResponse<EditProfileResponse>? data =
        ApiResponse.fromJson(response, (result) {
      return EditProfileResponse.fromJson(result);
    });
    return data;
  }

  Future<ResponseModel?> updateEditProfile(
      {String? profile_headline,
      aboutmyself,
      genderID,
      interestedGenderID,
      dob,
      location,
      lat,
      long,
      relatioshipstatus,
      childrenID,
      height,
      heightMeasurementID,
      weight,
      weightMeasurementID,
      occupationID,
      dietprefs,
      starsign,
      smokeID,
      drinkID,
      exerciseID,
      personalitytypeID,
      bodyTypeID,
      datingPersonAgegroup,
      income,
      selectedHobbies,
      ownCarID,
      datingTypeID,
      ethiicityID,
      politicalLeaningID,
      castID,
      networth,
      religiousViewID}) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body["profile_headline"] = profile_headline;
    _helper.body["about_myself"] = aboutmyself;
    _helper.body["genderID"] = genderID;
    _helper.body["interested_genderID"] = interestedGenderID;
    _helper.body["dob"] = dob;
    _helper.body["location"] = location;
    _helper.body["long"] = long;
    _helper.body["lat"] = lat;
    _helper.body["relationship_status"] = relatioshipstatus;
    _helper.body["children"] = childrenID;
    _helper.body["height_measurment_type_id"] = heightMeasurementID;
    _helper.body["height"] = height;
    _helper.body["weight_measurment_type_id"] = weightMeasurementID;
    _helper.body["weight"] = weight;
    _helper.body["occupation"] = occupationID;
    _helper.body["diet_preference"] = dietprefs;

    _helper.body["start_sign"] = starsign;
    _helper.body["smoke"] = smokeID;
    _helper.body["drink"] = drinkID;
    _helper.body["exercise"] = exerciseID;
    _helper.body["personality_type"] = personalitytypeID;
    _helper.body["body_type"] = bodyTypeID;
    _helper.body["dating_person_age_group"] = datingPersonAgegroup;
    _helper.body["income"] = income;
    _helper.body["selected_hobbies"] = selectedHobbies;
    _helper.body["own_car"] = ownCarID;
    _helper.body["dating_type"] = datingTypeID;
    _helper.body["ethinicity"] = ethiicityID;
    _helper.body["political_leaning"] = politicalLeaningID;
    _helper.body["cast"] = castID;
    _helper.body['net_worth'] = networth;
    _helper.body["religiousview"] = religiousViewID;

    final response = await _helper.post(
        APIConstants.update_edit_profile_endpoint,
        formdata: _helper.body);

    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }

  Future<ResponseModel?> hideProfile(bool isProfileHide) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body['is_profiel_hide'] = isProfileHide ? "1" : "0";

    final response = await _helper.post(APIConstants.hide_profile_endpoint,
        formdata: _helper.body);
    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }

  Future<ResponseModel?> updateProfileImage(String imagename) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body['images'] = imagename;

    final response = await _helper.post(
        APIConstants.upload_profile_image_endpont,
        formdata: _helper.body);
    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }
}
