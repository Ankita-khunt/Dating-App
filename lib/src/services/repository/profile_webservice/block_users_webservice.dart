import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/blockuser_model.dart';

class BlockUserRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<BlockUserResponse>?> getBlockUserlist(String page) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body["page"] = page;

    final response = await _helper.post(APIConstants.get_block_users_endpont,
        formdata: _helper.body);

    ApiResponse<BlockUserResponse>? data =
        ApiResponse.fromJson(response, (result) {
      return BlockUserResponse.fromJson(result);
    });
    return data;
  }

  Future<ResponseModel?> blockUser(String blockuserID, isBlock) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body["is_block"] = isBlock;
    _helper.body["block_user_id"] = blockuserID;

    final response = await _helper.post(APIConstants.bloc_user_endpont,
        formdata: _helper.body);
    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }

  Future<ResponseModel?> reportUser(String reoprtuserID, msg) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body["message"] = msg;
    _helper.body["report_user_id"] = reoprtuserID;

    final response = await _helper.post(APIConstants.report_user_endpont,
        formdata: _helper.body);
    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }
}
