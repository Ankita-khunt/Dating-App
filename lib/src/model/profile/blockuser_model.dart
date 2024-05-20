import 'package:dating_app/imports.dart';

class BlockUserResponse extends Serializable {
  List<BlockedUsers>? blockedUsers;

  BlockUserResponse({this.blockedUsers});

  BlockUserResponse.fromJson(Map<String, dynamic> json) {
    if (json['blocked_users'] != null) {
      blockedUsers = <BlockedUsers>[];
      json['blocked_users'].forEach((v) {
        blockedUsers!.add(BlockedUsers.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (blockedUsers != null) {
      data['blocked_users'] = blockedUsers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BlockedUsers {
  String? userId;
  String? userImage;
  String? name;
  String? username;

  BlockedUsers({this.userId, this.userImage, this.name, this.username});

  BlockedUsers.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userImage = json['user_image'];
    name = json['name'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_image'] = userImage;
    data['name'] = name;
    data['username'] = username;
    return data;
  }
}
