import 'dart:io';

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/chat/chat_detail.dart';
import 'package:dating_app/src/model/dashboard/user_detail_model.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/binding_user_detail.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/controller_user_detail.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/preview_image/binding_preview.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/preview_image/controller_preview.dart';
import 'package:dating_app/src/services/repository/chat_webservice/chat_list_webservice.dart';
import 'package:dating_app/src/services/repository/profile_webservice/block_users_webservice.dart';
import 'package:dating_app/src/utils/enums/enum.dart';
import 'package:dating_app/src/widgets/widget.card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ControllerChatDetail extends GetxController {
  TextEditingController msgController = TextEditingController();
  TextEditingController reportMsgController = TextEditingController();

//FILE PICK
  PlatformFile? docfile;
  String? size = "";

  // String? recieverID = "";
  ChatDetailResponse? chatDetailResponse;
  List<MessageList> messagelist = [];
  RefreshController refreshController = RefreshController(initialRefresh: false);

  RxBool isDataLoaded = false.obs;
  RxInt pageIndex = 1.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  //ChatDetail API
  chatdetailAPI(String chatID, receiverID) async {
    msgController.text = "";
    //For detecting Chatdetail open or not
    isChatDetailOpen.value = true;
    selectedChatReceiverID.value = receiverID;
    //
    // chatDetailResponse = null;
    // messagelist.clear();
    if (!isDataLoaded.value) showLoader();

    ApiResponse<ChatDetailResponse>? response =
        await ChatRepository().chatdetail(pageIndex.toString(), chatID, receiverID);

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      chatDetailResponse = response.result;
      isDataLoaded(true);
      if (response.result!.messageList!.isNotEmpty) {
        if (pageIndex.value == 1) {
          messagelist.clear();
        }
        messagelist.insertAll(0, response.result!.messageList!.reversed);
      }
      hideLoader();
      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    isDataLoaded(true);
    hideLoader();
  }

//Send Message
  sendMessageAPI({String? receiverID, chatID, message, messageTYpeID}) async {
    // pageIndex.value = 1;
    ApiResponse<SendMessageRespone>? response = await ChatRepository()
        .sendMessage(chatID: chatID, message: message, messageTYpeID: messageTYpeID, receiverID: receiverID);
    if (response!.code == CODE_SUCCESS_CODE) {
      isDataLoaded.value = true;
      pageIndex.value = 1;
      chatdetailAPI(response.result!.chatId!, receiverID);
      update();
      hideLoader();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }

  //Block API
  blockUserAPI(String blockuserID, String isBlock) async {
    showLoader();

    ResponseModel? response = await BlockUserRepository().blockUser(blockuserID, isBlock);

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      hideLoader();
      chatdetailAPI(chatDetailResponse!.chatId!, chatDetailResponse?.userId);

      showSnackBar(Get.overlayContext, toLabelValue(response.message!));
    } else {
      hideLoader();

      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    hideLoader();
  }

  Widget blockDialogue(String name, userID) {
    return showDialogBox(
        Get.overlayContext!,
        toLabelValue(StringConstants.block_user_will_no_longer_sent_msg),
        () {
          Get.back();
        },
        StringConstants.no,
        () {
          // dismissKeyboard();
          Get.back();
          blockUserAPI(userID, chatDetailResponse?.is_blocked_user == "0" ? "1" : "0");
        },
        StringConstants.yes,
        "${toLabelValue(StringConstants.are_you_sure_want_to_block)} $name?");
  }

  show_BlockUser_sheet(String name) {
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
                  maxHeight: Get.height * 0.3, minHeight: MediaQuery.of(bottomContext).size.height * 0.22),
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
                            Get.back();
                            if (chatDetailResponse?.is_blocked_user == "0") {
                              blockDialogue(chatDetailResponse!.name!, chatDetailResponse?.userId);
                            } else {
                              blockUserAPI(chatDetailResponse!.userId!, "0");
                            }
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
                                    text: toLabelValue(chatDetailResponse?.is_blocked_user == "1"
                                        ? StringConstants.unblock_user
                                        : StringConstants.block_user),
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
                            show_report_dialogue();
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
        );
      },
    ));
  }

  validateReportField(String userID) {
    String isValidatemsg = Validator.blankValidation(reportMsgController.text, StringConstants.message);

    if (isValidatemsg != "") {
      showSnackBar(Get.overlayContext, isValidatemsg);
    } else {
      Get.back();
      dismissKeyboard();
      BindingUserdetail().dependencies();
      Get.find<ControllerUserDetail>().reportUserAPI(userID, reportMsgController.text);
      reportMsgController.clear();
      chatdetailAPI(chatDetailResponse!.chatId!, chatDetailResponse!.userId);
      update();
    }
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
                  maxHeight: Get.height * 0.4, minHeight: MediaQuery.of(bottomContext).size.height * 0.26),
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
                              controller: reportMsgController,
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
                            validateReportField(chatDetailResponse!.userId.toString());
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

