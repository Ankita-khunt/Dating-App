import 'package:dating_app/imports.dart';

class SubscriptionPlanResponse extends Serializable {
  Plans? plans;

  SubscriptionPlanResponse({this.plans});

  SubscriptionPlanResponse.fromJson(Map<String, dynamic> json) {
    plans = json['plans'] != null ? Plans.fromJson(json['plans']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (plans != null) {
      data['plans'] = plans!.toJson();
    }
    return data;
  }
}

class Plans {
  PremiumPlan? premiumPlan;
  PremiumPlan? vIPPlan;

  Plans({this.premiumPlan, this.vIPPlan});

  Plans.fromJson(Map<String, dynamic> json) {
    premiumPlan = json['premium_plan'] != null
        ? PremiumPlan.fromJson(json['premium_plan'])
        : null;
    vIPPlan = json['VIP_plan'] != null
        ? PremiumPlan.fromJson(json['VIP_plan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (premiumPlan != null) {
      data['premium_plan'] = premiumPlan!.toJson();
    }
    if (vIPPlan != null) {
      data['VIP_plan'] = vIPPlan!.toJson();
    }
    return data;
  }
}

class PremiumPlan {
  String? id;
  String? planName;
  String? swipe;
  String? isUnlimitedSwipe;
  String? swipeCount;
  String? imageUpload;
  String? chat;
  String? videoCall;
  String? rewind;
  String? myBoost;
  String? myBoostDuration;
  String? imageUploadUnlimited;
  String? imageUploadCount;
  List<PlanDuration>? planDuration;
  List<AddOns>? addOns;

  PremiumPlan(
      {this.id,
      this.planName,
      this.swipe,
      this.isUnlimitedSwipe,
      this.swipeCount,
      this.imageUpload,
      this.chat,
      this.videoCall,
      this.rewind,
      this.myBoost,
      this.myBoostDuration,
      this.imageUploadUnlimited,
      this.imageUploadCount,
      this.planDuration,
      this.addOns});

  PremiumPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planName = json['plan_name'];
    swipe = json['swipe'];
    isUnlimitedSwipe = json['is_unlimited_swipe'];
    swipeCount = json['swipe_count'];
    imageUpload = json['image_upload'];
    chat = json['chat'];
    videoCall = json['video_call'];
    rewind = json['rewind'];
    myBoost = json['my_boost'];
    myBoostDuration = json['my_boost_duration'];
    imageUploadUnlimited = json['image_upload_unlimited'];
    imageUploadCount = json['image_upload_count'];
    if (json['plan_duration'] != null) {
      planDuration = <PlanDuration>[];
      json['plan_duration'].forEach((v) {
        planDuration!.add(PlanDuration.fromJson(v));
      });
    }
    if (json['add_ons'] != null) {
      addOns = <AddOns>[];
      json['add_ons'].forEach((v) {
        addOns!.add(AddOns.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['plan_name'] = planName;
    data['swipe'] = swipe;
    data['is_unlimited_swipe'] = isUnlimitedSwipe;
    data['swipe_count'] = swipeCount;
    data['image_upload'] = imageUpload;
    data['chat'] = chat;
    data['video_call'] = videoCall;
    data['rewind'] = rewind;
    data['my_boost'] = myBoost;
    data['my_boost_duration'] = myBoostDuration;
    data['image_upload_unlimited'] = imageUploadUnlimited;
    data['image_upload_count'] = imageUploadCount;
    if (planDuration != null) {
      data['plan_duration'] = planDuration!.map((v) => v.toJson()).toList();
    }
    if (addOns != null) {
      data['add_ons'] = addOns!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlanDuration {
  String? id;
  String? duration;
  String? price;
  String? discount;
  String? isActivePlan;

  PlanDuration(
      {this.id, this.duration, this.price, this.discount, this.isActivePlan});

  PlanDuration.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    duration = json['duration'];
    price = json['price'];
    discount = json['discount'];
    isActivePlan = json['is_plan_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['duration'] = duration;
    data['price'] = price;
    data['discount'] = discount;
    data['is_plan_active'] = isActivePlan;
    return data;
  }
}

class AddOns {
  String? id;
  String? addOnType;
  String? addOnCount;
  String? price;

  AddOns({this.id, this.addOnType, this.addOnCount, this.price});

  AddOns.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addOnType = json['add_on_type'];
    addOnCount = json['add_on_count'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['add_on_type'] = addOnType;
    data['add_on_count'] = addOnCount;
    data['price'] = price;
    return data;
  }
}
