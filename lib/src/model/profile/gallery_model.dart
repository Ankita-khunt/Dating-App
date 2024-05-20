import 'package:dating_app/imports.dart';

class GalleryResponse extends Serializable {
  List<GallaryList>? gallaryList;

  GalleryResponse({this.gallaryList});

  GalleryResponse.fromJson(Map<String, dynamic> json) {
    if (json['gallary_list'] != null) {
      gallaryList = <GallaryList>[];
      json['gallary_list'].forEach((v) {
        gallaryList!.add(GallaryList.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (gallaryList != null) {
      data['gallary_list'] = gallaryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GallaryList {
  String? id;
  String? image;

  GallaryList({this.id, this.image});

  GallaryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    return data;
  }
}
