import 'package:dating_app/imports.dart';

class GetSetUpProfileResponse extends Serializable {
  String? isSubscribe;
  List<ProfileFieldResponse>? ethnicity;
  List<ProfileFieldResponse>? cast;
  String? minLocationRange;
  String? maxLocationRange;
  List<ProfileFieldResponse>? maritalStatus;
  List<ProfileFieldResponse>? religiousViews;
  List<ProfileFieldResponse>? politicalLeaningTypes;
  List<ProfileFieldResponse>? gender;
  List<ProfileFieldResponse>? hobbies;
  List<ProfileFieldResponse>? datingGroup;
  String? minIncome;
  String? maxIncome;
  String? minNetworth;
  String? maxNetworth;
  List<ProfileFieldResponse>? occupation;
  List<ProfileFieldResponse>? relationshipStatus;
  List<ProfileFieldResponse>? diePreference;
  List<ProfileFieldResponse>? starSign;
  List<ProfileFieldResponse>? personalityType;
  List<ProfileFieldResponse>? bodyType;
  List<ProfileFieldResponse>? datingType;

  GetSetUpProfileResponse(
      {this.ethnicity,
      this.cast,
      this.isSubscribe,
      this.minLocationRange,
      this.maxLocationRange,
      this.maritalStatus,
      this.religiousViews,
      this.politicalLeaningTypes,
      this.gender,
      this.hobbies,
      this.datingGroup,
      this.minIncome,
      this.maxIncome,
      this.minNetworth,
      this.maxNetworth,
      this.occupation,
      this.relationshipStatus,
      this.diePreference,
      this.starSign,
      this.personalityType,
      this.bodyType,
      this.datingType});

  GetSetUpProfileResponse.fromJson(Map<String, dynamic> json) {
    if (json['ethnicity'] != null) {
      ethnicity = <ProfileFieldResponse>[];
      json['ethnicity'].forEach((v) {
        ethnicity!.add(ProfileFieldResponse.fromJson(v));
      });
    }
    if (json['cast'] != null) {
      cast = <ProfileFieldResponse>[];
      json['cast'].forEach((v) {
        cast!.add(ProfileFieldResponse.fromJson(v));
      });
    }
    minLocationRange = json['min_location_range'];
    isSubscribe = json['is_subscribed'];
    maxLocationRange = json['max_location_range'];
    if (json['marital_status'] != null) {
      maritalStatus = <ProfileFieldResponse>[];
      json['marital_status'].forEach((v) {
        maritalStatus!.add(ProfileFieldResponse.fromJson(v));
      });
    }
    if (json['religious_views'] != null) {
      religiousViews = <ProfileFieldResponse>[];
      json['religious_views'].forEach((v) {
        religiousViews!.add(ProfileFieldResponse.fromJson(v));
      });
    }
    if (json['political_leaning_types'] != null) {
      politicalLeaningTypes = <ProfileFieldResponse>[];
      json['political_leaning_types'].forEach((v) {
        politicalLeaningTypes!.add(ProfileFieldResponse.fromJson(v));
      });
    }
    if (json['gender'] != null) {
      gender = <ProfileFieldResponse>[];
      json['gender'].forEach((v) {
        gender!.add(ProfileFieldResponse.fromJson(v));
      });
    }
    if (json['hobbies'] != null) {
      hobbies = <ProfileFieldResponse>[];
      json['hobbies'].forEach((v) {
        hobbies!.add(ProfileFieldResponse.fromJson(v));
      });
    }
    if (json['dating_group'] != null) {
      datingGroup = <ProfileFieldResponse>[];
      json['dating_group'].forEach((v) {
        datingGroup!.add(ProfileFieldResponse.fromJson(v));
      });
    }
    minIncome = json['min_income'];
    maxIncome = json['max_income'];
    minNetworth = json['min_networth'];
    maxNetworth = json['max_networth'];
    if (json['occupation'] != null) {
      occupation = <ProfileFieldResponse>[];
      json['occupation'].forEach((v) {
        occupation!.add(ProfileFieldResponse.fromJson(v));
      });
    }
    if (json['relationship_status'] != null) {
      relationshipStatus = <ProfileFieldResponse>[];
      json['relationship_status'].forEach((v) {
        relationshipStatus!.add(ProfileFieldResponse.fromJson(v));
      });
    }
    if (json['die_preference'] != null) {
      diePreference = <ProfileFieldResponse>[];
      json['die_preference'].forEach((v) {
        diePreference!.add(ProfileFieldResponse.fromJson(v));
      });
    }
    if (json['star_sign'] != null) {
      starSign = <ProfileFieldResponse>[];
      json['star_sign'].forEach((v) {
        starSign!.add(ProfileFieldResponse.fromJson(v));
      });
    }
    if (json['personality_type'] != null) {
      personalityType = <ProfileFieldResponse>[];
      json['personality_type'].forEach((v) {
        personalityType!.add(ProfileFieldResponse.fromJson(v));
      });
    }
    if (json['body_type'] != null) {
      bodyType = <ProfileFieldResponse>[];
      json['body_type'].forEach((v) {
        bodyType!.add(ProfileFieldResponse.fromJson(v));
      });
    }
    if (json['dating_type'] != null) {
      datingType = <ProfileFieldResponse>[];
      json['dating_type'].forEach((v) {
        datingType!.add(ProfileFieldResponse.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (ethnicity != null) {
      data['ethnicity'] = ethnicity!.map((v) => v.toJson()).toList();
    }
    if (cast != null) {
      data['cast'] = cast!.map((v) => v.toJson()).toList();
    }
    data['is_subscribed'] = isSubscribe;
    data['min_location_range'] = minLocationRange;
    data['max_location_range'] = maxLocationRange;
    if (maritalStatus != null) {
      data['marital_status'] = maritalStatus!.map((v) => v.toJson()).toList();
    }
    if (religiousViews != null) {
      data['religious_views'] = religiousViews!.map((v) => v.toJson()).toList();
    }
    if (politicalLeaningTypes != null) {
      data['political_leaning_types'] =
          politicalLeaningTypes!.map((v) => v.toJson()).toList();
    }
    if (gender != null) {
      data['gender'] = gender!.map((v) => v.toJson()).toList();
    }
    if (hobbies != null) {
      data['hobbies'] = hobbies!.map((v) => v.toJson()).toList();
    }
    if (datingGroup != null) {
      data['dating_group'] = datingGroup!.map((v) => v.toJson()).toList();
    }
    data['min_income'] = minIncome;
    data['max_income'] = maxIncome;
    data['min_networth'] = minNetworth;
    data['max_networth'] = maxNetworth;
    if (occupation != null) {
      data['occupation'] = occupation!.map((v) => v.toJson()).toList();
    }
    if (relationshipStatus != null) {
      data['relationship_status'] =
          relationshipStatus!.map((v) => v.toJson()).toList();
    }
    if (diePreference != null) {
      data['die_preference'] = diePreference!.map((v) => v.toJson()).toList();
    }
    if (starSign != null) {
      data['star_sign'] = starSign!.map((v) => v.toJson()).toList();
    }
    if (personalityType != null) {
      data['personality_type'] =
          personalityType!.map((v) => v.toJson()).toList();
    }
    if (bodyType != null) {
      data['body_type'] = bodyType!.map((v) => v.toJson()).toList();
    }
    if (datingType != null) {
      data['dating_type'] = datingType!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProfileFieldResponse {
  String? id;
  String? name;

  ProfileFieldResponse({this.id, this.name});

  ProfileFieldResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
