import 'package:dating_app/imports.dart';

class CMSResponse extends Serializable {
  String? id;
  String? title;
  String? content;

  CMSResponse({this.id, this.title, this.content});

  CMSResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    return data;
  }
}
