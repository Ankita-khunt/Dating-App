import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/boost/boost_history/controller_boost_history.dart';
import 'package:dating_app/src/widgets/custom_divider.dart';

class ScreenBoostHistory extends StatelessWidget {
  const ScreenBoostHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseController(
        widgetsScaffold: Scaffold(
            backgroundColor: ColorConstants().white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(58.0),
                child: CustomAppBar(
                  isGradientAppBar: true,
                  isBackVisible: true,
                  backIconColor: ColorConstants().white,
                  title: toLabelValue(StringConstants.history),
                  titleColor: ColorConstants().white,
                )),
            body: GetBuilder<ControllerBoostHistory>(
              builder: (controller) {
                return controller.historyResponse != null &&
                        controller.historyResponse!.history!.isNotEmpty
                    ? ListView.separated(
                        itemCount: controller.historyResponse!.history!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: toLabelValue(
                                          controller.addonTypeID.value == 0
                                              ? StringConstants.boost_profile
                                              : StringConstants.swipe),
                                      style: TextStyleConfig.regularTextStyle(
                                          fontSize: TextStyleConfig.bodyText16),
                                    ),
                                    CustomText(
                                      text: dateformate(
                                          controller.historyResponse!
                                              .history![index].date!,
                                          "MMM dd, yyyy"),
                                      style: TextStyleConfig.regularTextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: TextStyleConfig.bodyText14),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 4),
                                CustomText(
                                  text: dateformate(
                                      controller.historyResponse!
                                          .history![index].date!,
                                      "hh:mm a"),
                                  style: TextStyleConfig.regularTextStyle(
                                      color: ColorConstants().grey,
                                      fontSize: TextStyleConfig.bodyText14),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return CustomDivider();
                        },
                      )
                    : controller.isDataLoaded.value
                        ? noDataView(StringConstants.no_data_found)
                        : const SizedBox();
              },
            )));
  }
}
