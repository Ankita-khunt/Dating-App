import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/my_subscription_model.dart';

class MySubscriptionRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<MySubscriptionPlanResponse>?> getMySubscription() async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;

    final response = await _helper
        .post(APIConstants.get_my_subscription_endpont, formdata: _helper.body);

    ApiResponse<MySubscriptionPlanResponse>? data =
        ApiResponse.fromJson(response, (result) {
      return MySubscriptionPlanResponse.fromJson(result);
    });
    return data;
  }
}
