import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/authentication/register_model.dart';

class RegisterRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<RegisterResponse>?> register(
      String username, fullname, email, dob, password, profilename) async {
    _helper.body["full_name"] = fullname;
    _helper.body["username"] = username;
    _helper.body["fcm_token"] = fcmtoken;
    _helper.body["email"] = email;
    _helper.body["DOB"] = formate_yyyyMMdd(dob);
    _helper.body["password"] = password;
    _helper.body["profile_picture"] = profilename;
    _helper.body["device_type"] = deviceType;

    final response = await _helper.post(APIConstants.register_endpoint,
        formdata: _helper.body);
    ApiResponse<RegisterResponse>? data =
        ApiResponse.fromJson(response, (result) {
      return RegisterResponse.fromJson(result);
    });
    return data;
  }

  Future<ResponseModel?> isUserExist(String email, username) async {
    if (email != "") {
      _helper.body["email"] = email;
    } else {
      _helper.body["username"] = username;
    }

    final response = await _helper.post(APIConstants.username_exists_endpoint,
        formdata: _helper.body);
    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }
}
