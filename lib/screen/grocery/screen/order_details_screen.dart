import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_state.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_order_details.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_bg.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class GroceryOrderDetailsScreen extends StatefulWidget {
  const GroceryOrderDetailsScreen({super.key, required this.mealMeOrderId});
  final String mealMeOrderId;
  @override
  State<GroceryOrderDetailsScreen> createState() =>
      _GroceryOrderDetailsScreenState();
}

class _GroceryOrderDetailsScreenState extends State<GroceryOrderDetailsScreen> {
  RestaurantBloc restaurantBloc = RestaurantBloc();
  List<OrderData> orderData = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    loading = true;
    Future.delayed(const Duration(seconds: 10)).then((value) {
      restaurantBloc
          .add(GetOrderDetailsEvent(mealMeOrderId: widget.mealMeOrderId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () => Future(() => false),
        child: BlocConsumer(
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
              : SizedBox(
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
                                    onTap: () =>
                                        Get.to(() => const RestaurantBGView()),
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
                                      '${orderData[0].deliveryTimeMin}-${orderData[0].deliveryTimeMax} min',
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
                          ).paddingOnly(top: 35.h, left: 20.w)
                        ],
                      ),
                      SizedBox(
                        width: double.infinity.w,
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.coral,
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
                                  AssetsUtils.teracottLoader,
                                  height: 24.h,
                                  width: 20.w,
                                ),
                              ),
                              Text(StringUtils.trackOrder,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                        color: const Color(0xFF010101),
                                      )),
                            ],
                          ),
                        ),
                      ).paddingSymmetric(horizontal: 20.w, vertical: 20.h),
                      orderData.isEmpty
                          ? Expanded(
                              child: Center(
                                child: Text(
                                  'Currently No Invoice Found',
                                  style: FontUtils.h18(
                                    fontColor: AppColors.darkGray,
                                    fontWeight: FWT.medium,
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(
                                    orderData.length,
                                    (index) => dashBoardCardView(
                                            child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              AssetsUtils.defaultLogo,
                                              height: 37.h,
                                              width: 37.w,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.67,
                                                  child: Text(
                                                    '${orderData[index].storeName}',
                                                    style: textTheme
                                                        .headlineSmall
                                                        ?.copyWith(
                                                            color: const Color(
                                                                0xFF010101)),
                                                  ),
                                                ),
                                                Text(
                                                  'Order ${orderData[index].orderId}',
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                          color: AppColors
                                                              .middleGray,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.2),
                                                ),
                                              ],
                                            ).paddingOnly(left: 10.w)
                                          ],
                                        ),
                                        commonRowData(
                                          title:
                                              '${orderData[index].quantity}x ${orderData[index].productName}',
                                          value:
                                              '\$ ${orderData[index].price! / 100}',
                                          textTheme: textTheme.bodyMedium!
                                              .copyWith(color: Colors.black),
                                          valueTextTheme: textTheme.bodyLarge!
                                              .copyWith(color: Colors.black),
                                        ),
                                        commonRowData(
                                          title: 'Total',
                                          value:
                                              '\$ ${orderData[index].price! / 100}',
                                          textTheme: textTheme.bodyLarge!
                                              .copyWith(
                                                  color: AppColors.darkGray),
                                          valueTextTheme: textTheme
                                              .headlineSmall!
                                              .copyWith(color: Colors.black),
                                        ),
                                      ],
                                    ).paddingAll(12))
                                        .paddingSymmetric(
                                            horizontal: 20.w, vertical: 5),
                                  ),
                                ),
                              ),
                            ),
                      const Text('Have any questions? Fill free to ask us!'),
                      buildButton(
                              context: context,
                              bgColor: AppColors.primaryBlue,
                              onPressed: () {},
                              textColor: AppColors.skyBlue,
                              title: 'Support')
                          .paddingOnly(
                              top: 8.h, bottom: 20.h, left: 20.w, right: 20.w),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget commonRowData({
    required String title,
    required String value,
    required TextStyle textTheme,
    required TextStyle valueTextTheme,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Text(title, style: textTheme)),
        Text(value, style: valueTextTheme),
      ],
    ).paddingSymmetric(vertical: 5);
  }
}
