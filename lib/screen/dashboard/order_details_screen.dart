import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/models/get_order_invoice_list_model.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_bloc.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_event.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_state.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
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
  String fullName = '';
  AccountBloc accountBloc = AccountBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      accountBloc.add(GetProfileDetailsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer(
        bloc: accountBloc,
        listener: (context, state) {
          if (state is GetProfileDetailsSuccessState) {
            fullName =
                '${state.profileDetails?.firstName} ${state.profileDetails?.lastName}';
            setState(() {});
          }
        },
        builder: (context, state) => SizedBox(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              height: 40.h,
                              width: 40.w,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
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
                              style: textTheme.bodyLarge
                                  ?.copyWith(color: const Color(0xFF010101)),
                            ),
                            Text(
                              getMaxValue(),
                              // widget.data.deliveryTimeMin.toString().isEmpty
                              //     ? ''
                              //     : '${widget.data.deliveryTimeMin}-${widget.data.deliveryTimeMax} min',
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
                  onPressed: () {
                    launchUrlForTracking();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isTap ? AppColors.coral : AppColors.mint,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0, bottom: 4),
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
              ).paddingSymmetric(horizontal: 20.w, vertical: 20.h),
              Expanded(
                child: SingleChildScrollView(
                  child: dashBoardCardView(
                          child: /*isTap ? */
                              Column(
                    children: [
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.data.items?.length ?? 0,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
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
                                              0.65,
                                          child: Text(
                                            widget.data.items?[index].stores
                                                    ?.storeName ??
                                                '',
                                            style: textTheme.headlineSmall
                                                ?.copyWith(
                                                    color: const Color(
                                                        0xFF010101)),
                                          ),
                                        ),
                                        Text(
                                          'Order #${widget.data.orderId}',
                                          style: textTheme.bodySmall?.copyWith(
                                              color: AppColors.middleGray,
                                              fontWeight: FontWeight.w400,
                                              height: 1.2),
                                        ),
                                      ],
                                    ).paddingOnly(left: 10.w)
                                  ],
                                ),
                                commonRowData(
                                  title:
                                      '${widget.data.items?[index].quantity}x ${widget.data.items?[index].productName} ',
                                  value:
                                      '\$ ${(widget.data.items?[index].price ?? 0) / 100}',
                                  textTheme: textTheme.bodyMedium!
                                      .copyWith(color: Colors.black),
                                  valueTextTheme: textTheme.bodyLarge!
                                      .copyWith(color: Colors.black),
                                ),
                                commonRowData(
                                  title: 'Total',
                                  value:
                                      '\$ ${(widget.data.items?[index].price ?? 0) / 100}',
                                  textTheme: textTheme.bodyLarge!
                                      .copyWith(color: AppColors.darkGray),
                                  valueTextTheme: textTheme.headlineSmall!
                                      .copyWith(color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      )
                    ],
                  ).paddingAll(12)
                          /*: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Wallmart',
                                  style: textTheme.bodyLarge
                                      ?.copyWith(color: const Color(0xFF000000))),
                              Text(
                                'Order #123456',
                                style: textTheme.bodySmall?.copyWith(
                                    color: AppColors.green,
                                    fontSize: 10.sp,
                                    letterSpacing: -0.2,
                                    fontWeight: FontWeight.w800),
                              ),
                              commonRowData(
                                title: '1x Potatoes',
                                value: '5,99',
                                textTheme: textTheme.bodyMedium!
                                    .copyWith(color: Colors.black),
                                valueTextTheme: textTheme.bodyLarge!
                                    .copyWith(color: Colors.black),
                              ),
                              commonRowData(
                                title: '1x Mushrooms small packs (20 oz)',
                                value: '5,99',
                                textTheme: textTheme.bodyMedium!
                                    .copyWith(color: Colors.black),
                                valueTextTheme: textTheme.bodyLarge!
                                    .copyWith(color: Colors.black),
                              ),
                              commonRowData(
                                title: 'Total',
                                value: '\$ 11.98',
                                textTheme: textTheme.bodyLarge!
                                    .copyWith(color: AppColors.darkGray),
                                valueTextTheme: textTheme.headlineSmall!
                                    .copyWith(color: Colors.black),
                              ),
                              Divider(height: 5.h, color: AppColors.darkGray),
                              Text(
                                'Tesco',
                                style: textTheme.bodyLarge
                                    ?.copyWith(color: const Color(0xFF000000)),
                              ).paddingOnly(top: 8.h),
                              Text(
                                'Order #123456',
                                style: textTheme.bodySmall?.copyWith(
                                    color: AppColors.green,
                                    fontSize: 10.sp,
                                    letterSpacing: -0.2,
                                    fontWeight: FontWeight.w800),
                              ),
                              commonRowData(
                                title: '1x Milk Almond Breeze 500ml, 1.5% fat',
                                value: '5,99',
                                textTheme: textTheme.bodyMedium!
                                    .copyWith(color: Colors.black),
                                valueTextTheme: textTheme.bodyLarge!
                                    .copyWith(color: Colors.black),
                              ),
                              commonRowData(
                                title: 'Total',
                                value: '\$ 5.99',
                                textTheme: textTheme.bodyLarge!
                                    .copyWith(color: AppColors.darkGray),
                                valueTextTheme: textTheme.headlineSmall!
                                    .copyWith(color: Colors.black),
                              ),
                            ],
                          ).paddingAll(15.r),*/
                          )
                      .paddingSymmetric(horizontal: 20.w, vertical: 5.w),
                ),
              ),
              // const Spacer(),
              const Text('Have any questions? Fill free to ask us!'),
              buildButton(
                      context: context,
                      bgColor: AppColors.primaryBlue,
                      onPressed: () {
                        Livechat.beginChat(
                          '16538658',
                          '0',
                          fullName,
                          PreferenceUtils.getString(prefUserEmail),
                          <String, String>{
                            'org': PreferenceUtils.getString(prefUserData),
                            'position': 'user'
                          },
                        );
                      },
                      textColor: AppColors.skyBlue,
                      title: 'Support')
                  .paddingOnly(top: 8.h, bottom: 20.h, left: 20.w, right: 20.w),
            ],
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

  Widget commonRowData({
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
