import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/my_swipe_model.dart';

class MySwipeRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<MySwipeRespons>?> getMySwipe() async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;

    final response = await _helper.post(APIConstants.get_swipe_data_details,
        formdata: _helper.body);

    ApiResponse<MySwipeRespons>? data =
        ApiResponse.fromJson(response, (result) {
      return MySwipeRespons.fromJson(result);
    });
    return data;
  }

  //Boost plan purchase

  Future<ResponseModel?> swipe_plan_purchase(
      {String? addonPlanID,
      addonType,
      addonCount,
      transactionID,
      totalAmount,
      transactionReceipt}) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body["add_on_plan_id"] = addonPlanID;
    _helper.body["add_on_type"] = addonType;
    _helper.body["add_on_count"] = addonCount;
    _helper.body["transaction_id"] = transactionID;
    _helper.body["total_amount"] = totalAmount;
    _helper.body["apple_inapp_receipt"] = transactionReceipt;

    final response = await _helper
        .post(APIConstants.swipe_purchase_plan_endpont, formdata: _helper.body);

    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }
}
