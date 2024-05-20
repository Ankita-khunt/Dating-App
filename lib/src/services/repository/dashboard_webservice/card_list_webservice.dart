import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/dashboard/cardlist_model.dart';

class UserCardRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<CardListResponse>?> cardlist(
      {String? lat,
      long,
      pageIndex,
      ethinicity,
      occupation,
      height_measurment_type_id,
      height,
      weight_measurment_type_id,
      weight,
      cast,
      own_car,
      dating_type,
      selectedhobbiewIDs,
      marital_status,
      children,
      diet_prefs,
      political_leaning,
      star_sign,
      smoke,
      drink,
      exercise,
      locationRange,
      personality_type,
      dating_group_id,
      bodytype,
      religiousview,
      min_income,
      max_income,
      min_networth,
      max_networth}) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);
    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;

    _helper.body["lat"] = lat;
    _helper.body["long"] = long;
    _helper.body["ethinicity"] = ethinicity;

    //need to add location range parameter,body_type_religiousview
    _helper.body['location_range'] = locationRange;
    _helper.body['body_type'] = bodytype;
    _helper.body['religious_view'] = religiousview;
    _helper.body["occupation"] = occupation;
    _helper.body["height_measurment_type_id"] = height_measurment_type_id;
    _helper.body["height"] = height;
    _helper.body["weight_measurment_type_id"] = weight_measurment_type_id;
    _helper.body["weight"] = weight;
    _helper.body["cast"] = cast;
    _helper.body["own_car"] = own_car;
    _helper.body["dating_type"] = dating_type;
    _helper.body["selected_hobbies_id"] = selectedhobbiewIDs;
    _helper.body["marital_status"] = marital_status;
    _helper.body["children"] = children;
    _helper.body["diet_preference"] = diet_prefs;
    _helper.body["political_leaning"] = political_leaning;
    _helper.body["start_sign"] = star_sign;
    _helper.body["smoke"] = smoke;
    _helper.body["drink"] = drink;
    _helper.body["exercise"] = exercise;
    _helper.body["personality_type"] = personality_type;
    _helper.body["dating_group_id"] = dating_group_id;
    _helper.body["min_income"] = min_income;
    _helper.body["max_income"] = max_income;
    _helper.body["min_networth"] = min_networth;
    _helper.body["max_networth"] = max_networth;

    final response = await _helper.post(APIConstants.user_card_list_endpoint, formdata: _helper.body);
    ApiResponse<CardListResponse>? data = ApiResponse.fromJson(response, (result) {
      return CardListResponse.fromJson(result);
    });
    return data;
  }

  Future<ResponseModel?> userLikeCard(String cardID, isLike) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);
    _helper.body["token"] = token;
    _helper.body["user_id"] = userID;
    _helper.body["card_id"] = cardID.toString();
    _helper.body["is_like"] = isLike.toString();

    final response = await _helper.post(APIConstants.user_like_endpoint, formdata: _helper.body);
    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }
}
