import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/dashboard/user_detail_model.dart';

class UserDetailRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<UserDetailResponse>?> getUserDetail(
      String cardID, lat, long,
      {bool? isIncongnitoMode}) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body["card_id"] = cardID;
    _helper.body["is_incognito_mode"] =
        isIncongnitoMode == true ? 1.toString() : 0.toString();
    _helper.body["lat"] = lat.toString();
    _helper.body["long"] = long.toString();

    final response = await _helper.post(APIConstants.get_user_details_endpoint,
        formdata: _helper.body);

    ApiResponse<UserDetailResponse>? data =
        ApiResponse.fromJson(response, (result) {
      return UserDetailResponse.fromJson(result);
    });
    return data;
  }
}