//LAYOUTS for CHAT
  /// Get layout from URL
  getImageFromUrl(context, MessageList chat, String url, int index) {
    return GestureDetector(
      onTap: () {
        dismissKeyboard();
        BindingPreview().dependencies();
        Get.find<ControllerPreview>().productImages = [Images(id: "0", imageUrl: url)];
        Get.toNamed(Routes.preview_image);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: const Radius.circular(12),
            topLeft: const Radius.circular(12),
            bottomLeft:
                chat.typeId == chatDetailResponse?.userId ? const Radius.circular(0) : const Radius.circular(12),
            bottomRight:
                chat.typeId == chatDetailResponse?.userId ? const Radius.circular(12) : const Radius.circular(0),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            color: (chat.typeId == chatDetailResponse?.userId ? Colors.grey.shade200 : Colors.transparent),
            child:
                // url.contains("http")
                //     ? Image.network(
                //         url,
                //         fit: BoxFit.cover,
                //         height: 300,
                //         width: 180,
                //       )
                //     :
                CachedNetworkImage(
              imageUrl: "${generalSetting?.s3Url}$url",
              fit: BoxFit.cover,
              height: 300,
              width: 180,
              errorWidget: (context, url, error) {
                return Image.asset(ImageConstants.noimage);
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _displayFileSize(String path) async {
    final fileSizeInBytes = await _getFileSize(path);
    _displaySize(fileSizeInBytes);
  }

  Future<int> _getFileSize(String path) async {
    final fileBytes = await File(path).readAsBytes();

    return fileBytes.lengthInBytes;
  }

  void _displaySize(int fileSizeInBytes) {
    final fileSizeInKB = fileSizeInBytes / 1000;
    final fileSizeInMB = fileSizeInKB / 1000;
    final fileSizeInGB = fileSizeInMB / 1000;
    final fileSizeInTB = fileSizeInGB / 1000;

    final fileSize = '''
  $fileSizeInBytes bytes
  $fileSizeInKB KB
  $fileSizeInMB MB
  $fileSizeInGB GB
  $fileSizeInTB TB
      ''';

    size = fileSize;
    update();
  }

  getDocumentLayout(MessageList chat, context, int index) {
    return GestureDetector(
      onTap: () {
        showLoader();
        downloadFile("${generalSetting?.s3Url}${chat.message.toString()}");
      },
      child: Container(
        padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
        child: Align(
          alignment: (chat.typeId == chatDetailResponse?.userId ? Alignment.topLeft : Alignment.topRight),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: const Radius.circular(12),
                topLeft: const Radius.circular(12),
                bottomLeft:
                    (chat.typeId == chatDetailResponse?.userId) ? const Radius.circular(0) : const Radius.circular(12),
                bottomRight: chat.messageType == describeEnum(ChatUserType.sender)
                    ? const Radius.circular(12)
                    : const Radius.circular(0),
              ),
              color:
                  (chat.typeId == chatDetailResponse?.userId ? ColorConstants().light1 : ColorConstants().primaryLight),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
              Image.asset(
                getImage("${generalSetting?.s3Url}${chat.message!}"),
                height: 30,
                width: 30,
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    child: CustomText(
                      text: chat.message!.split("/").last,
                      overflow: TextOverflow.ellipsis,
                      maxlines: 2,
                      style: TextStyleConfig.regularTextStyle(fontSize: TextStyleConfig.bodyText14),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  getVideoLayout(MessageList chat, context, int index) {
    return GestureDetector(
        onTap: () {
          // OpenAppFile.open(docfile!.path.toString());
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
          child: Align(
            alignment: (chat.typeId == chatDetailResponse?.userId ? Alignment.topLeft : Alignment.topRight),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(20),
                  topLeft: const Radius.circular(20),
                  bottomLeft: (chat.typeId == chatDetailResponse?.userId)
                      ? const Radius.circular(0)
                      : const Radius.circular(20),
                  bottomRight:
                      chat.typeId == chatDetailResponse?.userId ? const Radius.circular(20) : const Radius.circular(0),
                ),
                color: (chat.typeId == chatDetailResponse?.userId ? Colors.grey.shade200 : Colors.blue[200]),
              ),
              padding: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    child: CustomText(
                      text: chat.message!.split("/").last,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ));
  }

//Pagination

  void onRefresh() {
    // monitor network fetch
    // if failed,use refreshFailed()
    chatdetailAPI(chatDetailResponse!.chatId!, chatDetailResponse!.userId);
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    pageIndex += 1;
    chatdetailAPI(chatDetailResponse!.chatId!, chatDetailResponse!.userId);
    refreshController.loadComplete();
    update();
  }

//File Pick
  Future<void> picksinglefile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['docx', 'pdf', 'doc'],
    );
    if (result != null) {
      if (result.files.first.path!.split(".").last.toLowerCase() == "pdf" ||
          result.files.first.path!.split(".").last.toLowerCase() == "doc" ||
          result.files.first.path!.split(".").last.toLowerCase() == "docx") {
        docfile = result.files.first;
        final kb = docfile!.size / 1024;
        final mb = kb / 1024;
        final size = (mb >= 1) ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
        this.size = size;

        uploadS3Image(File(docfile!.path!)).then((value) async {
          sendMessageAPI(
              chatID: chatDetailResponse!.chatId,
              message: value.split("/").last,
              messageTYpeID: "3",
              receiverID: chatDetailResponse!.userId);
          hideLoader();
        }).onError((error, stackTrace) {
          hideLoader();
          if (kDebugMode) {
            print('$error ==> Error Occured While Uploading Image To Bucket');
          }
        });

        update();
      } else {
        showSnackBar(Get.overlayContext, toLabelValue(StringConstants.only_support_pdf));
      }
    } else {
      hideLoader();
    }
  }
}
