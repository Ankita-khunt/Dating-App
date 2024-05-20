import 'package:dating_app/imports.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message");
  }
  if (message.data['notification_type'] == "2") {}
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  getToken();
  late final Uuid uuid;
  uuid = const Uuid();
  currentUuid = uuid.v4();
  //APP ORIENTATION CODE

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  String token = await SharedPref.getString(PreferenceConstants.token);
  String userID = await SharedPref.getString(PreferenceConstants.userID);
  bool firstAppLaunch = await SharedPref.getBool(PreferenceConstants.isAppLaunched);

  loginresponse?.token = token;
  loginresponse?.userId = userID;

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });

//FIREBASE CONFIGURATION

  await PushNotificationService().registerNotificationListeners();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//RUNAPP
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Sizer(builder: (context, orientation, deviceType) {
        return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          return OrientationBuilder(builder: (BuildContext context, Orientation orientation) {
            return NotificationListener(
              onNotification: (OverscrollIndicatorNotification overScroll) {
                overScroll.disallowIndicator();
                return false;
              },
              child: GetMaterialApp(
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child ?? const SizedBox(),
                    );
                  },
                  title: 'DatingApp',
                  debugShowCheckedModeBanner: false,
                  navigatorKey: navigatorKey,
                  theme: ThemeData(
                    appBarTheme: const AppBarTheme(
                      systemOverlayStyle: SystemUiOverlayStyle(
                        systemNavigationBarColor: Colors.transparent,
                        statusBarIconBrightness: Brightness.dark,
                        systemNavigationBarIconBrightness: Brightness.dark,
                      ),
                    ),
                    fontFamily: FontFamilyConstants.fontfamily,
                    scaffoldBackgroundColor: Colors.transparent,
                  ),
                  initialRoute: Routes.splash,
                  getPages: getPages),
            );
          });
        });
      }),
    );
  }
}
