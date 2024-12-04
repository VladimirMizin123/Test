import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/models/get_order_invoice_list_model.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_bloc.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_event.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_state.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_state.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_order_details.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/order_bill_widget.dart';
import 'package:livechatt/livechatt.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant/asset_utils.dart';
import '../../constant/color_utils.dart';
import '../../constant/string_utils.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.data});

  final OrderedItem data;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final routeName = '/OrderDetailsScreen';
  bool isTap = true;
  AccountBloc accountBloc = AccountBloc();
  RestaurantBloc restaurantBloc = RestaurantBloc();
  String fullName = '';
  OrderData? orderData;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      accountBloc.add(GetProfileDetailsEvent());
      restaurantBloc
          .add(GetOrderDetailsEvent(mealMeOrderId: widget.data.orderId ?? ""));
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer(
        bloc: restaurantBloc,
        listener: (context, state) {
          if (state is GetOrderLoadingState) {
            loading = true;
          }
          if (state is GetOrderSuccessState) {
            orderData = state.data;
            loading = false;
          }
          if (state is GetOrderErrorState) {
            loading = false;
          }
        },
        builder: (context, state) => loading == true
            ? const AppCenterLoader()
            : SafeArea(
                child: SizedBox(
                  height: size.height.h,
                  width: size.width.w,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            AssetsUtils.orderDetailHeader,
                            width: double.infinity.w,
                            opacity: const AlwaysStoppedAnimation(0.95),
                            fit: BoxFit.cover,
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => Get.back(),
                                    child: Container(
                                      height: 40.h,
                                      width: 40.w,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: const Icon(
                                        Icons.arrow_back_ios,
                                        size: 18,
                                        color: AppColors.darkGray,
                                      ).paddingOnly(left: 5.w),
                                    ),
                                  ),
                                  Image.asset(
                                    AssetsUtils.gymEatsSpoon,
                                    height: 40.h,
                                    width: 100.w,
                                    color: Colors.white,
                                  ).paddingOnly(right: 60.w),
                                  const SizedBox()
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 76, 99, 0.08),
                                      blurRadius: 3,
                                      offset: Offset(0, 0),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24.w, vertical: 12.h),
                                child: Column(
                                  children: [
                                    Text(
                                      StringUtils.orderDetails,
                                      style: textTheme.bodyLarge?.copyWith(
                                          color: const Color(0xFF010101)),
                                    ),
                                    Text(
                                      getMaxValue(),
                                      style: textTheme.displayLarge?.copyWith(
                                          color: AppColors.darkGray,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: -0.8),
                                    ),
                                    Text(
                                      StringUtils.estimatedTimeText,
                                      style: textTheme.bodySmall?.copyWith(
                                          color: AppColors.middleGray,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ).paddingOnly(top: 10.h, left: 20.w)
                        ],
                      ),
                      SizedBox(
                        width: double.infinity.w,
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: () {
                            launchUrlForTracking();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isTap ? AppColors.coral : AppColors.mint,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 10.0, bottom: 4),
                                child: SvgPicture.asset(
                                  isTap
                                      ? AssetsUtils.teracottLoader
                                      : AssetsUtils.greenLoader,
                                  height: 24.h,
                                  width: 20.w,
                                ),
                              ),
                              Text(StringUtils.trackOrder,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                        color: isTap
                                            ? const Color(0xFF010101)
                                            : AppColors.greenPressed,
                                      )),
                            ],
                          ),
                        ),
                      ).paddingOnly(
                          left: 20.w, right: 20.w, top: 20.w, bottom: 15),
                      Expanded(
                        child: SingleChildScrollView(
                            child: dashBoardCardView(
                                child: Column(
                          children: [
                            OrderBillWidget(orderData: orderData),
                          ],
                        )).paddingOnly(left: 20.w, right: 20.w, bottom: 5.w)),
                      ),
                      const Text('Have any questions? Fill free to ask us!'),
                      BlocConsumer(
                        bloc: accountBloc,
                        listener: (context, state) {
                          if (state is GetProfileDetailsSuccessState) {
                            fullName =
                                '${state.profileDetails?.firstName} ${state.profileDetails?.lastName}';
                            setState(() {});
                          }
                        },
                        builder: (context, state) => buildButton(
                          context: context,
                          bgColor: AppColors.primaryBlue,
                          onPressed: () async {
                            Livechat.beginChat(
                              Constant.i.chatId,
                              visitorEmail:
                                  PreferenceUtils.getString(prefUserEmail),
                              visitorName:
                                  PreferenceUtils.getString(prefUserName),
                              customParams: <String, String>{
                                'org': PreferenceUtils.getString(prefUserName),
                                'position': 'user'
                              },
                            );
                          },
                          textColor: AppColors.skyBlue,
                          title: 'Support',
                        ).paddingOnly(
                            top: 8.h, bottom: 20.h, left: 20.w, right: 20.w),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  getMaxValue() {
    int maxIndex = (widget.data.items ?? [])
        .map<int>((jsonObject) => jsonObject.deliveryTimeMax as int)
        .reduce((max, current) => max > current ? max : current);

    int minIndex = 0;
    for (var data in widget.data.items!) {
      if (data.deliveryTimeMax == maxIndex) {
        minIndex = (data.deliveryTimeMin ?? 0).toInt();
      }
    }

    return "$minIndex-$maxIndex min";
  }

  launchUrlForTracking() async {
    try {
      await launchUrl(
        Uri.parse(
          widget.data.trackLink ?? "",
        ),
      );
    } catch (e) {
      print("PAYMENT LINK:- $e");
    }
  }
}
