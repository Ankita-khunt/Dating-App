import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dating_app/src/screen/dashboard/my_profile/boost/my_boost/bindng_my_boost.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/boost/my_boost/controller_my_boost.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/swipe/binding_swipe.dart';
import 'package:dating_app/src/screen/dashboard/my_profile/swipe/controller_swipe.dart';
import 'package:dating_app/src/screen/subscriptions/binding_subscription.dart';
import 'package:dating_app/src/screen/subscriptions/controller_subscription.dart';
import 'package:dating_app/src/services/repository/subscriptions_purchase_webservice/subscription_plan_webservice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

import '../../imports.dart';

PurchasedItem? currentPurchasedItem;

class PaymentService {
  /// We want singelton object of ``PaymentService`` so create private constructor
  ///
  /// Use PaymentService as ``PaymentService.instance``
  // PaymentService()._internal();

  static final PaymentService instance = PaymentService.instance;

  late StreamSubscription<ConnectionResult> connectionSubscription;

  /// To listen the status of the purchase made inside or outside of the app (App Store / Play Store)
  ///
  /// If status is not error then app will be notied by this stream
  late StreamSubscription<PurchasedItem?> purchaseUpdatedSubscription;

  /// To listen the errors of the purchase
  late StreamSubscription<PurchaseResult?> purchaseErrorSubscription;

  /// List of product ids you want to fetch
  List<String> productIds = [];

  /// All available products will be store in this list
  List<IAPItem>? products;

  /// All past purchases will be store in this list
  List<PurchasedItem> _pastPurchases = [];

  /// view of the app will subscribe to this to get notified
  /// when premium status of the user changes
  final ObserverList<Function> _proStatusChangedListeners = ObserverList<Function>();

  /// view of the app will subscribe to this to get errors of the purchase
  final ObserverList<Function(String)> _errorListeners = ObserverList<Function(String)>();

  /// logged in user's premium status
  bool _isProUser = false;

  bool get isProUser => _isProUser;

  addToProStatusChangedListeners(Function callback) {
    _proStatusChangedListeners.add(callback);
  }

  /// view can cancel to _proStatusChangedListeners using this method
  removeFromProStatusChangedListeners(Function callback) {
    _proStatusChangedListeners.remove(callback);
  }

  /// view can subscribe to _errorListeners using this method
  // addToErrorListeners(Function callback) {
  //   _errorListeners.add(callback);
  // }

  // /// view can cancel to _errorListeners using this method
  // removeFromErrorListeners(Function callback) {
  //   _errorListeners.remove(callback);
  // }

  /// Call this method to notify all the subsctibers of _proStatusChangedListeners
  void _callProStatusChangedListeners() {
    for (var callback in _proStatusChangedListeners) {
      callback();
    }
  }

  /// Call this method to notify all the subsctibers of _errorListeners
  void _callErrorListeners(String error) {
    hideLoader();
    for (var callback in _errorListeners) {
      callback(error);
    }
  }

  //Purchase Plan API
  Future<ResponseModel?> check_user_status() async {
    showLoader();

    ResponseModel? response;

    response = await PurchaseSubscriptionRepository().check_user_deactivate();
    return response;
  }

  void initConnection(String selectedProductID,
      {bool? isFromBoost = false,
      isFromSubscription = false,
      isFromSwipe = false,
      isFromSetUpProfile = false,
      isFRomChatScreen = false}) async {
    check_user_status().then((response) async {
      if (int.parse(response!.code!.toString()) == CODE_SUCCESS_CODE) {
        await FlutterInappPurchase.instance.initialize();
        currentPurchasedItem = null;
        connectionSubscription = FlutterInappPurchase.connectionUpdated.listen((connected) {
          if (kDebugMode) {
            print(connected.connected);
          }
        });
        try {
          String msg = await FlutterInappPurchase.instance.consumeAll();
          if (kDebugMode) {
            print('consumeAllItems: >>>>2 $msg');
          }
        } catch (err) {
          if (kDebugMode) {
            print('consumeAllItems error: $err');
          }
        }

        purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen(
          (event) {
            _handlePurchaseUpdate(event,
                isFromBoost: isFromBoost,
                isFromSubscription: isFromSubscription,
                isFromSwipe: isFromSwipe,
                isFromSetUpProfile: isFromSetUpProfile,
                isFromChatScreen: isFRomChatScreen);
          },
        );

        purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen(_handlePurchaseError);

        _getItems(selectedProductID,
            isFromBoost: isFromBoost, isFromSubscription: isFromSubscription, isFromSwipe: isFromSwipe);
        _getPastPurchases();
      } else {
        hideLoader();

        showDialogBox(Get.overlayContext!, toLabelValue(response.message!));
      }
    });
  }

