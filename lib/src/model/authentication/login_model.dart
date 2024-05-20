import 'package:dating_app/imports.dart';

class LoginResponse extends Serializable {
  String? userId;
  String? username;
  String? email;
  String? token;
  String? isSetUpProfile;
  String? is_full_setupProfile;
  String? is_subscribed;

  LoginResponse(
      {this.userId,
      this.username,
      this.email,
      this.token,
      this.is_subscribed,
      this.is_full_setupProfile,
      this.isSetUpProfile});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    email = json['email'];
    token = json['token'];
    is_subscribed = json['is_subscribed'];
    is_full_setupProfile = json['is_full_setupProfile'];
    isSetUpProfile = json['is_profile_set'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['username'] = username;
    data['email'] = email;
    data['token'] = token;
    data['is_subscribed'] = is_subscribed;
    data['is_full_setupProfile'] = is_full_setupProfile;
    data['is_profile_set'] = isSetUpProfile;
    return data;
  }
}
