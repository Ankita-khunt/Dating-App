import 'dart:io';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/preview_image/controller_preview.dart';
import 'package:dating_app/src/widgets/widget.card.dart';
import 'package:flutter/foundation.dart';

class ScreenPreview extends StatelessWidget {
  ScreenPreview({super.key});

  final previewController = Get.find<ControllerPreview>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
        widgetsScaffold: Scaffold(
      backgroundColor: ColorConstants().white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: CustomAppBar(
          title: "",
          isGradientAppBar: true,
          titleColor: ColorConstants().white,
          backIconColor: ColorConstants().white,
          isBackVisible: true,
          backWidgetIcon: ImageConstants.icon_cross,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: ColorConstants().white,
              height: previewController.productImages!.length > 1 ? Get.height * 0.7 : Get.height * 0.85,
              child: buildPageView(),
            ),
            if (previewController.productImages!.length > 1) buildStepIndicator()
          ],
        ),
      ),
    ));
  }

  buildPageView() {
    return GetBuilder<ControllerPreview>(
      builder: (controller) {
        return PageView.builder(
          itemCount: controller.productImages!.length,
          controller: previewController.pageController,
          itemBuilder: (BuildContext context, int index) {
            if (index != controller.currentPageNotifier.value) {
              index = controller.currentPageNotifier.value;
            }
            return InteractiveViewer(
              panEnabled: false,
              // Set it to false
              boundaryMargin: const EdgeInsets.all(0),
              minScale: 0.1,
              maxScale: 2,
              child: previewController.productImages![index].filepath == true
                  ? Image.file(File(previewController.productImages![index].imageUrl!),
                      fit: BoxFit.contain, width: Get.width)
                  : CachedNetworkImage(
                      imageUrl: "${generalSetting?.s3Url}${controller.productImages![index].imageUrl!}",
                      fit: BoxFit.contain,
                      width: Get.width,
                      errorWidget: (context, url, error) {
                        return Image.asset(ImageConstants.noimage);
                      },
                    ),
            );
          },
          onPageChanged: (int index) {
            controller.currentPageNotifier.value = index;

            controller.update();
          },
        );
      },
    );
  }

  buildStepIndicator() {
    return GetBuilder<ControllerPreview>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: SizedBox(
            height: 80,
            child: ListView.builder(
              reverse: false,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: controller.productImages!.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        if (kDebugMode) {
                          print("$index");
                        }
                        controller.currentPageNotifier.value = index;
                        previewController.changePageIndex(controller.currentPageNotifier.value);
                      },
                      child: CustomCard(
                        shadowColor: Colors.transparent,
                        isGradientCard: false,
                        backgroundColor: ColorConstants().primaryGradient,
                        borderradius: 8,
                        borderwidth: (index == previewController.currentPageNotifier.value) ? 1 : 0,
                        bordercolor: (index == previewController.currentPageNotifier.value)
                            ? ColorConstants().primaryGradient
                            : Colors.transparent,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          child: previewController.productImages![index].filepath == true
                              ? Image.file(File(previewController.productImages![index].imageUrl!))
                              : CachedNetworkImage(
                                  imageUrl:
                                      "${generalSetting?.s3Url}${previewController.productImages![index].imageUrl!}",
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                  errorWidget: (context, url, error) {
                                    return Image.asset(ImageConstants.noimage);
                                  },
                                ),
                        ),
                      ),
                    ));
              },
            ),
          ),
        );
      },
    );
  }
}
