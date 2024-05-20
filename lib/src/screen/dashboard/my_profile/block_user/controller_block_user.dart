import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/profile/blockuser_model.dart';
import 'package:dating_app/src/services/repository/profile_webservice/block_users_webservice.dart';
import 'package:dating_app/src/widgets/custom_chat_view/chat_list.dart';

class ControllerBlockUser extends GetxController {
  RxBool isDataLoaded = false.obs;
  RxInt pageIndex = 1.obs;
  final refreshController = RefreshController(initialRefresh: false);

  BlockUserResponse? blockUserList;

//Pagination

  void onRefresh() {
    // monitor network fetch
    // if failed,use refreshFailed()
    refreshController.refreshCompleted();
    pageIndex.value = 1;
    getblockUserAPI();
  }

  void onLoading() async {
    pageIndex += 1;
    await Future.delayed(const Duration(milliseconds: 1000));

    getblockUserAPI();
    refreshController.loadComplete();

    update();
  }

  //get blockUsers API
  getblockUserAPI() async {
    if (!isDataLoaded.value) showLoader();

    ApiResponse<BlockUserResponse>? response =
        await BlockUserRepository().getBlockUserlist(pageIndex.toString());

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      blockUserList = response.result;
      isDataLoaded(true);
      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    isDataLoaded(true);
    hideLoader();
  }

  unblockUserDialogue(String blockuserID, isBlock, username) {
    showDialogBox(
      Get.overlayContext!,
      "${toLabelValue(StringConstants.are_you_sure_want_to_unblock)} $username?",
      () {
        Get.back();
      },
      StringConstants.no,
      () {
        blockUserAPI(blockuserID, isBlock);
      },
      StringConstants.yes,
    );
  }

  //Block API
  blockUserAPI(String blockuserID, String isBlock) async {
    showLoader();

    ResponseModel? response =
        await BlockUserRepository().blockUser(blockuserID, isBlock);

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      hideLoader();

      Get.back();
      getblockUserAPI();
      showSnackBar(Get.overlayContext, toLabelValue(response.message!));
    } else {
      hideLoader();

      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    hideLoader();
  }
}
