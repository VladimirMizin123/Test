import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_cousines_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_list_model.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen(
      {super.key, required this.cousinesList, required this.restaurantList});
  final CousinesList cousinesList;
  final List<RestaurantList> restaurantList;
  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List mealType = [
    'Rating',
    'Price',
    'Fast Delivery',
  ];

  List mealData = [
    {
      'image': AssetsUtils.food,
      'title': 'Asian',
    },
    {
      'image': AssetsUtils.food1,
      'title': 'Italian',
    },
    {
      'image': AssetsUtils.food2,
      'title': 'Chinese',
    },
    {
      'image': AssetsUtils.food,
      'title': 'Asian',
    },
    {
      'image': AssetsUtils.food1,
      'title': 'Italian',
    },
    {
      'image': AssetsUtils.food2,
      'title': 'Chinese',
    },
    {
      'image': AssetsUtils.food,
      'title': 'Asian',
    },
    {
      'image': AssetsUtils.food1,
      'title': 'Italian',
    },
    {
      'image': AssetsUtils.food2,
      'title': 'Chinese',
    },
    {
      'image': AssetsUtils.food,
      'title': 'Asian',
    },
    {
      'image': AssetsUtils.food1,
      'title': 'Italian',
    },
    {
      'image': AssetsUtils.food2,
      'title': 'Chinese',
    },
  ];
  List selectedTabData = [];
  List selectedCategoryData = [];
  List<RestaurantList> data = [];

  Map<String, dynamic> alldata = {};

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                AssetsUtils.gymEatsSpoon,
                height: 22.h,
                width: 56.w,
                color: AppColors.terracotta,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 8, bottom: 21, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                    ),
                  ),
                  const Text(
                    'All Filters',
                    style: TextStyle(
                      color: Color(0xFF010101),
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    width: 30,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Sort by',
                style: FontUtils.h24(
                  fontColor: const Color(0xff000000),
                  fontWeight: FWT.medium,
                ),
              ),
            ),

            /// Tab bar ----------------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.only(
                  top: 16, bottom: 24, right: 16, left: 16),
              child: SizedBox(
                height: 40.h,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: mealType.length,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (selectedTabData.contains(mealType[index])) {
                          setState(() {
                            selectedTabData.remove(mealType[index]);
                          });
                        } else {
                          setState(() {
                            selectedTabData.add(mealType[index]);
                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: selectedTabData.contains(mealType[index])
                              ? AppColors.coral
                              : AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          children: [
                            index == 0
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: Icon(
                                      Icons.star,
                                      color: selectedTabData
                                              .contains(mealType[index])
                                          ? AppColors.terracotta
                                          : AppColors.darkGray,
                                    ),
                                  )
                                : const SizedBox(),
                            Text(
                              mealType[index],
                              style: FontUtils.h18(
                                fontColor:
                                    selectedTabData.contains(mealType[index])
                                        ? AppColors.terracotta
                                        : AppColors.darkGray,
                                fontWeight: FWT.medium,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 15,
                              color: selectedTabData.contains(mealType[index])
                                  ? AppColors.terracotta
                                  : AppColors.darkGray,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Browse by category',
                style: FontUtils.h24(
                  fontColor: Colors.black,
                  fontWeight: FWT.medium,
                ),
              ),
            ),

            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: MediaQuery.of(context).size.height * 0.13,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: widget.cousinesList.cousines!.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (selectedCategoryData
                          .contains(widget.cousinesList.cousines![index])) {
                        setState(() {
                          selectedCategoryData
                              .remove(widget.cousinesList.cousines![index]);
                        });
                      } else {
                        setState(() {
                          selectedCategoryData
                              .add(widget.cousinesList.cousines![index]);
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedCategoryData
                                .contains(widget.cousinesList.cousines![index])
                            ? AppColors.coral
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: selectedCategoryData
                                .contains(widget.cousinesList.cousines![index])
                            ? Border.all(color: AppColors.terracotta)
                            : const Border(),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff004C63).withOpacity(0.08),
                            offset: const Offset(0, 0),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 4.h, left: 3.h),
                              child: SizedBox(
                                width: 70.w,
                                child: Text(
                                  widget.cousinesList.cousines![index],
                                  style: FontUtils.h17(
                                    fontColor: Colors.black,
                                    fontWeight: FWT.regular,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            // height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 0.22,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  AssetsUtils.food1,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryData.clear();
                      });
                    },
                    child: Container(
                      height: 48,
                      width: MediaQuery.of(context).size.width / 2.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(
                            color: selectedCategoryData.isEmpty
                                ? AppColors.disabledColor
                                : AppColors.terracotta,
                            width: 2),
                      ),
                      child: Center(
                        child: Text(
                          'Clear',
                          style: FontUtils.h18(
                            fontColor: selectedCategoryData.isEmpty
                                ? AppColors.disabledColor
                                : AppColors.terracotta,
                            fontWeight: FWT.medium,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (selectedCategoryData.isEmpty) {
                        Fluttertoast.showToast(
                          msg: 'Select atleast 1 Category',
                        );
                      } else {
                        // for (var i = 0; i < widget.restaurantList.length; i++) {
                        //   for (var j = 0;
                        //       j < widget.restaurantList[i].cuisines!.length;
                        //       j++) {
                        //     print(
                        //         '---$i-->>>>>${widget.restaurantList[i].cuisines![j]}');
                        //
                        //     if (widget.restaurantList[i].cuisines![j]
                        //         .contains('Bagels')) {
                        //       print('YESSSS');
                        //     }
                        //   }
                        // }
                        data.clear();
                        for (var i = 0; i < widget.restaurantList.length; i++) {
                          for (var j = 0;
                              j < widget.restaurantList[i].cuisines!.length;
                              j++) {
                            for (var k = 0;
                                k < selectedCategoryData.length;
                                k++) {
                              if (widget.restaurantList[i].cuisines![j]
                                  .contains(selectedCategoryData[k]
                                      .toString()
                                      .trim())) {
                                data.add(widget.restaurantList[i]);
                                print('----->>>>.1');
                              }
                            }
                          }
                        }
                        alldata = {
                          'restaurantData': data,
                          'filterTab': selectedCategoryData
                        };

                        Get.back(result: alldata);
                      }
                    },
                    child: Container(
                      height: 48,
                      width: MediaQuery.of(context).size.width / 2.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: selectedCategoryData.isEmpty
                            ? AppColors.disabledColor
                            : AppColors.terracotta,
                        border: Border.all(
                          color: selectedCategoryData.isEmpty
                              ? AppColors.disabledColor
                              : AppColors.terracotta,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Apply',
                          style: FontUtils.h18(
                            fontColor: Colors.white,
                            fontWeight: FWT.medium,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
