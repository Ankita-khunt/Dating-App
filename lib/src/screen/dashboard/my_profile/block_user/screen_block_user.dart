import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/blockuser_model.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/block_user/controller_block_user.dart';
import 'package:dating_app/src/widgets/custom_chat_view/chat_list.dart';
import 'package:dating_app/src/widgets/custom_divider.dart';
import 'package:flutter/cupertino.dart';

class ScreenBlockUser extends StatelessWidget {
  ScreenBlockUser({super.key});

  final blockUserController = Get.find<ControllerBlockUser>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
        widgetsScaffold: Scaffold(
            backgroundColor: ColorConstants().white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(58),
                child: CustomAppBar(
                  title: toLabelValue(StringConstants.block_user)
                      .toLowerCase()
                      .capitalizeFirst!,
                  isBackVisible: true,
                  isGradientAppBar: true,
                  backIconColor: ColorConstants().white,
                  titleColor: ColorConstants().white,
                )),
            body: GetBuilder<ControllerBlockUser>(
              builder: (controller) {
                return controller.blockUserList != null &&
                        controller.blockUserList!.blockedUsers!.isNotEmpty
                    ? blockList()
                    : controller.isDataLoaded.value
                        ? noDataView(StringConstants.no_data_found)
                        : const SizedBox();
              },
            )));
  }

  Widget blockList() {
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
      onRefresh: blockUserController.onRefresh,
      onLoading: blockUserController.onLoading,
      controller: blockUserController.refreshController,
      child: ListView.separated(
        itemCount: blockUserController.blockUserList!.blockedUsers!.length,
        itemBuilder: (context, index) {
          BlockedUsers blockuser =
              blockUserController.blockUserList!.blockedUsers![index];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: CachedNetworkImage(
                        imageUrl:
                            "${generalSetting?.s3Url}${blockuser.userImage}",
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: blockuser.name,
                          style: TextStyleConfig.boldTextStyle(
                              fontSize: TextStyleConfig.bodyText16,
                              fontWeight: FontWeight.w700,
                              color: ColorConstants().black),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        CustomText(
                          text: blockuser.username,
                          style: TextStyleConfig.boldTextStyle(
                              fontSize: TextStyleConfig.bodyText14,
                              fontWeight: FontWeight.w400,
                              color: ColorConstants().grey1),
                        ),
                      ],
                    ),
                  ],
                ),
                PrimaryButton(
                  btnWidth: Get.width * 0.3,
                  fontWeight: FontWeight.w700,
                  btnFontSize: TextStyleConfig.bodyText14,
                  btnTitle: StringConstants.unblock,
                  onClicked: () {
                    blockUserController.unblockUserDialogue(
                        blockuser.userId!, "0", blockuser.name);
                  },
                )
              ],
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
