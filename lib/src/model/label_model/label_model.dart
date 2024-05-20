import 'package:dating_app/imports.dart';

class LabelResponse extends Serializable {
  int? code;
  String? message;
  String? timeStamp;
  List<LabelResult>? result;

  LabelResponse({this.code, this.message, this.timeStamp, this.result});

  LabelResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    timeStamp = json['time_stamp'];
    if (json['data'] != null) {
      result = <LabelResult>[];
      json['data'].forEach((v) {
        result!.add(LabelResult.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['time_stamp'] = timeStamp;
    if (result != null) {
      data['data'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LabelResult {
  String? key;
  String? value;

  LabelResult({this.key, this.value});

  LabelResult.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}
