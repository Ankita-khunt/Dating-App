import 'dart:io';

import 'package:dating_app/src/model/profile/gallery_model.dart';
import 'package:dating_app/src/services/repository/profile_webservice/my_gallery_webservice.dart';
import 'package:flutter/foundation.dart';

import '../../../../../imports.dart';

class ControllerMyGallery extends GetxController {
  RxBool isDataLoaded = false.obs;
  RxList<File> pickedImageList = <File>[].obs;
  List<String> imageListData = [];
  List<String> removeimageListData = [];
  int uploadImageCount = 0;
  GalleryResponse? gallaryResponse;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    pickedImageList.value = List.generate(6, (index) => File(""));
  }

  //get Mylikes API
  getMyGalleryAPI() async {
    uploadImageCount = await SharedPref.getInt(PreferenceConstants.uploadImageCount);

    if (!isDataLoaded.value) showLoader();
    pickedImageList.value = List.generate(uploadImageCount, (index) => File(""));

    ApiResponse<GalleryResponse>? response = await MyGalleryRepository().getMygallery();

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      gallaryResponse = response.result;

      for (int i = 0; i < gallaryResponse!.gallaryList!.length; i++) {
        if (i <= uploadImageCount) {
          pickedImageList[i] = File("${gallaryResponse!.gallaryList![i].image}");
        }
      }
      removeimageListData = [];
      imageListData.clear();
      isDataLoaded(true);
      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    isDataLoaded(true);

    hideLoader();
  }

  //removePhoto API
  removePhotoAPI(String imageID, int index) async {
    showLoader();

    ResponseModel? response = await MyGalleryRepository().removeGalleryPhoto(imageID);

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      hideLoader();
      var count = pickedImageList.where((element) => element.path != "" && element.path.contains('/'));

      removeimageListData.removeWhere((element) => element == imageID);
      if (removeimageListData.isEmpty) {
        uploadPhotoAPI();
      }
      if (count.isEmpty) {
        showSnackBar(Get.overlayContext, (toLabelValue(response.message!)));
      }

      update();
    } else {
      hideLoader();

      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }

  //Upload Photo API
  uploadPhotoAPI() async {
    imageListData = [];
    var count = pickedImageList.where((element) => element.path != "" && element.path.contains("/"));
    if (kDebugMode) {
      print("====== ${count.length}");
    }
    if (count.isNotEmpty) {
      for (var image in pickedImageList) {
        if (image.path.contains("/")) {
          uploadS3Image(File(image.path)).then((value) async {
            if (kDebugMode) {
              print("success => $value");
            }
            imageListData.add(value.split("/").last);

            if (count.length == imageListData.length) {
              ResponseModel? response = await MyGalleryRepository().uploadGalleryPhoto(imageListData.join(","));

              if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
                hideLoader();
                Get.back();
                showSnackBar(Get.overlayContext, (toLabelValue(response.message!)));
                update();
              } else {
                hideLoader();

                showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
              }
            }
          });
        }
      }
    } else {
      hideLoader();
      Get.back();
    }
  }
}

class ImageModel {
  final String? id;
  final String? urlPath;
  String? filePath;

  ImageModel({this.id, this.urlPath, this.filePath});
}
