import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/my_likes_model.dart';

class MyLikesRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<MyLikesResponse>?> getMyLikes(
      String isSentLikes, page) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body['is_sent'] = isSentLikes;
    _helper.body["page"] = page;

    final response = await _helper.post(APIConstants.my_likes_endpont,
        formdata: _helper.body);

    ApiResponse<MyLikesResponse>? data =
        ApiResponse.fromJson(response, (result) {
      return MyLikesResponse.fromJson(result);
    });
    return data;
  }
}
