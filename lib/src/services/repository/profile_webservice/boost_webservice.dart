import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/boost_history_model.dart';
import 'package:dating_app/src/model/profile/my_boost_model.dart';

class MyBoostRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<BoostResponse>?> getMyBoost() async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;

    final response = await _helper.post(APIConstants.get_boost_data_endpont, formdata: _helper.body);

    ApiResponse<BoostResponse>? data = ApiResponse.fromJson(response, (result) {
      return BoostResponse.fromJson(result);
    });
    return data;
  }

  Future<ApiResponse<GetBoostTime>?> getBoostTime() async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;

    final response = await _helper.post(APIConstants.get_boost_time_endpont, formdata: _helper.body);

    ApiResponse<GetBoostTime>? data = ApiResponse.fromJson(response, (result) {
      return GetBoostTime.fromJson(result);
    });
    return data;
  }

  Future<ResponseModel?> boostProfile({String? addone_planID, String? addone_type, String? addon_totalCount}) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body["add_on_plan_id"] = addone_planID;
    _helper.body["add_on_type"] = addone_type;
    _helper.body["add_on_total_count"] = addon_totalCount;

    final response = await _helper.post(APIConstants.boost_profile_endpont, formdata: _helper.body);
    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }

  Future<ResponseModel?> endBoost(String addonPlanID) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body["add_on_plan_id"] = addonPlanID;

    final response = await _helper.post(APIConstants.end_boost_endpont, formdata: _helper.body);

    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }

  //Boost plan purchase

  Future<ResponseModel?> boost_plan_purchase(
      {String? addonPlanID, addonType, addonCount, transactionID, totalAmount, transactionReceipt}) async {
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

    final response = await _helper.post(APIConstants.boost_purchase_plan_endpont, formdata: _helper.body);

    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }
}
