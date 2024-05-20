import 'package:dating_app/imports.dart';

class NotificationListResponse extends Serializable {
  dynamic pageIndex;
  List<NotificationList>? notificationList;

  NotificationListResponse({this.pageIndex, this.notificationList});

  NotificationListResponse.fromJson(Map<String, dynamic> json) {
    pageIndex = json['pageIndex'];
    if (json['notification_list'] != null) {
      notificationList = <NotificationList>[];
      json['notification_list'].forEach((v) {
        notificationList!.add(NotificationList.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageIndex'] = pageIndex;
    if (notificationList != null) {
      data['notification_list'] = notificationList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationList {
  String? id;
  String? userId;
  String? img;
  String? type;
  String? name;
  String? chatID;
  String? message;
  String? created_at;

  NotificationList({this.id, this.userId, this.img, this.name, this.type, this.chatID, this.message, this.created_at});

  NotificationList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    created_at = json['created_at'];
    img = json['img'];
    chatID = json['chat_id'];
    name = json['name'];
    type = json['type'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = created_at;
    data['chat_id'] = chatID;
    data['type'] = type;
    data['user_id'] = userId;
    data['img'] = img;
    data['name'] = name;
    data['message'] = message;
    return data;
  }
}

class NotificationData {
  late int id;
  late String notificationId;
  late String notificationType;
  late String status;
  late String isReadable;
  late String date;
  late String title;
  late String message;
  late String actionId;
  late String actionRelationId;
  late String tenderMappingId;

  NotificationData(
      {required this.id,
      required this.notificationId,
      required this.notificationType,
      required this.status,
      required this.isReadable,
      required this.date,
      required this.title,
      required this.message,
      required this.actionId,
      required this.actionRelationId,
      required this.tenderMappingId});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notificationId = json['notification_id'];
    status = json['status'];
    notificationType = json['notification_type'];
    isReadable = json['is_readable'];
    date = json['date'];
    title = json['title'];
    message = json['message'];
    actionId = json['action_id'];
    actionRelationId = json['action_relation_id'];
    tenderMappingId = json['tender_mapping_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['notification_type'] = notificationType;
    data['is_readable'] = isReadable;
    data['date'] = date;
    data['title'] = title;
    data['message'] = message;
    data['action_id'] = actionId;
    data['action_relation_id'] = actionRelationId;
    data['tender_mapping_id'] = tenderMappingId;
    return data;
  }
}
