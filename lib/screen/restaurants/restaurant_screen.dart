import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/get_all_restriction_modal.dart';
import 'package:gymeats_mobile/screen/restaurants/bottomsheet/delivery_order_option_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/filter_screen.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const DeliverOrderBottomSheet();
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

  List mealType = [
    'All   >',
    'Italian',
    'Chinese',
    'Asian',
    'Healthy',
    'Cheap',
  ];

  List restaurantData = [
    {
      'type': 'Free Delivery',
      'image': AssetsUtils.restaurantFood,
      'name': 'GaGa',
      'origin': 'Italian',
    },
    {
      'type': 'Eat out only',
      'image': AssetsUtils.restaurantFood1,
      'name': 'Asian Rest',
      'origin': 'Asian',
    },
    {
      'type': 'Pick up only',
      'image': AssetsUtils.restaurantFood2,
      'name': 'Italian Rest',
      'origin': 'Italian',
    },
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showBottomSheet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(
                height: 5.h,
              ),
              Center(
                child: Image.asset(
                  AssetsUtils.gymEatsSpoon,
                  height: 22.h,
                  width: 56.w,
                  color: AppColors.terracotta,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Get.toNamed('ProfileScreen');
                    },
                    child: Image.asset(
                      AssetsUtils.user,
                      height: 25.h,
                      width: 25.w,
                      color: AppColors.darkGray,
                    ),
                  ),
                  Text(
                    StringUtils.restaurants,
                    style: textTheme.displayMedium?.copyWith(
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w500,
                        fontSize: 24),
                  ),
                  Image.asset(
                    AssetsUtils.notification,
                    height: 25.h,
                    width: 25.w,
                    color: AppColors.darkGray,
                  )
                ],
              ),

              /// Choose Delivery type ---------------------------------------------------------
              GestureDetector(
                onTap: () {
                  showBottomSheet();
                },
                child: Container(
                  height: 30,
                  width: 225.w,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.terracotta, width: 1),
                    color: AppColors.coral,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        AssetsUtils.deliveryVehicle,
                        width: 15,
                        height: 15,
                        color: AppColors.terracotta,
                      ),
                      const Text(
                        'Choose delivery type',
                        style: TextStyle(
                            color: AppColors.terracotta,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Avenir'),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.terracotta,
                      )
                    ],
                  ),
                ),
              ),

              /// Search bar -------------------------------------------------------------------

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 48,
                      width: 245.w,
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
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.darkGray,
                          ),
                          contentPadding: const EdgeInsets.all(0),
                          hintText: 'Search for item or place',
                        ),
                        onTap: () {
                          Get.to(
                            () => const FilterScreen(),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 48,
                      width: 77,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            AssetsUtils.icShoppingIcon,
                            color: AppColors.darkGray,
                          ),
                          Text(
                            '0',
                            style: FontUtils.h18(
                                fontColor: AppColors.darkGray,
                                fontWeight: FWT.medium),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// Location ---------------------------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AssetsUtils.icRestaurants,
                    height: 14,
                    width: 12,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    '88 Road Square Str.',
                    style: FontUtils.h14(
                      fontColor: AppColors.darkGray,
                      fontWeight: FWT.lightMedium,
                    ),
                  )
                ],
              ),

              /// Tab bar ----------------------------------------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
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
                        )),
                      );
                    },
                  ),
                ),
              ),

              /// Restaurant list --------------------------------------------------------------

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: ListView.separated(
                  itemCount: restaurantData.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 10, top: 5),
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 16,
                    );
                  },
                  itemBuilder: (context, index) => Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          height: 160,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage(restaurantData[index]['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 109,
                                margin: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Text(
                                    restaurantData[index]['type'],
                                    style: FontUtils.h16(
                                      fontColor: Colors.black,
                                      fontWeight: FWT.regular,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  height: 30,
                                  width: 109,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  margin: const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SvgPicture.asset(AssetsUtils.icLike),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Center(
                                          child: Text(
                                            '95%',
                                            style: FontUtils.h16(
                                              fontColor: Colors.black,
                                              fontWeight: FWT.regular,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          '(145)',
                                          style: FontUtils.h12(
                                            fontColor: AppColors.disable,
                                            fontWeight: FWT.regular,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                restaurantData[index]['name'],
                                style: FontUtils.h18(
                                  fontColor: AppColors.darkGray,
                                  fontWeight: FWT.semiBold,
                                ),
                              ),
                              Container(
                                height: 22,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    restaurantData[index]['origin'],
                                    style: FontUtils.h14(
                                      fontColor: AppColors.darkGray,
                                      fontWeight: FWT.lightMedium,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Image.asset(
                              AssetsUtils.deliveryVehicle,
                              width: 15,
                              height: 15,
                              color: AppColors.darkGray,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              '\$ 20.99  •  15-25 min',
                              style: FontUtils.h14(
                                fontColor: AppColors.darkGray,
                                fontWeight: FWT.lightMedium,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
