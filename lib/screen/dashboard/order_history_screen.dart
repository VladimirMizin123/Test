import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constant/app_colors.dart';
import '../../constant/app_string.dart';

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
          AppStrings.orderHistory,
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
              AppStrings.orderProgressText,
              style:
                  textTheme.headlineSmall?.copyWith(color: Color(0xFF010101)),
            ).paddingOnly(top: 8.h),
            Container(
              width: double.infinity.w,
              padding: const EdgeInsets.all(12),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Image.asset(
                      AppStrings.storeImage,
                      height: 40.h,
                      width: 40.w,
                    ),
                    title: Text(
                      AppStrings.storeText,
                      style: textTheme.headlineSmall
                          ?.copyWith(color: const Color(0xFF010101)),
                    ),
                    subtitle: Text(
                      AppStrings.storeAddress,
                      style: textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF010101),
                          fontWeight: FontWeight.w400),
                    ),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                  Divider(
                    height: 3.h,
                    color: AppColors.darkGray,
                  ),
                  const Row(
                    children: [
                      Column(
                        children: [],
                      ),
                      Wrap(
                        children: [Text(''), Icon(Icons.arrow_forward_ios)],
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
