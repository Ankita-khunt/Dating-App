import 'package:dating_app/imports.dart';

class GeneralSettingsRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<GeneralSetting>?> fetchGeneralSetting() async {
    final response = await _helper.post(APIConstants.general_endpoint,
        formdata: _helper.body);
    ApiResponse<GeneralSetting>? generalSettingResponseJsonData =
        ApiResponse.fromJson(response, (result) {
      return GeneralSetting.fromJson(result);
    });
    return generalSettingResponseJsonData;
  }
}
