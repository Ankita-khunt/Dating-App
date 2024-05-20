import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/custom_tab/view/bottom_navigation.dart/tab_navigator.dart';

class TabbarController extends GetxController {
  RxInt currentIndex = 0.obs;

  Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
    3: GlobalKey<NavigatorState>(),
    4: GlobalKey<NavigatorState>(),
  };

  Widget buildOffstageNavigator(int tabItem) {
    return Offstage(
      offstage: currentIndex != tabItem,
      child: TabNavigator(
        navigatorKey: navigatorKeys[currentIndex]!,
        index: currentIndex.value,
      ),
    );
  }
}
