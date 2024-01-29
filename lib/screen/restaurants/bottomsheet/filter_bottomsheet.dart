import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet(
      {super.key, required this.filterType, this.selectedValue, this.price});
  final String filterType;
  final String? price;
  final List? selectedValue;
  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int selectedIndex = -1;
  List selectedFoodOrigin = [];
  List priceType = [
    '\$',
    '\$\$',
    '\$\$\$',
    '\$\$\$\$',
  ];
  List ratingType = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ];

  @override
  void initState() {
    super.initState();
    selectedFoodOrigin = widget.selectedValue ?? [];
    if (widget.price == '0-10') {
      priceIndex = 0;
    } else if (widget.price == '10-20') {
      priceIndex = 1;
    } else if (widget.price == '20-40') {
      priceIndex = 2;
    } else if (widget.price == '40') {
      priceIndex = 3;
    } else {
      priceIndex = -1;
    }
  }

  int priceIndex = -1;
  String priceValue = '';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Material(
      color: AppColors.whiteColor,
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 3.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.disable),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.filterType,
                  style: FontUtils.h20(
                    fontColor: AppColors.darkGray,
                    fontWeight: FWT.medium,
                  ),
                ),
              ),

              /// Tab bar ----------------------------------------------------------------------
              widget.filterType == 'Price'
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: SizedBox(
                        height: 40.h,
                        child: Center(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: priceType.length,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  // if (selectedFoodOrigin
                                  //     .contains(priceType[index])) {
                                  //   setState(() {
                                  //     selectedFoodOrigin
                                  //         .remove(priceType[index]);
                                  //   });
                                  // } else {
                                  //   setState(() {
                                  //     selectedFoodOrigin.add(priceType[index]);
                                  //   });
                                  // }

                                  setState(() {
                                    priceIndex = index;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  decoration: BoxDecoration(
                                    color: priceIndex == index
                                        ? AppColors.coral
                                        : AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: Text(
                                      priceType[index],
                                      style: FontUtils.h18(
                                        fontColor: priceIndex == index
                                            ? AppColors.terracotta
                                            : AppColors.darkGray,
                                        fontWeight: FWT.medium,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 35.h),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: const Divider(
                                color: AppColors.disabledColor, thickness: 1),
                          ),
                          Positioned(
                            top: -6.h,
                            left: 0,
                            right: 0,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  ratingType.length,
                                  (index) => Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          selectedIndex = index;
                                          if (selectedFoodOrigin
                                              .contains(ratingType[index])) {
                                            setState(() {
                                              selectedFoodOrigin
                                                  .remove(ratingType[index]);
                                            });
                                          } else {
                                            setState(() {
                                              selectedFoodOrigin
                                                  .add(ratingType[index]);
                                              selectedFoodOrigin.sort(
                                                  (a, b) => a.compareTo(b));
                                            });
                                          }
                                        },
                                        child: Icon(
                                          Icons.star,
                                          size: 25.h,
                                          color: selectedFoodOrigin
                                                  .contains(ratingType[index])
                                              ? Colors.black
                                              : AppColors.disabledColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4.h,
                                      ),
                                      Text(
                                        '${ratingType[index]}',
                                        style: FontUtils.h14(
                                          fontColor: Colors.black,
                                          fontWeight: FWT.lightMedium,
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),

              widget.filterType == 'Price'
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: simpleTextBorderButton(
                        context: context,
                        color: AppColors.terracotta,
                        lableColor: AppColors.terracotta,
                        buttonLable: priceIndex == -1 ? 'Back' : 'View Result',
                        height: screenSize.height * 0.065,
                        width: screenSize.width,
                        isLoadingWidget: false,
                        onTap: () {
                          if (priceIndex == -1) {
                            Get.back();
                          } else {
                            if (priceType[priceIndex] == '\$') {
                              priceValue = '0-10';
                            } else if (priceType[priceIndex] == '\$\$') {
                              priceValue = '10-20';
                            } else if (priceType[priceIndex] == '\$\$\$') {
                              priceValue = '20-40';
                            } else {
                              priceValue = '40';
                            }
                            Get.back(
                              result: priceValue,
                            );
                          }
                        },
                        isDarkColor: true,
                        isFillColor: priceIndex == -1 ? false : true,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: simpleTextBorderButton(
                        context: context,
                        color: AppColors.terracotta,
                        lableColor: AppColors.terracotta,
                        buttonLable:
                            selectedFoodOrigin.isEmpty || priceIndex == -1
                                ? 'Back'
                                : 'View Result',
                        height: screenSize.height * 0.065,
                        width: screenSize.width,
                        isLoadingWidget: false,
                        onTap: () {
                          if (selectedIndex == -1 || priceIndex == -1) {
                            Get.back();
                          } else {
                            Get.back(result: selectedFoodOrigin);
                          }
                        },
                        isDarkColor: true,
                        isFillColor: selectedFoodOrigin.isEmpty ? false : true,
                      ),
                    ),

              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFoodOrigin.clear();
                      priceIndex = -1;
                    });
                  },
                  child: Text(
                    'Reset',
                    style: FontUtils.h18(
                      fontColor: AppColors.darkGray,
                      fontWeight: FWT.medium,
                    ),
                  ),
                ),
              ),
              // const SizedBox(
              //   height: 30,
              // ),
              // Center(
              //   child: Image.asset(
              //     AssetsUtils.gymEatsSpoon,
              //     height: 20.h,
              //     width: 55.w,
              //     color: AppColors.terracotta,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
