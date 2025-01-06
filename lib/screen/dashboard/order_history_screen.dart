import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/dashboard/get_dashboard/get_dashboard_bloc.dart';
import 'package:gymeats_mobile/bloc/dashboard/get_dashboard/get_dashboard_event.dart';
import 'package:gymeats_mobile/bloc/dashboard/get_dashboard/get_dashboard_state.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/get_order_invoice_list_model.dart';
import 'package:gymeats_mobile/screen/dashboard/order_details_screen.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final routeName = '/order-history';

  GetDashboardBloc getDashboardBloc = GetDashboardBloc();
  List<OrderedItem> invoiceData = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getDashboardBloc.add(GetOrderInvoiceList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer(
          bloc: getDashboardBloc,
          listener: (context, state) {
            if (state is GetOrderInvoiceSuccessState) {
              invoiceData = state.invoiceData;

              loading = false;
            }
            if (state is GetOrderInvoiceLoadingState) {
              loading = true;
            }
            if (state is GetOrderInvoiceErrorState) {
              loading = false;
            }
          },
          builder: (context, state) => loading == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                        Text(
                          StringUtils.orderHistory,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(color: const Color(0xFF010101)),
                        ),
                        const SizedBox()
                      ],
                    ).paddingSymmetric(horizontal: 15, vertical: 5.h),
                    invoiceData.isEmpty
                        ? Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Currently No Order Found',
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    StringUtils.recentOrders,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          color: const Color(0xFF010101),
                                        ),
                                  ).paddingOnly(top: 10.h, right: 15, left: 15),
                                  SizedBox(height: 15.0.h),
                                  ListView.builder(
                                    itemCount: invoiceData.length,
                                    shrinkWrap: true,
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      OrderedItem item = invoiceData[index];
                                      String deliveryTime =
                                          (item.items?.isNotEmpty ?? false)
                                              ? item.items?.first
                                                      .expectedTimeOfArrival ??
                                                  "00:00 AM"
                                              : "00:00 AM";

                                      return Container(
                                        width: double.infinity.w,
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 12.5, 10, 17),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xff004C63)
                                                  .withOpacity(0.08),
                                              spreadRadius: 0,
                                              blurRadius: 16,
                                              offset: const Offset(0, 0),
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              invoiceData[index]
                                                      .items?[0]
                                                      .stores
                                                      ?.storeName ??
                                                  '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                      color: const Color(
                                                          0xFF010101)),
                                            ),
                                            if (item.createdOn != null)
                                              Text(
                                                DateFormat(
                                                        'dd MMM yyyy, hh:mm a')
                                                    .format(item.createdOn!),
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Avenir',
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF5F5F5F),
                                                ),
                                              ),
                                            const SizedBox(height: 12),
                                            Divider(
                                                height: 1.h,
                                                color: AppColors.disable),
                                            const SizedBox(height: 15),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      itemWidget(
                                                        title: StringUtils
                                                            .orderType,
                                                        value: (item.items
                                                                    ?.isNotEmpty ??
                                                                false)
                                                            ? (item.items?.first
                                                                        .isPickUp ??
                                                                    false)
                                                                ? "Pick up"
                                                                : 'Delivery'
                                                            : 'Delivery',
                                                      ),
                                                      itemWidget(
                                                        title: StringUtils
                                                            .deliveryTime,
                                                        value: deliveryTime,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.to(() =>
                                                        OrderDetailsScreen(
                                                          data: invoiceData[
                                                              index],
                                                        ));
                                                  },
                                                  child: const Row(
                                                    children: [
                                                      Text(
                                                        StringUtils.details,
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .terracotta,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: AppColors
                                                              .terracotta),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ).paddingOnly(bottom: 16);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                  ],
                ),
        ),
      ),
    );
  }

  Widget itemWidget({required String title, required String value}) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.darkGray,
              fontWeight: FontWeight.w800,
              fontSize: 10,
            ),
          ),
        ),
        Text(
          ":   $value",
          style: const TextStyle(
            color: AppColors.oxFF010101,
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
