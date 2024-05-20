class ApiResponse<T extends Serializable> {
  dynamic code;
  String? message;
  String? callDeclined;
  T? result;

  ApiResponse({this.message, this.result, this.code, this.callDeclined});

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    return ApiResponse<T>(
        message: json["message"],
        code: json["code"],
        callDeclined: json["call_declined"],
        result: json["data"] != null ? create(json["data"]) : null);
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
        "call_declined": callDeclined,
        "data": result?.toJson(),
      };
}

abstract class Serializable {
  Map<String, dynamic> toJson();
}

class ResponseModel {
  dynamic code;
  String? message;

  ResponseModel({this.code, this.message});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}
