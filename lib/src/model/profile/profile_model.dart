import 'package:dating_app/imports.dart';

class ProfileResponse extends Serializable {
  String? userId;
  String? name;
  String? email;
  String? profileImage;
  String? isProfileHide;
  String? age;

  ProfileResponse(
      {this.userId,
      this.name,
      this.email,
      this.profileImage,
      this.isProfileHide,
      this.age});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    profileImage = json['profile_image'];
    isProfileHide = json['is_profile_hide'];
    age = json['age'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['profile_image'] = profileImage;
    data['is_profile_hide'] = isProfileHide;
    data['age'] = age;
    return data;
  }
}
