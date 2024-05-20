import 'package:dating_app/imports.dart';

class MatchRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<MatchResponse>?> matchList(String page) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["page"] = page.toString();
    _helper.body['token'] = token;

    final response = await _helper.post(APIConstants.get_match_list_endpoint,
        formdata: _helper.body);
    ApiResponse<MatchResponse>? data = ApiResponse.fromJson(response, (result) {
      return MatchResponse.fromJson(result);
    });
    return data;
  }

  Future<ResponseModel?> removeMatch(String matchID) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["match_userID"] = matchID.toString();
    _helper.body['token'] = token;

    final response = await _helper.post(APIConstants.remove_match_endpoint,
        formdata: _helper.body);
    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }
}
