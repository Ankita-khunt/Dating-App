import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/chat/chat_list_model.dart';
import 'package:dating_app/src/screen/dashboard/chat/chats/screen_chats.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/binding_user_detail.dart';
import 'package:dating_app/src/screen/dashboard/home/user_detail/controller_user_detail.dart';
import 'package:dating_app/src/services/repository/chat_webservice/chat_list_webservice.dart';

export 'package:pull_to_refresh/pull_to_refresh.dart';

class ControllerChats extends GetxController with GetTickerProviderStateMixin {
  late TabController chatTabController;
  final chatrefreshController = RefreshController(initialRefresh: false);
  final videorefreshController = RefreshController(initialRefresh: false);

  Rx<TextEditingController> searchController = TextEditingController().obs;

  RxBool isSelectionEnable = false.obs;
  TextEditingController reportMsgController = TextEditingController();
  RxBool isBlockType = false.obs;
  RxInt pageIndex = 1.obs;

  List<ChatList>? chatList = [];

  List<ChatList>? searchChatList = [];
  bool isChatAvailable = false;
  bool isVideoAvailable = false;
  ChatResponse? chatResponse;
  RxInt? isSelectedlistIndex = (-1).obs;
  RxBool isDataLoaded = false.obs;

  RxBool? isChatSearchEnable = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    chatTabController = TabController(length: 2, vsync: this);
    isSelectedlistIndex!.value = (-1);
    isSelectionEnable(false);
  }

  //Search faqs
  onSearchTextChanged(String text) async {
    searchChatList!.clear();
    if (text.isEmpty) {
      update();
      return;
    }

    for (var chatdata in chatResponse!.chat!) {
      if (chatdata.name!.toLowerCase().contains(text.toLowerCase())) {
        searchChatList!.add(chatdata);
      }
    }

    update();
  }

  //Pagination
  void onRefresh(String? chattype) {
    // monitor network fetch
    // if failed,use refreshFailed()
    if (chattype == "0") {
      chatrefreshController.refreshCompleted();
    } else {
      videorefreshController.refreshCompleted();
    }
    pageIndex.value = 1;
    chatlistAPI(chattype!);
  }

  void onLoading(String? chattype) async {
    pageIndex += 1;

    chatlistAPI(chattype!);
    if (chattype == "0") {
      chatrefreshController.loadComplete();
    } else {
      videorefreshController.loadComplete();
    }

    update();
  }

  //ChatList API
  chatlistAPI(String chatType) async {
    if (!isDataLoaded.value) showLoader();

    ApiResponse<ChatResponse>? response = await ChatRepository().chatlist(pageIndex.toString(), chatType);

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      chatResponse = response.result;
      chatUnreadCount.value = response.result?.unread_message_count;
      if (response.result!.chat!.isNotEmpty) {
        if (pageIndex.value == 1) {
          chatList = [];
        }
        chatList!.addAll(response.result!.chat!);
      }
      isUserSubscribe = await SharedPref.getBool(PreferenceConstants.isUserSubscribed);
      if (currentSubscriptionData!.plan!.planExpireDate != "" &&
          DateTime.parse(currentSubscriptionData!.plan!.planExpireDate!).isBefore(DateTime.now())) {
        chatResponse?.isSubscribed = (isUserSubscribe == true) ? "1" : "0";
      }
      isChatAvailable = await SharedPref.getBool(PreferenceConstants.isChatAvailable);
      isVideoAvailable = await SharedPref.getBool(PreferenceConstants.isVideoAvailable);
      hideLoader();
      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    isDataLoaded(true);
    hideLoader();
  }

  validateReportField(String userID) {
    String isValidatemsg = Validator.blankValidation(reportMsgController.text, StringConstants.message);

    if (isValidatemsg != "") {
      showSnackBar(Get.overlayContext, isValidatemsg);
    } else {
      Get.back();

      BindingUserdetail().dependencies();
      Get.find<ControllerUserDetail>()
          .reportUserAPI(chatList![isSelectedlistIndex!.value].userId!, reportMsgController.text);
      reportMsgController.clear();
      isSelectedlistIndex!.value = (-1);
      isSelectionEnable(false);
      update();
    }
  }
}

class ChatUser {
  String? id;
  String? image;
  String? name;
  String? msg;
  String? time;
  String? count;

  ChatUser({this.id, this.count, this.image, this.msg, this.name, this.time});
}
