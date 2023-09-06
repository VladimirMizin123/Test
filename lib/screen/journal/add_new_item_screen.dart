import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../constant/color_utils.dart';

class AddNewItemScreen extends StatefulWidget {
  const AddNewItemScreen({super.key});

  @override
  State<AddNewItemScreen> createState() => _AddNewItemScreenState();
}

class _AddNewItemScreenState extends State<AddNewItemScreen> {
  final routeName = '/AddNewItemScreen';
  final itemNameController = TextEditingController();
  final weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          StringUtils.addNewItem,
          style: textTheme.displayMedium?.copyWith(color: Colors.black),
        ),
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios, color: AppColors.darkGray, size: 20.h),
          onPressed: () => Navigator.pop(context),
        ).paddingOnly(left: 10.w),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: dashBoardCardView(
              width: double.infinity.w,
              height: MediaQuery.of(context).size.height.h,
              margin: EdgeInsets.only(top: 5.h),
              child: Column(
                children: [
                  Container(
                    height: 120.h,
                    width: double.infinity.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: AppColors.disable),
                    child: Center(
                      child: Text(
                        StringUtils.addPhoto,
                        style: textTheme.headlineSmall
                            ?.copyWith(color: AppColors.middleGray),
                      ),
                    ),
                  ),
                  commonTextField(
                    context: context,
                    controller: itemNameController,
                    hintText: StringUtils.itemName,
                  ).paddingOnly(top: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(StringUtils.weight,
                          style: textTheme.bodyLarge
                              ?.copyWith(color: Colors.black)),
                      Container(
                        height: 45.h,
                        width: 86.w,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade300, // Set border color
                              width: 1.0), // Set border width
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: TextFormField(
                          controller: weightController,
                          keyboardType: TextInputType.number,
                          cursorColor: AppColors.middleGray,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkGray),
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            filled: false,
                            hintText: '00',
                            hintStyle: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.darkGray),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            suffix: const Text(StringUtils.oz),
                            suffixStyle: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                        ),
                      )
                    ],
                  ).paddingSymmetric(vertical: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      dashBoardCardView(
                        margin: EdgeInsets.only(right: 4),
                        child: calciumDataView(
                          title: 'Cal',
                          percent: 0.16,
                          gramCount: '320',
                          progressColor: AppColors.primaryBlue,
                          textTheme: textTheme,
                          totalGram: '2000 cal'
                        )
                      ),
                      dashBoardCardView(
                          margin: EdgeInsets.only(left: 4),
                        child: calciumDataView(
                          title: 'Fat',
                          percent: 0.77,
                          gramCount: '100',
                          progressColor: AppColors.coral,
                          textTheme: textTheme,
                          totalGram: '177 g'
                        )
                      ),
                    ],
                  ).paddingSymmetric(vertical: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      dashBoardCardView(
                        margin: EdgeInsets.only(right: 4),
                        child: calciumDataView(
                            title: 'Carbs',
                            textTheme: textTheme,
                            gramCount: '100',
                            percent: 0.77,
                            totalGram: '177 g',
                            progressColor: AppColors.mint
                        )
                      ),
                      dashBoardCardView(
                          margin: EdgeInsets.only(left: 4),
                        child: calciumDataView(
                            title: 'Protein',
                            textTheme: textTheme,
                            gramCount: '32',
                            percent: 0.66,
                            totalGram: '48 g',
                            progressColor: AppColors.skyBlue
                        )
                      ),
                    ],
                  ).paddingSymmetric(vertical: 4),
                ],
              ).paddingAll(10),
            ),
          ),
          buildButton(
            context: context,
            bgColor: AppColors.disable,
            hasImage: false,
            onPressed: () {},
            textColor: Colors.white,
            title: StringUtils.saveNewItem,
          ).paddingOnly(bottom: 30.h, top: 10.h)
        ],
      ).paddingSymmetric(horizontal: 20.w),
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
            width: 70.w,
            lineHeight: 8.0,
            percent: percent ?? 0.5),
        Text(
          '$gramCount / $totalGram',
          style: textTheme?.bodyMedium
              ?.copyWith(color: AppColors.darkGray, height: 1.7),
        ),
        SizedBox(width: 70,child: commonTextField(context: context,hintText: "cal",isPassword: false, controller: TextEditingController())).paddingSymmetric(vertical: 5),
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
}
