import 'package:dating_app/imports.dart';

class MatchResponse extends Serializable {
  List<MatchList>? matchList;

  MatchResponse({this.matchList});

  MatchResponse.fromJson(Map<String, dynamic> json) {
    if (json['match_list'] != null) {
      matchList = <MatchList>[];
      json['match_list'].forEach((v) {
        matchList!.add(MatchList.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (matchList != null) {
      data['match_list'] = matchList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MatchList {
  String? userId;
  String? userImage;
  String? name;
  String? chatID;

  String? username;

  MatchList(
      {this.userId, this.userImage, this.name, this.chatID, this.username});

  MatchList.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    chatID = json['chat_id'];
    userImage = json['user_image'];
    name = json['name'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['chat_id'] = chatID;
    data['user_image'] = userImage;
    data['name'] = name;
    data['username'] = username;
    return data;
  }
}
