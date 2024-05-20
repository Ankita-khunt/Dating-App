// ignore_for_file: invalid_use_of_protected_member

import 'dart:io';

import 'package:dating_app/src/model/dashboard/user_detail_model.dart';
import 'package:dating_app/src/model/profile/gallery_model.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/preview_image/binding_preview.dart';

import '../../../../../imports.dart';
import '../../home/user_detail/preview_image/controller_preview.dart';
import 'controller_my_gallery.dart';

class ScreenMyGallery extends StatelessWidget {
  ScreenMyGallery({super.key});

  final myGalleryController = Get.find<ControllerMyGallery>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants().white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(58.0),
            child: CustomAppBar(
              isGradientAppBar: true,
              isBackVisible: true,
              title: toLabelValue(StringConstants.my_gallery),
              titleColor: ColorConstants().white,
              backIconColor: ColorConstants().white,
            )),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 28.0, right: 20, left: 20),
          child: PrimaryButton(
            btnTitle: StringConstants.update,
            onClicked: isUserSubscribe == true
                ? () {
                    final images = myGalleryController.pickedImageList.where((element) => element.path != "");

                    if (images.isNotEmpty) {
                      showLoader();

                      if (myGalleryController.removeimageListData.isNotEmpty) {
                        for (int i = 0; i < myGalleryController.removeimageListData.length; i++) {
                          myGalleryController.removePhotoAPI(myGalleryController.removeimageListData[i].toString(), i);
                        }
                      } else {
                        myGalleryController.uploadPhotoAPI();
                      }
                    } else {
                      showSnackBar(
                        Get.overlayContext,
                        toLabelValue(StringConstants.add_2_images),
                      );
                    }
                  }
                : null,
          ),
        ),
        body: GetBuilder<ControllerMyGallery>(
          builder: (controller) {
            return (controller.gallaryResponse != null)
                ? GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(16),
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    crossAxisCount: 3,
                    children: List.generate(controller.pickedImageList.value.length, (index) => imageItemWidget(index)))
                : controller.isDataLoaded.value
                    ? noDataView(StringConstants.no_data_found)
                    : const SizedBox();
          },
        ));
  }

  Widget imageItemWidget(int index) {
    GallaryList imgModel = GallaryList();

    if (index < myGalleryController.gallaryResponse!.gallaryList!.length &&
        (myGalleryController.pickedImageList[index].path != "")) {
      imgModel = myGalleryController.gallaryResponse!.gallaryList![index];
    }
    return IgnorePointer(
      ignoring: index > myGalleryController.uploadImageCount ? true : false,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: (imgModel.image != null && imgModel.image!.isNotEmpty)
            ? Stack(
                children: [
                  InkWell(
                    onTap: () {
                      BindingPreview().dependencies();
                      Get.find<ControllerPreview>().productImages = [Images(id: "0", imageUrl: imgModel.image!)];
                      Get.toNamed(Routes.preview_image);
                    },
                    child: CachedNetworkImage(
                      imageUrl: '${generalSetting?.s3Url}${imgModel.image!}',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      height: 120,
                      width: 120,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: ColorConstants().primaryGradient,
                              strokeWidth: 2,
                            )),
                      ),
                      errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        myGalleryController.update();
                        myGalleryController.removeimageListData
                            .add(myGalleryController.gallaryResponse!.gallaryList![index].id.toString());
                        myGalleryController.gallaryResponse!.gallaryList!.removeAt(index);

                        myGalleryController.pickedImageList[index] = File('');
                        myGalleryController.pickedImageList.value =
                            List.generate(myGalleryController.uploadImageCount, (index) => File(""));
                        for (int i = 0; i < myGalleryController.gallaryResponse!.gallaryList!.length; i++) {
                          myGalleryController.pickedImageList[i] =
                              File("${myGalleryController.gallaryResponse!.gallaryList![i].image}");
                        }
                        myGalleryController.update();
                      },
                      child: SvgPicture.asset(
                        ImageConstants.icon_close,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ],
              )
            : (myGalleryController.pickedImageList[index].path.isNotEmpty)
                ? Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          BindingPreview().dependencies();
                          Get.find<ControllerPreview>().productImages = [
                            Images(id: "0", imageUrl: myGalleryController.pickedImageList[index].path, filepath: true)
                          ];
                          Get.toNamed(Routes.preview_image);
                        },
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image.file(
                            File(myGalleryController.pickedImageList[index].path),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            for (int i = 0; i < myGalleryController.pickedImageList[index].path.length; i++) {
                              if (myGalleryController.pickedImageList[i].path ==
                                  myGalleryController.pickedImageList[index].path) {
                                myGalleryController.pickedImageList[index] = File('');
                                myGalleryController.update(myGalleryController.pickedImageList);
                              }
                            }
                            myGalleryController.pickedImageList[index] = File('');

                            myGalleryController.update();
                          },
                          child: SvgPicture.asset(
                            ImageConstants.icon_close,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ],
                  )
                : InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: (myGalleryController.pickedImageList[index].path.isNotEmpty)
                        ? null
                        : () async {
                            if (isUserSubscribe == true) {
                              List<File> pickedImage = await showImageSelectionBottomSheet();

                              myGalleryController.pickedImageList[index] = pickedImage.first;
                              myGalleryController.update();
                            } else {
                              Get.toNamed(Routes.subscription);
                            }
                          },
                    child: Container(
                        color: ColorConstants().steppercolor,
                        child: SvgPicture.asset(
                          ImageConstants.icon_add,
                          fit: BoxFit.scaleDown,
                        )),
                  ),
      ),
    );
  }
}
