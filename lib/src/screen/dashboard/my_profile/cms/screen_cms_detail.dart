import 'package:dating_app/src/screen/dashboard/my_profile/cms/controller_cms.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../../imports.dart';

class ScreenCMSDetails extends StatelessWidget {
  ScreenCMSDetails({super.key});

  RxString cmsTitle = ''.obs;
  RxString cmsDescription = ''.obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerCMS>(
      builder: (controller) {
        return Scaffold(
            backgroundColor: ColorConstants().white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(58.0),
                child: CustomAppBar(
                  isGradientAppBar: true,
                  isBackVisible: true,
                  title: controller.cmsResponse!.title!,
                  titleColor: ColorConstants().white,
                  backIconColor: ColorConstants().white,
                )),
            body: controller.cmsResponse != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        Html(
                          data: controller.cmsResponse?.content!,
                        )
                      ],
                    ),
                  )
                : controller.isDataLoaded.value
                    ? noDataView(StringConstants.no_data_found)
                    : const SizedBox());
      },
    );
  }
}
