import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/authentication/setup_profile_model.dart';

class EditProfileResponse extends Serializable {
  UserSelectedData? userSelectedData;

  EditProfileResponse({this.userSelectedData});

  EditProfileResponse.fromJson(Map<String, dynamic> json) {
    userSelectedData = json['user_selected_data'] != null
        ? UserSelectedData.fromJson(json['user_selected_data'])
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userSelectedData != null) {
      data['user_selected_data'] = userSelectedData!.toJson();
    }
    return data;
  }
}

class UserSelectedData {
  String? userId;
  String? userEmail;
  String? name;
  String? username;
  String? profileHeadline;
  String? aboutMyself;
  String? dateOfBirth;
  String? gender;
  String? interestedIn;
  String? location;
  List<ProfileFieldResponse>? hobbies;
  String? relationshipStatus;
  String? children;
  String? lat;
  String? long;
  String? height;
  String? heightMeasurementType;
  String? weight;
  String? weightMeasurementType;
  String? occupation;
  String? dietPreference;
  String? startSign;
  String? smoke;
  String? networth;
  String? drink;
  String? exercise;
  String? personalityType;
  String? bodyType;
  String? datingPersonAgeGroup;
  String? income;
  String? carYouOwn;
  String? datingType;
  String? ethinicity;
  String? cast;
  String? politicalLeaning;
  String? religeousView;

  UserSelectedData(
      {this.userId,
      this.userEmail,
      this.name,
      this.username,
      this.lat,
      this.long,
      this.profileHeadline,
      this.aboutMyself,
      this.dateOfBirth,
      this.networth,
      this.gender,
      this.interestedIn,
      this.location,
      this.hobbies,
      this.relationshipStatus,
      this.children,
      this.height,
      this.heightMeasurementType,
      this.weight,
      this.weightMeasurementType,
      this.occupation,
      this.dietPreference,
      this.startSign,
      this.smoke,
      this.drink,
      this.exercise,
      this.personalityType,
      this.bodyType,
      this.datingPersonAgeGroup,
      this.income,
      this.carYouOwn,
      this.datingType,
      this.ethinicity,
      this.cast,
      this.politicalLeaning,
      this.religeousView});

  UserSelectedData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userEmail = json['user_email'];
    lat = json['lat'];
    long = json['long'];
    name = json['name'];
    networth = json['net_worth'];
    username = json['username'];
    profileHeadline = json['profile_headline'];
    aboutMyself = json['about_myself'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    interestedIn = json['interested_in'];
    location = json['location'];
    if (json['hobbies'] != null) {
      hobbies = <ProfileFieldResponse>[];
      json['hobbies'].forEach((v) {
        hobbies!.add(ProfileFieldResponse.fromJson(v));
      });
    }
    relationshipStatus = json['relationship_status'];
    children = json['children'];
    height = json['height'];
    heightMeasurementType = json['height_measurement_type'];
    weight = json['weight'];
    weightMeasurementType = json['weight_measurement_type'];
    occupation = json['occupation'];
    dietPreference = json['diet_preference'];
    startSign = json['start_sign'];
    smoke = json['smoke'];
    drink = json['drink'];
    exercise = json['exercise'];
    personalityType = json['personality_type'];
    bodyType = json['body_type'];
    datingPersonAgeGroup = json['dating_person_age_group'];
    income = json['income'];
    carYouOwn = json['car_you_own'];
    datingType = json['dating_type'];
    ethinicity = json['ethinicity'];
    cast = json['cast'];
    politicalLeaning = json['political_leaning'];
    religeousView = json['religeous_view'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_email'] = userEmail;
    data['lat'] = lat;
    data['long'] = long;
    data['net_worth'] = networth;
    data['name'] = name;
    data['username'] = username;
    data['profile_headline'] = profileHeadline;
    data['about_myself'] = aboutMyself;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    data['interested_in'] = interestedIn;
    data['location'] = location;
    if (hobbies != null) {
      data['hobbies'] = hobbies!.map((v) => v.toJson()).toList();
    }
    data['relationship_status'] = relationshipStatus;
    data['children'] = children;
    data['height'] = height;
    data['height_measurement_type'] = heightMeasurementType;
    data['weight'] = weight;
    data['weight_measurement_type'] = weightMeasurementType;
    data['occupation'] = occupation;
    data['diet_preference'] = dietPreference;
    data['start_sign'] = startSign;
    data['smoke'] = smoke;
    data['drink'] = drink;
    data['exercise'] = exercise;
    data['personality_type'] = personalityType;
    data['body_type'] = bodyType;
    data['dating_person_age_group'] = datingPersonAgeGroup;
    data['income'] = income;
    data['car_you_own'] = carYouOwn;
    data['dating_type'] = datingType;
    data['ethinicity'] = ethinicity;
    data['cast'] = cast;
    data['political_leaning'] = politicalLeaning;
    data['religeous_view'] = religeousView;
    return data;
  }
}
