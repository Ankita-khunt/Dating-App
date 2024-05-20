import 'package:dating_app/imports.dart';

import '../../../model/profile/video_chat_model.dart';

class VideoChatDetails {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<GetVideoChatDetailsResponseModel>?> getVideoChatDetails(
      String receiverId) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body["reciver_caller_id"] = receiverId;

    final response = await _helper.post(APIConstants.get_video_chat_details,
        formdata: _helper.body);

    ApiResponse<GetVideoChatDetailsResponseModel>? data =
        ApiResponse.fromJson(response, (result) {
      return GetVideoChatDetailsResponseModel.fromJson(result);
    });
    return data;
  }
}
