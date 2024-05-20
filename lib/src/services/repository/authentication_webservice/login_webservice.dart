import 'dart:io';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/authentication/login_model.dart';

class LoginRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<LoginResponse>?> login(String email, username, password) async {
    _helper.body["fcm_token"] = fcmtoken;
    _helper.body["device_type"] = Platform.isAndroid ? 0.toString() : 1.toString();
    _helper.body["password"] = password;

    if (email != "") {
      _helper.body["email"] = email;
    } else {
      _helper.body["username"] = username;
    }
    final response = await _helper.post(APIConstants.login_endpoint, formdata: _helper.body);
    ApiResponse<LoginResponse>? data = ApiResponse.fromJson(response, (result) {
      return LoginResponse.fromJson(result);
    });
    return data;
  }
}
