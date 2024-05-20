import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/cms/faqs/controller_faq.dart';
import 'package:dating_app/src/widgets/custom_divider.dart';

import 'controller_cms.dart';

class ScreenCMS extends StatelessWidget {
  ScreenCMS({super.key});

  final cmsController = Get.find<ControllerCMS>();
  final faqsController = Get.find<ControllerFaq>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants().white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: CustomAppBar(
            isGradientAppBar: true,
            isBackVisible: true,
            title: toLabelValue(StringConstants.more),
            titleColor: ColorConstants().white,
            backIconColor: ColorConstants().white,
          )),
      body: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cmsController.cmsList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                dense: true,
                title: CustomText(
                  text: cmsController.cmsList[index] ?? '',
                  style: TextStyleConfig.regularTextStyle(
                      color: ColorConstants().black, fontWeight: FontWeight.w500, fontSize: TextStyleConfig.bodyText15),
                ),
                trailing: SvgPicture.asset(
                  ImageConstants.icon_arrow_forward,
                  fit: BoxFit.scaleDown,
                ),
                onTap: () {
                  // About Us
                  if (index == 0 || index == 2 || index == 3) {
                    if (index == 0) {
                      cmsController.cmsAPI(1.toString());
                    } else if (index == 2) {
                      cmsController.cmsAPI(3.toString());
                    } else if (index == 3) {
                      cmsController.cmsAPI(2.toString());
                    }
                  } else if (index == 1) {
                    faqsController.faqsAPI();
                  } else if (index == 4) {
                    Get.toNamed(Routes.contactUsRoute);
                  }
                },
              ),
              CustomDivider()
            ],
          );
        },
      ),
    );
  }
}
