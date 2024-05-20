import 'package:dating_app/imports.dart';

class PurchaseSubscriptionRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ResponseModel?> purchase(
      {String? planID, planDurationID, transactionID, totalAmount, startDate, enddate, appReceipt}) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body["plan_id"] = planID;
    _helper.body["plan_duration_id"] = planDurationID;
    _helper.body["transaction_id"] = transactionID;
    _helper.body["total_amount"] = totalAmount;
    _helper.body["start_date"] = startDate;
    _helper.body["end_date"] = enddate;
    _helper.body["apple_inapp_receipt"] = appReceipt;

    final response = await _helper.post(APIConstants.purchase_plan_details, formdata: _helper.body);
    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }

  Future<ResponseModel?> check_user_deactivate(
      {String? planID, planDurationID, transactionID, totalAmount, startDate, enddate, appReceipt}) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;

    final response = await _helper.post(APIConstants.check_user_status_endpoint, formdata: _helper.body);
    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }
}
