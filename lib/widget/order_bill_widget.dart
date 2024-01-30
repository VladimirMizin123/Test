import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';

class OrderBillWidget extends StatelessWidget {
  const OrderBillWidget({
    super.key,
    this.storeName,
    this.productName,
    this.orderId,
    this.quantity = 0,
    this.price = 0,
    this.deliveryFee = 0,
    this.serviceFee = 0,
    this.serviceTaxFee = 0,
  });
  final String? storeName;
  final String? productName;
  final String? orderId;
  final num quantity;
  final num price;
  final num deliveryFee;
  final num serviceFee;
  final num serviceTaxFee;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              AssetsUtils.defaultLogo,
              height: 37.h,
              width: 37.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.67,
                  child: Text(
                    storeName ?? "",
                    style: textTheme.headlineSmall
                        ?.copyWith(color: const Color(0xFF010101)),
                  ),
                ),
                Text(
                  'Order #$orderId',
                  style: textTheme.bodySmall?.copyWith(
                      color: AppColors.middleGray,
                      fontWeight: FontWeight.w400,
                      height: 1.2),
                ),
              ],
            ).paddingOnly(left: 10.w)
          ],
        ),
        _billRowWidget(
          title: '${quantity}x $productName',
          value: '\$ ${(price * quantity) / 100}',
          textTheme: textTheme.bodyMedium!.copyWith(color: Colors.black),
          valueTextTheme: textTheme.bodyLarge!.copyWith(color: Colors.black),
        ),
        _billRowWidget(
          title: 'Delivery Fee',
          value: '\$ ${deliveryFee / 100}',
          textTheme: textTheme.bodyMedium!.copyWith(color: Colors.black),
          valueTextTheme: textTheme.bodyLarge!.copyWith(color: Colors.black),
        ),
        _billRowWidget(
          title: 'Service Fee',
          value: '\$ ${serviceFee / 100}',
          textTheme: textTheme.bodyMedium!.copyWith(color: Colors.black),
          valueTextTheme: textTheme.bodyLarge!.copyWith(color: Colors.black),
        ),
        _billRowWidget(
          title: 'Service Tax Fee',
          value: '\$ ${serviceTaxFee / 100}',
          textTheme: textTheme.bodyMedium!.copyWith(color: Colors.black),
          valueTextTheme: textTheme.bodyLarge!.copyWith(color: Colors.black),
        ),
        _billRowWidget(
          title: 'Total',
          value:
              '\$ ${(((price * quantity) / 100) + (deliveryFee / 100) + (serviceFee / 100) + (serviceTaxFee / 100)).toStringAsFixed(2)}',
          textTheme: textTheme.bodyLarge!.copyWith(color: AppColors.darkGray),
          valueTextTheme:
              textTheme.headlineSmall!.copyWith(color: Colors.black),
        ),
      ],
    );
  }

  Widget _billRowWidget({
    required String title,
    required String value,
    required TextStyle textTheme,
    required TextStyle valueTextTheme,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(title, style: textTheme, maxLines: 1)),
        Text(value, style: valueTextTheme),
      ],
    ).paddingSymmetric(vertical: 5);
  }
}
