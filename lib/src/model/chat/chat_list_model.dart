import 'package:dating_app/imports.dart';

class ChatResponse extends Serializable {
  String? isSubscribed;
  String? unread_message_count;
  List<ChatList>? chat;

  ChatResponse({this.isSubscribed, this.chat, this.unread_message_count});

  ChatResponse.fromJson(Map<String, dynamic> json) {
    isSubscribed = json['is_subscribed'];
    unread_message_count = json['unread_message_count'];
    if (json['chat'] != null) {
      chat = <ChatList>[];
      json['chat'].forEach((v) {
        chat!.add(ChatList.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_subscribed'] = isSubscribed;
    data['unread_message_count'] = unread_message_count;
    if (chat != null) {
      data['chat'] = chat!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatList {
  String? chatId;
  String? userId;
  String? userImage;
  String? name;
  String? lastMessage;
  String? videoCallCount;
  String? messageTime;
  String? is_blocked_user;
  String? messageType;

  String? unreadMessages;

  //videocall model data
  String? videoId;

  String? isIncoming;

  ChatList(
      {this.chatId,
      this.userId,
      this.userImage,
      this.messageType,
      this.is_blocked_user,
      this.name,
      this.lastMessage,
      this.messageTime,
      this.unreadMessages,
      this.videoCallCount,
      this.videoId,
      this.isIncoming});

  ChatList.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    userId = json['user_id'];
    userImage = json['user_image'];
    name = json['name'];
    messageType = json['message_type'];
    lastMessage = json['last_message'];
    is_blocked_user = json['is_blocked_user'];
    messageTime = json['message_time'];
    unreadMessages = json['unread_messages'];
    videoCallCount = json['video_call_count'];
    videoId = json['video_id'];
    isIncoming = json['is_incoming'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat_id'] = chatId;
    data['user_id'] = userId;
    data['message_type'] = messageType;
    data['user_image'] = userImage;
    data['name'] = name;
    data['last_message'] = lastMessage;
    data['message_time'] = messageTime;
    data['unread_messages'] = unreadMessages;
    data['video_id'] = videoId;
    data['video_call_count'] = videoCallCount;
    data['is_blocked_user'] = is_blocked_user;
    data['is_incoming'] = isIncoming;
    return data;
  }
}
