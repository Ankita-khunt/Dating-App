import 'package:dating_app/imports.dart';

class ForgotPassResponse extends Serializable {
  String? userId;
  String? token;

  ForgotPassResponse({this.userId, this.token});

  ForgotPassResponse.fromJson(Map<String, dynamic> json) {
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
