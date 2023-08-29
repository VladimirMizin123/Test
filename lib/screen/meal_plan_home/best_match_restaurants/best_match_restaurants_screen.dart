import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_bloc.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_event.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_state.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/product_restaurant_search_screen.dart';
import 'package:gymeats_mobile/widget/cache_network_image_widget.dart';

class BestMatchRestaurantsScreen extends StatefulWidget {
  const BestMatchRestaurantsScreen({super.key});

  @override
  State<BestMatchRestaurantsScreen> createState() => _BestMatchRestaurantsScreenState();
}

class _BestMatchRestaurantsScreenState extends State<BestMatchRestaurantsScreen> {
  MealPlanBloc mealPlanBloc = MealPlanBloc();

  List<RestaurantProduct> productsList = [];

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    mealPlanBloc.add(RestaurantSearchEvent(name: 'Spicy Beans On Toast', latitude: '37.7786357', longitude: '-122.3918135', maximumMiles: '1.5', pickup: false));
    // });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocConsumer<MealPlanBloc, FetchMealPlanState>(
        bloc: mealPlanBloc,
        listener: (context, state) {
          if (state is RestaurantSearchSuccessState) {
            productsList = state.restaurantSearchData!.products!;
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                const GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(21.2408, 72.8806),
                    zoom: 15,
                  ),
                ),
                Positioned(
                    top: 40,
                    left: 15,
                    child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(Icons.keyboard_arrow_left_sharp, color: AppColors.darkGray, size: 40))),
                DraggableScrollableSheet(
                    initialChildSize: 0.4,
                    minChildSize: 0.2,
                    maxChildSize: 0.7,
                    builder: (BuildContext context, ScrollController scrollController) {
                      return Container(
                        color: AppColors.whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 3.h,
                                    width: 80.w,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.disable),
                                  )),
                              const SizedBox(height: 15),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'See Best Matches',
                                  style: FontUtils.h22(fontColor: AppColors.darkGray, fontWeight: FWT.bold),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Expanded(
                                child: state is RestaurantSearchLoadingState
                                    ? const Center(
                                        child: CircularProgressIndicator(color: AppColors.primaryBlue),
                                      )
                                    : productsList.isEmpty
                                        ? const SizedBox()
                                        : ListView.builder(
                                            controller: scrollController,
                                            itemCount: productsList.length,
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(bottom: 12),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Stack(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius: BorderRadius.circular(12),
                                                                child: SizedBox(height: screenSize.height * 0.25, width: double.infinity, child: CachedNetworkImageWidget(imgURL: productsList[index].image ?? '')
                                                                    //  Image.network(
                                                                    //   // AssetsUtils.defaultImage,
                                                                    //   productsList[index].image!,
                                                                    //   fit: BoxFit.cover,
                                                                    // ),
                                                                    ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 12, left: 12),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        color: AppColors.whiteColor,
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                                        child: Text(
                                                                          'Free delivery',
                                                                          style: FontUtils.h12(fontColor: AppColors.black, fontWeight: FWT.semiBold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 10),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        color: AppColors.whiteColor,
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                                        child: Text(
                                                                          '-10% off',
                                                                          style: FontUtils.h12(fontColor: AppColors.terracotta, fontWeight: FWT.semiBold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 12, left: 12),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        color: AppColors.whiteColor,
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                                        child: Text(
                                                                          'Free delivery',
                                                                          style: FontUtils.h12(fontColor: AppColors.black, fontWeight: FWT.semiBold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 10),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        color: AppColors.whiteColor,
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                                        child: Text(
                                                                          '-10% off',
                                                                          style: FontUtils.h12(fontColor: AppColors.terracotta, fontWeight: FWT.semiBold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Positioned(
                                                                right: 12,
                                                                bottom: 12,
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: AppColors.whiteColor,
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(AssetsUtils.icThumbUpLine),
                                                                        const SizedBox(width: 5),
                                                                        Text(
                                                                          '95%',
                                                                          style: FontUtils.h16(fontColor: AppColors.black, fontWeight: FWT.semiBold),
                                                                        ),
                                                                        const SizedBox(width: 5),
                                                                        Text(
                                                                          '(145)',
                                                                          style: FontUtils.h14(fontColor: AppColors.disable, fontWeight: FWT.light),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 5),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(productsList[index].itemName ?? '', overflow: TextOverflow.ellipsis, maxLines: 2, style: FontUtils.h18(fontColor: AppColors.darkGray, fontWeight: FWT.semiBold)),
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                  color: AppColors.lightGrey,
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                                  child: Text(
                                                                    productsList[index].category ?? '',
                                                                    style: FontUtils.h14(fontColor: AppColors.black, fontWeight: FWT.regular),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset(AssetsUtils.icScooter),
                                                              const SizedBox(width: 10),
                                                              Text(productsList[index].formattedPrice ?? '', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                                              const SizedBox(width: 10),
                                                              const CircleAvatar(maxRadius: 3, backgroundColor: AppColors.darkGray),
                                                              const SizedBox(width: 10),
                                                              Text('15-25 min', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 5),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          );
        });
  }
}
