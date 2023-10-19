import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List mealType = [
    'Rating   >',
    'Price   >',
    'Fast Delivery   >',
  ];
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                padding: const EdgeInsets.only(top: 8, bottom: 21),
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
              Text(
                'Sort by',
                style: FontUtils.h24(
                  fontColor: const Color(0xff000000),
                  fontWeight: FWT.medium,
                ),
              ),

              /// Tab bar ----------------------------------------------------------------------
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 24),
                child: SizedBox(
                  height: 40.h,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: mealType.length,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            vertical: 9, horizontal: 15),
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Text(
                            mealType[index],
                            style: FontUtils.h18(
                              fontColor: AppColors.darkGray,
                              fontWeight: FWT.medium,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              Text(
                'Browse by category',
                style: FontUtils.h24(
                  fontColor: Colors.black,
                  fontWeight: FWT.medium,
                ),
              ),
              const SizedBox(
                height: 16,
              ),

              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 110,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff004C63).withOpacity(0.08),
                            offset: const Offset(0, 0),
                            blurRadius: 16,
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
