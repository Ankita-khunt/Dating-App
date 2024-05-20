import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/dashboard/notification_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../services/repository/dashboard_webservice/notification_webservice.dart';

class ControllerNotification extends GetxController {
  RxBool isDataLoaded = false.obs;
  RxInt pageIndex = 1.obs;
  final refreshController = RefreshController(initialRefresh: false);

  List<NotificationList>? notificationList = [];

  @override
  void onInit() {
    super.onInit();
    notificationAPI();
  }

//Pagination

  void onRefresh() {
    // monitor network fetch
    // if failed,use refreshFailed()
    refreshController.refreshCompleted();
    pageIndex.value = 1;
    notificationAPI();
  }

  void onLoading() async {
    pageIndex += 1;
    await Future.delayed(const Duration(milliseconds: 1000));

    notificationAPI();
    refreshController.loadComplete();

    update();
  }

  //Notification List API
  notificationAPI() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isDataLoaded.value) {
        showLoader();
      }
    });

    ApiResponse<NotificationListResponse>? response =
        await NotificationRepository()
            .notificationList(pageIndex.value.toString());
    if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
      if (pageIndex.value == 1) {
        notificationList = [];
      }
      notificationList!.addAll(response.result!.notificationList!);
      hideLoader();
      update();
    } else {
      hideLoader();
      showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
    }
    isDataLoaded(true);
    hideLoader();
  }
}
