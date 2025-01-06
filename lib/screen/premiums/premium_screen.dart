// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
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

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  List<ProductDetails> productList = [];
  int selectedIndex = 0;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  Future<void> _initialize() async {
    productList = await IapService.i.getProducts();
    // IapService.i.fetchStatus();
    selectedIndex = productList.length - 1;
    if (mounted) {
      setState(() {});
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
        }

        if (state is SubscriptionStatusState) {
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
        }

        if (state is ReceiptDetailsSuccessState) {
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
                      if (!alreadyItemPurchased)
                        ...productList
                            .asMap()
                            .map((index, e) {
                              String unit = "";
                              if (e is GooglePlayProductDetails) {
                                if (e
                                    .productDetails
                                    .subscriptionOfferDetails![
                                        e.subscriptionIndex!]
                                    .pricingPhases
                                    .isNotEmpty) {
                                  String period = e
                                      .productDetails
                                      .subscriptionOfferDetails![
                                          e.subscriptionIndex!]
                                      .pricingPhases
                                      .first
                                      .billingPeriod;
                                  unit = IapService.i.billingPeriod(period);
                                  if (unit.isEmpty) {
                                    return MapEntry(
                                        index, const SizedBox.shrink());
                                  }
                                }
                              }
                              if (e is AppStoreProductDetails) {
                                unit =
                                    "${e.skProduct.subscriptionPeriod?.numberOfUnits} ${e.skProduct.subscriptionPeriod?.unit.name}";
                              }

                              int? savePer;
                              if (index != 0) {
                                if (productList.length > 1) {
                                  double actualPrice =
                                      productList.first.rawPrice *
                                          convertUnitInMonth(unit);
                                  if (Platform.isIOS) {
                                    savePer = (100 -
                                            ((e.rawPrice * 100) / actualPrice))
                                        .ceil();
                                  }
                                }
                              }

                              return MapEntry(
                                  index,
                                  PurchaseOptions(
                                    month: unit,
                                    price: e.price,
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                    },
                                    isSelected: index == selectedIndex,
                                    savePercentage:
                                        savePer != null ? "$savePer" : null,
                                  ).paddingSymmetric(horizontal: 4.w));
                            })
                            .values
                            .toList(),
                    ],
                  ).paddingSymmetric(),
                ),
                Obx(
                  () => buildButton(
                    context: context,
                    showLoader: showLoader.value,
                    title: 'Start 14 days free trial',
                    bgColor: AppColors.appColor,
                    textColor: const Color(0xFFC1EACE),
                    onPressed: () async {
                      if (showLoader.value) {
                        return;
                      }
                      if (productList.isEmpty) {
                        showToast(
                          message: "Subscription plan not found",
                          isSuccess: false,
                        );
                        return;
                      }
                      try {
                        ProductDetails details = productList[selectedIndex];
                        await IapService.i.buyProduct(details);
                      } catch (e) {
                        log(e.toString());
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
