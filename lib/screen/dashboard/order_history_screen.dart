import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/dashboard/get_dashboard/get_dashboard_bloc.dart';
import 'package:gymeats_mobile/bloc/dashboard/get_dashboard/get_dashboard_event.dart';
import 'package:gymeats_mobile/bloc/dashboard/get_dashboard/get_dashboard_state.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/get_order_invoice_list_model.dart';
import 'package:gymeats_mobile/screen/dashboard/order_details_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final routeName = '/order-history';

  GetDashboardBloc getDashboardBloc = GetDashboardBloc();
  List<InvoiceList> invoiceData = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getDashboardBloc.add(GetOrderInvoiceList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer(
          bloc: getDashboardBloc,
          listener: (context, state) {
            if (state is GetOrderInvoiceSuccessState) {
              for (var element in state.invoiceData) {
                if (element.type == "1") {
                  invoiceData.add(element);
                }
              }
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
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
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
                      ),
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
                          : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Pending Orders ------------------------------------------------------------------
                                  // Text(
                                  //   StringUtils.orderProgressText,
                                  //   style: Theme.of(context)
                                  //       .textTheme
                                  //       .headlineSmall
                                  //       ?.copyWith(color: const Color(0xFF010101)),
                                  // ).paddingOnly(top: 20.h, bottom: 15.h),

                                  ///
                                  // ListView.builder(
                                  //     itemCount: 1,
                                  //     shrinkWrap: true,
                                  //     physics: const NeverScrollableScrollPhysics(),
                                  //     itemBuilder: (BuildContext context, int index) {
                                  //       return Container(
                                  //         width: double.infinity.w,
                                  //         // padding: const EdgeInsets.all(12),
                                  //         decoration: BoxDecoration(
                                  //           borderRadius: BorderRadius.circular(8.r),
                                  //           color: Colors.white,
                                  //           border:
                                  //               Border.all(color: AppColors.terracotta),
                                  //           boxShadow: [
                                  //             BoxShadow(
                                  //               color: const Color(0xff004C63)
                                  //                   .withOpacity(0.008),
                                  //               spreadRadius: 0,
                                  //               blurRadius: 16,
                                  //               offset: const Offset(0, 0),
                                  //             )
                                  //           ],
                                  //           /*  border: Border.all(
                                  //   color: AppColors.terracotta,
                                  //   width: 1.w,
                                  //   style: BorderStyle.solid),*/
                                  //         ),
                                  //         child: Column(
                                  //           mainAxisAlignment: MainAxisAlignment.start,
                                  //           children: [
                                  //             ListTile(
                                  //               visualDensity: const VisualDensity(
                                  //                   horizontal: 0, vertical: 0),
                                  //               minVerticalPadding: 0,
                                  //               leading: Image.asset(
                                  //                 AssetsUtils.storeImage,
                                  //                 height: 40.h,
                                  //                 width: 40.w,
                                  //               ),
                                  //               title: Text(
                                  //                 StringUtils.storeText,
                                  //                 style: Theme.of(context)
                                  //                     .textTheme
                                  //                     .headlineSmall
                                  //                     ?.copyWith(
                                  //                         color: const Color(0xFF010101)),
                                  //               ),
                                  //               subtitle: Text(
                                  //                 StringUtils.storeAddress,
                                  //                 style: Theme.of(context)
                                  //                     .textTheme
                                  //                     .bodySmall
                                  //                     ?.copyWith(
                                  //                         color: const Color(0xFF010101),
                                  //                         fontWeight: FontWeight.w400),
                                  //               ),
                                  //               contentPadding: const EdgeInsets.only(
                                  //                   left: 15.0,
                                  //                   right: 15.0,
                                  //                   bottom: 5.0,
                                  //                   top: 5.0),
                                  //               dense: true,
                                  //             ),
                                  //             Padding(
                                  //               padding: const EdgeInsets.only(
                                  //                 left: 15.0,
                                  //                 right: 15.0,
                                  //               ),
                                  //               child: Divider(
                                  //                 height: 1.h,
                                  //                 color: AppColors.darkGray,
                                  //               ),
                                  //             ),
                                  //             SizedBox(
                                  //               height: 10.h,
                                  //             ),
                                  //             Padding(
                                  //               padding: const EdgeInsets.only(
                                  //                   left: 15.0,
                                  //                   right: 15.0,
                                  //                   bottom: 15.0),
                                  //               child: Row(
                                  //                 children: [
                                  //                   const Expanded(
                                  //                     child: Column(
                                  //                       children: [
                                  //                         Row(
                                  //                           children: [
                                  //                             Text(
                                  //                               StringUtils.orderType,
                                  //                               style: TextStyle(
                                  //                                 color:
                                  //                                     AppColors.darkGray,
                                  //                                 fontWeight:
                                  //                                     FontWeight.w800,
                                  //                                 fontSize: 10,
                                  //                               ),
                                  //                             ),
                                  //                             Text(
                                  //                               'Delivery',
                                  //                               style: TextStyle(
                                  //                                 color: AppColors
                                  //                                     .oxFF010101,
                                  //                                 fontWeight:
                                  //                                     FontWeight.w400,
                                  //                                 fontSize: 12,
                                  //                               ),
                                  //                             ),
                                  //                           ],
                                  //                         ),
                                  //                         Row(
                                  //                           children: [
                                  //                             Text(
                                  //                               StringUtils.deliveryTime,
                                  //                               style: TextStyle(
                                  //                                 color:
                                  //                                     AppColors.darkGray,
                                  //                                 fontWeight:
                                  //                                     FontWeight.w800,
                                  //                                 fontSize: 10,
                                  //                               ),
                                  //                             ),
                                  //                             Text(
                                  //                               '10:00-10:20',
                                  //                               style: TextStyle(
                                  //                                 color: AppColors
                                  //                                     .oxFF010101,
                                  //                                 fontWeight:
                                  //                                     FontWeight.w400,
                                  //                                 fontSize: 12,
                                  //                               ),
                                  //                             ),
                                  //                           ],
                                  //                         ),
                                  //                       ],
                                  //                     ),
                                  //                   ),
                                  //                   GestureDetector(
                                  //                     onTap: () {
                                  //                       Get.toNamed(
                                  //                           '/OrderDetailsScreen');
                                  //                     },
                                  //                     child: const Row(
                                  //                       children: [
                                  //                         Text(
                                  //                           StringUtils.details,
                                  //                           style: TextStyle(
                                  //                             color: AppColors.terracotta,
                                  //                             fontWeight: FontWeight.w300,
                                  //                             fontSize: 14,
                                  //                           ),
                                  //                         ),
                                  //                         Icon(Icons.arrow_forward_ios,
                                  //                             color:
                                  //                                 AppColors.terracotta),
                                  //                       ],
                                  //                     ),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //             )
                                  //           ],
                                  //         ),
                                  //       ).paddingOnly(bottom: 10);
                                  //     }),
                                  Text(
                                    StringUtils.recentOrders,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          color: const Color(0xFF010101),
                                        ),
                                  ).paddingOnly(top: 10.h),
                                  SizedBox(height: 15.0.h),
                                  ListView.builder(
                                    itemCount: invoiceData.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        width: double.infinity.w,
                                        // padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xff004C63)
                                                  .withOpacity(0.008),
                                              spreadRadius: 0,
                                              blurRadius: 16,
                                              offset: const Offset(0, 0),
                                            )
                                          ],
                                          /*  border: Border.all(
                      color: AppColors.terracotta,
                      width: 1.w,
                      style: BorderStyle.solid),*/
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: 0,
                                                      vertical: 0),
                                              minVerticalPadding: 0,
                                              leading: Image.asset(
                                                AssetsUtils.storeImage,
                                                height: 40.h,
                                                width: 40.w,
                                              ),
                                              title: SizedBox(
                                                child: Text(
                                                  '${invoiceData[index].storeName}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall
                                                      ?.copyWith(
                                                          color: const Color(
                                                              0xFF010101)),
                                                ),
                                              ),
                                              subtitle: Text(
                                                StringUtils.storeAddress,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                        color: const Color(
                                                            0xFF010101),
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 15.0,
                                                      right: 15.0,
                                                      bottom: 5.0,
                                                      top: 5.0),
                                              dense: true,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                              ),
                                              child: Divider(
                                                height: 1.h,
                                                color: AppColors.darkGray,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0,
                                                  right: 15.0,
                                                  bottom: 15.0),
                                              child: Row(
                                                children: [
                                                  const Expanded(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              StringUtils
                                                                  .orderType,
                                                              style: TextStyle(
                                                                color: AppColors
                                                                    .darkGray,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Delivery',
                                                              style: TextStyle(
                                                                color: AppColors
                                                                    .oxFF010101,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              StringUtils
                                                                  .deliveryTime,
                                                              style: TextStyle(
                                                                color: AppColors
                                                                    .darkGray,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                            Text(
                                                              '10:00-10:20',
                                                              style: TextStyle(
                                                                color: AppColors
                                                                    .oxFF010101,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
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
                                              ),
                                            )
                                          ],
                                        ),
                                      ).paddingOnly(bottom: 10);
                                    },
                                  ),
                                ],
                              ),
                            )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
