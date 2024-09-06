// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/subscription/subscription_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';

class IapService {
  static final i = IapService._();
  IapService._();

  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription _subscription;
  List<PurchaseDetails> purchaseList = [];

  SubscriptionBloc bloc = SubscriptionBloc();

  void initialize() {
    _subscription = _iap.purchaseStream.listen(_handleInAppPurchase);
  }

  void dispose() {
    _subscription.cancel();
  }

  void fetchStatus() {
    bloc.add(FetchSubscriptionEvent());
  }

  void _handleInAppPurchase(List<PurchaseDetails> purchase) {
    purchaseList = purchase;
    for (int i = 0; i < purchase.length; i++) {
      String purchaseToken = "";
      if (Platform.isAndroid) {
        dynamic data =
            purchase[i].verificationData.localVerificationData.isNotEmpty
                ? jsonDecode(purchase[i].verificationData.localVerificationData)
                : null;
        purchaseToken = data?["purchaseToken"] ?? "";
      } else {
        purchaseToken = purchase[i].verificationData.localVerificationData;
      }
      Map<String, dynamic> reqData = {
        "pendingCompletePurchase": purchase[i].pendingCompletePurchase,
        "productID": purchase[i].productID,
        "purchaseID":
            Platform.isIOS ? purchase[i].purchaseID : "com.gymeats.app.mobile",
        "status": purchase[i].status.name,
        "email": PreferenceUtils.getString(prefUserEmail),
        "transactionDate": purchase[i].transactionDate,
        "verificationData": {
          "localVerificationData": purchaseToken,
          "serverVerificationData":
              purchase[i].verificationData.serverVerificationData,
        },
        "source": purchase[i].verificationData.source,
      };
      log("Req Data : $reqData");
      if (purchase[i].status == PurchaseStatus.purchased) {
        _iap.completePurchase(purchase[i]);
        if (!PreferenceUtils.getBool(subscriptionStatus)) {
          bloc.add(AddReceiptDetailsEvent(requestData: reqData));
        }
      } else if (purchase[i].status == PurchaseStatus.restored) {
        log("Restore Item : ${purchase[i].productID}");
        fetchStatus();
      }
    }
  }

  Future<List<ProductDetails>> getProducts() async {
    if (await _iap.isAvailable()) {
      Set<String> ids = Platform.isIOS
          ? {
              "com.gymeats.mobile.1_month",
              "com.gymeats.mobile.6_month",
              "com.gymeats.mobile.12_month",
            }
          : {
              "com.gymeats.mobile",
            };

      ProductDetailsResponse response = await _iap.queryProductDetails(ids);
      log(response.productDetails.toString());

      return response.productDetails;
    } else {
      return [];
    }
  }

  Future<bool> buyProduct(ProductDetails prod) async {
    if (Platform.isIOS) {
      var transactions = await SKPaymentQueueWrapper().transactions();
      for (var skPaymentTransactionWrapper in transactions) {
        SKPaymentQueueWrapper().finishTransaction(skPaymentTransactionWrapper);
      }
    }
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void updateProduct(ProductDetails productDetails,
      {GooglePlayPurchaseDetails? oldPurchaseDetails}) {
    if (Platform.isAndroid && oldPurchaseDetails != null) {
      PurchaseParam purchaseParam = GooglePlayPurchaseParam(
        productDetails: productDetails,
        changeSubscriptionParam: ChangeSubscriptionParam(
          oldPurchaseDetails: oldPurchaseDetails,
          prorationMode: ProrationMode.immediateWithTimeProration,
        ),
      );
      InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  Future<void> restorePurchases() async {
    await InAppPurchase.instance.restorePurchases();
  }

  static Future<bool> isSubscriptionRunning(
    String sku, [
    Duration duration = const Duration(days: 30),
    Duration grace = const Duration(days: 0),
  ]) async {
    if (Platform.isIOS) {
      for (PurchaseDetails purchase in i.purchaseList) {
        if (purchase.status == PurchaseStatus.purchased) {
          Duration difference = DateTime.now()
              .difference(DateTime.tryParse(purchase.transactionDate ?? "")!);

          if (difference.inMinutes <= (duration + grace).inMinutes &&
              purchase.productID == sku) return true;
        }
      }
      return false;
    } else if (Platform.isAndroid) {
      for (PurchaseDetails purchase in i.purchaseList) {
        if (purchase.status == PurchaseStatus.purchased) {
          if (purchase.productID == sku) return true;
        }
      }
      return false;
    }

    throw PlatformException(
        code: Platform.operatingSystem, message: "platform not supported");
  }

  String billingPeriod(String period) {
    switch (period) {
      case "P1W":
        return "1 Week";
      case "P1M":
        return "1 Month";
      case "P6M":
        return "6 Month";
      case "P1Y":
        return "12 Month";
      default:
        return "";
    }
  }
}
