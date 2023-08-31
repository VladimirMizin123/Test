import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

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
                  ),
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
                  )
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
}
