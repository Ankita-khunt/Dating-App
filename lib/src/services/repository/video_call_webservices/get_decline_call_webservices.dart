import 'package:dating_app/imports.dart';

class GetDeclineVideoCall {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getDeclineCallApi(
      String receiverId, String channelId) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body["caller_id"] = receiverId;
    _helper.body["channel_id"] = channelId;

    final response = await _helper.post(APIConstants.get_decline_call_api,
        formdata: _helper.body);

    ApiResponse? data = ApiResponse.fromJson(response, (result) {
      return ApiResponse();
    });
    return data;
  }
}
