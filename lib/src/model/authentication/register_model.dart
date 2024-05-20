import 'package:dating_app/imports.dart';

class RegisterResponse extends Serializable {
  String? userId;
  String? token;

  RegisterResponse({this.userId, this.token});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    token = json['token'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['token'] = token;
    return data;
  }
}
