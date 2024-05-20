import 'package:dating_app/imports.dart';

class MyLikesResponse extends Serializable {
  List<SentLikes>? sentLikes;

  MyLikesResponse({this.sentLikes});

  MyLikesResponse.fromJson(Map<String, dynamic> json) {
    if (json['likes'] != null) {
      sentLikes = <SentLikes>[];
      json['likes'].forEach((v) {
        sentLikes!.add(SentLikes.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sentLikes != null) {
      data['likes'] = sentLikes!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class SentLikes {
  String? id;
  String? imageUrl;
  String? name;
  String? age;

  SentLikes({this.id, this.imageUrl, this.name, this.age});

  SentLikes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
    name = json['name'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image_url'] = imageUrl;
    data['name'] = name;
    data['age'] = age;
    return data;
  }
}
