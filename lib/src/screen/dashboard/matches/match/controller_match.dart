import 'package:dating_app/imports.dart';
import 'package:dating_app/src/widgets/custom_chat_view/chat_list.dart';

class ControllerMatch extends GetxController {
  RxBool isDataLoaded = false.obs;
  RxInt pageIndex = 1.obs;
  final refreshController = RefreshController(initialRefresh: false);

  MatchResponse? matchResponse;
  List<MatchList> matchlist = [];

  //MatchList API
  Future<void> matchlistAPI() async {
    if (!isDataLoaded.value) showLoader();

    ApiResponse<MatchResponse>? response =
        await MatchRepository().matchList(pageIndex.toString());

    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      matchResponse = response.result;
      if (pageIndex.value == 1) {
        matchlist.clear();
      }
      if (response.result!.matchList!.isNotEmpty) {
        matchlist.addAll(response.result!.matchList!);
      } else {}
      hideLoader();
      update();
    } else {
      matchResponse = null;
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    isDataLoaded(true);
    hideLoader();
  }

//Remove match
  removeMatchAPI(String matchID) async {
    showLoader();
    ResponseModel? response = await MatchRepository().removeMatch(matchID);
    if (response!.code == CODE_SUCCESS_CODE) {
      showSnackBar(Get.overlayContext, toLabelValue(response.message!));
      matchlistAPI();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
  }

  //Pagination
  void onRefresh() {
    // monitor network fetch
    // if failed,use refreshFailed()
    refreshController.refreshCompleted();
    pageIndex.value = 1;
    matchlistAPI();
  }

  void onLoading() async {
    pageIndex += 1;
    await Future.delayed(const Duration(milliseconds: 1000));

    matchlistAPI();
    refreshController.loadComplete();
    update();
  }
}
