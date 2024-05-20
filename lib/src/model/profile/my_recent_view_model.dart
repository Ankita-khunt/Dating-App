import 'package:dating_app/imports.dart';

class MyRecentViewModelResponseView extends Serializable {
  List<RecentViewCardList>? recentViewCardList;

  MyRecentViewModelResponseView({this.recentViewCardList});

  MyRecentViewModelResponseView.fromJson(Map<String, dynamic> json) {
    if (json['recent_view_card_list'] != null) {
      recentViewCardList = <RecentViewCardList>[];
      json['recent_view_card_list'].forEach((v) {
        recentViewCardList!.add(RecentViewCardList.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (recentViewCardList != null) {
      data['recent_view_card_list'] =
          recentViewCardList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecentViewCardList {
  String? id;
  String? name;
  String? timestamp;
  String? profile;

  RecentViewCardList({this.id, this.name, this.timestamp, this.profile});

  RecentViewCardList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    timestamp = json['timestamp'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['timestamp'] = timestamp;
    data['profile'] = profile;
    return data;
  }
}
