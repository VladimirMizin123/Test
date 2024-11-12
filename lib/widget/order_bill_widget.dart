import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_string.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_order_details.dart';

class OrderBillWidget extends StatelessWidget {
  const OrderBillWidget({
    super.key,
    this.orderData,
  });

  final OrderData? orderData;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    List<OrderedItems> orderItems = orderData?.orderedItems ?? [];

    double productSum = orderItems.fold(
        0.0,
        (previousValue, element) => previousValue +=
            (((element.price ?? 0) * (element.quantity ?? 0)) +
                (element.options?.fold<double>(
                        0.0,
                        (p, e) => p +=
                            ((e.optionPrice ?? 0) * (element.quantity ?? 0))) ??
                    0)));
    double totalSum = (productSum +
            (orderData?.deliveryFee ?? 0) +
            (orderData?.serviceFee ?? 0) +
            (orderData?.serviceTaxFee ?? 0)) /
        100;

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: "${orderData?.storeId}".storeGenericImg(40),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.67,
                  child: Text(
                    orderData?.storeName ?? "",
                    style: textTheme.headlineSmall
                        ?.copyWith(color: const Color(0xFF010101)),
                  ),
                ),
                Text(
                  'Order #${orderData?.orderId}',
                  style: textTheme.bodySmall?.copyWith(
                      color: AppColors.middleGray,
                      fontWeight: FontWeight.w400,
                      height: 1.2),
                ),
              ],
            ).paddingOnly(left: 10.w)
          ],
        ),
        ...List.generate(
          orderItems.length,
          (index) {
            OrderedItems items = orderItems[index];
            double price = ((items.price ?? 0) * (items.quantity ?? 0)) / 100;
            if (items.options?.isNotEmpty ?? false) {
              price += (items.options?.fold<double>(
                          0.0,
                          (p, e) =>
                              p +
                              ((e.optionPrice ?? 0) * (items.quantity ?? 0))) ??
                      0) /
                  100;
            }
            return _billRowWidget(
              title: '${items.quantity}x ${items.productName}',
              value: '\$ $price',
              textTheme: textTheme.bodyMedium!.copyWith(color: Colors.black),
              valueTextTheme:
                  textTheme.bodyLarge!.copyWith(color: Colors.black),
            );
          },
        ),
        _billRowWidget(
          title: 'Delivery Fee',
          value: '\$ ${(orderData?.deliveryFee ?? 0) / 100}',
          textTheme: textTheme.bodyMedium!.copyWith(color: Colors.black),
          valueTextTheme: textTheme.bodyLarge!.copyWith(color: Colors.black),
        ),
        _billRowWidget(
          title: 'Service Fee',
          value: '\$ ${(orderData?.serviceFee ?? 0) / 100}',
          textTheme: textTheme.bodyMedium!.copyWith(color: Colors.black),
          valueTextTheme: textTheme.bodyLarge!.copyWith(color: Colors.black),
        ),
        _billRowWidget(
          title: 'Service Tax Fee',
          value: '\$ ${(orderData?.serviceTaxFee ?? 0) / 100}',
          textTheme: textTheme.bodyMedium!.copyWith(color: Colors.black),
          valueTextTheme: textTheme.bodyLarge!.copyWith(color: Colors.black),
        ),
        _billRowWidget(
          title: 'Total',
          value: "\$ ${totalSum.toStringAsFixed(2)}",
          textTheme: textTheme.bodyLarge!.copyWith(color: AppColors.darkGray),
          valueTextTheme:
              textTheme.headlineSmall!.copyWith(color: Colors.black),
        ),
      ],
    ).paddingAll(12);
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
