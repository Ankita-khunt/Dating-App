import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/my_recent_view_model.dart';

class RecentViewRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<MyRecentViewModelResponseView>?> getRecentView() async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;

    final response = await _helper.post(APIConstants.my_recent_view_endpoint,
        formdata: _helper.body);

    ApiResponse<MyRecentViewModelResponseView>? data =
        ApiResponse.fromJson(response, (result) {
      return MyRecentViewModelResponseView.fromJson(result);
    });
    return data;
  }
}
