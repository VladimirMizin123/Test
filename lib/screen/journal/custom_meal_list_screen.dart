import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/journal/custom_meal_bloc/custom_meal_bloc.dart';
import 'package:gymeats_mobile/bloc/journal/custom_meal_bloc/custom_meal_event.dart';
import 'package:gymeats_mobile/bloc/journal/custom_meal_bloc/custom_meal_item_state.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/get_custom_meal_list_model.dart';
import 'package:gymeats_mobile/screen/journal/add_new_item_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../widget/svg_image.dart';

class CustomMealList extends StatefulWidget {
  final String type;
  final DateTime? dateTime;
  const CustomMealList({super.key, required this.type, required this.dateTime});

  @override
  State<CustomMealList> createState() => _CustomMealListState();
}

class _CustomMealListState extends State<CustomMealList> {
  AddNewMealBloc addNewMealBloc = AddNewMealBloc();
  List<CustomMealDetails> customMealList = [];
  List<CustomMealDetails> searchCustomMealList = [];
  bool isCustomMealFetchLoadingState = false;
  bool isSearchOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      addNewMealBloc.add(GetCustomListEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    log('DATATATA>>>>$customMealList');
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer(
        bloc: addNewMealBloc,
        listener: (context, state) {
          ///----------Loading State
          if (state is GetCustomMealListLoadingState) {
            isCustomMealFetchLoadingState = true;
          }

          ///----------Error State
          if (state is GetCustomMealListErrorState) {
            isCustomMealFetchLoadingState = false;
          }

          ///----------Success State
          if (state is GetCustomMealListSuccessState) {
            log('---->>>${state.customMealDetails}');

            log('state.customMealDetails!.isNotEmpty---------->>>>>> ${state.customMealDetails!.isNotEmpty}');

            if (state.customMealDetails!.isNotEmpty) {
              for (var e in state.customMealDetails!) {
                if (e.type == widget.type.toString().capitalizeFirst ||
                    e.type!.trim() == widget.type.trim() ||
                    e.type == '${widget.type[0].toLowerCase()}${widget.type.substring(1)}') {
                  customMealList.add(e);
                }
              }
            } else {
              customMealList = [];
            }

            log('customMealList---------->>>>>> ${customMealList.length}');

            // customMealList = state.customMealDetails ?? [];
            isCustomMealFetchLoadingState = false;
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SizedBox(
              height: size.height.h,
              width: size.width.w,
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
                          Navigator.pop(context);
                        },
                        child: const SvgImage(
                          image: AssetsUtils.icBack,
                          color: AppColors.darkGray,
                        ),
                      ),
                      Text('Custom List', style: FontUtils.h20(fontColor: AppColors.oxFF010101, fontWeight: FWT.semiBold)),
                      const SizedBox()
                    ],
                  ).paddingSymmetric(horizontal: 20.w, vertical: 5.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12.h),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        boxShadow: boxShadowWidget,
                      ),
                      child: TextFormField(
                        readOnly: false,
                        onChanged: (String? value) {
                          if (value!.isNotEmpty) {
                            setState(() {
                              isSearchOn = true;

                              // searchEdgesList = groceryDetails
                              //     .where((item) => item.productName!
                              //         .toLowerCase()
                              //         .contains(value!.toLowerCase()))
                              //     .toList();

                              searchCustomMealList = customMealList.where((item) {
                                return item.name!.toLowerCase().contains(value.toLowerCase());
                              }).toList();
                            });
                          } else {
                            setState(() {
                              isSearchOn = false;
                            });
                          }
                        },
                        style: FontUtils.h16(fontColor: AppColors.black, fontWeight: FWT.regular),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          hintText: 'Search',
                          // hintStyle: FontUtils.h16(),
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: customMealList.isEmpty
                        ? isCustomMealFetchLoadingState
                            ? SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: ListView.builder(
                                  itemCount: 10,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                      child: Shimmer.fromColors(
                                          baseColor: AppColors.disable.withOpacity(0.20),
                                          highlightColor: AppColors.disable.withOpacity(0.20),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    width: 240,
                                                    decoration: BoxDecoration(color: AppColors.disable, borderRadius: BorderRadius.circular(5)),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 4,
                                                    child: Container(
                                                      height: 20,
                                                      decoration: BoxDecoration(color: AppColors.disable, borderRadius: BorderRadius.circular(4)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              const Divider(color: AppColors.disable, thickness: 1.2),
                                            ],
                                          )),
                                    );
                                  },
                                ),
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: 50.h,
                                  ),
                                  SvgPicture.asset(AssetsUtils.emptyShoppingListIcon),
                                  Text(
                                    'Your Custom Meal List is\n empty.',
                                    textAlign: TextAlign.center,
                                    style: FontUtils.h14(fontWeight: FWT.regular),
                                  ),
                                ],
                              )
                        : isSearchOn == true
                            ? searchCustomMealList.isNotEmpty

                                ///Searched Data Display ===================================================

                                ? SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: ListView.builder(
                                      itemCount: searchCustomMealList.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          child: GestureDetector(
                                            onTap: () {
                                              /*Get.toNamed(
                                                '/GroceryItemDetails',
                                                arguments:
                                                    GroceryItemDetailsArguments(
                                                  isShowData: true,
                                                  fat: searchCustomMealList[
                                                          index]
                                                      .fat,
                                                  imageUrl:
                                                      searchCustomMealList[
                                                              index]
                                                          .imageUrl,
                                                  carbs: searchCustomMealList[
                                                          index]
                                                      .carbs,
                                                  cal: searchCustomMealList[
                                                          index]
                                                      .calorie,
                                                  protein: searchCustomMealList[
                                                          index]
                                                      .protein,
                                                  productName:
                                                      customMealList[index]
                                                          .name,
                                                  quantity:
                                                      customMealList[index]
                                                          .quantity,
                                                  isFromCustomMealScreen: true,
                                                ),
                                              );*/
                                              Get.to(
                                                  () => AddNewItemScreen(
                                                      id: searchCustomMealList[index].id,
                                                      name: searchCustomMealList[index].name,
                                                      cal: searchCustomMealList[index].calorie.toString(),
                                                      carbs: searchCustomMealList[index].carbs.toString(),
                                                      fat: searchCustomMealList[index].fat.toString(),
                                                      protein: searchCustomMealList[index].protein.toString(),
                                                      weight: searchCustomMealList[index].quantity.toString(),
                                                      imageUrl: searchCustomMealList[index].imageUrl),
                                                  arguments: widget.type);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white, boxShadow: boxShadowWidget, borderRadius: BorderRadius.circular(8)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(12),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          width: 280.w,
                                                          child: Text(
                                                            '${searchCustomMealList[index].name.toString().capitalizeFirst}',
                                                            style: FontUtils.h16(fontColor: AppColors.black, fontWeight: FWT.medium),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 300.w,
                                                          child: Text(
                                                            'Calories : ${searchCustomMealList[index].calorie?.toStringAsFixed(2) ?? 0}, Protein : ${searchCustomMealList[index].protein?.toStringAsFixed(2) ?? 0} , Carbs : ${searchCustomMealList[index].carbs?.toStringAsFixed(2) ?? 0} , fat : ${searchCustomMealList[index].fat?.toStringAsFixed(2) ?? 0}',
                                                            style: FontUtils.h12(
                                                              fontColor: AppColors.middleGray,
                                                              fontWeight: FWT.medium,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : const Center(
                                    child: Text('No Search Found!', style: TextStyle(color: AppColors.middleGray)),
                                  )

                            ///Regular Data Display ===================================================
                            : SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: ListView.builder(
                                  itemCount: customMealList.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      child: GestureDetector(
                                        onTap: () {
                                          /* Get.toNamed(
                                            '/GroceryItemDetails',
                                            arguments:
                                                GroceryItemDetailsArguments(
                                              isShowData: true,
                                              imageUrl: customMealList[index]
                                                  .imageUrl,
                                              fat: customMealList[index].fat,
                                              carbs:
                                                  customMealList[index].carbs,
                                              cal:
                                                  customMealList[index].calorie,
                                              protein:
                                                  customMealList[index].protein,
                                              productName:
                                                  customMealList[index].name,
                                              isFromCustomMealScreen: true,
                                              quantity: customMealList[index]
                                                  .quantity,
                                            ),
                                          );*/

                                          Get.to(
                                              () => AddNewItemScreen(
                                                    id: customMealList[index].id,
                                                    name: customMealList[index].name,
                                                    cal: customMealList[index].calorie.toString(),
                                                    carbs: customMealList[index].carbs.toString(),
                                                    fat: customMealList[index].fat.toString(),
                                                    protein: customMealList[index].protein.toString(),
                                                    weight: customMealList[index].quantity.toString(),
                                                    imageUrl: customMealList[index].imageUrl,
                                                  ),
                                              arguments: widget.type);
                                        },
                                        child: Container(
                                          decoration:
                                              BoxDecoration(color: Colors.white, boxShadow: boxShadowWidget, borderRadius: BorderRadius.circular(8)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 280.w,
                                                      child: Text(
                                                        '${customMealList[index].name.toString().capitalizeFirst}',
                                                        style: FontUtils.h16(fontColor: AppColors.black, fontWeight: FWT.medium),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 300.w,
                                                      child: Text(
                                                        'Calories : ${customMealList[index].calorie?.toStringAsFixed(2) ?? 0}, Protein : ${customMealList[index].protein?.toStringAsFixed(2) ?? 0} , Carbs : ${customMealList[index].carbs?.toStringAsFixed(2) ?? 0} , fat : ${customMealList[index].fat?.toStringAsFixed(2) ?? 0}',
                                                        style: FontUtils.h12(
                                                          fontColor: AppColors.middleGray,
                                                          fontWeight: FWT.medium,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                  ),
                  !(widget.dateTime!.day == DateTime.now().day)
                      ? SizedBox()
                      : buildButton(
                          context: context,
                          bgColor: AppColors.primaryBlue,
                          hasImage: false,
                          onPressed: () {
                            log("null");
                            Get.toNamed("/AddNewItemScreen", arguments: widget.type);
                          },
                          textColor: Colors.white,
                          title: StringUtils.addNewItem,
                        ).paddingOnly(bottom: 30.h, top: 10.h, right: 14, left: 14),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
