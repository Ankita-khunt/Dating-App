import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/authentication/setup_profile_model.dart';

class UserDetailResponse extends Serializable {
  String? userId;
  String? chatId;

  String? isOnline;
  String? loaction;
  String? lat;
  String? profile;
  String? is_match_user;
  String? long;
  String? name;
  String? cardID;
  String? is_block;
  String? username;
  String? profession;
  String? profileShortDesc;
  String? aboutBio;
  String? age;
  String? distance;
  List<ProfileFieldResponse>? hobbies;
  String? height;
  String? weight;
  String? height_type;

  String? weight_type;
  String? maritalStatus;
  String? datingType;
  String? datingPersonAgeGroup;
  String? diePreference;
  String? income;
  String? netWorth;
  String? isCarOwn;
  String? starSign;
  String? isSmoke;
  String? isDrink;
  String? isExercise;
  String? bodyType;
  String? personalityType;
  String? ethnicity;
  String? cast;
  String? politicalLeaning;
  List<Images>? images;

  UserDetailResponse(
      {this.userId,
      this.isOnline,
      this.chatId,
      this.loaction,
      this.is_match_user,
      this.is_block,
      this.lat,
      this.long,
      this.height_type,
      this.weight_type,
      this.name,
      this.cardID,
      this.username,
      this.profile,
      this.profession,
      this.profileShortDesc,
      this.aboutBio,
      this.age,
      this.distance,
      this.hobbies,
      this.height,
      this.weight,
      this.maritalStatus,
      this.datingType,
      this.datingPersonAgeGroup,
      this.diePreference,
      this.income,
      this.netWorth,
      this.isCarOwn,
      this.starSign,
      this.isSmoke,
      this.isDrink,
      this.isExercise,
      this.bodyType,
      this.personalityType,
      this.ethnicity,
      this.cast,
      this.politicalLeaning,
      this.images});

  UserDetailResponse.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    chatId = json['chat_id'];
    is_match_user = json['is_match_user'];
    isOnline = json['is_online'];
    loaction = json['loaction'];
    lat = json['lat'];
    profile = json['profile'];
    is_block = json['is_block'];
    long = json['long'];
    cardID = json['card_id'];
    height_type = json['height_type'];
    weight_type = json['weight_type'];
    name = json['name'];
    username = json['username'];
    profession = json['profession'];
    profileShortDesc = json['profile_short_desc'];
    aboutBio = json['about_bio'];
    age = json['age'];
    distance = json['distance'];
    if (json['hobbies'] != null) {
      hobbies = <ProfileFieldResponse>[];
      json['hobbies'].forEach((v) {
        hobbies!.add(ProfileFieldResponse.fromJson(v));
      });
    }
    height = json['height'];
    weight = json['weight'];
    maritalStatus = json['marital_status'];
    datingType = json['dating_type'];
    datingPersonAgeGroup = json['dating_person_age_group'];
    diePreference = json['die_preference'];
    income = json['income'];
    netWorth = json['Net Worth'];
    isCarOwn = json['is_car_own'];
    starSign = json['star_sign'];
    isSmoke = json['is_smoke'];
    isDrink = json['is_drink'];
    isExercise = json['is_exercise'];
    bodyType = json['body_type'];
    personalityType = json['personality_type'];
    ethnicity = json['ethnicity'];
    cast = json['cast'];
    politicalLeaning = json['political_leaning'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['chat_id'] = chatId;
    data['is_block'] = is_block;
    data['is_online'] = isOnline;
    data['loaction'] = loaction;
    data['lat'] = lat;
    data['height_type'] = height_type;
    data['weight_type'] = weight_type;
    data['is_match_user'] = is_match_user;
    data['long'] = long;
    data['profile'] = profile;
    data['name'] = name;
    data['card_id'] = cardID;
    data['username'] = username;
    data['profession'] = profession;
    data['profile_short_desc'] = profileShortDesc;
    data['about_bio'] = aboutBio;
    data['age'] = age;
    data['distance'] = distance;
    if (hobbies != null) {
      data['hobbies'] = hobbies!.map((v) => v.toJson()).toList();
    }
    data['height'] = height;
    data['weight'] = weight;
    data['marital_status'] = maritalStatus;
    data['dating_type'] = datingType;
    data['dating_person_age_group'] = datingPersonAgeGroup;
    data['die_preference'] = diePreference;
    data['income'] = income;
    data['Net Worth'] = netWorth;
    data['is_car_own'] = isCarOwn;
    data['star_sign'] = starSign;
    data['is_smoke'] = isSmoke;
    data['is_drink'] = isDrink;
    data['is_exercise'] = isExercise;
    data['body_type'] = bodyType;
    data['personality_type'] = personalityType;
    data['ethnicity'] = ethnicity;
    data['cast'] = cast;
    data['political_leaning'] = politicalLeaning;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String? id;
  String? imageUrl;
  bool? filepath;

  Images({this.id, this.imageUrl, this.filepath});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = imageUrl;
    return data;
  }
}
