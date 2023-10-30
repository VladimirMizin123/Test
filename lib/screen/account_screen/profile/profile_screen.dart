import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/account_screen/profile/profile_screen_widget.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/svg_image.dart';
import 'package:intl/intl.dart';
import '../../../constant/color_utils.dart';
import '../account/account_scrren_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DateTime dateTime = DateTime.now();
  String? showDate;
  bool isClick = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  AccountTitleWidget(
                    title: "Profile",
                    widget: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200, spreadRadius: 1)
                        ],
                      ),
                      margin:
                          EdgeInsets.only(top: 140.h, right: 23.w, left: 23.w),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 8.h),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 45,
                                  child: SvgPicture.asset(AssetsUtils.appleLogo,
                                      fit: BoxFit.fill,
                                      height: 50,
                                      width: 50,
                                      color: Colors.yellow),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Text(
                                  "Edit profile photo",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          profileDataWidget(
                            text: "name",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400),
                            widget: commonTextFormField(
                                enableBorderColor: AppColors.primaryBlueColor,
                                obscureText: false,
                                width: 140.w,
                                horizontal: 10,
                                vertical: 0,
                                hintText: ""),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: labelWidget(
                                text: "Goal/Focus",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400),
                              )),
                              Container(
                                height: 46.h,
                                width: 140.w,
                                child: DropdownButtonFormField(
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13.sp,
                                      color: AppColors.blackColor),
                                  hint: Text(StringUtils.loseWeight,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 13.sp)),
                                  icon: const SvgImage(
                                      image: AssetsUtils.downArrow,
                                      color: AppColors.middleGray),
                                  iconSize: 30,
                                  items: <String>["gain weight", "lose weight"]
                                      .map<DropdownMenuItem>((String value) {
                                    return DropdownMenuItem(
                                      child: Text(value),
                                      value: value,
                                    );
                                  }).toList(),
                                  onChanged: (value) {},
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          profileDataWidget(
                            text: "Weight",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400),
                            widget: commonTextFormField(
                                enableBorderColor: AppColors.primaryBlueColor,
                                width: 140.w,
                                horizontal: 10,
                                vertical: 0,
                                hintText: ""),
                          ),
                          profileDataWidget(
                            text: "Target Weight",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400),
                            widget: commonTextFormField(
                                enableBorderColor: AppColors.primaryBlueColor,
                                width: 140.w,
                                horizontal: 10,
                                vertical: 0,
                                hintText: ""),
                          ),
                          profileDataWidget(
                            text: "Height",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400),
                            widget: commonTextFormField(
                                enableBorderColor: AppColors.middleGray,
                                width: 140.w,
                                horizontal: 10,
                                vertical: 0,
                                hintText: StringUtils.required,
                                hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.middleGray)),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: labelWidget(
                                text: "BirthDate",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400),
                              )),
                              GestureDetector(
                                onTap: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) => CupertinoActionSheet(
                                      actions: [
                                        buildDatePicker(),
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                        onPressed: () {
                                          isClick = true;
                                          showDate = DateFormat('MM/dd/yyyy')
                                              .format(dateTime);
                                          print("showDate : ${showDate}");
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Done",
                                            style: TextStyle(
                                                color:
                                                    AppColors.errorRedColor)),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 49,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.disabledColor),
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(8.w),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        isClick == true
                                            ? showDate.toString()
                                            : StringUtils.required,
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w300,
                                            color: AppColors.middleGray),
                                      ),
                                      Container(
                                        height: 15,
                                        width: 25,
                                        child: const SvgImage(
                                          image: AssetsUtils.downArrow,
                                          color: AppColors.middleGray,
                                        ),
                                      ),
                                    ],
                                  ).paddingOnly(right: 10.w, left: 10.w),
                                ),
                              ),
                              /*    GestureDetector(
                                onTap: () {
                                  print("object1111111");
                                },
                                child: Container(
                                  height: 45.h,
                                  width: 140.w,
                                  child: DropdownButtonFormField<DateTime>(
                                    items: []
                                        .map((e) => DropdownMenuItem<DateTime>(
                                              child: Text(e.toString()),
                                            ))
                                        .toList(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 13.sp,
                                        color: AppColors.blackColor),
                                    hint: Text(StringUtils.required,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 13.sp)),
                                    icon: const SvgImage(
                                        image: AssetsUtils.downArrow,
                                        color: AppColors.middleGray),
                                    iconSize: 30,
                                    onChanged: (DateTime? value) async {
                                      print("object");
                                    },
                                  ),
                                ),
                              ),*/
                            ],
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: labelWidget(
                                text: "Gender",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400),
                              )),
                              Container(
                                height: 45.h,
                                width: 140.w,
                                child: DropdownButtonFormField(
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13.sp,
                                      color: AppColors.blackColor),
                                  hint: Text(StringUtils.required,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 13.sp)),
                                  icon: const SvgImage(
                                      image: AssetsUtils.downArrow,
                                      color: AppColors.middleGray),
                                  iconSize: 30,
                                  items: <String>["Male", "Female"]
                                      .map<DropdownMenuItem>((String value) {
                                    return DropdownMenuItem(
                                      child: Text(value),
                                      value: value,
                                    );
                                  }).toList(),
                                  onChanged: (value) {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ).paddingOnly(right: 16.w, left: 16.w, bottom: 10.w),
                    ),
                  ),
                ],
              ),
              buildButton(
                      context: context,
                      title: "Update",
                      bgColor: AppColors.primaryBlueColor,
                      textColor: AppColors.whiteColor,
                      onPressed: () {})
                  .paddingOnly(
                      right: 16.w, left: 16.w, top: 16.h, bottom: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDatePicker() => Container(
        height: 200,
        // decoration: BoxDecoration(
        //     color: Colors.grey.shade200,
        //     borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(10.w),
        //         topRight: Radius.circular(10.w))),
        width: double.infinity,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: dateTime,
          minimumDate: DateTime(2019),
          maximumYear: DateTime.now().year,
          backgroundColor: Colors.grey.shade200,
          onDateTimeChanged: (dateTime) => setState(() {
            this.dateTime = dateTime;
            print("date : ${dateTime}");
          }),
        ),
      );
}
