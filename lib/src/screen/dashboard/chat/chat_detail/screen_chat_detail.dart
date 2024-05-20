import 'dart:io';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/chat/chat_detail.dart';
import 'package:dating_app/src/screen/dashboard/chat/chat_detail/controller_chat_detail.dart';
import 'package:dating_app/src/screen/dashboard/chat/videocall/binding_video_call.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/controller_user_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../model/dashboard/user_detail_model.dart';
import '../../home/card_swip/controller_card_swipe.dart';
import '../../home/user_detail/binding_user_detail.dart';
import '../../home/user_detail/preview_image/binding_preview.dart';
import '../../home/user_detail/preview_image/controller_preview.dart';
import '../videocall/controller_video_call.dart';

class ScreenChatDetail extends StatelessWidget {
  ScreenChatDetail({super.key});

  final chatdetailController = Get.find<ControllerChatDetail>();

  @override
  Widget build(BuildContext context) {
    return BaseController(
        widgetsScaffold: Scaffold(
            backgroundColor: ColorConstants().white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(58),
                child: GetBuilder<ControllerChatDetail>(builder: (controller) {
                  return controller.chatDetailResponse != null
                      ? CustomAppBar(
                          title: "",
                          isGradientAppBar: true,
                          backIconColor: ColorConstants().white,
                          titleColor: ColorConstants().white,
                          isBackVisible: true,
                          firstleading: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(50)),
                                child: InkWell(
                                  onTap: () {
                                    dismissKeyboard();
                                    BindingPreview().dependencies();
                                    Get.find<ControllerPreview>().productImages = [
                                      Images(id: "0", imageUrl: "${controller.chatDetailResponse?.userImage}")
                                    ];
                                    Get.toNamed(Routes.preview_image);
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: "${generalSetting?.s3Url}${controller.chatDetailResponse?.userImage}",
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                    placeholder: (context, url) {
                                      return const Icon(Icons.person_outlined);
                                    },
                                    errorWidget: (context, url, error) {
                                      return const Icon(Icons.person_outlined);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  BindingUserdetail().dependencies();

                                  Get.find<ControllerUserDetail>().isShowLikeButtom(false);
                                  Get.find<ControllerUserDetail>().userdata = null;
                                  Get.find<ControllerUserDetail>().isDataLoaded(false);
                                  Get.find<ControllerUserDetail>().getSetUpProfileAPI().then((value) {
                                    Get.find<ControllerUserDetail>().getUserDetailAPI(
                                        controller.chatDetailResponse?.userId ?? "",
                                        latitude,
                                        longitude,
                                        Get.find<ControllerCard>().isIncognitoModeON.value);
                                    Get.toNamed(Routes.user_detail);
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: Get.width * 0.45,
                                      child: CustomText(
                                        text: controller.chatDetailResponse?.name,
                                        maxlines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyleConfig.boldTextStyle(
                                            color: ColorConstants().white,
                                            fontSize: TextStyleConfig.bodyText16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    controller.chatDetailResponse?.is_blocked_user == "1"
                                        ? const SizedBox(
                                            height: 4,
                                          )
                                        : CustomText(
                                            text: controller.chatDetailResponse?.isOnline == "1"
                                                ? toLabelValue(StringConstants.online)
                                                : "",
                                            style: TextStyleConfig.boldTextStyle(
                                                color: ColorConstants().white,
                                                fontSize: TextStyleConfig.bodyText12,
                                                fontWeight: FontWeight.w400),
                                          )
                                  ],
                                ),
                              )
                            ],
                          ),
                          firstTrailing: SvgPicture.asset(ImageConstants.icon_menu_chat),
                          onfirstOnclick: () {
                            dismissKeyboard();
                            chatdetailController.show_BlockUser_sheet(controller.chatDetailResponse!.name!);
                          },
                          secondTrailing: SvgPicture.asset(
                            ImageConstants.icon_video,
                            color: ColorConstants().white,
                          ),
                          onSecondOnclick: () async {
                            bool isVideoAvailable = await SharedPref.getBool(PreferenceConstants.isVideoAvailable);
                            if (isUserSubscribe! && isVideoAvailable) {
                              if (chatdetailController.chatDetailResponse?.is_blocked_user == "0") {
                                showLoader();
                                PushNotificationService().enableIOSNotifications(false);
                                BindingVideoCall().dependencies();
                                Get.find<ControllerVideoCall>()
                                    .videoChatDetail(chatdetailController.chatDetailResponse?.userId ?? "",
                                        chatdetailController.chatDetailResponse!.userImage!)
                                    .then((value) {});
                              } else {
                                showSnackBar(context,
                                    "${toLabelValue(StringConstants.unblock)} ${chatdetailController.chatDetailResponse?.name} ${toLabelValue(StringConstants.start_video_call)}");
                              }
                            } else {
                              Get.toNamed(Routes.subscription);
                            }
                          },
                        )
                      : controller.isDataLoaded.value
                          ? noDataView("")
                          : const SizedBox();
                })),
            body: GetBuilder<ControllerChatDetail>(
              builder: (controller) {
                return Stack(
                  children: <Widget>[
                    controller.messagelist.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 100),
                            child: SmartRefresher(
                                enablePullDown: false,
                                enablePullUp: true,
                                header: const WaterDropHeader(),
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
                                onRefresh: controller.onRefresh,
                                onLoading: controller.onLoading,
                                controller: controller.refreshController,
                                child: controller.messagelist.isNotEmpty
                                    ? ListView.builder(
                                        reverse: true,
                                        itemCount: controller.messagelist.length,
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                                        physics: const AlwaysScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          MessageList chat =
                                              controller.messagelist[(controller.messagelist.length - 1) - index];

                                          return Column(
                                            crossAxisAlignment: chat.typeId == controller.chatDetailResponse?.userId
                                                ? CrossAxisAlignment.start
                                                : CrossAxisAlignment.end,
                                            children: [
                                              (index == controller.messagelist.length - 1)
                                                  ? Center(
                                                      child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                                      child: CustomText(
                                                        text:
                                                            dateformate(chat.messageSentTime.toString(), "dd MMM yyyy"),
                                                        style: TextStyleConfig.regularTextStyle(
                                                            color: ColorConstants().grey2,
                                                            fontSize: TextStyleConfig.bodyText14),
                                                      ),
                                                    ))
                                                  : const SizedBox(),
                                              (index != controller.messagelist.length - 1)
                                                  ? ((dateformate(chat.messageSentTime.toString(), "dd-MM-yyyy")) !=
                                                          (dateformate(
                                                              controller
                                                                  .messagelist[
                                                                      (controller.messagelist.length - 1) - (index + 1)]
                                                                  .messageSentTime
                                                                  .toString(),
                                                              "dd-MM-yyyy")))
                                                      ? (dateformate(chat.messageSentTime.toString(), "dd-MM-yyyy") !=
                                                              dateformate(DateTime.now().toString(), "dd-MM-yyyy"))
                                                          ? (dateformate(
                                                                      chat.messageSentTime.toString(), "dd-MM-yyyy") !=
                                                                  dateformate(
                                                                      DateTime.now()
                                                                          .subtract(const Duration(days: 1))
                                                                          .toString(),
                                                                      "dd-MM-yyyy"))
                                                              ? Center(
                                                                  child: Padding(
                                                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                                                  child: CustomText(
                                                                    text: dateformate(
                                                                        chat.messageSentTime.toString(), "dd MMM yyyy"),
                                                                    style: TextStyleConfig.regularTextStyle(
                                                                        color: ColorConstants().grey2,
                                                                        fontSize: TextStyleConfig.bodyText14),
                                                                  ),
                                                                ))
                                                              : Center(
                                                                  child: Padding(
                                                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                                                  child: CustomText(
                                                                    text: "Yesterday",
                                                                    //  ${dateformate(chat.messageSentTime.toString(), "hh:mm a")}

                                                                    style: TextStyleConfig.regularTextStyle(
                                                                        color: ColorConstants().grey2,
                                                                        fontSize: TextStyleConfig.bodyText14),
                                                                  ),
                                                                ))
                                                          : Center(
                                                              child: Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                                              child: CustomText(
                                                                text: "Today",
                                                                style: TextStyleConfig.regularTextStyle(
                                                                    color: ColorConstants().grey2,
                                                                    fontSize: TextStyleConfig.bodyText14),
                                                              ),
                                                            ))
                                                      : const SizedBox()
                                                  : const SizedBox(),
                                              chat.typeId != controller.chatDetailResponse?.userId
                                                  ? (chat.message!.split(".").last.toLowerCase() == "doc" ||
                                                          chat.message!.split(".").last.toLowerCase() == "pdf" ||
                                                          chat.message!.split(".").last.toLowerCase() == "docx")
                                                      ? chatdetailController.getDocumentLayout(chat, context, index)
                                                      : (chat.message!.split(".").last.toLowerCase() == "png" ||
                                                              chat.message!.split(".").last.toLowerCase() == "jpg" ||
                                                              chat.message!.split(".").last.toLowerCase() == "jpeg")
                                                          ? Padding(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: chatdetailController.getImageFromUrl(
                                                                  context, chat, chat.message.toString(), index))
                                                          : GestureDetector(
                                                              child: Container(
                                                                padding: const EdgeInsets.only(
                                                                    left: 14, right: 14, top: 4, bottom: 4),
                                                                child: Align(
                                                                  alignment: (chat.typeId ==
                                                                          controller.chatDetailResponse?.userId
                                                                      ? Alignment.topLeft
                                                                      : Alignment.topRight),
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: const BorderRadius.only(
                                                                        topRight: Radius.circular(12),
                                                                        topLeft: Radius.circular(12),
                                                                        bottomLeft: Radius.circular(12),
                                                                      ),
                                                                      color: (chat.typeId ==
                                                                              controller.chatDetailResponse?.userId
                                                                          ? ColorConstants().light1
                                                                          : ColorConstants().primaryLight),
                                                                    ),
                                                                    padding: const EdgeInsets.all(16),
                                                                    child: CustomText(
                                                                      text: chat.message!,
                                                                      style: const TextStyle(fontSize: 15),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                  : (chat.message!.split(".").last.toLowerCase() == "doc" ||
                                                          chat.message!.split(".").last.toLowerCase() == "pdf" ||
                                                          chat.message!.split(".").last.toLowerCase() == "docx")
                                                      ? chatdetailController.getDocumentLayout(chat, context, index)
                                                      : ((chat.message!.split(".").last.toLowerCase() == "png" ||
                                                              chat.message!.split(".").last.toLowerCase() == "jpg" ||
                                                              chat.message!.split(".").last.toLowerCase() == "jpeg"))
                                                          ? Padding(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: chatdetailController.getImageFromUrl(
                                                                  context, chat, chat.message.toString(), index))
                                                          : Container(
                                                              padding: const EdgeInsets.only(
                                                                  left: 14, right: 14, top: 2, bottom: 2),
                                                              child: Align(
                                                                alignment: (chat.typeId ==
                                                                        controller.chatDetailResponse?.userId
                                                                    ? Alignment.topLeft
                                                                    : Alignment.topRight),
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: const BorderRadius.only(
                                                                      topRight: Radius.circular(12),
                                                                      topLeft: Radius.circular(12),
                                                                      bottomRight: Radius.circular(12),
                                                                    ),
                                                                    color: (chat.typeId ==
                                                                            controller.chatDetailResponse?.userId
                                                                        ? ColorConstants().light1
                                                                        : ColorConstants().primaryLight),
                                                                  ),
                                                                  padding: const EdgeInsets.all(16),
                                                                  child: CustomText(
                                                                    text: chat.message!,
                                                                    style: TextStyleConfig.regularTextStyle(
                                                                      color: ColorConstants().black,
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: TextStyleConfig.bodyText14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                              (index != 0)
                                                  ? (((dateformate(chat.messageSentTime.toString(), "hh:mm a")) !=
                                                          (dateformate(
                                                              chatdetailController
                                                                  .messagelist[
                                                                      (chatdetailController.messagelist.length - 1) -
                                                                          (index - 1)]
                                                                  .messageSentTime
                                                                  .toString(),
                                                              "hh:mm a"))))
                                                      ? Padding(
                                                          padding: const EdgeInsets.only(
                                                              left: 15, right: 15, top: 0, bottom: 10),
                                                          child: CustomText(
                                                            text:
                                                                dateformate(chat.messageSentTime.toString(), "hh:mm a"),
                                                            style: TextStyleConfig.regularTextStyle(
                                                              color: ColorConstants().grey,
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: TextStyleConfig.bodyText12,
                                                            ),
                                                          ),
                                                        )
                                                      : Padding(
                                                          padding: const EdgeInsets.only(
                                                              left: 15, right: 15, top: 0, bottom: 10),
                                                          child: CustomText(
                                                            text:
                                                                dateformate(chat.messageSentTime.toString(), "hh:mm a"),
                                                            style: TextStyleConfig.regularTextStyle(
                                                              color: ColorConstants().grey,
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: TextStyleConfig.bodyText12,
                                                            ),
                                                          ),
                                                        )
                                                  : Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 15, right: 15, top: 0, bottom: 10),
                                                      child: CustomText(
                                                        text: dateformate(chat.messageSentTime.toString(), "hh:mm a"),
                                                        style: TextStyleConfig.regularTextStyle(
                                                          color: ColorConstants().grey,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: TextStyleConfig.bodyText12,
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          );
                                        },
                                      )
                                    : const SizedBox()),
                          )
                        : controller.isDataLoaded.value
                            ? noDataView(StringConstants.no_data_found)
                            : const SizedBox(),
                    SafeArea(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: InkWell(
                            onTap: (chatdetailController.chatDetailResponse?.is_blocked_user == "1")
                                ? () {
                                    showSnackBar(context,
                                        "${toLabelValue(StringConstants.unblock)} ${chatdetailController.chatDetailResponse?.name} ${toLabelValue(StringConstants.send_a_msg)}");
                                  }
                                : null,
                            child: IgnorePointer(
                              ignoring:
                                  (chatdetailController.chatDetailResponse?.is_blocked_user == "1") ? true : false,
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: ColorConstants().light1,
                                  borderRadius: const BorderRadius.all(Radius.circular(45)),
                                  border: Border.all(width: 1, color: Colors.transparent),
                                ),
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                        child: SizedBox(
                                      height: 45,
                                      child: TextField(
                                        controller: chatdetailController.msgController,
                                        inputFormatters: [
                                          NoLeadingSpaceFormatter(),
                                          FilteringTextInputFormatter.deny(RegExp('  ')),
                                        ],
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                                          hintText: toLabelValue(StringConstants.send_your_msg),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(width: 0, color: Colors.transparent),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(width: 0, color: Colors.transparent),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        onTap: () {
                                          if (chatdetailController.chatDetailResponse?.is_blocked_user == "1") {}
                                        },
                                        onChanged: ((value) {}),
                                      ),
                                    )),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            dismissKeyboard();
                                            if (chatdetailController.chatDetailResponse?.is_blocked_user == "0") {
                                              List<File> pickedImage = await showImageSelectionBottomSheet();
                                              if (pickedImage.isNotEmpty) {
                                                showLoader();
                                                uploadS3Image(pickedImage.first).then((value) async {
                                                  controller.sendMessageAPI(
                                                      chatID: controller.chatDetailResponse!.chatId,
                                                      message: value.split("/").last,
                                                      messageTYpeID: "1",
                                                      receiverID: controller.chatDetailResponse!.userId);

                                                  chatdetailController.update();
                                                }).onError((error, stackTrace) {
                                                  hideLoader();
                                                  if (kDebugMode) {
                                                    print('$error ==> Error Occured While Uploading Image To Bucket');
                                                  }
                                                });
                                              }
                                            } else {
                                              showSnackBar(context,
                                                  "${toLabelValue(StringConstants.unblock)} ${chatdetailController.chatDetailResponse?.name} ${toLabelValue(StringConstants.send_a_msg)}");
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                            child: SvgPicture.asset(ImageConstants.icon_gallary),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            dismissKeyboard();
                                            if (chatdetailController.chatDetailResponse?.is_blocked_user == "0") {
                                              showLoader();
                                              chatdetailController.picksinglefile();
                                            } else {
                                              showSnackBar(context,
                                                  "${toLabelValue(StringConstants.unblock)} ${chatdetailController.chatDetailResponse?.name} ${toLabelValue(StringConstants.send_a_msg)}");
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                            child: SvgPicture.asset(ImageConstants.icon_attachment),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 16, left: 8, top: 8, bottom: 8),
                                          child: InkWell(
                                            onTap: () {
                                              if (chatdetailController.chatDetailResponse?.is_blocked_user == "0") {
                                                if (chatdetailController.msgController.text.isNotEmpty) {
                                                  controller.sendMessageAPI(
                                                      chatID: controller.chatDetailResponse!.chatId,
                                                      message: chatdetailController.msgController.text,
                                                      messageTYpeID: "0",
                                                      receiverID: controller.chatDetailResponse!.userId);
                                                }

                                                chatdetailController.msgController.clear();
                                                chatdetailController.update();
                                              } else {
                                                chatdetailController.msgController.text = "";
                                                showSnackBar(context,
                                                    "${toLabelValue(StringConstants.unblock)} ${chatdetailController.chatDetailResponse?.name} ${toLabelValue(StringConstants.send_a_msg)}");
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SvgPicture.asset(ImageConstants.icon_sends),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            )));
  }
}
