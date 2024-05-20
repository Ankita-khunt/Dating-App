import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/matches/match/controller_match.dart';
import 'package:dating_app/src/screen/dashboard/matches/match_detail/binding_matchDetail.dart';
import 'package:dating_app/src/screen/dashboard/matches/match_detail/controller_matchDetail.dart';
import 'package:dating_app/src/widgets/custom_chat_view/chat_list.dart';
import 'package:dating_app/src/widgets/custom_divider.dart';
import 'package:flutter/cupertino.dart';

class ScreenMatch extends StatelessWidget {
  ScreenMatch({super.key});

  final matchController = Get.find<ControllerMatch>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
        widgetsScaffold: Scaffold(
            backgroundColor: ColorConstants().white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(58),
                child: CustomAppBar(
                  title: toLabelValue(StringConstants.match),
                  isGradientAppBar: true,
                  titleColor: ColorConstants().white,
                  backIconColor: ColorConstants().white,
                )),
            body: GetBuilder<ControllerMatch>(
              builder: (controller) {
                return matchList();
              },
            )));
  }

  Widget matchList() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: MaterialClassicHeader(
        color: ColorConstants().primaryGradient,
      ),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator(
              color: ColorConstants().primaryGradient,
            );
          } else {
            body = const Text("");
          }

          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      onRefresh: matchController.onRefresh,
      onLoading: matchController.onLoading,
      controller: matchController.refreshController,
      child: matchController.matchlist.isNotEmpty
          ? ListView.separated(
              itemCount: matchController.matchlist.length,
              itemBuilder: (context, index) {
                MatchList matchlist = matchController.matchlist[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () {
                      BindingMatchDetail().dependencies();
                      Get.find<ControllerMatchDetail>().getprofileAPI();
                      Get.find<ControllerMatchDetail>().matchedUser = matchlist;
                      Get.toNamed(Routes.matchDetail);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${generalSetting?.s3Url}${matchlist.userImage}",
                                fit: BoxFit.cover,
                                height: 52,
                                width: 52,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: Get.width * 0.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: matchlist.name,
                                    maxlines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyleConfig.boldTextStyle(
                                        fontSize: TextStyleConfig.bodyText16,
                                        fontWeight: FontWeight.w700,
                                        color: ColorConstants().black),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  CustomText(
                                    text: matchlist.username,
                                    maxlines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyleConfig.boldTextStyle(
                                        fontSize: TextStyleConfig.bodyText14,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstants().grey1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        PrimaryButton(
                          btnWidth: Get.width * 0.3,
                          fontWeight: FontWeight.w700,
                          btnFontSize: TextStyleConfig.bodyText14,
                          btnTitle: StringConstants.remove,
                          onClicked: () {
                            matchController.removeMatchAPI(matchlist.userId!);
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return CustomDivider();
              },
            )
          : matchController.isDataLoaded.value
              ? noDataView(StringConstants.no_data_found)
              : const SizedBox(),
    );
  }
}
