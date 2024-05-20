import 'package:dating_app/imports.dart';

class MySubscriptionPlanResponse extends Serializable {
  Plan? plan;

  MySubscriptionPlanResponse({this.plan});

  MySubscriptionPlanResponse.fromJson(Map<String, dynamic> json) {
    plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (plan != null) {
      data['plan'] = plan!.toJson();
    }
    return data;
  }
}

class Plan {
  String? planId;
  String? planName;
  String? planExpireDate;
  String? planPrice;
  String? planPerDuration;
  List<Benefits>? benefits;
  List<Addons>? addons;

  Plan(
      {this.planId,
      this.planName,
      this.planExpireDate,
      this.planPrice,
      this.planPerDuration,
      this.benefits,
      this.addons});

  Plan.fromJson(Map<String, dynamic> json) {
    planId = json['plan_id'];
    planName = json['plan_name'];
    planExpireDate = json['plan_expire_date'];
    planPrice = json['plan_price'];
    planPerDuration = json['plan_per_duration'];
    if (json['benefits'] != null) {
      benefits = <Benefits>[];
      json['benefits'].forEach((v) {
        benefits!.add(Benefits.fromJson(v));
      });
    }
    if (json['addons'] != null) {
      addons = <Addons>[];
      json['addons'].forEach((v) {
        addons!.add(Addons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plan_id'] = planId;
    data['plan_name'] = planName;
    data['plan_expire_date'] = planExpireDate;
    data['plan_price'] = planPrice;
    data['plan_per_duration'] = planPerDuration;
    if (benefits != null) {
      data['benefits'] = benefits!.map((v) => v.toJson()).toList();
    }
    if (addons != null) {
      data['addons'] = addons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Benefits {
  String? imageUpload;
  String? unlimitedImage;
  String? chat;
  String? videoCall;
  String? swipe;
  String? swipecount;
  String? add_on_swipe_count;
  String? myBoostDuration;

  Benefits(
      {this.imageUpload,
      this.unlimitedImage,
      this.chat,
      this.videoCall,
      this.swipecount,
      this.swipe,
      this.add_on_swipe_count,
      this.myBoostDuration});

  Benefits.fromJson(Map<String, dynamic> json) {
    imageUpload = json['image_upload_count'];
    unlimitedImage = json['image_upload'];

    chat = json['chat'];
    videoCall = json['video_call'];
    swipe = json['swipe'];
    add_on_swipe_count = json['add_on_swipe_count'];
    swipecount = json['swipe_count'];
    myBoostDuration = json['my_boost_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_upload'] = unlimitedImage;
    data['image_upload_count'] = imageUpload;

    data['chat'] = chat;
    data['video_call'] = videoCall;
    data['swipe'] = swipe;
    data['add_on_swipe_count'] = add_on_swipe_count;
    data['swipe_count'] = swipecount;
    data['my_boost_duration'] = myBoostDuration;
    return data;
  }
}

class Addons {
  String? id;
  String? addonPlan;
  String? addonDetail;

  Addons({this.id, this.addonPlan, this.addonDetail});

  Addons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addonPlan = json['addon_plan'];
    addonDetail = json['addon_detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['addon_plan'] = addonPlan;
    data['addon_detail'] = addonDetail;
    return data;
  }
}
