import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/controller_card_swipe.dart';
import 'package:dating_app/src/screen/dashboard/home/notification/controller_notification.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/binding_user_detail.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/controller_user_detail.dart';
import 'package:dating_app/src/screen/dashboard/matches/match/controller_match.dart';
import 'package:dating_app/src/screen/dashboard/matches/match_detail/binding_matchDetail.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_likes/controller_my_likes.dart';
import 'package:dating_app/src/widgets/custom_divider.dart';
import 'package:flutter/cupertino.dart';

import '../../chat/chat_detail/controller_chat_detail.dart';

class ScreenNotification extends StatelessWidget {
  ScreenNotification({super.key});

  final notificationController = Get.find<ControllerNotification>();
  final tabbarController = Get.find<TabbarController>();
  final matchController = Get.find<ControllerMatch>();
  final userdetailController = Get.find<ControllerUserDetail>();
  final cardController = Get.find<ControllerCard>();
  final chatdetailController = Get.find<ControllerChatDetail>();

  final mylikesController = Get.find<ControllerMyLikes>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
        widgetsScaffold: Scaffold(
            backgroundColor: ColorConstants().white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(58),
                child: CustomAppBar(
                  title: toLabelValue(StringConstants.notification),
                  isGradientAppBar: true,
                  isBackVisible: true,
                  titleColor: ColorConstants().white,
                  backIconColor: ColorConstants().white,
                )),
            body: GetBuilder<ControllerNotification>(
              builder: (controller) {
                return controller.notificationList != null && controller.notificationList!.isNotEmpty
                    ? notificationList()
                    : controller.isDataLoaded.value
                        ? noDataView(StringConstants.no_data_found)
                        : const SizedBox();
              },
            )));
  }

  Widget notificationList() {
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
      onRefresh: notificationController.onRefresh,
      onLoading: notificationController.onLoading,
      controller: notificationController.refreshController,
      child: ListView.separated(
        itemCount: notificationController.notificationList!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () async {
                if (notificationController.notificationList?[index].type == "1") {
                  //Chat redirection
                  bottomNavigationBackgroundColor = ColorConstants().white;
                  tabbarController.currentIndex.value = 2;
                  Get.back();
                  chatdetailController.chatDetailResponse = null;
                  chatdetailController.chatdetailAPI(notificationController.notificationList?[index].chatID ?? "",
                      notificationController.notificationList?[index].userId);
                  Get.toNamed(Routes.chat_detail);
                } else if (notificationController.notificationList?[index].type == "2") {
                  //VideoCall notification
                } else if (notificationController.notificationList?[index].type == "3") {
                  //MY likes Redirection
                  bottomNavigationBackgroundColor = ColorConstants().white;

                  tabbarController.currentIndex.value = 3;
                  Get.back();

                  mylikesController.tabController.index = 1;
                  mylikesController.isDataLoaded(false);
                  mylikesController.myLikeResponse = null;
                  mylikesController.receiveList.value = [];

                  mylikesController.getMyLikesAPI(false);
                  Get.toNamed(Routes.myLikesRoute);
                } else if (notificationController.notificationList?[index].type == "4") {
                  //Match Redirection
                  BindingMatchDetail().dependencies();
                  bottomNavigationBackgroundColor = ColorConstants().white;
                  tabbarController.currentIndex.value = 1;
                  Get.back();
                  matchController.matchlistAPI();
                } else if (notificationController.notificationList?[index].type == "5") {
                  //UserDetail redirection

                  bottomNavigationBackgroundColor = ColorConstants().white;

                  tabbarController.currentIndex.value = 0;
                  Get.back();
                  BindingUserdetail().dependencies();

                  userdetailController.isShowLikeButtom(true);
                  userdetailController.isDataLoaded(false);
                  userdetailController.getSetUpProfileAPI().then((value) {
                    userdetailController
                        .getUserDetailAPI(notificationController.notificationList?[index].userId ?? "",
                            latitude.toString(), longitude.toString(), cardController.isIncognitoModeON.value)
                        .then((value) {
                      Get.toNamed(Routes.user_detail);
                    });
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    child: CachedNetworkImage(
                      imageUrl: "${generalSetting?.s3Url}${notificationController.notificationList![index].img}",
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      height: 52,
                      width: 52,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: CustomText(
                                text: notificationController.notificationList?[index].name,
                                maxlines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyleConfig.boldTextStyle(
                                    fontSize: TextStyleConfig.bodyText16,
                                    fontWeight: FontWeight.w700,
                                    color: ColorConstants().black),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            CustomText(
                              text: DateTime.parse(
                                notificationController.notificationList![index].created_at.toString(),
                              ).toLocal().timeAgo(numericDates: false),
                              style: TextStyleConfig.boldTextStyle(
                                  fontSize: TextStyleConfig.bodyText14,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstants().grey),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        CustomText(
                          text: notificationController.notificationList?[index].message,
                          maxlines: 2,
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
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return CustomDivider();
        },
      ),
    );
  }
}
