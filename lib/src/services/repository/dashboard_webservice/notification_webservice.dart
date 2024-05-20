import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/dashboard/notification_model.dart';

class NotificationRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<NotificationListResponse>?> notificationList(
      String page) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);
    _helper.body["token"] = token;

    _helper.body["user_id"] = userID;
    _helper.body["page"] = page.toString();

    final response = await _helper.post(APIConstants.notification_list_endpoint,
        formdata: _helper.body);
    ApiResponse<NotificationListResponse>? data =
        ApiResponse.fromJson(response, (result) {
      return NotificationListResponse.fromJson(result);
    });
    return data;
  }
}
