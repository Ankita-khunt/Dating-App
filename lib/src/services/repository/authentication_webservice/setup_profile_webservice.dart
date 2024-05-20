import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/authentication/setup_profile_model.dart';

class SetupProfileRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

//GET SETUP Profile

  Future<ApiResponse<GetSetUpProfileResponse>?> getSetupProfile() async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    final response = await _helper.get("${APIConstants.get_set_up_profile_endpoint}?user_id=$userID&token=$token");
    ApiResponse<GetSetUpProfileResponse>? data = ApiResponse.fromJson(response, (result) {
      return GetSetUpProfileResponse.fromJson(result);
    });
    return data;
  }

//UPDATE SETUP Profile
  Future<ResponseModel?> updateSetupProfile(
      {String? user_id,
      selected_gender_id,
      interested_in_id,
      profile_headline,
      about_yourself,
      height_measurment_type_id,
      height,
      weight_measurment_type_id,
      selected_hobbies_id,
      selected_occupation_id,
      selected_relationship_status,
      children,
      diet_preference,
      smoke,
      drink,
      excerise,
      personality_type,
      body_type,
      lat,
      long,
      income,
      networth,
      own_car,
      dating_type,
      image_name,
      weight,
      star_sign,
      address,
      is_full_setupProfile}) async {
    bool isUserSubscribe = await SharedPref.getBool(PreferenceConstants.isUserSubscribed);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["token"] = token;
    _helper.body["user_id"] = user_id;
    _helper.body["selected_gender_id"] = selected_gender_id;
    _helper.body["interested_in_id"] = interested_in_id;
    _helper.body["profile_headline"] = profile_headline;
    _helper.body["about_yourself"] = about_yourself;
    _helper.body["height_measurment_type_id"] = height_measurment_type_id;
    _helper.body["height"] = height;
    _helper.body["weight_measurment_type_id"] = weight_measurment_type_id;
    _helper.body["weight"] = weight;
    _helper.body["selected_hobbies_id"] = selected_hobbies_id;
    _helper.body["selected_occupation_id"] = selected_occupation_id;
    _helper.body["selected_relationship_status"] = selected_relationship_status;
    _helper.body["children"] = children;
    _helper.body["diet_preference"] = diet_preference;
    _helper.body["smoke"] = smoke;
    _helper.body["drink"] = drink;
    _helper.body["excerise"] = excerise;
    _helper.body["personality_type"] = personality_type;
    _helper.body["body_type"] = body_type;
    _helper.body["lat"] = lat;
    _helper.body["long"] = long;
    _helper.body["address"] = address;
    _helper.body["star_sign"] = star_sign;
    _helper.body["is_full_setupProfile"] = is_full_setupProfile;

    //OPTIONAL if User SUBSCRIBED

    if (isUserSubscribe == true) {
      _helper.body["income"] = income;
      _helper.body["networth"] = networth;
      _helper.body["own_car"] = own_car;
      _helper.body["dating_type"] = dating_type;
      if (image_name != null && image_name != "") {
        _helper.body["image_name"] = image_name;
      }
    } else {}
    final response = await _helper.post(APIConstants.update_setup_profile_endpoint, formdata: _helper.body);

    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }
}
