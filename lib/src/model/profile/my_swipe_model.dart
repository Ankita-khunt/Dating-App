import 'package:dating_app/imports.dart';

class MySwipeRespons extends Serializable {
  String? id;
  MySwipe? mySwipe;
  List<SwipeList>? swipeList;

  MySwipeRespons({this.id, this.mySwipe, this.swipeList});

  MySwipeRespons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mySwipe =
        json['my_swipe'] != null ? MySwipe.fromJson(json['my_swipe']) : null;
    if (json['swipe_list'] != null) {
      swipeList = <SwipeList>[];
      json['swipe_list'].forEach((v) {
        swipeList!.add(SwipeList.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (mySwipe != null) {
      data['my_swipe'] = mySwipe!.toJson();
    }
    if (swipeList != null) {
      data['swipe_list'] = swipeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MySwipe {
  String? addOnPlanId;
  String? addOnType;
  String? totalSwipe;
  String? createdAt;

  MySwipe({this.addOnPlanId, this.addOnType, this.totalSwipe, this.createdAt});

  MySwipe.fromJson(Map<String, dynamic> json) {
    addOnPlanId = json['add_on_plan_id'];
    addOnType = json['add_on_type'];
    totalSwipe = json['total_swipe'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['add_on_plan_id'] = addOnPlanId;
    data['add_on_type'] = addOnType;
    data['total_swipe'] = totalSwipe;
    data['created_at'] = createdAt;
    return data;
  }
}

class SwipeList {
  String? swipeId;
  String? swipeCount;
  String? swipePrice;

  SwipeList({this.swipeId, this.swipeCount, this.swipePrice});

  SwipeList.fromJson(Map<String, dynamic> json) {
    swipeId = json['swipe_id'];
    swipeCount = json['swipe_count'];
    swipePrice = json['swipe_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['swipe_id'] = swipeId;
    data['swipe_count'] = swipeCount;
    data['swipe_price'] = swipePrice;
    return data;
  }
}
