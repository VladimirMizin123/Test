// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/subscription/subscription_bloc.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/models/sign_up_data_navigate_model.dart';
import 'package:gymeats_mobile/screen/account_screen/about/pivacy/privacy_policy_screen.dart';
import 'package:gymeats_mobile/screen/account_screen/about/terms_conditions_screen/terms_conditions_screens.dart';
import 'package:gymeats_mobile/screen/appmanager/app_manager_screen.dart';
import 'package:gymeats_mobile/screen/premiums/puchase_options_widget.dart';
import 'package:gymeats_mobile/service/in_app_purchase_service.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';
import 'package:http/http.dart' as http;

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  List<ProductDetails> productList = [];
  int selectedIndex = 0;
  late final String? accessToken;
  Timer? _subscriptionCheckTimer;
  bool _hasRedirected = false;

  @override
  void initState() {
    _initialize();
    super.initState();
    accessToken = Get.parameters['access_token'];
    print('[Params] access_token present: ${accessToken != null && accessToken!.isNotEmpty}');
    final alreadyActive = PreferenceUtils.getBool(subscriptionStatus) == true;

    if (!alreadyActive) {
      _checkSubscriptionStatus();
      _subscriptionCheckTimer = Timer.periodic(
        const Duration(seconds: 15),
        (_) => _checkSubscriptionStatus(),
      );
    }
  }

  Future<void> _initialize() async {
    try {
      print('[IAP] Fetching products…');
      productList = await IapService.i.getProducts();
      print('[IAP] getProducts returned ${productList.length} items');

      for (final p in productList) {
        print('[IAP] Product: {id: ${p.id}, title: ${p.title}, price: ${p.price}, '
            'rawPrice: ${p.rawPrice}, currency: ${p.currencyCode}, type: ${p.runtimeType}}');

        if (p is GooglePlayProductDetails) {
          final offers = p.productDetails.subscriptionOfferDetails;
          print('[IAP][Android] offers count: ${offers?.length ?? 0}');
          if (offers != null) {
            for (var i = 0; i < offers.length; i++) {
              final phases = offers[i].pricingPhases; // List<PricingPhaseWrapper>
              print('[IAP][Android] offer #$i phases: ${phases.length}');
              for (var j = 0; j < phases.length; j++) {
                final ph = phases[j];
                print('[IAP][Android]  phase #$j '
                    'formattedPrice: ${ph.formattedPrice}, '
                    'billingPeriod: ${ph.billingPeriod}, '
                    'recurrenceMode: ${ph.recurrenceMode}, '
                    'billingCycleCount: ${ph.billingCycleCount}');
              }
            }
          }
        } else if (p is AppStoreProductDetails) {
          final period = p.skProduct.subscriptionPeriod;
          print('[IAP][iOS] period: ${period?.numberOfUnits} ${period?.unit.name}');
        }
      }

      selectedIndex = productList.isEmpty ? 0 : (productList.length - 1);
    } catch (e, st) {
      print('[IAP] Exception during getProducts: $e');
      print('[IAP] StackTrace: $st');
    }

    if (mounted) {
      setState(() {});
    }
  }

  String get userEmail => PreferenceUtils.getString(prefUserEmail);

  Future<void> _checkSubscriptionStatus() async {
    try {
      if (PreferenceUtils.getBool(subscriptionStatus) == true) {
        _subscriptionCheckTimer?.cancel();
        return;
      }

      final token = PreferenceUtils.getString(prefToken);
      final apiURL = '${ApiUrls.getSubscriptionStatus}/$userEmail';
      print('[SUBS] Checking subscription: $apiURL');

      Map<String, String> headers;
      if (token.isEmpty) {
        headers = {
          'accept': '*/*',
          'Api_Key': ApiUrls.apiKey,
        };
      } else {
        headers = {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
          'Api_Key': ApiUrls.apiKey,
        };
      }

      final response = await http.get(
        Uri.parse(apiURL),
        headers: headers,
      );

      print('[SUBS] Response: ${response.statusCode} ${response.reasonPhrase}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        final status = json['data']?.toString();
        print('[SUBS] Parsed status: $status');

        if (status?.toLowerCase() == 'active' && !_hasRedirected) {
          _hasRedirected = true;

          await PreferenceUtils.setBool(subscriptionStatus, true);

          _subscriptionCheckTimer?.cancel();

          final genderString = PreferenceUtils.getString('gender');
          Get.toNamed(
            '/RandomLoginScreen',
            arguments: genderString.toString().capitalizeFirst,
          );
        }
      } else {
        print('[SUBS] Error body: ${response.body}');
      }
    } catch (e, st) {
      print('[SUBS] Exception checking subscription: $e');
      print('[SUBS] StackTrace: $st');
    }
  }

  bool alreadyItemPurchased = false;
  RxBool showLoader = false.obs;

  UserSignUpDataModel userSignUpDataModel =
      Get.arguments ?? UserSignUpDataModel();

  @override
  Widget build(BuildContext context) {
    bool fromDashboard = Get.parameters['fromDashboard'] == "true";
    productList.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));

    final TextTheme textTheme = Theme.of(context).textTheme;

    // Диагностика на каждый билд
    print('[UI] fromDashboard=$fromDashboard, alreadyItemPurchased=$alreadyItemPurchased, '
        'products=${productList.length}, selectedIndex=$selectedIndex');
    if (productList.isEmpty) {
      print('[UI] productList is EMPTY => plan tile will NOT render (only the button is visible). '
          'Check Play/App Store config or IapService.i.getProducts().');
    } else {
      final safeIndex = (selectedIndex >= 0 && selectedIndex < productList.length)
          ? selectedIndex
          : 0;
      print('[UI] Rendering BASIC plan using product id=${productList[safeIndex].id}, '
          'price=${productList[safeIndex].price}');
    }

    return BlocConsumer<SubscriptionBloc, SubscriptionState>(
      bloc: IapService.i.bloc,
      listener: (context, state) {
        if (state is SubscriptionStatusErrorState) {
          if (state.message.isNotEmpty) {
            showToast(message: state.message, isSuccess: false);
          }
          if (IapService.i.isRestoreCheck) {
            IapService.i.isRestoreCheck = false;
          }
          print('[SUBS][Bloc] SubscriptionStatusErrorState: ${state.message}');
        }

        if (state is SubscriptionStatusState) {
          print('[SUBS][Bloc] SubscriptionStatusState: ${state.status?.data}');
          if (state.status?.data == "Active" && IapService.i.isRestoreCheck) {
            IapService.i.isRestoreCheck = false;
            showToast(message: "Item Restore Successfully !", isSuccess: true);
            if (!fromDashboard) {
              if (Get.currentRoute.contains("/PremiumScreen")) {
                Get.toNamed('/BuildMyProfileScreen',
                    arguments: userSignUpDataModel);
              }
            } else {
              Get.offAll(() => const AppManagerScreen(selectIndex: 2));
            }
          }
        }

        if (state is ReceiptDetailsLoadingState) {
          showLoader.value = state.isLoading;
          print('[IAP] ReceiptDetailsLoadingState: isLoading=${state.isLoading}');
        }

        if (state is ReceiptDetailsSuccessState) {
          print('[IAP] ReceiptDetailsSuccessState: purchase OK');
          showToast(message: "Item Purchased Successfully !", isSuccess: true);
          if (!fromDashboard) {
            if (Get.currentRoute.contains("/PremiumScreen")) {
              Get.toNamed('/BuildMyProfileScreen',
                  arguments: userSignUpDataModel);
            }
          } else {
            Get.offAll(() => const AppManagerScreen(selectIndex: 2));
          }
        }
      },
      builder: (context, state) => Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0XFFECECED).withOpacity(0.5),
            image: const DecorationImage(
              image: AssetImage(AssetsUtils.premiumScreenBG),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            top: true,
            child: Column(
              children: [
                if (!fromDashboard)
                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.chevron_left,
                        color: const Color(0XFF373737),
                        size: 36.sp,
                        fill: 0,
                      ),
                    ).paddingOnly(left: 10.w),
                  )
                else
                  const SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(top: 8.h, left: 20.w, right: 20.w),
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.80),
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'No more guessing! With GYM EATS I’m no longer eating ignorant–I know what foods are best for me and it shows!',
                        style: textTheme.bodyLarge!.copyWith(
                          color: const Color(0xFFCE6B53),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            AssetsUtils.gymEatsSpoon,
                            color: AppColors.letsEatButton,
                            height: 22.h,
                            width: 64.w,
                          ),
                          Text(
                            'Chandler - 27 lbs',
                            style: textTheme.bodyLarge!.copyWith(
                              color: const Color(0xFFCE6B53),
                            ),
                          )
                        ],
                      ).paddingOnly(top: 16.h),
                    ],
                  ),
                ),
                const Spacer(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!alreadyItemPurchased && productList.isNotEmpty)
                        (() {
                          final safeIndex = (selectedIndex >= 0 && selectedIndex < productList.length) ? selectedIndex : 0;
                          final e = productList[safeIndex];
                          return PurchaseOptions(
                            month: 'Basic', // single Basic plan
                            price: e.price, // show its price
                            onTap: () {
                              setState(() {
                                selectedIndex = safeIndex;
                              });
                              print('[UI] Basic plan tapped. Using product id=${e.id}, price=${e.price}');
                            },
                            isSelected: true,
                            savePercentage: null,
                          ).paddingSymmetric(horizontal: 4.w);
                        })(),
                    ],
                  ).paddingSymmetric(),
                ),
                Obx(
                  () => buildButton(
                    context: context,
                    showLoader: showLoader.value,
                    title: 'Start 7 days free trial',
                    bgColor: AppColors.appColor,
                    textColor: const Color(0xFFC1EACE),
                    onPressed: () async {
                      if (showLoader.value) return;

                      if (accessToken == null || accessToken!.isEmpty) {
                        showToast(message: "Access token is missing", isSuccess: false);
                        print('[BTN] Access token is missing');
                        return;
                      }

                      final url = 'https://gymeats.azurewebsites.net/manage-subscription?access_token=$accessToken';
                      print('[BTN] Opening URL: $url');

                      if (await canLaunchUrl(Uri.parse(url))) {
                        final ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                        print('[BTN] launchUrl result: $ok');
                      } else {
                        showToast(message: "Cannot open browser", isSuccess: false);
                        print('[BTN] canLaunchUrl=false');
                      }
                    },
                  ).paddingOnly(
                      bottom: 8.h, top: 23.h, right: 20.w, left: 20.w),
                ),
                Text('No commitment. Cancel any time.',
                    style: textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    )),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Privacy Policy',
                        style: textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w800),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PolicyScreen(),
                              ),
                            );
                          },
                      ),
                      TextSpan(
                        text: '      Restore',
                        style: textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w800),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            IapService.i.isRestoreCheck = true;
                            await IapService.i.restorePurchases();
                            print('[IAP] Restore pressed');
                          },
                      ),
                      TextSpan(
                        text: '      Terms of Use',
                        style: textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w800),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ConditionScreen(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ).paddingSymmetric(vertical: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int convertUnitInMonth(String unit) {
    try {
      List<String> unitList = unit.split(" ");
      if (unitList.length > 1) {
        switch (unitList[1].toLowerCase()) {
          case "year":
            return (int.tryParse(unitList[0]) ?? 0) * 12;
          case "month":
            return int.tryParse(unitList[0]) ?? 0;
        }
      }
      return 1;
    } catch (e) {
      return 1;
    }
  }
}
