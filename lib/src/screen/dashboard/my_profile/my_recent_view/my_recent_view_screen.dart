import 'package:dating_app/src/screen/dashboard/chat/chats/controller_chats.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/my_recent_view/my_recent_view_controller.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../imports.dart';
import '../../home/card_swip/controller_card_swipe.dart';
import '../../home/user_detail/binding_user_detail.dart';
import '../../home/user_detail/controller_user_detail.dart';

class MyRecentViewScreen extends StatelessWidget {
  MyRecentViewScreen({super.key});

  final recentViewController = Get.find<MyRecentViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(58.0),
          child: CustomAppBar(
            isGradientAppBar: true,
            isBackVisible: true,
            backIconColor: ColorConstants().white,
            title: toLabelValue(StringConstants.my_recently_view),
            titleColor: ColorConstants().white,
          )),
      backgroundColor: Colors.white,
      body: Obx(() => recentViewController.recentViewList.isNotEmpty
          ? SmartRefresher(
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
              onRefresh: recentViewController.onRefresh,
              onLoading: recentViewController.onLoading,
              controller: recentViewController.refreshController,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 16),
                shrinkWrap: true,
                itemCount: recentViewController.recentViewList.length,
                itemBuilder: (context, index) {
                  var data = recentViewController.recentViewList[index];
                  return SizedBox(
                    width: Get.width,
                    child: ListTile(
                      onTap: () {
                        BindingUserdetail().dependencies();

                        Get.find<ControllerUserDetail>().userdata = null;
                        Get.find<ControllerUserDetail>().isShowLikeButtom(true);
                        Get.find<ControllerUserDetail>().isDataLoaded(false);
                        Get.find<ControllerUserDetail>().getSetUpProfileAPI().then((value) {
                          Get.find<ControllerUserDetail>().getUserDetailAPI(
                              data.id ?? "", latitude, longitude, Get.find<ControllerCard>().isIncognitoModeON.value);
                          Get.toNamed(Routes.user_detail);
                        });
                      },
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: CachedNetworkImage(
                          imageUrl: "${generalSetting?.s3Url}${data.profile}",
                          height: 100,
                          width: 60,
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return errorImage();
                          },
                          errorWidget: (context, url, error) {
                            return errorImage();
                          },
                        ),
                      ),
                      title: Text(data.name ?? ""),
                      trailing: Text(
                          DateTime.parse(data.timestamp ?? "").toLocal().timeAgo(numericDates: false).toString() ?? ""),
                      subtitle: Text(toLabelValue(StringConstants.viewed_your_profile)),
                    ),
                  );
                },
              ),
            )
          : recentViewController.isDataLoaded.value
              ? noDataView(StringConstants.no_data_found)
              : const SizedBox()),
    );
  }
}
