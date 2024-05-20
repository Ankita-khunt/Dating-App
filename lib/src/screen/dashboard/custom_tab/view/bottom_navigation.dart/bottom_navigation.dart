import 'package:badges/badges.dart' as badges;
import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/chat/chats/controller_chats.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/controller_card_swipe.dart';
import 'package:dating_app/src/screen/dashboard/matches/match/controller_match.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/profile/controller_profile.dart';

// import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class CustomTabbar extends StatelessWidget {
  CustomTabbar({Key? key}) : super(key: key);

  final tabController = Get.find<TabbarController>();
  final cardController = Get.find<ControllerCard>();
  final matchController = Get.find<ControllerMatch>();
  final chatController = Get.find<ControllerChats>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Obx(() => Scaffold(
                  backgroundColor: bottomNavigationBackgroundColor,
                  body: Stack(children: <Widget>[
                    tabController.buildOffstageNavigator(tabController.currentIndex.value),
                  ]),
                  bottomNavigationBar: OrientationBuilder(
                    builder: (context, orientation) {
                      return Container(
                        decoration: BoxDecoration(
                          color: ColorConstants().white,
                          borderRadius:
                              const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                          border: Border.all(width: 1, color: Colors.transparent),
                          boxShadow: [
                            BoxShadow(
                              color: ColorConstants().dropshadow.withOpacity(0.11),
                              spreadRadius: 0,
                              blurRadius: 40,
                              offset: const Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: BottomNavigationBar(
                          type: BottomNavigationBarType.fixed,
                          // Shifting

                          items: [
                            BottomNavigationBarItem(
                                icon: Container(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: tabController.currentIndex.value == 0
                                      ? SvgPicture.asset(
                                          ImageConstants.icon_selected_home,
                                          height: 26,
                                          width: 26,
                                        )
                                      : SvgPicture.asset(
                                          ImageConstants.icon_unselected_home,
                                          height: 26,
                                          width: 26,
                                        ),
                                ),
                                backgroundColor: ColorConstants().white,
                                label: ""),
                            BottomNavigationBarItem(
                              label: "",
                              icon: Container(
                                padding: const EdgeInsets.only(top: 15),
                                child: tabController.currentIndex.value == 1
                                    ? SvgPicture.asset(
                                        ImageConstants.icon_selected_likes,
                                        height: 26,
                                        width: 26,
                                      )
                                    : SvgPicture.asset(
                                        ImageConstants.icon_unselect_likes,
                                        height: 26,
                                        width: 26,
                                      ),
                              ),
                              backgroundColor: ColorConstants().white,
                            ),
                            BottomNavigationBarItem(
                              label: "",
                              icon: ValueListenableBuilder(
                                valueListenable: chatUnreadCount,
                                builder: (BuildContext context, value, Widget? child) {
                                  return chatUnreadCount.value.toString() != "0"
                                      ? badges.Badge(
                                          position: badges.BadgePosition.topEnd(top: 4, end: -8),
                                          badgeAnimation: const badges.BadgeAnimation.slide(
                                            curve: Curves.easeInCubic,
                                          ),
                                          showBadge: true,
                                          badgeStyle: const badges.BadgeStyle(
                                            padding: EdgeInsets.all(6),
                                            badgeColor: Colors.red,
                                          ),
                                          badgeContent: Text(
                                            chatUnreadCount.value.toString(),
                                            style: const TextStyle(color: Colors.white, fontSize: 10),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.only(top: 15),
                                            child: tabController.currentIndex.value == 2
                                                ? SvgPicture.asset(
                                                    ImageConstants.icon_selected_chat,
                                                    height: 26,
                                                    width: 26,
                                                  )
                                                : SvgPicture.asset(
                                                    ImageConstants.icon_unselected_chat,
                                                    height: 26,
                                                    width: 26,
                                                  ),
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.only(top: 15),
                                          child: tabController.currentIndex.value == 2
                                              ? SvgPicture.asset(
                                                  ImageConstants.icon_selected_chat,
                                                  height: 26,
                                                  width: 26,
                                                )
                                              : SvgPicture.asset(
                                                  ImageConstants.icon_unselected_chat,
                                                  height: 26,
                                                  width: 26,
                                                ),
                                        );
                                },
                              ),
                              backgroundColor: ColorConstants().white,
                            ),
                            BottomNavigationBarItem(
                              label: "",
                              icon: Container(
                                padding: const EdgeInsets.only(top: 15),
                                child: tabController.currentIndex.value == 3
                                    ? SvgPicture.asset(
                                        ImageConstants.icon_selected_profile,
                                        height: 26,
                                        width: 26,
                                      )
                                    : SvgPicture.asset(
                                        ImageConstants.icon_unselected_profile,
                                        height: 26,
                                        width: 26,
                                      ),
                              ),
                              backgroundColor: ColorConstants().white,
                            ),
                          ],
                          elevation: 0,

                          backgroundColor: Colors.transparent,
                          currentIndex: tabController.currentIndex.value,
                          onTap: (index) async {
                            String lattitude = await SharedPref.getString(PreferenceConstants.currentLAT);
                            String longitude = await SharedPref.getString(PreferenceConstants.currentLONG);

                            if (index == 0) {
                              bottomNavigationBackgroundColor = ColorConstants().secondaryGradient;
                            } else {
                              bottomNavigationBackgroundColor = ColorConstants().white;
                            }
                            if (index == 0) {
                              latitude = lattitude;
                              longitude = longitude;
                              cardController.lastIndex.value = (-1);
                              cardController.isDataLoaded.value = false;
                              cardController.pageIndex.value = 1;
                              cardController.cardlist = [];
                              cardController.userCardAPI();
                              showLoader();
                              cardController.countSwipeLimit.value = 0;

                              cardController.onInit();
                            } else if (index == 1) {
                              matchController.matchlistAPI();
                            } else if (index == 2) {
                              chatController.chatResponse = null;
                              chatController.isChatSearchEnable!.value = false;
                              chatController.isDataLoaded.value = false;
                              chatController.onInit();
                              chatController.chatlistAPI("0");
                            } else if (index == 3) {
                              Get.find<ControllerProfile>().onInit();
                            } else {}
                            tabController.currentIndex.value = index;
                          },
                        ),
                      );
                    },
                  ),
                ))));
  }
}
