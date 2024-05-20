import 'package:dating_app/imports.dart';

class ChangepasswordRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ResponseModel?> changePassword(String oldpass, newpass) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body["current_password"] = oldpass;
    _helper.body["new_password"] = newpass;

    final response = await _helper.post(APIConstants.change_password_endpont,
        formdata: _helper.body);

    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }
}
