// ignore_for_file: invalid_use_of_protected_member

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/my_likes_model.dart';
import 'package:dating_app/src/services/repository/profile_webservice/my_likes_webservice.dart';
import 'package:dating_app/src/widgets/custom_chat_view/chat_list.dart';

export 'package:pull_to_refresh/pull_to_refresh.dart';

class ControllerMyLikes extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  RxBool isDataLoaded = false.obs;
  MyLikesResponse? myLikeResponse;

  RxInt selectedTabIndex = 0.obs;
  RxInt pageIndex = 1.obs;
  final sentrefreshController = RefreshController(initialRefresh: false);
  final receiverefreshController = RefreshController(initialRefresh: false);

  RxList<SentLikes> likeList = <SentLikes>[].obs;
  RxList<SentLikes> receiveList = <SentLikes>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

//Pagination
  onRefresh(bool isFromSentLikes) {
    // monitor network fetch
    // if failed,use refreshFailed()
    if (isFromSentLikes) {
      sentrefreshController.refreshCompleted();
    } else {
      receiverefreshController.refreshCompleted();
    }

    pageIndex.value = 1;
    getMyLikesAPI(isFromSentLikes);
  }

  onLoading(bool isFromSentLikes) async {
    pageIndex += 1;

    getMyLikesAPI(isFromSentLikes);
    if (isFromSentLikes) {
      sentrefreshController.loadComplete();
    } else {
      receiverefreshController.loadComplete();
    }
    update();
  }

  //get Mylikes API
  getMyLikesAPI(bool isFromSentLikes) async {
    if (!isDataLoaded.value) showLoader();

    ApiResponse<MyLikesResponse>? response =
        await MyLikesRepository().getMyLikes(isFromSentLikes ? "1" : "0", pageIndex.value.toString());

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      if (pageIndex.value == 1) {
        likeList.value.clear();
        receiveList.value.clear();
      }
      if (response.result!.sentLikes!.isNotEmpty) {
        myLikeResponse = response.result;
        if (isFromSentLikes) {
          likeList.value.addAll(response.result!.sentLikes!);
        } else {
          receiveList.value.addAll(response.result!.sentLikes!);
        }
      }
      hideLoader();

      isDataLoaded(true);
      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    isDataLoaded(true);
    hideLoader();
  }
}