  /// call when user close the app
  void dispose() {
    connectionSubscription.cancel();
    purchaseErrorSubscription.cancel();
    purchaseUpdatedSubscription.cancel();
  }

  void _handlePurchaseError(PurchaseResult? purchaseError) {
    hideLoader();
    _callErrorListeners(purchaseError?.message ?? '');
  }

  _handlePurchaseUpdate(PurchasedItem? productItem,
      {bool? isFromBoost, isFromSubscription, isFromSwipe, isFromSetUpProfile, isFromChatScreen}) async {
    if (Platform.isAndroid) {
      if (productItem!.purchaseStateAndroid == PurchaseState.purchased) {
        hideLoader();
        if (currentPurchasedItem == null) {
          currentPurchasedItem = productItem;

          await _verifyAndFinishTransaction(productItem,
              isFromBoost: isFromBoost,
              isFromSubscription: isFromSubscription,
              isFromSwipe: isFromSwipe,
              isFromSetUpProfile: isFromSetUpProfile,
              isFromChat: isFromChatScreen);
        }
      } else if (productItem.purchaseStateAndroid == PurchaseState.pending) {
        FlutterInappPurchase.instance.finishTransaction(productItem);

        if (kDebugMode) {
          print("Purchasing Android===");
        }
      } else {
        if (kDebugMode) {
          print("Error Android===");
        }
      }
    } else {
      await _handlePurchaseUpdateIOS(productItem,
          isFromBoost: isFromBoost,
          isFromSubscription: isFromSubscription,
          isFromSwipe: isFromSwipe,
          isFromSetUpProfile: isFromSetUpProfile,
          isFromChatScreen: isFromChatScreen);
    }
  }

  Future<void> _handlePurchaseUpdateIOS(PurchasedItem? purchasedItem,
      {bool? isFromBoost, isFromSwipe, isFromSubscription, isFromSetUpProfile, isFromChatScreen}) async {
    if (kDebugMode) {
      print(purchasedItem);
    }
    hideLoader();
    switch (purchasedItem!.transactionStateIOS) {
      case TransactionState.deferred:
        // Edit: This was a bug that was pointed out here : https://github.com/dooboolab/flutter_inapp_purchase/issues/234
        // FlutterInappPurchase.instance.finishTransaction(purchasedItem);

        break;
      case TransactionState.failed:
        _callErrorListeners("Transaction Failed");
        FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      case TransactionState.purchased:
        hideLoader();
        if (currentPurchasedItem == null) {
          currentPurchasedItem = purchasedItem;

          await _verifyAndFinishTransaction(purchasedItem,
              isFromBoost: isFromBoost,
              isFromSubscription: isFromSubscription,
              isFromSwipe: isFromSwipe,
              isFromSetUpProfile: isFromSetUpProfile,
              isFromChat: isFromChatScreen);
        }

        break;
      case TransactionState.purchasing:
        if (kDebugMode) {
          print('purchassing ......');
        }
        break;
      case TransactionState.restored:
        FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      default:
    }
  }

