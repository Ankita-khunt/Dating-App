import 'package:dating_app/imports.dart';

class BoostHistoryResponse extends Serializable {
  List<History>? history;

  BoostHistoryResponse({this.history});

  BoostHistoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['history'] != null) {
      history = <History>[];
      json['history'].forEach((v) {
        history!.add(History.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (history != null) {
      data['history'] = history!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class History {
  String? id;
  String? date;
  String? addOnType;

  History({this.id, this.date, this.addOnType});

  History.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    addOnType = json['add_on_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['add_on_type'] = addOnType;
    return data;
  }
}

class GetBoostTime extends Serializable {
  String? createdBoostTime;
  String? boost_time;

  GetBoostTime({this.createdBoostTime, this.boost_time});

  GetBoostTime.fromJson(Map<String, dynamic> json) {
    createdBoostTime = json['created_boost_time'];
    boost_time = json['boost_time'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_boost_time'] = createdBoostTime;
    data['boost_time'] = boost_time;

    return data;
  }
}
