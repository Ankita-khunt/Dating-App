import 'package:dating_app/imports.dart';

class LabelRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<LabelResponse?> fetchlabel() async {
    final response =
        await _helper.post(APIConstants.label_endpoint, formdata: _helper.body);
    if (response != null) {
      return LabelResponse.fromJson(response);
    } else {
      return null;
    }
  }
}
