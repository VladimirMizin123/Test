import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';
import 'package:gymeats_mobile/widget/divider_widget.dart';

import '../../../constant/asset_utils.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(
              AssetsUtils.gymEatsLogo,
              height: 20.h,
              width: 56.w,
              color: AppColors.primaryBlue,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButtonWidget(),
                Text('Checkout', style: FontUtils.h20(fontColor: AppColors.oxFF010101, fontWeight: FWT.semiBold)),
                Opacity(opacity: 0, child: Text('Edit', style: FontUtils.h16(fontColor: AppColors.oxFF010101))),
              ],
            ).paddingSymmetric(horizontal: 6, vertical: 5.h),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Payment method',
                          style: FontUtils.h20(fontColor: AppColors.middleGray),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.terracotta)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              SvgPicture.asset(AssetsUtils.icCardImg),
                              const SizedBox(width: 15),
                              Expanded(
                                  child: Text(
                                'Choose payment\nmethod',
                                style: FontUtils.h18(fontColor: AppColors.black, fontWeight: FWT.semiBold),
                              )),
                              Text(
                                'Edit',
                                style: FontUtils.h16(fontColor: AppColors.terracotta),
                              ),
                              const SizedBox(width: 5),
                              const Icon(Icons.chevron_right_rounded, color: AppColors.terracotta),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Delivery info',
                          style: FontUtils.h20(fontColor: AppColors.middleGray),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.whiteColor,
                          boxShadow: boxShadowWidget,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              SvgPicture.asset(AssetsUtils.icLocation, color: AppColors.green, height: 25),
                              const SizedBox(width: 15),
                              Expanded(
                                  child: Text(
                                'Bring me the order',
                                style: FontUtils.h18(fontColor: AppColors.black, fontWeight: FWT.medium),
                              )),
                              Text(
                                'Edit',
                                style: FontUtils.h16(fontColor: AppColors.terracotta),
                              ),
                              const SizedBox(width: 5),
                              const Icon(Icons.chevron_right_rounded, color: AppColors.terracotta),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          color: AppColors.lightGrey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/MapAddressScreen');
                        },
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                            color: AppColors.whiteColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(children: [
                              SvgPicture.asset(AssetsUtils.icHome, color: AppColors.green, height: 25),
                              const SizedBox(width: 15),
                              Text(
                                'Where?',
                                style: FontUtils.h18(fontColor: AppColors.black, fontWeight: FWT.light),
                              ),
                              const Spacer(),
                              const Icon(Icons.chevron_right_rounded)
                            ]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ExpansionPanelList(
                        elevation: 1,
                        expandedHeaderPadding: const EdgeInsets.all(0),
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            _isExpanded = !isExpanded;
                          });
                        },
                        children: [
                          ExpansionPanel(
                            headerBuilder: (BuildContext context, bool isExpanded) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(children: [
                                  SvgPicture.asset(AssetsUtils.icListIcon, color: AppColors.green, height: 25),
                                  const SizedBox(width: 15),
                                  Text(
                                    'Your Order',
                                    style: FontUtils.h18(fontColor: AppColors.black, fontWeight: FWT.light),
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      color: AppColors.terracotta,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Center(
                                        child: Text(
                                      '2',
                                      style: FontUtils.h12(fontColor: AppColors.whiteColor),
                                    )),
                                  ),
                                ]),
                              );
                            },
                            body: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Wallmart',
                                        style: FontUtils.h22(fontColor: AppColors.black),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Order #123456',
                                      style: FontUtils.h12(fontColor: AppColors.green, fontWeight: FWT.semiBold),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                myWidgetRow('1x Potatoes', '5,99'),
                                myWidgetRow('1x Potatoes', '5,99'),
                                const SizedBox(height: 5),
                                myWidgetIconRow('Delivery Fee', 'FREE'),
                                myWidgetIconRow('Service Fee', '\$4.00'),
                                myWidgetRow('Service fee tex', '\$0.30'),
                                const SizedBox(height: 10),
                                myWidgetAmountRow('Total', '\$11.98'),
                                const SizedBox(height: 5),
                                const DividerWidget(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Wallmart',
                                        style: FontUtils.h22(fontColor: AppColors.black),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Order #123456',
                                      style: FontUtils.h12(fontColor: AppColors.green, fontWeight: FWT.semiBold),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                myWidgetRow('1x Potatoes', '5,99'),
                                myWidgetRow('1x Potatoes', '5,99'),
                                const SizedBox(height: 5),
                                myWidgetIconRow('Delivery Fee', 'FREE'),
                                myWidgetIconRow('Service Fee', '\$4.00'),
                                myWidgetRow('Service fee tex', '\$0.30'),
                                const SizedBox(height: 10),
                                myWidgetAmountRow('Total', '\$11.98'),
                                const SizedBox(height: 5),
                              ],
                            ),
                            isExpanded: _isExpanded,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Order Notes',
                          style: FontUtils.h20(fontColor: AppColors.middleGray, fontWeight: FWT.semiBold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.whiteColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(children: [
                            Text(
                              'Cut the bread, please!',
                              style: FontUtils.h18(fontColor: AppColors.black, fontWeight: FWT.medium),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: AppColors.whiteColor,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Text(
                          'Delivery fee',
                          style: FontUtils.h14(fontColor: AppColors.black),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.info_outline),
                        const Spacer(),
                        Text(
                          'FREE',
                          style: FontUtils.h14(fontColor: AppColors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Text(
                          'Service fee',
                          style: FontUtils.h14(fontColor: AppColors.black),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.info_outline),
                        const Spacer(),
                        Text(
                          '\$4.00',
                          style: FontUtils.h14(fontColor: AppColors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Text(
                          'Service fee tax',
                          style: FontUtils.h14(fontColor: AppColors.black),
                        ),
                        const Spacer(),
                        Text(
                          '\$0.30',
                          style: FontUtils.h14(fontColor: AppColors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: FontUtils.h22(fontColor: AppColors.black, fontWeight: FWT.semiBold),
                        ),
                        Text(
                          '\$ 14.97',
                          style: FontUtils.h22(fontColor: AppColors.black, fontWeight: FWT.semiBold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: simpleTextBorderButton(
                      context: context,
                      color: AppColors.green,
                      buttonLable: 'Checkout ',
                      height: screenSize.height * 0.065,
                      width: screenSize.width,
                      isLoadingWidget: false,
                      onTap: () {
                        Get.toNamed('/PaymentCardSelectionScreen');
                      },
                      isDarkColor: true,
                      isFillColor: true,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myWidgetRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: FontUtils.h18(fontColor: AppColors.black),
          ),
          Text(
            value,
            style: FontUtils.h20(fontColor: AppColors.black, fontWeight: FWT.semiBold),
          ),
        ],
      ),
    );
  }

  Widget myWidgetIconRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: FontUtils.h18(fontColor: AppColors.black),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.info_outline_rounded),
            ],
          ),
          Text(
            value,
            style: FontUtils.h20(fontColor: AppColors.black),
          ),
        ],
      ),
    );
  }

  Widget myWidgetAmountRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: FontUtils.h20(fontColor: AppColors.black),
          ),
          Text(
            value,
            style: FontUtils.h22(fontColor: AppColors.black, fontWeight: FWT.semiBold),
          ),
        ],
      ),
    );
  }
}
