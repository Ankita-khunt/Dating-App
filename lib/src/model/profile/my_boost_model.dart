import 'package:dating_app/imports.dart';

class BoostResponse extends Serializable {
  String? id;
  MyBoost? myBoost;
  List<BoostList>? boostList;
  String? boost_time;

  BoostResponse({
    this.id,
    this.myBoost,
    this.boostList,
    this.boost_time,
  });

  BoostResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    myBoost =
        json['my_boost'] != null ? MyBoost.fromJson(json['my_boost']) : null;
    if (json['boost_list'] != null) {
      boostList = <BoostList>[];
      json['boost_list'].forEach((v) {
        boostList!.add(BoostList.fromJson(v));
      });
    }
    boost_time = json['boost_time'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (myBoost != null) {
      data['my_boost'] = myBoost!.toJson();
    }
    if (boostList != null) {
      data['boost_list'] = boostList!.map((v) => v.toJson()).toList();
    }
    data['boost_time'] = boost_time;

    return data;
  }
}

class MyBoost {
  String? id;
  String? totalBoost;
  String? remainingBoost;
  String? createdat;
  String? add_on_plan_id;
  String? addonType;

  MyBoost(
      {this.id,
      this.totalBoost,
      this.remainingBoost,
      this.createdat,
      this.add_on_plan_id,
      this.addonType});

  MyBoost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalBoost = json['total_boost'];
    remainingBoost = json['remaining_boost'];
    createdat = json['created_at'];
    add_on_plan_id = json['add_on_plan_id'];
    addonType = json['add_on_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['total_boost'] = totalBoost;
    data['remaining_boost'] = remainingBoost;
    data['created_at'] = createdat;
    data['add_on_plan_id'] = add_on_plan_id;
    data['add_on_type'] = addonType;

    return data;
  }
}

class BoostList {
  String? boostId;
  String? boostCount;
  String? boostPrice;

  BoostList({this.boostId, this.boostCount, this.boostPrice});

  BoostList.fromJson(Map<String, dynamic> json) {
    boostId = json['boost_id'];
    boostCount = json['boost_count'];
    boostPrice = json['boost_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['boost_id'] = boostId;
    data['boost_count'] = boostCount;
    data['boost_price'] = boostPrice;
    return data;
  }
}
