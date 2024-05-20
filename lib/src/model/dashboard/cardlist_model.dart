import 'package:dating_app/imports.dart';

class CardListResponse extends Serializable {
  String? cardCount;
  String? unread_message_count;
  String? notificationCount;
  String? userprofile;
  List<CardList>? cardList;

  CardListResponse(
      {this.cardCount,
      this.unread_message_count,
      this.notificationCount,
      this.cardList,
      this.userprofile});

  CardListResponse.fromJson(Map<String, dynamic> json) {
    cardCount = json['card_count'];
    userprofile = json['user_profile'];
    unread_message_count = json['unread_message_count'];
    notificationCount = json['notification_count'];
    if (json['card_list'] != null) {
      cardList = <CardList>[];
      json['card_list'].forEach((v) {
        cardList!.add(CardList.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['card_count'] = cardCount;
    data['unread_message_count'] = unread_message_count;
    data['user_profile'] = userprofile;
    data['notification_count'] = notificationCount;
    if (cardList != null) {
      data['card_list'] = cardList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CardList {
  String? id;
  String? name;
  String? age;
  String? awayDistance;
  String? isOnline;
  String? image;
  String? location;

  CardList(
      {this.id,
      this.name,
      this.age,
      this.awayDistance,
      this.isOnline,
      this.image,
      this.location});

  CardList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    awayDistance = json['away_distance'];
    isOnline = json['is_online'];
    image = json['image'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['age'] = age;
    data['away_distance'] = awayDistance;
    data['is_online'] = isOnline;
    data['image'] = image;
    data['location'] = location;
    return data;
  }
}
