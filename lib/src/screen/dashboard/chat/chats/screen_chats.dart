import 'dart:ui';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/chat/chat_detail/binding_chat_detail.dart';
import 'package:dating_app/src/screen/dashboard/chat/chat_detail/controller_chat_detail.dart';
import 'package:dating_app/src/screen/dashboard/chat/chats/controller_chats.dart';
import 'package:dating_app/src/screen/dashboard/chat/videocall/binding_video_call.dart';
import 'package:dating_app/src/screen/dashboard/chat/videocall/controller_video_call.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/binding_user_detail.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/controller_user_detail.dart';
import 'package:dating_app/src/screen/dashboard/matches/match/controller_match.dart';
import 'package:dating_app/src/screen/subscriptions/binding_subscription.dart';
import 'package:dating_app/src/screen/subscriptions/controller_subscription.dart';
import 'package:dating_app/src/widgets/custom_divider.dart';
import 'package:dating_app/src/widgets/custom_searchBar.dart';
import 'package:dating_app/src/widgets/widget.card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../../../model/chat/chat_list_model.dart';

export 'package:pull_to_refresh/pull_to_refresh.dart';

class ScreenChats extends StatelessWidget {
  ScreenChats({super.key});

  final chatsController = Get.find<ControllerChats>();
  final chatDetailController = Get.find<ControllerChatDetail>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
      widgetsScaffold: Scaffold(
          backgroundColor: ColorConstants().white,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(58),
              child: GetBuilder<ControllerChats>(
                builder: (controller) {
                  return CustomAppBar(
                    title: toLabelValue(StringConstants.chats),
                    isGradientAppBar: true,
                    titleColor: ColorConstants().white,
                    backIconColor: ColorConstants().white,
                    secondTrailing: SvgPicture.asset(ImageConstants.icon_search_chats),
                    onSecondOnclick: () {
                      controller.isSelectionEnable.value = false;
                      controller.isChatSearchEnable!.value = !controller.isChatSearchEnable!.value;
                      controller.update();
                    },
                  );
                },
              )),
          body: GetBuilder<ControllerChats>(
            builder: (controller) {
              return Column(
                children: [
                  if (chatsController.isChatSearchEnable!.value && chatsController.chatList!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: CustomSearchBar(
                        controller: chatsController.searchController.value,
                        isPrimaryIconColor: true,
                        hintText: toLabelValue(StringConstants.search_user),
                        onValueChanged: (value) async {
                          chatsController.onSearchTextChanged(value);
                        },
                        onRemoveValue: () {
                          chatsController.searchController.value.clear();
                          chatsController.onSearchTextChanged('');
                          chatsController.update();
                        },
                      ),
                    ),
                  TabBar(
                    tabs: [
                      Container(
                        height: 55,
                        alignment: Alignment.center,
                        child: CustomText(
                          text: toLabelValue(StringConstants.chat),
                        ),
                      ),
                      Container(
                        height: 55,
                        alignment: Alignment.center,
                        child: CustomText(
                          text: toLabelValue(StringConstants.video),
                        ),
                      )
                    ],
                    unselectedLabelColor: ColorConstants().grey,
                    indicatorColor: ColorConstants().primaryGradient,
                    labelColor: Colors.black,
                    unselectedLabelStyle: TextStyleConfig.boldTextStyle(
                        color: ColorConstants().grey,
                        fontWeight: FontWeight.w700,
                        fontSize: TextStyleConfig.bodyText14),
                    labelStyle: TextStyleConfig.boldTextStyle(
                        color: ColorConstants().black,
                        fontWeight: FontWeight.w700,
                        fontSize: TextStyleConfig.bodyText14),
                    onTap: (index) {
                      chatsController.isSelectionEnable.value = false;
                      chatsController.isDataLoaded(false);
                      chatsController.pageIndex.value = 1;
                      chatsController.update();
                      chatsController.chatResponse = null;
                      chatsController.chatList = [];

                      if (index == 0) {
                        chatsController.chatlistAPI("0");
                      } else {
                        chatsController.chatlistAPI("1");
                      }
                    },
                    indicatorWeight: 1,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: EdgeInsets.zero,
                    isScrollable: false,
                    controller: chatsController.chatTabController,
                  ),
                  chatsController.chatResponse != null
                      ? Expanded(
                          child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: chatsController.chatTabController,
                              children: <Widget>[
                                (chatsController.chatResponse != null && chatsController.chatList!.isNotEmpty)
                                    ? Stack(
                                        children: [
                                          GetBuilder<ControllerChats>(
                                            builder: (controller) {
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
                                                  controller.onRefresh("0");
                                                },
                                                onLoading: () {
                                                  controller.onLoading("0");
                                                },
                                                controller: controller.chatrefreshController,
                                                child: chatsController.searchChatList!.isNotEmpty ||
                                                        chatsController.searchController.value.text.isNotEmpty
                                                    ? chatsController.searchChatList!.isNotEmpty
                                                        ? ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: controller.searchChatList!.length,
                                                            scrollDirection: Axis.vertical,
                                                            itemBuilder: (context, index) {
                                                              ChatList userChat = controller.searchChatList![index];
                                                              return InkWell(
                                                                onLongPress:
                                                                    (chatsController.chatResponse!.isSubscribed ==
                                                                                "1" &&
                                                                            chatsController.isChatAvailable)
                                                                        ? () {
                                                                            chatsController.isSelectionEnable(true);
                                                                            chatsController.isSelectedlistIndex!.value =
                                                                                index;
                                                                            show_BlockUser_sheet(index);
                                                                            chatsController.update();
                                                                          }
                                                                        : null,
                                                                onTap: () {
                                                                  if (chatsController.chatResponse!.isSubscribed ==
                                                                          "1" &&
                                                                      chatsController.isChatAvailable) {
                                                                    BindingChatDetail().dependencies();
                                                                    PushNotificationService()
                                                                        .enableIOSNotifications(false);
                                                                    chatsController.isSelectionEnable(false);
                                                                    chatsController.isSelectedlistIndex!.value = (-1);
                                                                    chatDetailController.isDataLoaded(false);
                                                                    chatDetailController.messagelist.clear();

                                                                    chatDetailController.chatDetailResponse = null;
                                                                    chatDetailController.pageIndex.value = 1;
                                                                    chatDetailController.chatdetailAPI(
                                                                        userChat.chatId!, userChat.userId);
                                                                    Get.toNamed(Routes.chat_detail)!.then((value) {
                                                                      PushNotificationService()
                                                                          .enableIOSNotifications(true);
                                                                      controller.pageIndex.value = 1;
                                                                      isChatDetailOpen.value = false;
                                                                      selectedChatReceiverID.value = "";
                                                                      controller.chatlistAPI("0");
                                                                    });
                                                                  }
                                                                },
                                                                child: Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.fromLTRB(16, 14, 16, 16),
                                                                      child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          if (chatsController.isSelectionEnable.value)
                                                                            SizedBox(
                                                                              width: 30,
                                                                              child: CustomCheckBox(
                                                                                checkBoxSize: 20,
                                                                                checkedIcon:
                                                                                    ImageConstants.icon_round_check,
                                                                                uncheckedIcon:
                                                                                    ImageConstants.icon_round_uncheck,
                                                                                value: (index ==
                                                                                        chatsController
                                                                                            .isSelectedlistIndex!.value)
                                                                                    ? true
                                                                                    : false,
                                                                                onChanged: (value) {
                                                                                  if (chatsController
                                                                                          .isSelectedlistIndex!.value ==
                                                                                      index) {
                                                                                    chatsController
                                                                                        .isSelectionEnable(false);
                                                                                  } else {
                                                                                    chatsController.isSelectedlistIndex!
                                                                                        .value = index;
                                                                                  }
                                                                                  chatsController.update();
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ClipRRect(
                                                                            borderRadius: const BorderRadius.all(
                                                                                Radius.circular(50)),
                                                                            child: ImageFiltered(
                                                                                imageFilter: chatsController
                                                                                                .chatResponse!
                                                                                                .isSubscribed ==
                                                                                            "0" ||
                                                                                        !chatsController.isChatAvailable
                                                                                    ? ImageFilter.blur(
                                                                                        sigmaX: 3, sigmaY: 3)
                                                                                    : ImageFilter.blur(
                                                                                        sigmaX: 0, sigmaY: 0),
                                                                                child: CachedNetworkImage(
                                                                                  imageUrl:
                                                                                      "${generalSetting!.s3Url}${userChat.userImage}",
                                                                                  height: 50,
                                                                                  width: 50,
                                                                                  fit: BoxFit.cover,
                                                                                  alignment: Alignment.topCenter,
                                                                                )),
                                                                          ),
                                                                          const SizedBox(width: 8),
                                                                          Expanded(
                                                                            child: Column(
                                                                              crossAxisAlignment:
                                                                                  CrossAxisAlignment.start,
                                                                              children: [
                                                                                CustomText(
                                                                                  text: userChat.name,
                                                                                  maxlines: 2,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style:
                                                                                      TextStyleConfig.regularTextStyle(
                                                                                          fontSize: TextStyleConfig
                                                                                              .bodyText16,
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color:
                                                                                              ColorConstants().black),
                                                                                ),
                                                                                const SizedBox(height: 4),
                                                                                ImageFiltered(
                                                                                  imageFilter: chatsController
                                                                                                  .chatResponse!
                                                                                                  .isSubscribed ==
                                                                                              "0" ||
                                                                                          !chatsController
                                                                                              .isChatAvailable
                                                                                      ? ImageFilter.blur(
                                                                                          sigmaX: 3, sigmaY: 3)
                                                                                      : ImageFilter.blur(
                                                                                          sigmaX: 0, sigmaY: 0),
                                                                                  child: userChat.messageType == "0"
                                                                                      ? CustomText(
                                                                                          text: userChat.lastMessage ??
                                                                                              "",
                                                                                          maxlines: 1,
                                                                                          overflow:
                                                                                              TextOverflow.ellipsis,
                                                                                          style: TextStyleConfig
                                                                                              .regularTextStyle(
                                                                                                  fontSize:
                                                                                                      TextStyleConfig
                                                                                                          .bodyText14,
                                                                                                  fontWeight:
                                                                                                      FontWeight.w400,
                                                                                                  color:
                                                                                                      ColorConstants()
                                                                                                          .grey1),
                                                                                        )
                                                                                      : Row(
                                                                                          children: [
                                                                                            Icon(
                                                                                              userChat.messageType ==
                                                                                                      "1"
                                                                                                  ? Icons.photo
                                                                                                  : Icons
                                                                                                      .file_present_rounded,
                                                                                              color:
                                                                                                  ColorConstants().grey,
                                                                                            ),
                                                                                            CustomText(
                                                                                              text: userChat
                                                                                                          .messageType ==
                                                                                                      "1"
                                                                                                  ? toLabelValue(
                                                                                                      StringConstants
                                                                                                          .photo)
                                                                                                  : toLabelValue(
                                                                                                      StringConstants
                                                                                                          .file),
                                                                                              maxlines: 1,
                                                                                              overflow:
                                                                                                  TextOverflow.ellipsis,
                                                                                              style: TextStyleConfig
                                                                                                  .regularTextStyle(
                                                                                                      fontSize:
                                                                                                          TextStyleConfig
                                                                                                              .bodyText14,
                                                                                                      fontWeight:
                                                                                                          FontWeight
                                                                                                              .w400,
                                                                                                      color:
                                                                                                          ColorConstants()
                                                                                                              .grey1),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          const SizedBox(width: 8),
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                                            children: [
                                                                              CustomText(
                                                                                text: DateTime.parse(
                                                                                  userChat.messageTime!,
                                                                                )
                                                                                    .toLocal()
                                                                                    .timeAgo(numericDates: false),
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyleConfig.regularTextStyle(
                                                                                    fontSize:
                                                                                        TextStyleConfig.bodyText12,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    color: ColorConstants().grey),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 4,
                                                                              ),
                                                                              (userChat.unreadMessages != null &&
                                                                                      userChat.unreadMessages == "0")
                                                                                  ? const SizedBox()
                                                                                  : ClipRRect(
                                                                                      borderRadius:
                                                                                          const BorderRadius.all(
                                                                                              Radius.circular(22)),
                                                                                      child: Container(
                                                                                        height: 20,
                                                                                        width: 20,
                                                                                        color: ColorConstants()
                                                                                            .primaryGradient,
                                                                                        child: CustomText(
                                                                                          text:
                                                                                              userChat.unreadMessages ??
                                                                                                  "",
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyleConfig
                                                                                              .regularTextStyle(
                                                                                                  styleLineHeight: 1.5,
                                                                                                  fontWeight:
                                                                                                      FontWeight.w500,
                                                                                                  fontSize:
                                                                                                      TextStyleConfig
                                                                                                          .bodyText12,
                                                                                                  color:
                                                                                                      ColorConstants()
                                                                                                          .white),
                                                                                        ),
                                                                                      ))
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    CustomDivider()
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : noConversation_View()
                                                    : ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: controller.chatList!.length,
                                                        scrollDirection: Axis.vertical,
                                                        itemBuilder: (context, index) {
                                                          ChatList userChat = controller.chatList![index];
                                                          return InkWell(
                                                            onLongPress: (chatsController.chatResponse!.isSubscribed ==
                                                                        "1" &&
                                                                    chatsController.isChatAvailable)
                                                                ? () {
                                                                    chatsController.isSelectionEnable(true);
                                                                    chatsController.isSelectedlistIndex!.value = index;
                                                                    show_BlockUser_sheet(index);
                                                                    chatsController.update();
                                                                  }
                                                                : null,
                                                            onTap: (chatsController.chatResponse!.isSubscribed == "1" &&
                                                                    chatsController.isChatAvailable)
                                                                ? () {
                                                                    BindingChatDetail().dependencies();

                                                                    PushNotificationService()
                                                                        .enableIOSNotifications(false);
                                                                    chatsController.isSelectionEnable(false);
                                                                    chatsController.isSelectedlistIndex!.value = (-1);
                                                                    chatDetailController.isDataLoaded(false);

                                                                    chatDetailController.messagelist.clear();
                                                                    chatDetailController.chatDetailResponse = null;
                                                                    chatDetailController.pageIndex.value = 1;
                                                                    chatDetailController.chatdetailAPI(
                                                                        userChat.chatId!, userChat.userId);

                                                                    Get.toNamed(Routes.chat_detail)!.then((value) {
                                                                      PushNotificationService()
                                                                          .enableIOSNotifications(true);
                                                                      controller.pageIndex.value = 1;
                                                                      isChatDetailOpen.value = false;
                                                                      selectedChatReceiverID.value = "";
                                                                      controller.chatlistAPI("0");
                                                                    });
                                                                  }
                                                                : null,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      if (chatsController.isSelectionEnable.value)
                                                                        SizedBox(
                                                                          width: 30,
                                                                          child: CustomCheckBox(
                                                                            checkBoxSize: 20,
                                                                            checkedIcon:
                                                                                ImageConstants.icon_round_check,
                                                                            uncheckedIcon:
                                                                                ImageConstants.icon_round_uncheck,
                                                                            value: (index ==
                                                                                    chatsController
                                                                                        .isSelectedlistIndex!.value)
                                                                                ? true
                                                                                : false,
                                                                            onChanged: (value) {
                                                                              if (chatsController
                                                                                      .isSelectedlistIndex!.value ==
                                                                                  index) {
                                                                                chatsController
                                                                                    .isSelectionEnable(false);
                                                                              } else {
                                                                                chatsController
                                                                                    .isSelectedlistIndex!.value = index;
                                                                              }
                                                                              chatsController.update();
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            const BorderRadius.all(Radius.circular(50)),
                                                                        child: ImageFiltered(
                                                                            imageFilter: chatsController.chatResponse!
                                                                                            .isSubscribed ==
                                                                                        "0" ||
                                                                                    !chatsController.isChatAvailable
                                                                                ? ImageFilter.blur(sigmaX: 3, sigmaY: 3)
                                                                                : ImageFilter.blur(
                                                                                    sigmaX: 0, sigmaY: 0),
                                                                            child: CachedNetworkImage(
                                                                              imageUrl:
                                                                                  "${generalSetting!.s3Url}${userChat.userImage}",
                                                                              height: 50,
                                                                              width: 50,
                                                                              fit: BoxFit.cover,
                                                                              alignment: Alignment.topCenter,
                                                                            )),
                                                                      ),
                                                                      const SizedBox(width: 8),
                                                                      Expanded(
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            CustomText(
                                                                              text: userChat.name,
                                                                              style: TextStyleConfig.regularTextStyle(
                                                                                  fontSize: TextStyleConfig.bodyText16,
                                                                                  fontWeight: FontWeight.w700,
                                                                                  color: ColorConstants().black),
                                                                            ),
                                                                            const SizedBox(height: 4),
                                                                            ImageFiltered(
                                                                              imageFilter: chatsController.chatResponse!
                                                                                              .isSubscribed ==
                                                                                          "0" ||
                                                                                      !chatsController.isChatAvailable
                                                                                  ? ImageFilter.blur(
                                                                                      sigmaX: 3, sigmaY: 3)
                                                                                  : ImageFilter.blur(
                                                                                      sigmaX: 0, sigmaY: 0),
                                                                              child: userChat.messageType == "0"
                                                                                  ? CustomText(
                                                                                      text: userChat.lastMessage ?? "",
                                                                                      maxlines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: TextStyleConfig
                                                                                          .regularTextStyle(
                                                                                              fontSize: TextStyleConfig
                                                                                                  .bodyText14,
                                                                                              fontWeight:
                                                                                                  FontWeight.w400,
                                                                                              color: ColorConstants()
                                                                                                  .grey1),
                                                                                    )
                                                                                  : Row(
                                                                                      children: [
                                                                                        Icon(
                                                                                          userChat.messageType == "1"
                                                                                              ? Icons.photo
                                                                                              : Icons
                                                                                                  .file_present_rounded,
                                                                                          color: ColorConstants().grey,
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          width: 4,
                                                                                        ),
                                                                                        CustomText(
                                                                                          text: userChat.messageType ==
                                                                                                  "1"
                                                                                              ? toLabelValue(
                                                                                                  StringConstants.photo)
                                                                                              : toLabelValue(
                                                                                                  StringConstants.file),
                                                                                          maxlines: 1,
                                                                                          overflow:
                                                                                              TextOverflow.ellipsis,
                                                                                          style: TextStyleConfig
                                                                                              .regularTextStyle(
                                                                                                  fontSize:
                                                                                                      TextStyleConfig
                                                                                                          .bodyText14,
                                                                                                  fontWeight:
                                                                                                      FontWeight.w400,
                                                                                                  color:
                                                                                                      ColorConstants()
                                                                                                          .grey1),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      const SizedBox(width: 8),
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                                        children: [
                                                                          CustomText(
                                                                            text: DateTime.parse(
                                                                              userChat.messageTime!,
                                                                            ).toLocal().timeAgo(numericDates: false),
                                                                            textAlign: TextAlign.center,
                                                                            style: TextStyleConfig.regularTextStyle(
                                                                                fontSize: TextStyleConfig.bodyText12,
                                                                                fontWeight: FontWeight.w400,
                                                                                color: ColorConstants().grey),
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 4,
                                                                          ),
                                                                          (userChat.unreadMessages != null &&
                                                                                  userChat.unreadMessages == "0")
                                                                              ? const SizedBox()
                                                                              : ClipRRect(
                                                                                  borderRadius: const BorderRadius.all(
                                                                                      Radius.circular(22)),
                                                                                  child: Container(
                                                                                    height: 20,
                                                                                    width: 20,
                                                                                    color: ColorConstants()
                                                                                        .primaryGradient,
                                                                                    child: CustomText(
                                                                                      text:
                                                                                          userChat.unreadMessages ?? "",
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyleConfig
                                                                                          .regularTextStyle(
                                                                                              styleLineHeight: 1.5,
                                                                                              fontWeight:
                                                                                                  FontWeight.w500,
                                                                                              fontSize: TextStyleConfig
                                                                                                  .bodyText12,
                                                                                              color: ColorConstants()
                                                                                                  .white),
                                                                                    ),
                                                                                  ))
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                CustomDivider()
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                              );
                                            },
                                          ),
                                          if (chatsController.chatResponse!.isSubscribed == "0" ||
                                              !chatsController.isChatAvailable)
                                            Positioned(
                                              top: Get.height * 0.55,
                                              child: Center(
                                                child: SizedBox(
                                                  height: Get.height * 0.12,
                                                  width: Get.width,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      CustomText(
                                                        text: toLabelValue(StringConstants.subscribe_to_view_message),
                                                        style: TextStyleConfig.boldTextStyle(
                                                            fontSize: TextStyleConfig.bodyText16,
                                                            fontWeight: FontWeight.w600,
                                                            color: ColorConstants().black),
                                                      ),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      PrimaryButton(
                                                        btnHeight: 40,
                                                        btnWidth: Get.width * 0.53,
                                                        btnTitle: StringConstants.see_who_msg_you,
                                                        onClicked: () {
                                                          BindingSubscription().dependencies();
                                                          SharedPref.setBool(PreferenceConstants.isFromChat, true);
                                                          Get.find<ControllerSubscription>().isFromChatScreen = true;
                                                          Get.toNamed(Routes.subscription);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      )
                                    : chatsController.isDataLoaded.value
                                        ? noConversation_View()
                                        : const SizedBox(),
                                (chatsController.chatResponse != null && chatsController.chatList!.isNotEmpty)
                                    ? Stack(
                                        children: [
                                          GetBuilder<ControllerChats>(
                                            builder: (controller) {
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
                                                  controller.onRefresh("1");
                                                },
                                                onLoading: () {
                                                  controller.onLoading("1");
                                                },
                                                controller: controller.videorefreshController,
                                                child: chatsController.searchChatList!.isNotEmpty ||
                                                        chatsController.searchController.value.text.isNotEmpty
                                                    ? chatsController.searchChatList!.isNotEmpty
                                                        ? ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: controller.searchChatList!.length,
                                                            scrollDirection: Axis.vertical,
                                                            itemBuilder: (context, index) {
                                                              ChatList userChat = controller.searchChatList![index];
                                                              return Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        if (chatsController.isSelectionEnable.value)
                                                                          SizedBox(
                                                                            width: 30,
                                                                            child: CustomCheckBox(
                                                                              checkBoxSize: 20,
                                                                              checkedIcon:
                                                                                  ImageConstants.icon_round_check,
                                                                              uncheckedIcon:
                                                                                  ImageConstants.icon_round_uncheck,
                                                                              value: (index ==
                                                                                      chatsController
                                                                                          .isSelectedlistIndex!.value)
                                                                                  ? true
                                                                                  : false,
                                                                              onChanged: (value) {
                                                                                if (chatsController
                                                                                        .isSelectedlistIndex!.value ==
                                                                                    index) {
                                                                                  chatsController
                                                                                      .isSelectionEnable(false);
                                                                                } else {
                                                                                  chatsController.isSelectedlistIndex!
                                                                                      .value = index;
                                                                                }
                                                                                chatsController.update();
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ClipRRect(
                                                                          borderRadius: const BorderRadius.all(
                                                                              Radius.circular(50)),
                                                                          child: ImageFiltered(
                                                                              imageFilter: chatsController.chatResponse!
                                                                                              .isSubscribed ==
                                                                                          "0" ||
                                                                                      !chatsController.isVideoAvailable
                                                                                  ? ImageFilter.blur(
                                                                                      sigmaX: 3, sigmaY: 3)
                                                                                  : ImageFilter.blur(
                                                                                      sigmaX: 0, sigmaY: 0),
                                                                              child: CachedNetworkImage(
                                                                                imageUrl:
                                                                                    "${generalSetting!.s3Url}${userChat.userImage}",
                                                                                height: 50,
                                                                                width: 50,
                                                                                fit: BoxFit.cover,
                                                                                alignment: Alignment.topCenter,
                                                                              )),
                                                                        ),
                                                                        const SizedBox(width: 8),
                                                                        Expanded(
                                                                          child: ImageFiltered(
                                                                            imageFilter: chatsController.chatResponse!
                                                                                            .isSubscribed ==
                                                                                        "0" ||
                                                                                    !chatsController.isVideoAvailable
                                                                                ? ImageFilter.blur(sigmaX: 3, sigmaY: 3)
                                                                                : ImageFilter.blur(
                                                                                    sigmaX: 0, sigmaY: 0),
                                                                            child: Column(
                                                                              crossAxisAlignment:
                                                                                  CrossAxisAlignment.start,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: Get.width * 0.62,
                                                                                  child: CustomText(
                                                                                    text:
                                                                                        "${userChat.name} ${chatsController.chatList?[index].videoCallCount != null ? "(${chatsController.chatList?[index].videoCallCount})" : ""}",
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    maxlines: 2,
                                                                                    style: TextStyleConfig
                                                                                        .regularTextStyle(
                                                                                            fontSize: TextStyleConfig
                                                                                                .bodyText16,
                                                                                            fontWeight: FontWeight.w700,
                                                                                            color:
                                                                                                ColorConstants().black),
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(height: 4),
                                                                                Row(
                                                                                  children: [
                                                                                    SvgPicture.asset((userChat
                                                                                                .isIncoming ==
                                                                                            "0")
                                                                                        ? ImageConstants.icon_receive
                                                                                        : ImageConstants.icon_outgoing),
                                                                                    const SizedBox(
                                                                                      width: 4,
                                                                                    ),
                                                                                    CustomText(
                                                                                      text: "${DateTime.parse(
                                                                                        userChat.messageTime!,
                                                                                      ).toLocal().timeAgo(numericDates: false)}, ${dateformate(userChat.messageTime!, "hh:mm a")}",
                                                                                      maxlines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: TextStyleConfig
                                                                                          .regularTextStyle(
                                                                                              fontSize: TextStyleConfig
                                                                                                  .bodyText14,
                                                                                              fontWeight:
                                                                                                  FontWeight.w400,
                                                                                              color: ColorConstants()
                                                                                                  .grey1),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(width: 8),
                                                                        InkWell(
                                                                          onTap: (chatsController
                                                                                          .chatResponse!.isSubscribed ==
                                                                                      "1" &&
                                                                                  chatsController.isVideoAvailable)
                                                                              ? () {}
                                                                              : null,
                                                                          child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.fromLTRB(8, 8, 0, 8),
                                                                            child: SvgPicture.asset(
                                                                              ImageConstants.icon_video,
                                                                              fit: BoxFit.scaleDown,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  CustomDivider()
                                                                ],
                                                              );
                                                            },
                                                          )
                                                        : noConversation_View()
                                                    : ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: controller.chatList!.length,
                                                        scrollDirection: Axis.vertical,
                                                        itemBuilder: (context, index) {
                                                          ChatList userChat = controller.chatList![index];
                                                          return InkWell(
                                                            onTap: (chatsController.chatResponse!.isSubscribed == "1" &&
                                                                    chatsController.isVideoAvailable)
                                                                ? () {
                                                                    if (chatsController.chatResponse?.chat![index]
                                                                            .is_blocked_user ==
                                                                        "0") {
                                                                      if (kDebugMode) {
                                                                        print("Hello video call");
                                                                      }
                                                                      showLoader();
                                                                      if (kDebugMode) {
                                                                        print(chatsController
                                                                            .chatResponse?.chat![index].userId);
                                                                      }
                                                                      BindingVideoCall().dependencies();

                                                                      PushNotificationService()
                                                                          .enableIOSNotifications(false);
                                                                      Get.find<ControllerVideoCall>().videoChatDetail(
                                                                          chatsController
                                                                                  .chatResponse?.chat![index].userId ??
                                                                              "",
                                                                          chatsController
                                                                              .chatResponse!.chat![index].userImage!);
                                                                    } else {
                                                                      showSnackBar(context,
                                                                          "${toLabelValue(StringConstants.unblock)} ${chatsController.chatResponse?.chat![index].name} ${toLabelValue(StringConstants.start_video_call)}");
                                                                    }
                                                                  }
                                                                : null,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      if (chatsController.isSelectionEnable.value)
                                                                        SizedBox(
                                                                          width: 30,
                                                                          child: CustomCheckBox(
                                                                            checkBoxSize: 20,
                                                                            checkedIcon:
                                                                                ImageConstants.icon_round_check,
                                                                            uncheckedIcon:
                                                                                ImageConstants.icon_round_uncheck,
                                                                            value: (index ==
                                                                                    chatsController
                                                                                        .isSelectedlistIndex!.value)
                                                                                ? true
                                                                                : false,
                                                                            onChanged: (value) {
                                                                              if (chatsController
                                                                                      .isSelectedlistIndex!.value ==
                                                                                  index) {
                                                                                chatsController
                                                                                    .isSelectionEnable(false);
                                                                              } else {
                                                                                chatsController
                                                                                    .isSelectedlistIndex!.value = index;
                                                                              }

                                                                              chatsController.update();
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            const BorderRadius.all(Radius.circular(50)),
                                                                        child: ImageFiltered(
                                                                            imageFilter: chatsController.chatResponse!
                                                                                            .isSubscribed ==
                                                                                        "0" ||
                                                                                    !chatsController.isVideoAvailable
                                                                                ? ImageFilter.blur(sigmaX: 3, sigmaY: 3)
                                                                                : ImageFilter.blur(
                                                                                    sigmaX: 0, sigmaY: 0),
                                                                            child: CachedNetworkImage(
                                                                              imageUrl:
                                                                                  "${generalSetting!.s3Url}${userChat.userImage}",
                                                                              height: 50,
                                                                              width: 50,
                                                                              fit: BoxFit.cover,
                                                                              alignment: Alignment.topCenter,
                                                                            )),
                                                                      ),
                                                                      const SizedBox(width: 8),
                                                                      Expanded(
                                                                        child: ImageFiltered(
                                                                          imageFilter: chatsController
                                                                                          .chatResponse!.isSubscribed ==
                                                                                      "0" ||
                                                                                  !chatsController.isVideoAvailable
                                                                              ? ImageFilter.blur(sigmaX: 3, sigmaY: 3)
                                                                              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                                                                          child: Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: Get.width * 0.62,
                                                                                    child: CustomText(
                                                                                      text:
                                                                                          "${userChat.name} ${chatsController.chatList?[index].videoCallCount != null ? "(${chatsController.chatList?[index].videoCallCount})" : ""}",
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      maxlines: 2,
                                                                                      style: TextStyleConfig
                                                                                          .regularTextStyle(
                                                                                              fontSize: TextStyleConfig
                                                                                                  .bodyText16,
                                                                                              fontWeight:
                                                                                                  FontWeight.w700,
                                                                                              color: ColorConstants()
                                                                                                  .black),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(height: 4),
                                                                              Row(
                                                                                children: [
                                                                                  SvgPicture.asset(
                                                                                      (userChat.isIncoming == "0")
                                                                                          ? ImageConstants.icon_receive
                                                                                          : ImageConstants
                                                                                              .icon_outgoing),
                                                                                  const SizedBox(
                                                                                    width: 4,
                                                                                  ),
                                                                                  CustomText(
                                                                                    text: "${DateTime.parse(
                                                                                      userChat.messageTime!,
                                                                                    ).toLocal().timeAgo(numericDates: false)}, ${dateformate(userChat.messageTime!, "hh:mm a")}",
                                                                                    maxlines: 1,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: TextStyleConfig
                                                                                        .regularTextStyle(
                                                                                            fontSize: TextStyleConfig
                                                                                                .bodyText14,
                                                                                            fontWeight: FontWeight.w400,
                                                                                            color:
                                                                                                ColorConstants().grey1),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(width: 8),
                                                                      InkWell(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                            8,
                                                                            8,
                                                                            0,
                                                                            8,
                                                                          ),
                                                                          child: SvgPicture.asset(
                                                                            ImageConstants.icon_video,
                                                                            fit: BoxFit.scaleDown,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                CustomDivider()
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                              );
                                            },
                                          ),
                                          if (chatsController.chatResponse!.isSubscribed == "0" ||
                                              !chatsController.isVideoAvailable)
                                            Positioned(
                                              top: Get.height * 0.55,
                                              child: Center(
                                                child: SizedBox(
                                                  height: Get.height * 0.12,
                                                  width: Get.width,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      CustomText(
                                                        text: toLabelValue(StringConstants.subscribe_to_view_calls),
                                                        style: TextStyleConfig.boldTextStyle(
                                                            fontSize: TextStyleConfig.bodyText16,
                                                            fontWeight: FontWeight.w600,
                                                            color: ColorConstants().black),
                                                      ),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      PrimaryButton(
                                                        btnHeight: 40,
                                                        btnWidth: Get.width * 0.53,
                                                        btnTitle: StringConstants.see_who_call_you,
                                                        onClicked: () {
                                                          BindingSubscription().dependencies();
                                                          SharedPref.setBool(PreferenceConstants.isFromChat, true);
                                                          Get.find<ControllerSubscription>().isFromChatScreen = true;
                                                          Get.toNamed(Routes.subscription);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                        ],
                                      )
                                    : chatsController.isDataLoaded.value
                                        ? noConversation_View()
                                        : const SizedBox(),
                              ]),
                        )
                      : const SizedBox()
                ],
              );
            },
          )),
    );
  }

  Widget noConversation_View() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "lib/src/asset/images/chats/Group 39479.png",
            height: 50,
          ),
          const SizedBox(
            height: 8,
          ),
          Image.asset(
            "lib/src/asset/images/chats/Group 39480.png",
            height: 50,
          ),
          const SizedBox(
            height: 16,
          ),
          CustomText(
            text: "No Conversation",
            style: TextStyleConfig.boldTextStyle(fontSize: TextStyleConfig.bodyText20, fontWeight: FontWeight.w700),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CustomText(
              text: "You don’t made any conversations yet,Start conversation with your matches ",
              textAlign: TextAlign.center,
              style: TextStyleConfig.regularTextStyle(
                  fontSize: TextStyleConfig.bodyText14, fontWeight: FontWeight.w400, color: ColorConstants().grey1),
            ),
          ),
          InkWell(
            onTap: () {
              dismissKeyboard();
              chatsController.searchController.value.text = "";

              Get.find<TabbarController>().currentIndex.value = 1;
              Get.find<ControllerMatch>().pageIndex(1);
              Get.find<ControllerMatch>().matchlistAPI();
            },
            child: CustomText(
              text: "Chat People",
              style: TextStyleConfig.boldTextStyle(
                  color: ColorConstants().primaryGradient,
                  fontSize: TextStyleConfig.bodyText14,
                  fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
    );
  }

  Widget blockDialogue(int index) {
    return showDialogBox(
        Get.overlayContext!,
        toLabelValue(StringConstants.block_user_will_no_longer_sent_msg),
        () {
          chatsController.isSelectionEnable(false);
          chatsController.update();
          Get.back();
        },
        StringConstants.no,
        () {
          chatsController.isSelectionEnable(false);

          BindingUserdetail().dependencies();
          Get.find<ControllerUserDetail>().blockUserAPI(chatsController.chatList![index].userId!, '1');
          chatsController.isSelectedlistIndex!.value = (-1);
          chatsController.isSelectionEnable(false);
          Future.delayed(
            const Duration(seconds: 1),
            () {
              chatsController.chatlistAPI(chatsController.chatTabController.index.toString());
            },
          );
          chatsController.update();
        },
        StringConstants.yes,
        "${toLabelValue(StringConstants.are_you_sure_want_to_block)} ${chatsController.chatList![index].name}?");
  }

  show_BlockUser_sheet(int index) {
    return Get.bottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ), StatefulBuilder(
      builder: (BuildContext bottomContext, StateSetter setState) {
        return SafeArea(
          child: PopScope(
            canPop: true,
            child: InkWell(
              onTap: () {
                if (kDebugMode) {
                  print("farefaeraqe===========");
                }
              },
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: Get.height * 0.35, minHeight: MediaQuery.of(bottomContext).size.height * 0.25),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    )),
                child: SafeArea(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                              child: SvgPicture.asset(
                            ImageConstants.icon_grey_indicator,
                            height: 5,
                            fit: BoxFit.scaleDown,
                          )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 32, 0, 4),
                            child: CustomText(
                              text: toLabelValue(StringConstants.more_option),
                              textAlign: TextAlign.center,
                              style: TextStyleConfig.boldTextStyle(
                                  fontSize: TextStyleConfig.bodyText16, color: ColorConstants().black),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          InkWell(
                            onTap: () {
                              if (chatsController.chatList![index].is_blocked_user == "0") {
                                Get.back();
                                chatsController.isBlockType(true);

                                if (chatsController.isSelectedlistIndex!.value == index) {
                                  chatsController.isSelectedlistIndex!.value = index;

                                  blockDialogue(index);

                                  chatsController.isSelectionEnable(false);
                                } else {
                                  chatsController.isSelectedlistIndex!.value = index;
                                }
                              } else {
                                chatsController.isSelectionEnable(false);

                                BindingUserdetail().dependencies();
                                Get.find<ControllerUserDetail>()
                                    .blockUserAPI(chatsController.chatList![index].userId!, '0')
                                    .then((value) {
                                  chatsController.chatlistAPI(chatsController.chatTabController.index.toString());
                                });
                                chatsController.isSelectedlistIndex!.value = (-1);
                                chatsController.isSelectionEnable(false);
                              }

                              chatsController.update();
                            },
                            child: SizedBox(
                              width: Get.width,
                              child: CustomCard(
                                  isGradientCard: false,
                                  borderradius: 60,
                                  shadowColor: Colors.transparent,
                                  bordercolor: Colors.transparent,
                                  borderwidth: 0,
                                  backgroundColor: ColorConstants().light1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: CustomText(
                                      text: toLabelValue(chatsController.chatList![index].is_blocked_user == "0"
                                          ? StringConstants.block_user
                                          : StringConstants.unblock_user),
                                      textAlign: TextAlign.center,
                                      style: TextStyleConfig.regularTextStyle(
                                          fontSize: TextStyleConfig.bodyText14, fontWeight: FontWeight.w400),
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                              chatsController.isBlockType(false);
                              if (chatsController.isSelectedlistIndex!.value == index) {
                                chatsController.isSelectedlistIndex!.value = index;

                                show_report_dialogue();

                                chatsController.isSelectionEnable(false);
                              } else {
                                chatsController.isSelectedlistIndex!.value = index;
                              }

                              chatsController.update();
                            },
                            child: SizedBox(
                              width: Get.width,
                              child: CustomCard(
                                  isGradientCard: false,
                                  borderradius: 60,
                                  shadowColor: Colors.transparent,
                                  bordercolor: Colors.transparent,
                                  borderwidth: 0,
                                  backgroundColor: ColorConstants().light1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: CustomText(
                                      text: toLabelValue(StringConstants.report_user),
                                      textAlign: TextAlign.center,
                                      style: TextStyleConfig.regularTextStyle(
                                          fontSize: TextStyleConfig.bodyText14, fontWeight: FontWeight.w400),
                                    ),
                                  )),
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ),
          ),
        );
      },
    )).then((value) {
      chatsController.isSelectionEnable.value = false;
      chatsController.isSelectedlistIndex!.value = (-1);
      chatsController.update();
    });
  }

  show_report_dialogue() {
    return Get.bottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ), StatefulBuilder(
      builder: (BuildContext bottomContext, StateSetter setState) {
        return SafeArea(
          child: PopScope(
            canPop: true,
            child: Container(
              constraints: BoxConstraints(
                  maxHeight: Get.height * 0.45, minHeight: MediaQuery.of(bottomContext).size.height * 0.26),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  )),
              child: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: SvgPicture.asset(
                          ImageConstants.icon_grey_indicator,
                          height: 5,
                          fit: BoxFit.scaleDown,
                        )),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 32, 0, 4),
                            child: CustomText(
                              text: toLabelValue(StringConstants.report_user),
                              textAlign: TextAlign.center,
                              style: TextStyleConfig.boldTextStyle(
                                  fontSize: TextStyleConfig.bodyText16, color: ColorConstants().black),
                            ),
                          ),
                        ),
                        CustomText(
                          text: toLabelValue(StringConstants.message),
                          textAlign: TextAlign.center,
                          style: TextStyleConfig.regularTextStyle(
                              fontSize: TextStyleConfig.bodyText14, color: ColorConstants().black),
                        ),
                        SizedBox(
                            height: 150,
                            child: CustomTextfieldWidget(
                              controller: chatsController.reportMsgController,
                              borderRadius: 16,
                              inputformater: [NoLeadingSpaceFormatter()],
                              placeholder: toLabelValue(StringConstants.enter_message),
                              contentPadding: const EdgeInsets.only(left: 4, bottom: 4, top: 20, right: 4),
                              maxLines: 8,
                            )),
                        const SizedBox(
                          height: 16,
                        ),
                        PrimaryButton(
                          btnTitle: StringConstants.send,
                          onClicked: () {
                            chatsController.validateReportField(chatsController
                                .chatList![chatsController.isSelectedlistIndex!.value].userId
                                .toString());
                          },
                        )
                      ],
                    )),
              ),
            ),
          ),
        );
      },
    ));
  }
}