  _verifyAndFinishTransaction(PurchasedItem purchasedItem,
      {bool? isFromBoost, isFromSwipe, isFromSubscription, isFromSetUpProfile, isFromChat}) async {
    bool isValid = false;
    try {
      if (kDebugMode) {
        print("Purchase success =====> $purchasedItem");
      }
      Map<String, String> receipt = {
        'receipt-data': purchasedItem.transactionReceipt!,
        'password': 'c60ce872c5ac4e63a08ac8df65f334ab'
      };

      FlutterInappPurchase.instance.finishTransaction(purchasedItem);

      //Get From which screen subscription is
      bool isFromChatScreen = await SharedPref.getBool(PreferenceConstants.isFromChat);
      bool isFromSubscriptionScreen = await SharedPref.getBool(PreferenceConstants.isFromSubscription);
      bool isFromBoostScreen = await SharedPref.getBool(PreferenceConstants.isFromBoost);
      bool isFromSwipeScreen = await SharedPref.getBool(PreferenceConstants.isFromSwipe);
      bool isFromSetUpProfileScreen = await SharedPref.getBool(PreferenceConstants.isFromSetupProfile);
//
      if (isFromBoostScreen == true) {
        BindingMyBoost().dependencies();
        Get.find<ControllerMyBoost>().boostpurchasePlan(
          purchasedItem.transactionReceipt.toString(),
          purchasedItem.transactionId,
        );
      } else if (isFromSwipeScreen) {
        BindingMySwipe().dependencies();
        Get.find<ControllerMySwipe>().swipepurchasePlan(
          purchasedItem.transactionReceipt.toString(),
          purchasedItem.transactionId,
        );
      } else if (isFromSetUpProfileScreen) {
        BindingSubscription().dependencies();
        Get.find<ControllerSubscription>()
            .purchasePlan(purchasedItem.transactionReceipt.toString(), purchasedItem.transactionId, "",
                isFromSetUpProfile, isFromChatScreen)
            .then((value) {});
      } else {
        BindingSubscription().dependencies();
        Get.find<ControllerSubscription>().purchasePlan(purchasedItem.transactionReceipt.toString(),
            purchasedItem.transactionId, "", isFromSubscriptionScreen, isFromChatScreen);
      }
    } on Exception {
      _callErrorListeners("Something went wrong");
      return;
    }
  }

  Future<void> _getItems(String productID,
      {bool? isFromBoost = false, isFromSwipe = false, isFromSubscription = false}) async {
    if (Platform.isAndroid) {
      List<IAPItem> items = await FlutterInappPurchase.instance.getProducts([productID]).onError((error, stackTrace) {
        return hideLoader();
      }).catchError((err) {
        hideLoader();
      });
      if (kDebugMode) {
        print("inAPP products ===.> ${items.first}");
      }
      products = [];
      if (items.isEmpty) {
        hideLoader();
      }
      for (var item in items) {
        if (item.productId == productID) {
          products!.add(item);

          buyProduct(item);
        }
      }
    } else {
      List<IAPItem> items =
          await FlutterInappPurchase.instance.getSubscriptions([productID]).onError((error, stackTrace) {
        return hideLoader();
      }).catchError((err) {
        hideLoader();
      });
      if (kDebugMode) {
        print("inAPP products ===.> ${items.first}");
      }
      products = [];
      if (items.length == 0) {
        hideLoader();
      }
      for (var item in items) {
        if (item.productId == productID) {
          products!.add(item);

          buyProduct(item);
        }
      }
    }
  }

  void _getPastPurchases() async {
    // remove this if you want to restore past purchases in iOS

    List<PurchasedItem>? purchasedItems = await FlutterInappPurchase.instance.getAvailablePurchases();

    for (var purchasedItem in purchasedItems!) {
      bool isValid = false;

      if (Platform.isAndroid) {
        Map map = json.decode(purchasedItem.transactionReceipt!);
        // if your app missed finishTransaction due to network or crash issue
        // finish transactins
        if (!map['acknowledged']) {
          if (isValid) {
            FlutterInappPurchase.instance.finishTransaction(purchasedItem);
            _isProUser = true;
            _callProStatusChangedListeners();
          }
        } else {
          _isProUser = true;
          _callProStatusChangedListeners();
        }
      }
    }

    _pastPurchases = [];
    _pastPurchases.addAll(purchasedItems);
  }

  Future<void> buyProduct(IAPItem item) async {
    try {
      if (Platform.isAndroid) {
        await FlutterInappPurchase.instance.requestPurchase(item.productId!);
      } else {
        await FlutterInappPurchase.instance.requestSubscription(item.productId!);
      }
    } catch (error) {
      if (kDebugMode) {
        print('buyProduct =======>  $error');
      }
    }
  }
}
