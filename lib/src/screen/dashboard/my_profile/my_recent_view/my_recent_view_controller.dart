import 'package:dating_app/imports.dart';
import 'package:dating_app/src/services/repository/profile_webservice/my_recent_view_webservices.dart';

import '../../../../model/profile/my_recent_view_model.dart';
import '../../../../widgets/custom_chat_view/chat_list.dart';

class MyRecentViewController extends GetxController {
  RxList<RecentViewCardList> recentViewList = <RecentViewCardList>[].obs;
  RxBool isDataLoaded = false.obs;
  RxInt pageIndex = 1.obs;
  final refreshController = RefreshController(initialRefresh: false);

  @override
  void onInit() {
    super.onInit();
    Future.delayed(
      const Duration(microseconds: 700),
      () {
        recentView();
      },
    );
  }

//Pagination

  void onRefresh() {
    // monitor network fetch
    // if failed,use refreshFailed()
    refreshController.refreshCompleted();
    pageIndex.value = 1;
    recentView();
  }

  void onLoading() async {
    pageIndex += 1;
    await Future.delayed(const Duration(milliseconds: 1000));

    refreshController.loadComplete();

    update();
  }

  recentView() {
    if (isDataLoaded.value == false) {
      showLoader();
    }

    RecentViewRepository().getRecentView().then((value) {
      recentViewList.value = value?.result?.recentViewCardList ?? [];
      isDataLoaded(true);
      hideLoader();
    });
  }
}
