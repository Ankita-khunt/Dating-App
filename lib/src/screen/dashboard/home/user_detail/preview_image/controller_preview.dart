import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/dashboard/user_detail_model.dart';

class ControllerPreview extends GetxController {
  var pageController = PageController();

  final currentPageNotifier = ValueNotifier<int>(0);

  List<Images>? productImages;

  @override
  void onInit() {
    super.onInit();
  }

  changePageIndex(int index) {
    pageController = PageController(initialPage: currentPageNotifier.value, viewportFraction: 0.99);
    update();
  }
}
