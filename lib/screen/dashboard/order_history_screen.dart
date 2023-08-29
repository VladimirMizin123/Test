import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import '../../constant/asset_utils.dart';
import '../../constant/string_utils.dart';
import '../../widget/app_widget.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final routeName = '/order-history';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          StringUtils.orderHistory,
          style: textTheme.displayMedium?.copyWith(color: Color(0xFF010101)),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: size.height.h,
        width: size.width.w,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringUtils.orderProgressText,
              style: textTheme.headlineSmall
                  ?.copyWith(color: const Color(0xFF010101), fontSize: 20.sp),
            ).paddingOnly(top: 8.h),
            Container(
              width: double.infinity.w,
              padding: const EdgeInsets.all(15),
              margin: EdgeInsets.only(top: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 76, 99, 0.08),
                    spreadRadius: 0.5,
                    blurRadius: 0.5,
                    offset: Offset(0, 0),
                  )
                ],
                border: Border.all(
                    color: AppColors.terracotta,
                    width: 1.w,
                    style: BorderStyle.solid),
              ),
              child: orderInfoView(
                textTheme: textTheme,
                image: AssetsUtils.storeImage,
                itemTitle: StringUtils.storeText,
                itemSubTitle: StringUtils.storeAddress,
                orderType: 'Delivery',
                timeType: 'Delivery time: ',
                time: '10:00-10:20',
              ),
            ),
            Text(
              StringUtils.recentOrders,
              style: textTheme.headlineSmall
                  ?.copyWith(color: const Color(0xFF010101), fontSize: 20.sp),
            ).paddingOnly(top: 15.h),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return dashBoardCardView(
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    child: orderInfoView(
                      textTheme: textTheme,
                      image: AssetsUtils.storeImage,
                      itemTitle: StringUtils.restaurantName,
                      itemSubTitle: StringUtils.storeAddress,
                      orderType: 'Delivery',
                      timeType: 'Delivery time: ',
                      time: '10:00-10:20',
                    ).paddingAll(10),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget orderInfoView({
    required TextTheme textTheme,
    required String image,
    required String itemTitle,
    required String itemSubTitle,
    required String orderType,
    required String timeType,
    required String time,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              image,
              height: 40.h,
              width: 40.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemTitle,
                  style: textTheme.headlineSmall
                      ?.copyWith(color: const Color(0xFF010101)),
                ),
                Text(
                  itemSubTitle,
                  style: textTheme.bodySmall?.copyWith(
                      color: AppColors.middleGray,
                      fontWeight: FontWeight.w400,
                      height: 1.2),
                ),
              ],
            ).paddingOnly(left: 10.w)
          ],
        ),
        Divider(
          height: 3.h,
          color: AppColors.darkGray,
        ).paddingOnly(top: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Order type: ',
                        style: textTheme.bodySmall!.copyWith(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2),
                      ),
                      TextSpan(
                        text: orderType,
                        style: textTheme.bodySmall!.copyWith(
                            color: Colors.black,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: timeType,
                        style: textTheme.bodySmall!.copyWith(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2),
                      ),
                      TextSpan(
                        text: time,
                        style: textTheme.bodySmall!.copyWith(
                            color: Colors.black,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Details ',
                  style: textTheme.bodyMedium
                      ?.copyWith(color: AppColors.terracotta, fontSize: 18.sp),
                ),
                Icon(Icons.arrow_forward_ios,
                    color: AppColors.terracotta, size: 20.sp)
              ],
            ),
          ],
        ).paddingOnly(top: 10.h),
      ],
    );
  }
}
