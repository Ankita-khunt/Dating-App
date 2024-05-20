import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/chat/chat_detail/binding_chat_detail.dart';
import 'package:dating_app/src/screen/dashboard/chat/chat_detail/controller_chat_detail.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/binding_card_swipe.dart';
import 'package:dating_app/src/screen/dashboard/matches/match/controller_match.dart';
import 'package:dating_app/src/screen/dashboard/matches/match_detail/controller_matchDetail.dart';

class ScreenMatchDetail extends StatelessWidget {
  ScreenMatchDetail({super.key});

  final matchDetailController = Get.find<ControllerMatchDetail>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
        widgetsScaffold: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: ColorConstants().white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(58),
                child: CustomAppBar(
                  isGradientAppBar: true,
                  isBackVisible: true,
                  title: toLabelValue(StringConstants.its_match),
                  titleColor: ColorConstants().white,
                  backIconColor: ColorConstants().white,
                )),
            body: GetBuilder<ControllerMatchDetail>(
              builder: (controller) {
                return controller.profileresponse != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: Get.height * 0.48,
                            width: Get.width * 0.779,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 90,
                                      ),
                                      child: RotationTransition(
                                          turns: const AlwaysStoppedAnimation(15 / 360),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.transparent,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: ColorConstants().black.withOpacity(.15),
                                                  spreadRadius: 0,
                                                  blurRadius: 21.46,
                                                  offset: const Offset(0, 21.46), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '${generalSetting?.s3Url}${controller.profileresponse?.profileImage}',
                                                fit: BoxFit.cover,
                                                height: Get.height * 0.25,
                                                width: Get.width * 0.355,
                                              ),
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 80, right: 90),
                                      child: RotationTransition(
                                          turns: const AlwaysStoppedAnimation(-10 / 360),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: ColorConstants().white,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(
                                                width: 0,
                                                color: Colors.transparent,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: ColorConstants().black.withOpacity(.15),
                                                  spreadRadius: 0,
                                                  blurRadius: 21.46,
                                                  offset: const Offset(0, 21.46), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '${generalSetting?.s3Url}${controller.matchedUser?.userImage}',
                                                fit: BoxFit.cover,
                                                height: Get.height * 0.25,
                                                width: Get.width * 0.35,
                                              ),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                Positioned(
                                    bottom: 20,
                                    left: 25,
                                    child: SvgPicture.asset(ImageConstants.icon_like_detail_rotate)),
                                Positioned(
                                    top: 20,
                                    right: 110,
                                    child: SvgPicture.asset(
                                      ImageConstants.icon_like_detail_rotateright,
                                      fit: BoxFit.scaleDown,
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: CustomText(
                              text: "${toLabelValue(StringConstants.its_match)}, ${controller.matchedUser?.name}",
                              textAlign: TextAlign.center,
                              style: TextStyleConfig.boldTextStyle(
                                  fontWeight: FontWeight.w700, fontSize: TextStyleConfig.bodyText24),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          CustomText(
                            text: toLabelValue(StringConstants.start_conversation_with_eachother),
                            style: TextStyleConfig.regularTextStyle(
                                color: ColorConstants().grey,
                                fontWeight: FontWeight.w400,
                                fontSize: TextStyleConfig.bodyText14),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          actionButtons()
                        ],
                      )
                    : controller.isDataLoaded.value
                        ? const SizedBox()
                        : const SizedBox();
              },
            )));
  }

  Widget actionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        PrimaryButton(
            btnTitle: StringConstants.say_hello,
            onClicked: () async {
              bool isChatAvailable = await SharedPref.getBool(PreferenceConstants.isChatAvailable);
              if (isUserSubscribe == true && isChatAvailable) {
                dismissKeyboard();
                BindingChatDetail().dependencies();
                Get.find<ControllerChatDetail>().isDataLoaded.value = false;
                Get.find<ControllerChatDetail>().messagelist.clear();
                Get.find<ControllerChatDetail>().chatDetailResponse = null;
                Get.find<ControllerChatDetail>().pageIndex.value = 1;
                Get.find<ControllerChatDetail>().chatdetailAPI(
                    matchDetailController.matchedUser!.chatID.toString(), matchDetailController.matchedUser!.userId);

                Get.toNamed(Routes.chat_detail)!.then((value) {
                  dismissKeyboard();
                  Get.back();
                  Get.find<ControllerMatch>().matchlistAPI();
                });
              } else {
                Get.toNamed(Routes.subscription);
              }
            }),
        const SizedBox(
          height: 16,
        ),
        PlanButton(
          btnTitle: StringConstants.keep_swiping,
          onClicked: () {
            Get.find<TabbarController>().currentIndex.value = 0;
            Get.offAllNamed(Routes.customTabbar);
            BindingCard().dependencies();
          },
        )
      ]),
    );
  }
}
