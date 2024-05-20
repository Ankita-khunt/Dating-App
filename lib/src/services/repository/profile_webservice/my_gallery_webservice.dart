import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/gallery_model.dart';

class MyGalleryRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse<GalleryResponse>?> getMygallery() async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;

    final response = await _helper.post(APIConstants.get_my_gallery_endpont,
        formdata: _helper.body);

    ApiResponse<GalleryResponse>? data =
        ApiResponse.fromJson(response, (result) {
      return GalleryResponse.fromJson(result);
    });
    return data;
  }

  Future<ResponseModel?> removeGalleryPhoto(String imageID) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body["image_id"] = imageID;

    final response = await _helper.post(
        APIConstants.remove_gallary_photo_endpont,
        formdata: _helper.body);
    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }

  Future<ResponseModel?> uploadGalleryPhoto(String images) async {
    String userID = await SharedPref.getString(PreferenceConstants.userID);
    String token = await SharedPref.getString(PreferenceConstants.token);

    _helper.body["user_id"] = userID;
    _helper.body["token"] = token;
    _helper.body["images"] = images;

    final response = await _helper.post(
        APIConstants.updalod_gallery_photo_endpont,
        formdata: _helper.body);
    if (response != null) {
      return ResponseModel.fromJson(response);
    } else {
      return null;
    }
  }
}
