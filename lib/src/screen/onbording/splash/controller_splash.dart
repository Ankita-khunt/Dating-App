import 'dart:async';
import 'dart:developer' as developer;

import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/authentication/forgotpass/binding_forgotpassword.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/controller_card_swipe.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:uni_links/uni_links.dart';

class ControllerSplash extends GetxController with WidgetsBindingObserver {
  //NETWORK CONNECTIVITY CODE
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  Position? currentPosition;

  //FIREBASE NOTIFICATION
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //Deep Links
  Uri? _initialURI;
  Uri? _currentURI;
  bool isInternetAvailable = false;
  StreamSubscription? _streamSubscription;
  AppUpdateInfo? updateInfo;
  bool flexibleUpdateAvailable = false;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void onInit() {
    super.onInit();

    _initURIHandler();
    _incomingLinkHandler();
    WidgetsBinding.instance.addObserver(this);

    initConnectivity();

    getToken();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    getLabelsAPI();
    getGeneralSettingAPI();

    FlutterAppBadger.removeBadge();
    //DeepLink Handler
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      connectWebsocket();
      sendMessage("online");

      debugPrint("Status appLifeCycle === $state");
    } else if (state == AppLifecycleState.inactive) {
      sendMessage("offline");

      debugPrint("Status appLifeCycle === $state");
    } else if (state == AppLifecycleState.paused) {
      debugPrint("Status appLifeCycle === $state");
    } else if (state == AppLifecycleState.detached) {
      sendMessage("offline");

      debugPrint("Status appLifeCycle === $state");
    } else {
      debugPrint("Status appLifeCycle === $state");
    }
  }

  navigateToApp() async {
    bool isLogin = await SharedPref.getBool(PreferenceConstants.islogin);
    bool isRegistered = await SharedPref.getBool(PreferenceConstants.isregistered);
    bool isSetupProfileCompleted = await SharedPref.getBool(PreferenceConstants.setupProfileDone);
    bool isAppLaunched = await SharedPref.getBool(PreferenceConstants.isAppLaunched);
    bool isUserSubscrib = await SharedPref.getBool(PreferenceConstants.isUserSubscribed);

    isUserSubscribe = isUserSubscrib;

    if (isLogin) {
      if (isSetupProfileCompleted) {
        connectWebsocket();
        getCurrentPosition();

        Get.offNamed(Routes.customTabbar);
      } else {
        Get.offNamed(Routes.login);
      }
    } else {
      if (isRegistered) {
        Get.offAllNamed(Routes.login);
      } else {
        if (isAppLaunched) {
          Get.offAllNamed(Routes.login);
        } else {
          Get.offAllNamed(Routes.onboard1);
        }
      }
    }
  }

  /// Get FCM Token
  getLabelsAPI() async {
    labelList.clear();
    LabelResponse? labelResponse = await LabelRepository().fetchlabel();
    labelList.addAll(labelResponse!.result!);
    if (labelResponse.result!.isNotEmpty) {
      Future.delayed(const Duration(seconds: 2), () {
        if (_initialURI != null) {
          BindingForgotPassword().dependencies();
          Get.find<ControllerSplash>();

          Get.offNamed(Routes.createnewpass);
        } else {
          if (isInternetAvailable) {
            navigateToApp();
          } else {
            initConnectivity();
          }
        }
      });
    } else {
      initConnectivity();
    }
  }

  getGeneralSettingAPI() async {
    ApiResponse<GeneralSetting>? generalSettingResponse = await GeneralSettingsRepository().fetchGeneralSetting();
    generalSetting = generalSettingResponse?.result;
  }

  //Internet connectivity check
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus = result;

    if (_connectionStatus == ConnectivityResult.mobile) {
      debugPrint("Mobile network---------");
      isInterNetExist = 1;
      if (!isInternetAvailable) {
        isInternetAvailable = true;

        if (isInterNetExist == 0) {
          onInit();
        }
        update();
        Get.back(result: true);
      }
    } else if (_connectionStatus == ConnectivityResult.wifi) {
      isInterNetExist = 1;

      if (!isInternetAvailable) {
        isInternetAvailable = true;

        debugPrint("WIFI network---------");
        update();

        if (Get.previousRoute == Routes.splash) {
          onInit();
        } else {
          Get.back(result: true);
        }
      }
    } else {
      isInterNetExist = 0;
      isInternetAvailable = false;

      Get.toNamed(Routes.connctionbar);
    }
  }

  //Deeplink Callback
  Future<void> _initURIHandler() async {
    // 1
    if (!initialURILinkHandled) {
      initialURILinkHandled = true;
      // 2

      try {
        // 3
        final initialURI = await getInitialUri();
        // 4
        if (initialURI != null) {
          debugPrint("Initial URI received $initialURI");

          _initialURI = initialURI;

          update();
          return;
        } else {
          debugPrint("Null Initial URI received");
        }
      } on PlatformException {
        // 5
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) {
        // 6
        debugPrint('Malformed Initial URI received ==>> $err');
        update();
      }
    }
  }

  //LOCATION PERMISSION
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      openSettingsDialog(Get.overlayContext!).then((value) {
        getCurrentPosition();
      });
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        openSettingsDialog(Get.overlayContext!).then((value) {
          getCurrentPosition();
        });
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      openSettingsDialog(Get.overlayContext!).then((value) {
        getCurrentPosition();
      });
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      currentPosition = position;

      ///STORE CURRENT LAT LONG
      SharedPref.setString(PreferenceConstants.currentLAT, currentPosition!.latitude.toString());
      SharedPref.setString(PreferenceConstants.currentLONG, currentPosition!.longitude.toString());
      BindingSplash().dependencies();
      latitude = currentPosition!.latitude.toString();
      longitude = currentPosition!.longitude.toString();
      Get.find<ControllerCard>().onInit();
    }).catchError((e) {
      debugPrint("error usercard ==> $e");
    });
  }

  void _incomingLinkHandler() {
    // 1
    if (!kIsWeb) {
      // 2
      _streamSubscription = uriLinkStream.listen(
        (Uri? uri) {
          debugPrint('Received URI: $uri');

          _currentURI = uri;
          if (_currentURI != null) {
            BindingForgotPassword().dependencies();
            // Get.find<ControllerSplash>();

            Get.offNamed(Routes.createnewpass);
          }

          update();
          // 3
        },
        onError: (Object err) {
          debugPrint('Error occurred: $err');

          _currentURI = null;
          update();
        },
      );
    }
  }
}

Future<void> getToken() async {
  String fcmTokenData = await SharedPref.getString(PreferenceConstants.fcmToken);
  FirebaseCrashlytics.instance.log('This is a log example');
  fcmtoken = fcmTokenData;

  Future.delayed(
    const Duration(seconds: 2),
    () {
      try {
        FirebaseMessaging.instance.getToken().then((value) {
          String? strToken = value;
          // showSnackBar(Get.overlayContext, "FCM null ==> ${value}");
          if (strToken != null) {
            SharedPref.setString(PreferenceConstants.fcmToken, strToken);
            fcmtoken = strToken;
            // showSnackBar(
            //     Get.overlayContext, "FCM Splash ==> ${fcmtoken.toString()}");

            debugPrint("FCM ===> $strToken");
            // showSnackBar(Get.overlayContext, "FCM ===> $strToken");
          }
        });
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
        showSnackBar(Get.overlayContext, "FCM Splash ==> ${e}");
        // TODO
      }
    },
  );
  // if (fcmtoken == "") {

  // }
}
