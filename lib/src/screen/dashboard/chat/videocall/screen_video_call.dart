import 'dart:io';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/widgets/widget.card.dart';

class ScreenVideoCall extends StatelessWidget {
  const ScreenVideoCall({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseController(
      widgetsScaffold: Scaffold(
        backgroundColor: ColorConstants().white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: CustomAppBar(
            title: "Jenny Willson",
            isGradientAppBar: true,
            backIconColor: ColorConstants().white,
            titleColor: ColorConstants().white,
            isBackVisible: true,
          ),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              "lib/src/asset/images/dashboard/beautiful-girl-stands-near-walll-with-leaves (1) 1 (1).png",
              height: Platform.isAndroid
                  ? Get.height * 0.8844
                  : Get.height * 0.8835,
              width: Get.width,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomCard(
                        isGradientCard: false,
                        borderradius: 18,
                        borderwidth: 2,
                        backgroundColor: ColorConstants().primaryGradient,
                        bordercolor: ColorConstants().primaryGradient,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(18)),
                          child: Image.asset(
                            "lib/src/asset/images/dashboard/Mask group.png",
                            height: Get.height * 0.18,
                            width: Get.width * 0.28,
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
                  Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: ColorConstants().dropshadow.withOpacity(0.75),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24)),
                      border: Border.all(width: 1, color: Colors.transparent),
                      boxShadow: [
                        BoxShadow(
                          color: ColorConstants().dropshadow.withOpacity(0.11),
                          spreadRadius: 0,
                          blurRadius: 40,
                          offset:
                              const Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset(ImageConstants.icon_microphone),
                        SvgPicture.asset(ImageConstants.icon_flip),
                        SvgPicture.asset(ImageConstants.icon_videostop),
                        CustomCard(
                            isGradientCard: false,
                            borderradius: 8,
                            bordercolor: Colors.transparent,
                            borderwidth: 0,
                            backgroundColor: ColorConstants().errorRed,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                              child: SvgPicture.asset(
                                  ImageConstants.icon_call_video),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
