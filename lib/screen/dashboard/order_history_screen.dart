import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import '../../constant/app_string.dart';
import 'oder_history_item.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final routeName = '/order-history';

  @override
  Widget build(BuildContext context) {
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
          style: Theme
              .of(context)
              .textTheme.displayMedium?.copyWith(
              color: const Color(0xFF010101)),
        ),
        centerTitle: true,
      ),

      body: ListView.builder(
          itemCount: 1,
          shrinkWrap: true,

          itemBuilder:
              (BuildContext context, int index) {
            return const OrderHistoryItem();
          }),
    );
  }
}
