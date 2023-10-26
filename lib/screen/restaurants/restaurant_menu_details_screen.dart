import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_cart_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_meal_Add_button.dart';

class RestaurantMenuDetailsScreen extends StatefulWidget {
  const RestaurantMenuDetailsScreen({super.key, required this.data});
  final MenuItemList data;

  @override
  State<RestaurantMenuDetailsScreen> createState() =>
      _RestaurantMenuDetailsScreenState();
}

class _RestaurantMenuDetailsScreenState
    extends State<RestaurantMenuDetailsScreen> {
  int item = 0;
  bool selectFirst = false;
  bool selectSecond = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size.height * 0.45,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.data.image!),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 30.h, left: 15.w),
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.data.name!,
                    style: FontUtils.h24(
                      fontColor: Colors.black,
                      fontWeight: FWT.medium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      widget.data.formattedPrice!,
                      style: FontUtils.h18(
                        fontColor: Colors.black,
                        fontWeight: FWT.medium,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.w, bottom: 10.h),
                    child: Text(
                      'Fried onions, green peppers, mixed cheese, served with fries',
                      style: FontUtils.h14(
                        fontColor: const Color(0xffA2A4A7),
                        fontWeight: FWT.lightMedium,
                      ),
                    ),
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.data.customizations!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${widget.data.customizations![index].name}',
                                style: FontUtils.h18(
                                  fontColor: Colors.black,
                                  fontWeight: FWT.semiBold,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Text(
                                    'Choose 1 option',
                                    style: FontUtils.h14(
                                      fontColor: Colors.black,
                                      fontWeight: FWT.regular,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.coral,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Required',
                                      style: FontUtils.h12(
                                        fontColor: AppColors.terracotta,
                                        fontWeight: FWT.regular,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0xffECECED), width: 1)),
                            child: Column(
                              children: List.generate(
                                widget.data.customizations![index].options!
                                    .length,
                                (index1) => Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          widget.data.customizations![index]
                                              .options![index1].name!,
                                          style: FontUtils.h18(
                                            fontColor: Colors.black,
                                            fontWeight: FWT.medium,
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectFirst = true;
                                            });
                                          },
                                          child: Image.asset(
                                            selectFirst == true
                                                ? AssetsUtils.terracotaCheck
                                                : AssetsUtils.icAdd,
                                            height: 24.h,
                                          ),
                                        )
                                      ],
                                    ),
                                    Divider(
                                      color: const Color(0xffECECED),
                                      thickness: 1,
                                      height: 16.h,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (item != 0) {
                              setState(() {
                                item--;
                              });
                            }
                          },
                          child: Container(
                            height: size.height * 0.060,
                            width: size.height * 0.060,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border:
                                    Border.all(color: AppColors.terracotta)),
                            child: Center(
                                child: item == 1 || item == 0
                                    ? SvgPicture.asset(
                                        AssetsUtils.icDelete,
                                        color: AppColors.terracotta,
                                      )
                                    : const Icon(Icons.remove)),
                            // child: const Center(child: Icon(Icons.remove, size: 27)),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          height: size.height * 0.060,
                          width: size.height * 0.060,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.disable),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                              child: Text(
                            '$item',
                            style: FontUtils.h18(
                                fontWeight: FWT.semiBold,
                                fontColor: AppColors.darkGray),
                          )),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              item++;
                            });
                          },
                          child: Container(
                            height: size.height * 0.060,
                            width: size.height * 0.060,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: AppColors.coral,
                            ),
                            child: const Center(
                              child: Icon(Icons.add,
                                  size: 27, color: AppColors.terracotta),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  RestaurantMealAddButtonWidget(
                    onTap: () {
                      if (item > 0) {
                        Get.to(
                          () => RestaurantCart(data: {
                            'image': AssetsUtils.restaurantFood1,
                            'title': widget.data.name!,
                            'price': widget.data.formattedPrice!,
                            'count': item
                          }),
                          transition: Transition.fadeIn,
                        );
                      }
                    },
                    buttonLable: item == 0 ? 'Add to cart' : 'View Cart',
                    isFillColor: true,
                    selectedItemCount: item,
                  ),
                  // simpleTextBorderButton(
                  //   color: AppColors.terracotta,
                  //   width: size.width,
                  //   isFillColor: true,
                  //   height: 40.h,
                  //   isLoadingWidget: false,
                  //   buttonLable: 'Add to Cart',
                  //   lableColor: Colors.white,
                  //   onTap: () {},
                  //   context: context,
                  //   isDarkColor: false,
                  // ),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Image.asset(
                      AssetsUtils.gymEatsSpoon,
                      height: 22.h,
                      width: 56.w,
                      color: AppColors.terracotta,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
