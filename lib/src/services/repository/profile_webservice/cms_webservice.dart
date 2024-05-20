import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/cms_model.dart';
import 'package:dating_app/src/model/profile/faq_model.dart';

class CMSRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<CMSResponse>?> getCMS(String cmsTypeID) async {
    _helper.body["cms_type"] = cmsTypeID;

    final response =
        await _helper.post(APIConstants.cms_endpoint, formdata: _helper.body);

    ApiResponse<CMSResponse>? data = ApiResponse.fromJson(response, (result) {
      return CMSResponse.fromJson(result);
    });
    return data;
  }

  Future<ApiResponse<FAQResponse>?> getFAQ() async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    final response =
        await _helper.post(APIConstants.faqs_endpoint, formdata: _helper.body);

    ApiResponse<FAQResponse>? data = ApiResponse.fromJson(response, (result) {
      return FAQResponse.fromJson(result);
    });
    return data;
  }

  Future<ResponseModel?> contactUs(String name, email, message) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body["name"] = name;
    _helper.body["email"] = email;
    _helper.body["message"] = message;

    final response = await _helper.post(APIConstants.contact_us_endpoint,
        formdata: _helper.body);
    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }
}
