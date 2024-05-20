import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/chat/chat_detail.dart';
import 'package:dating_app/src/model/chat/chat_list_model.dart';

class ChatRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<ChatResponse>?> chatlist(String page, chatType) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["page"] = page.toString();
    _helper.body['token'] = token;
    _helper.body['chat_type'] = chatType;

    final response = await _helper.post(APIConstants.get_chat_list_endpont, formdata: _helper.body);
    ApiResponse<ChatResponse>? data = ApiResponse.fromJson(response, (result) {
      return ChatResponse.fromJson(result);
    });
    return data;
  }

  Future<ApiResponse<ChatDetailResponse>?> chatdetail(String page, chatID, receiverID) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["page"] = page.toString();
    _helper.body['token'] = token;
    _helper.body['chat_id'] = chatID;
    _helper.body['receiver_id'] = receiverID;

    final response = await _helper.post(APIConstants.get_user_chat_endpont, formdata: _helper.body);
    ApiResponse<ChatDetailResponse>? data = ApiResponse.fromJson(response, (result) {
      return ChatDetailResponse.fromJson(result);
    });
    return data;
  }

  Future<ApiResponse<SendMessageRespone>?> sendMessage({String? receiverID, chatID, message, messageTYpeID}) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body["receiver_id"] = receiverID;
    _helper.body["message"] = message;
    _helper.body["message_type"] = messageTYpeID.toString();

    final response = await _helper.post(APIConstants.send_message_endpont, formdata: _helper.body);
    ApiResponse<SendMessageRespone>? data = ApiResponse.fromJson(response, (result) {
      return SendMessageRespone.fromJson(result);
    });
    return data;
  }
}
