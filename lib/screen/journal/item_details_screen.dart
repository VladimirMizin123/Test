import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../constant/color_utils.dart';

class ItemDetailsScreen extends StatefulWidget {
  const ItemDetailsScreen({super.key});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final routeName = '/ItemDetailsScreen';
  int itemCount = 1;
  String menuItem = 'cup';
  var items = ['cup', 'jar', 'spoon'];
  bool isBack = false;

  void addItem() {
    setState(() {
      itemCount++;
    });
  }

  void removeItem() {
    if (itemCount == 0) return;
    setState(() {
      itemCount--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Item Details',
          style: textTheme.displayMedium?.copyWith(color: Colors.black),
        ),
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios, color: AppColors.darkGray, size: 20.h),
          onPressed: () => Navigator.pop(context),
        ).paddingOnly(left: 10.w),
      ),
      body: SizedBox(
        height: size.height.h,
        width: size.width.w,
        child: ListView(
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  StringUtils.whiteBread,
                  style: textTheme.headlineSmall!
                      .copyWith(color: AppColors.darkGray),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.info_outlined,
                    color: AppColors.primaryBlue,
                    size: 20.h,
                  ),
                )
              ],
            ).paddingOnly(left: 20.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Wrap(
                  children: [
                    itemButton(
                      height: 45.h,
                      width: 48.w,
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 20.h,
                      ),
                      bgColor: AppColors.disable,
                      onPressed: removeItem,
                    ),
                    itemButton(
                      height: 45.h,
                      width: 48.w,
                      child: Text(
                        itemCount.toString(),
                      ),
                      bgColor: Colors.white,
                      borderColor: AppColors.disable,
                    ),
                    itemButton(
                      height: 45.h,
                      width: 48.w,
                      child: Icon(
                        Icons.add,
                        color: AppColors.primaryBlue,
                        size: 20.h,
                      ),
                      bgColor: AppColors.skyBlue,
                      onPressed: addItem,
                    ),
                  ],
                ),
                itemButton(
                  height: 45.h,
                  bgColor: Colors.white,
                  borderColor: AppColors.disable,
                  width: 155.w,
                  child: DropdownButton(
                    underline: const SizedBox(),
                    isDense: true,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    isExpanded: true,
                    elevation: 0,
                    menuMaxHeight: 150.h,
                    borderRadius: BorderRadius.circular(8.r),
                    value: menuItem,
                    icon: const Icon(Icons.arrow_drop_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: textTheme.bodyLarge
                              ?.copyWith(color: AppColors.darkGray),
                        ),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (newValue) {
                      setState(() {
                        menuItem = newValue!;
                      });
                    },
                  ),
                )
              ],
            ).paddingOnly(right: 17.w, left: 12.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                dashBoardCardView(
                  child: calciumDataView(
                      title: 'Cal',
                      textTheme: textTheme,
                      percent: 0.16,
                      gramCount: '320',
                      totalGram: '2000 cal',
                      progressColor: AppColors.primaryBlue),
                ),
                dashBoardCardView(
                  child: calciumDataView(
                      title: 'Fat',
                      textTheme: textTheme,
                      gramCount: '100',
                      percent: 0.77,
                      totalGram: '177 g',
                      progressColor: AppColors.coral),
                ),
              ],
            ).paddingOnly(top: 13.h, bottom: 8.h, left: 20.w, right: 20.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                dashBoardCardView(
                  child: calciumDataView(
                      title: 'Carbs',
                      textTheme: textTheme,
                      gramCount: '100',
                      percent: 0.77,
                      totalGram: '177 g',
                      progressColor: AppColors.mint),
                ),
                dashBoardCardView(
                  child: calciumDataView(
                      title: 'Protein',
                      textTheme: textTheme,
                      gramCount: '32',
                      percent: 0.66,
                      totalGram: '48 g',
                      progressColor: AppColors.skyBlue),
                ),
              ],
            ).paddingOnly(top: 5.h, bottom: 8.h, left: 20.w, right: 20.w),
            Text(
              StringUtils.nutritional,
              style: textTheme.displayMedium?.copyWith(color: Colors.black),
            ).paddingSymmetric(horizontal: 20.w, vertical: 5.h),
            SizedBox(
              height: 240.h,
              width: size.width.w,
              child: ListView.builder(
                itemCount: 4,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return nutritionalDataView(
                    textTheme: textTheme,
                    title1: 'Fat',
                    title2: 'Trans Fat',
                    title3: 'Trans Fat',
                    value1: '2g',
                    value2: '0g',
                    value3: '0g',
                  );
                },
              ),
            ),
            buildButton(
              context: context,
              onPressed: () {
                setState(() {
                  isBack = !isBack;
                });
              },
              hasImage: false,
              bgColor: AppColors.primaryBlue,
              textColor: AppColors.skyBlue,
              title: isBack ? StringUtils.back : StringUtils.addItem,
            ).paddingOnly(left: 20.w, right: 20.w, bottom: 25.h, top: 10.h)
          ],
        ),
      ),
    );
  }

  Widget itemButton({
    double height = 0.0,
    double width = 0.0,
    Widget? child,
    void Function()? onPressed,
    Color? bgColor,
    Color? borderColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        margin: EdgeInsets.only(left: 8.w),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(child: child),
      ),
    );
  }

  Widget calciumDataView({
    String? title,
    String? gramCount,
    TextTheme? textTheme,
    String? totalGram,
    double? percent,
    Color? progressColor,
  }) {
    return Column(
      children: [
        Text(
          title.toString(),
          style: textTheme?.bodyLarge?.copyWith(color: AppColors.darkGray),
        ),
        commonProgressbar(
            progressColor: progressColor,
            width: 76.w,
            lineHeight: 8.0,
            percent: percent ?? 0.5),
        Text(
          '$gramCount / $totalGram',
          style: textTheme?.bodyMedium
              ?.copyWith(color: AppColors.darkGray, height: 1.7),
        )
      ],
    ).paddingSymmetric(horizontal: 33.w, vertical: 6.h);
  }

  Widget commonProgressbar(
      {Color? progressColor,
      double? width,
      double? lineHeight,
      double? percent}) {
    return LinearPercentIndicator(
      width: width,
      barRadius: Radius.circular(10.r),
      animation: true,
      lineHeight: lineHeight!,
      animationDuration: 2000,
      percent: percent ?? 0.5,
      center: const Text(""),
      linearStrokeCap: LinearStrokeCap.round,
      progressColor: progressColor,
    ).paddingAll(5);
  }

  Widget nutritionalDataView({
    TextTheme? textTheme,
    String title1 = '',
    String title2 = '',
    String title3 = '',
    String value1 = '',
    String value2 = '',
    String value3 = '',
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title1,
                style:
                    textTheme?.bodyLarge?.copyWith(color: AppColors.darkGray)),
            Text(value1,
                style:
                    textTheme?.bodyLarge?.copyWith(color: AppColors.darkGray)),
          ],
        ).paddingSymmetric(vertical: 5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title2,
              style: textTheme?.bodySmall?.copyWith(
                color: AppColors.middleGray,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              value2,
              style: textTheme?.bodySmall?.copyWith(
                color: AppColors.middleGray,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ).paddingSymmetric(vertical: 5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title3,
              style: textTheme?.bodySmall?.copyWith(
                color: AppColors.middleGray,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              value3,
              style: textTheme?.bodySmall?.copyWith(
                color: AppColors.middleGray,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ).paddingSymmetric(vertical: 5.h),
        Divider(color: AppColors.disable, height: 1.5.h)
      ],
    ).paddingSymmetric(horizontal: 20.w);
  }
}
