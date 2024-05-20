import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/authentication/forgotpass_model.dart';

class ForgotPasswordRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<ForgotPassResponse>?> forgotPass(String email) async {
    _helper.body["email"] = email;

    final response = await _helper.post(APIConstants.forgot_password_endpont, formdata: _helper.body);
    ApiResponse<ForgotPassResponse>? data = ApiResponse.fromJson(response, (result) {
      return ForgotPassResponse.fromJson(result);
    });
    return data;
  }

  Future<ResponseModel?> resetPass(String newpass, confirmpass) async {
    String userID = await SharedPref.getString(PreferenceConstants.forgotUserID);
    String token = await SharedPref.getString(PreferenceConstants.forgotToken);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body["new_password"] = newpass;
    _helper.body["confirm_password"] = confirmpass;

    final response = await _helper.post(APIConstants.reset_password_endpont, formdata: _helper.body);
    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }
}
