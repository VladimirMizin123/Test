import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/restaurants/bottomsheet/filter_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_meal_details_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_menu_details_screen.dart';

class RestaurantMenuScreen extends StatefulWidget {
  const RestaurantMenuScreen({super.key, this.restaurantName});
  final String? restaurantName;

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  List tabMenu = [
    'BreakFast',
    'Lunch',
    'Snack',
    'Dinner',
  ];

  List selectedTabData = [];

  List mealType = [
    'I can eat',
    'Price',
    'Rating',
  ];

  List<Map<String, dynamic>> menuData = [
    {
      'image': AssetsUtils.restaurantFood,
      'title': 'Smoked Mackerel Salad With Fennel And Apple',
      'ingredients':
          'Fried onions, green peppers, mixed cheese, served with fries',
      'price': '\$6.00',
      'canEatImage': AssetsUtils.icCanEat
    },
    {
      'image': AssetsUtils.restaurantFood1,
      'title': 'Pizza With Mozzarella',
      'ingredients':
          'Fried onions, green peppers, mixed cheese, served with fries',
      'price': '\$8.00',
      'canEatImage': AssetsUtils.icCanEat
    },
    {
      'image': AssetsUtils.restaurantFood2,
      'title': 'Pork With Potatoes',
      'ingredients':
          'Fried onions, green peppers, mixed cheese, served with fries',
      'price': '\$5.00',
      'canEatImage': AssetsUtils.canEatYellow
    },
    {
      'image': AssetsUtils.restaurantFood,
      'title': 'Smoked Mackerel Salad With Fennel And Apple',
      'ingredients':
          'Fried onions, green peppers, mixed cheese, served with fries',
      'price': '\$6.00',
      'canEatImage': AssetsUtils.canEatRed
    },
  ];

  int select = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
              padding:
                  EdgeInsets.only(top: 8, bottom: 20.h, left: 16, right: 16),
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
                  Text(
                    '${widget.restaurantName} Menu',
                    style: const TextStyle(
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

            /// Meal type Slider ------------------------------------------------------------
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    tabMenu.length,
                    (index) => GestureDetector(
                      onTap: () async {
                        setState(() {
                          select = index;
                          // tabMenu[controller.select];
                        });
                      },
                      child: Container(
                        height: 30.h,
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        decoration: BoxDecoration(
                          border: BorderDirectional(
                            bottom: BorderSide(
                              color: index == select
                                  ? AppColors.primaryBlue
                                  : AppColors.disabledColor,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            tabMenu[index],
                            style: FontUtils.h18(
                              fontWeight: FWT.medium,
                              fontColor: index == select
                                  ? AppColors.primaryBlue
                                  : AppColors.disabledColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// Tab bar ----------------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 20),
              child: SizedBox(
                height: 40.h,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: mealType.length,
                  padding: const EdgeInsets.only(left: 16),
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

                        if (index != 0) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return FilterBottomSheet(
                                filterType: mealType[index],
                              );
                            },
                            isDismissible: false,
                            shape: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.r),
                                topRight: Radius.circular(16.r),
                              ),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                          );
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            mealType[index] == 'Rating'
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
                            index != 0
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      size: 15,
                                      color: selectedTabData
                                              .contains(mealType[index])
                                          ? AppColors.terracotta
                                          : AppColors.darkGray,
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            /// Restaurant Menu ----------------------------------------------------------------

            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: menuData.length,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => RestaurantMealDetails(
                          mealName: menuData[index]['title'],
                        ),
                        transition: Transition.fadeIn,
                      );
                    },
                    child: Column(
                      children: [
                        IntrinsicHeight(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  menuData[index]['image'],
                                  width: 80.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 140.w,
                                          child: Text(
                                            menuData[index]['title'],
                                            style: FontUtils.h16(
                                                fontColor: AppColors.darkGray,
                                                fontWeight: FWT.regular),
                                          ),
                                        ),
                                        Image.asset(
                                          menuData[index]['canEatImage'],
                                          width: 30.w,
                                          height: 30.h,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 160.w,
                                      child: Text(
                                        menuData[index]['ingredients'],
                                        style: FontUtils.h14(
                                          fontColor: const Color(0xffA2A4A7),
                                          fontWeight: FWT.light,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      menuData[index]['price'],
                                      style: FontUtils.h18(
                                        fontColor: Colors.black,
                                        fontWeight: FWT.medium,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          () => RestaurantMenuDetailsScreen(
                                            data: menuData[index],
                                          ),
                                          transition: Transition.fadeIn,
                                        );
                                      },
                                      child: Image.asset(
                                        AssetsUtils.icAdd,
                                        height: 22.h,
                                        alignment: Alignment.bottomRight,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          endIndent: 20.w,
                          indent: 20.w,
                          color: AppColors.disabledColor,
                          thickness: 1,
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
    );
  }
}
