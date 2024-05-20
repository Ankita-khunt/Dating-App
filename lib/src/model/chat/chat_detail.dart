import 'package:dating_app/imports.dart';

class ChatDetailResponse extends Serializable {
  String? chatId;
  String? userId;
  String? userImage;
  String? isOnline;
  String? name;
  String? is_blocked_user;
  String? username;
  List<MessageList>? messageList;

  ChatDetailResponse(
      {this.chatId,
      this.userId,
      this.userImage,
      this.isOnline,
      this.name,
      this.username,
      this.is_blocked_user,
      this.messageList});

  ChatDetailResponse.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    userId = json['user_id'];
    userImage = json['user_image'];
    is_blocked_user = json['is_blocked_user'];
    isOnline = json['is_online'];
    name = json['name'];
    username = json['username'];
    if (json['message_list'] != null) {
      messageList = <MessageList>[];
      json['message_list'].forEach((v) {
        messageList!.add(MessageList.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat_id'] = chatId;
    data['user_id'] = userId;
    data['is_blocked_user'] = is_blocked_user;
    data['user_image'] = userImage;
    data['is_online'] = isOnline;
    data['name'] = name;
    data['username'] = username;
    if (messageList != null) {
      data['message_list'] = messageList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MessageList {
  String? id;
  String? messageType;
  String? messageSentTime;
  String? typeId;
  String? message;
  String? fileUrl;

  MessageList(
      {this.id,
      this.messageType,
      this.messageSentTime,
      this.typeId,
      this.message,
      this.fileUrl});

  MessageList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    messageType = json['message_type'];
    messageSentTime = json['message_sent_time'];
    typeId = json['type_id'];
    message = json['message'];
    fileUrl = json['file_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message_type'] = messageType;
    data['message_sent_time'] = messageSentTime;
    data['type_id'] = typeId;
    data['message'] = message;
    data['file_url'] = fileUrl;
    return data;
  }
}

class SendMessageRespone extends Serializable {
  String? chatId;

  SendMessageRespone({this.chatId});

  SendMessageRespone.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat_id'] = chatId;
    return data;
  }
}
