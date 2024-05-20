import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/boost_history_model.dart';

class BoostHistoryRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<BoostHistoryResponse>?> getBoostHistory(
      String addonTYpe) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body["add_on_type"] = addonTYpe;

    final response = await _helper.post(APIConstants.get_history_endpont,
        formdata: _helper.body);

    ApiResponse<BoostHistoryResponse>? data =
        ApiResponse.fromJson(response, (result) {
      return BoostHistoryResponse.fromJson(result);
    });
    return data;
  }
}
