import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/subscription/subscription_reponse_model.dart';

class SubscriptionRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<SubscriptionPlanResponse>?> getSubscription() async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;

    final response = await _helper.post(APIConstants.subscription_plan_endpont,
        formdata: _helper.body);

    ApiResponse<SubscriptionPlanResponse>? data =
        ApiResponse.fromJson(response, (result) {
      return SubscriptionPlanResponse.fromJson(result);
    });
    return data;
  }
}
