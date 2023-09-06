import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_item_details.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';

class GrocerySearchScreen extends StatefulWidget {
  const GrocerySearchScreen({super.key});

  @override
  State<GrocerySearchScreen> createState() => _GrocerySearchScreenState();
}

class _GrocerySearchScreenState extends State<GrocerySearchScreen> {
  TextEditingController searchController = TextEditingController();
  GroceryBloc groceryBloc = GroceryBloc();

  List<Product> groceryMultiSearchModelDataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GroceryBloc, GroceryState>(
          bloc: groceryBloc,
          listener: (context, state) {
            if (state is GrocerySearchSuccessState) {
              groceryMultiSearchModelDataList = state.groceryMultiSearchProductList ?? [];
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Column(
                children: [
                  Image.asset(
                    AssetsUtils.gymEatsLogo,
                    height: 20.h,
                    width: 56.w,
                    color: AppColors.primaryBlue,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.keyboard_arrow_left_outlined, size: 30)),
                      Text('Grocery List', style: FontUtils.h20(fontColor: AppColors.oxFF010101, fontWeight: FWT.semiBold)),
                      Opacity(
                        opacity: 0,
                        child: Image.asset(
                          AssetsUtils.filter,
                          height: 20.h,
                          width: 20.w,
                          color: AppColors.darkGray,
                        ),
                      )
                    ],
                  ).paddingSymmetric(horizontal: 6, vertical: 5.h),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: searchController,
                      onSubmitted: (String value) {
                        groceryBloc.add(GrocerySearchEvent(searchValue: searchController.text));
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search for item',
                        hintStyle: FontUtils.h16(),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Expanded(
                    child: state is GrocerySearchLoadingState
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            itemCount: groceryMultiSearchModelDataList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed('/GroceryItemDetails',arguments: GroceryItemDetailsArguments(product: groceryMultiSearchModelDataList[index]));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(color: Colors.white, boxShadow: boxShadowWidget, borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'White Bread',
                                                style: FontUtils.h16(fontColor: AppColors.black, fontWeight: FWT.medium),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '1 slice, Dave’s Killer Bread - ',
                                                    style: FontUtils.h12(fontColor: AppColors.middleGray, fontWeight: FWT.medium),
                                                  ),
                                                  Text(
                                                    '110 cal',
                                                    style: FontUtils.h12(fontColor: AppColors.black, fontWeight: FWT.medium),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SvgPicture.asset(AssetsUtils.icAddCircle, height: 30),
                                          // SvgPicture.asset(AssetsUtils.icAddIcon, height: 30),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
