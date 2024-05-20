import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/my_likes_model.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/binding_card_swipe.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/controller_card_swipe.dart';
import 'package:flutter/cupertino.dart';

import '../../home/user_detail/binding_user_detail.dart';
import '../../home/user_detail/controller_user_detail.dart';
import 'controller_my_likes.dart';

export 'package:pull_to_refresh/pull_to_refresh.dart';

class ScreenMyLikes extends StatelessWidget {
  ScreenMyLikes({super.key});

  final myLikesController = Get.find<ControllerMyLikes>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants().white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(58.0),
            child: CustomAppBar(
              isGradientAppBar: true,
              isBackVisible: true,
              title: toLabelValue(StringConstants.my_likes),
              titleColor: ColorConstants().white,
              backIconColor: ColorConstants().white,
            )),
        body: GetBuilder<ControllerMyLikes>(
          builder: (controller) {
            return Column(
              children: <Widget>[
                TabBar(
                  tabs: [
                    Container(
                      height: 55,
                      alignment: Alignment.center,
                      child: CustomText(
                        text: toLabelValue(StringConstants.send),
                      ),
                    ),
                    Container(
                      height: 55,
                      alignment: Alignment.center,
                      child: CustomText(
                        text: toLabelValue(StringConstants.receive),
                      ),
                    )
                  ],
                  unselectedLabelColor: ColorConstants().grey,
                  indicatorColor: ColorConstants().primaryGradient,
                  labelColor: Colors.black,
                  unselectedLabelStyle: TextStyleConfig.boldTextStyle(
                      color: ColorConstants().grey, fontWeight: FontWeight.w700, fontSize: TextStyleConfig.bodyText14),
                  labelStyle: TextStyleConfig.boldTextStyle(
                      color: ColorConstants().black, fontWeight: FontWeight.w700, fontSize: TextStyleConfig.bodyText14),
                  onTap: (value) {
                    controller.selectedTabIndex.value = value;
                    controller.myLikeResponse = null;
                    controller.pageIndex.value = 1;

                    controller.isDataLoaded.value = false;
                    if (value == 0) {
                      controller.getMyLikesAPI(true);
                    } else {
                      controller.getMyLikesAPI(false);
                    }
                    controller.update();
                  },
                  indicatorWeight: 1,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.zero,
                  isScrollable: false,
                  controller: controller.tabController,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: controller.tabController,
                        children: <Widget>[
                          (myLikesController.myLikeResponse != null && myLikesController.likeList.isNotEmpty)
                              ? likesView()
                              : myLikesController.isDataLoaded.value
                                  ? noDataView(StringConstants.no_data_found)
                                  : const SizedBox(),
                          (myLikesController.myLikeResponse != null && myLikesController.receiveList.isNotEmpty)
                              ? receivesView()
                              : myLikesController.isDataLoaded.value
                                  ? noDataView(StringConstants.no_data_found)
                                  : const SizedBox(),
                        ]),
                  ),
                )
              ],
            );
          },
        ));
  }

  Widget likesView() {
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
      onRefresh: () {
        myLikesController.onRefresh(true);
      },
      onLoading: () {
        myLikesController.onLoading(true);
      },
      controller: myLikesController.sentrefreshController,
      child: GridView.builder(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: myLikesController.likeList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (BuildContext context, int index) {
          return myLikesController.likeList.isNotEmpty
              ? productCardItem(index, myLikesController.likeList[index], true)
              : myLikesController.isDataLoaded.value
                  ? noDataView(StringConstants.no_data_found)
                  : const SizedBox();
        },
      ),
    );
  }

  Widget receivesView() {
    return myLikesController.receiveList.isNotEmpty
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
            onRefresh: () {
              myLikesController.onRefresh(false);
            },
            onLoading: () {
              myLikesController.onLoading(false);
            },
            controller: myLikesController.receiverefreshController,
            child: GridView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: myLikesController.receiveList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (BuildContext context, int index) {
                return myLikesController.receiveList.isNotEmpty
                    ? productCardItem(index, myLikesController.receiveList[index], false)
                    : myLikesController.isDataLoaded.value
                        ? noDataView(StringConstants.no_data_found)
                        : const SizedBox();
              },
            ),
          )
        : myLikesController.isDataLoaded.value
            ? noDataView(StringConstants.no_data_found)
            : const SizedBox();
  }

  productCardItem(int index, SentLikes profileItem, bool isSentLikes) {
    return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: InkWell(
          onTap: () {
            BindingUserdetail().dependencies();

            Get.find<ControllerUserDetail>().userdata = null;
            Get.find<ControllerUserDetail>().isShowLikeButtom(isSentLikes ? false : true);
            Get.find<ControllerUserDetail>().isDataLoaded(false);
            Get.find<ControllerUserDetail>().getSetUpProfileAPI().then((value) {
              Get.find<ControllerUserDetail>().getUserDetailAPI(
                  profileItem.id ?? "", latitude, longitude, Get.find<ControllerCard>().isIncognitoModeON.value);
              Get.toNamed(Routes.user_detail)!.then((value) {
                myLikesController.getMyLikesAPI(isSentLikes ? true : false);
              });
            });
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: "${generalSetting?.s3Url}${profileItem.imageUrl}",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: ColorConstants().primaryGradient,
                          strokeWidth: 2,
                        )),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Positioned.fill(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, 1],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //display event name, start/end dates times and duration in a column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${profileItem.name},',
                                  style: TextStyleConfig.boldTextStyle(
                                      color: ColorConstants().white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: TextStyleConfig.bodyText12),
                                ),
                                TextSpan(
                                  text: ' ${profileItem.age}',
                                  style: TextStyleConfig.boldTextStyle(
                                      color: ColorConstants().white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: TextStyleConfig.bodyText12),
                                ),
                              ],
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Material(
                                  color: Colors.white, // Button color
                                  child: InkWell(
                                    splashColor: Colors.red, // Splash color
                                    onTap: () {
                                      showLoader();
                                      BindingCard().dependencies();

                                      Get.find<ControllerCard>().cardActionAPI(profileItem.id!, "0").then((value) {
                                        myLikesController.pageIndex.value = 1;
                                        myLikesController.getMyLikesAPI(isSentLikes);
                                        myLikesController.update();
                                      });
                                    },
                                    child: const SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: Icon(
                                          Icons.close,
                                          size: 14,
                                          color: Colors.black,
                                        )),
                                  ),
                                ),
                              ),
                              if (myLikesController.selectedTabIndex.value == 1)
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: ClipOval(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                                          gradient: LinearGradient(
                                            colors: [
                                              ColorConstants().primaryGradient,
                                              ColorConstants().secondaryGradient
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: const [0, 1],
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: InkWell(
                                            splashColor: Colors.red,
                                            onTap: () {
                                              BindingCard().dependencies();
                                              Get.find<ControllerCard>()
                                                  .cardActionAPI(profileItem.id!, "1")
                                                  .then((value) {
                                                myLikesController.pageIndex.value = 1;
                                                myLikesController.getMyLikesAPI(isSentLikes);
                                                myLikesController.update();
                                              });
                                            },
                                            child: SvgPicture.asset(
                                              ImageConstants.icon_white_heart,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
