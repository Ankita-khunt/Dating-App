import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/chat/chats/screen_chats.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/screen_card_swipe.dart';
import 'package:dating_app/src/screen/dashboard/matches/match/screen_match.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/profile/screen_profile.dart';

class TabNavigatorRoutes {
  static const String root = '/';
}

class TabNavigator extends StatelessWidget {
  var listScreen = [
    ScreenCardWipe(),
    ScreenMatch(),
    ScreenChats(),
    ScreenProfile(),
  ];

  final GlobalKey<NavigatorState> navigatorKey;
  final int index;

  TabNavigator({super.key, required this.navigatorKey, required this.index});

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      TabNavigatorRoutes.root: (context) => listScreen[index],
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Navigator(
        key: navigatorKey,
        initialRoute: TabNavigatorRoutes.root,
        onGenerateRoute: (routeSettings) {
          var name = routeSettings.name;

          return MaterialPageRoute(
              builder: (context) =>
                  routeBuilders[routeSettings.name!]!(context));
        });
  }
}
