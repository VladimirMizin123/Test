import 'dart:developer';

import 'package:either_dart/either.dart';
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
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/models/get_custom_meal_list_model.dart';
import 'package:gymeats_mobile/models/get_meallogby_date_model.dart';
import 'package:gymeats_mobile/screen/journal/add_new_item_screen.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_repository.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_repository.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/fatch_meal_details_model.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';
import 'package:intl/intl.dart';
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

  final MealPlanRepository _repo = MealPlanRepository();
  final JournalPlanRepository _journal = JournalPlanRepository();
  bool invoiceLoader = false;
  String? loadingId;
  List<Map<String, dynamic>> mealLog = [];
  Map<String, FetchMealDetailsModel> invoiceMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      addNewMealBloc.add(GetCustomListEvent());
      fetchJournalPlanBloc();
    });
  }

  Future<void> fetchJournalPlanBloc() async {
    try {
      DateTime time = widget.dateTime ?? DateTime.now();
      Either<ErrorModel, GetMealLogByDate> res = await _journal
          .getMealLogByDate(DateFormat('yyyy-MM-dd').format(time));
      if (res.isRight) {
        mealLog = res.right.data
                ?.map(
                  (e) => {"id": e.id, "name": e.mealName ?? ""},
                )
                .toList() ??
            [];
        setState(() {});
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> logMealPlan(String mealName) async {
    try {
      loadingId = mealName;
      setState(() {});
      if (!invoiceMap.containsKey(mealName)) {
        FetchMealDetailsModel? model =
            await _repo.findRecipeFromApi(recipeName: mealName);
        if (model != null) {
          invoiceMap[mealName] = model;
          setState(() {});
        }
      }
      bool isContain = invoiceMap.containsKey(mealName);
      if (isContain) {
        FetchMealDetailsModel? model = invoiceMap[mealName];
        final res = await _journal.addEatenMeal(
          mealId: null,
          mealName: mealName,
          calorie: model?.data?.recipe?.nutritionalInfo?.calories,
          mealType: widget.type.trim(),
          noOfServing: 0,
          recipeId: null,
          value: 1,
          protein: model?.data?.recipe?.nutritionalInfo?.protein,
          fat: model?.data?.recipe?.nutritionalInfo?.fat,
          carbs: model?.data?.recipe?.nutritionalInfo?.carbs,
          date: widget.dateTime?.toIso8601String(),
        );
        if (res.isRight) {
          await fetchJournalPlanBloc();
        }
      }
    } catch (e) {
      log(e.toString());
    } finally {
      loadingId = null;
      setState(() {});
    }
  }

  Future<void> removeMealPlan(String mealName) async {
    try {
      loadingId = mealName;
      setState(() {});
      Map<String, dynamic>? id =
          mealLog.firstWhereOrNull((element) => element["name"] == mealName);
      if (id?["id"] != null) {
        await _repo.removeMealLog(id?["id"]);
        await fetchJournalPlanBloc();
      }
    } catch (e) {
      log(e.toString());
    } finally {
      loadingId = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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

              log('state.customMealDetails!.isNotEmpty---------->>>>>> ${state.customMealDetails?.isNotEmpty}');

              if (state.customMealDetails?.isNotEmpty ?? false) {
                for (CustomMealDetails e in (state.customMealDetails ?? [])) {
                  if (e.type == widget.type.toString().capitalizeFirst ||
                      e.type?.trim() == widget.type.trim() ||
                      e.type ==
                          '${widget.type[0].toLowerCase()}${widget.type.substring(1)}') {
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
                        Text('Custom List',
                            style: FontUtils.h20(
                                fontColor: AppColors.oxFF010101,
                                fontWeight: FWT.semiBold)),
                        const SizedBox()
                      ],
                    ).paddingSymmetric(horizontal: 20.w, vertical: 5.h),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 12.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
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

                                searchCustomMealList =
                                    customMealList.where((item) {
                                  return item.name!
                                      .toLowerCase()
                                      .contains(value.toLowerCase());
                                }).toList();
                              });
                            } else {
                              setState(() {
                                isSearchOn = false;
                              });
                            }
                          },
                          style: FontUtils.h16(
                              fontColor: AppColors.black,
                              fontWeight: FWT.regular),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 12.h),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            hintText: 'Search',
                            // hintStyle: FontUtils.h16(),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 12),
                                        child: Shimmer.fromColors(
                                            baseColor: AppColors.disable
                                                .withOpacity(0.20),
                                            highlightColor: AppColors.disable
                                                .withOpacity(0.20),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      height: 30,
                                                      width: 240,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              AppColors.disable,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
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
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .disable,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                const Divider(
                                                    color: AppColors.disable,
                                                    thickness: 1.2),
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
                                    SvgPicture.asset(
                                        AssetsUtils.emptyShoppingListIcon),
                                    Text(
                                      'Your Custom Meal List is\n empty.',
                                      textAlign: TextAlign.center,
                                      style: FontUtils.h14(
                                          fontWeight: FWT.regular),
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          CustomMealDetails details =
                                              searchCustomMealList[index];
                                          String mName = details.name ?? "";
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.to(
                                                    () => AddNewItemScreen(
                                                        id: details.id,
                                                        name: details.name,
                                                        cal: details.calorie
                                                            .toString(),
                                                        carbs: details.carbs
                                                            .toString(),
                                                        fat: details.fat
                                                            .toString(),
                                                        protein: details.protein
                                                            .toString(),
                                                        weight: details.quantity
                                                            .toString(),
                                                        imageUrl:
                                                            details.imageUrl),
                                                    arguments: widget.type);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: boxShadowWidget,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              '${mName.toString().capitalizeFirst}',
                                                              style: FontUtils.h16(
                                                                  fontColor:
                                                                      AppColors
                                                                          .black,
                                                                  fontWeight: FWT
                                                                      .medium),
                                                            ),
                                                            Text(
                                                              'Calories : ${details.calorie?.toStringAsFixed(2) ?? 0}, Protein : ${details.protein?.toStringAsFixed(2) ?? 0} , Carbs : ${details.carbs?.toStringAsFixed(2) ?? 0} , fat : ${details.fat?.toStringAsFixed(2) ?? 0}',
                                                              style:
                                                                  FontUtils.h12(
                                                                fontColor: AppColors
                                                                    .middleGray,
                                                                fontWeight:
                                                                    FWT.medium,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      logMealButton(mName),
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
                                      child: Text('No Search Found!',
                                          style: TextStyle(
                                              color: AppColors.middleGray)),
                                    )

                              ///Regular Data Display ===================================================
                              : SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: ListView.builder(
                                    itemCount: customMealList.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      CustomMealDetails details =
                                          customMealList[index];
                                      String mName = details.name ?? "";
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(
                                                () => AddNewItemScreen(
                                                      id: details.id,
                                                      name: details.name,
                                                      cal: details.calorie
                                                          .toString(),
                                                      carbs: details.carbs
                                                          .toString(),
                                                      fat: details.fat
                                                          .toString(),
                                                      protein: details.protein
                                                          .toString(),
                                                      weight: details.quantity
                                                          .toString(),
                                                      imageUrl:
                                                          details.imageUrl,
                                                    ),
                                                arguments: widget.type);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: boxShadowWidget,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${mName.toString().capitalizeFirst}',
                                                          style: FontUtils.h16(
                                                              fontColor:
                                                                  AppColors
                                                                      .black,
                                                              fontWeight:
                                                                  FWT.medium),
                                                        ),
                                                        Text(
                                                          'Calories : ${details.calorie?.toStringAsFixed(2) ?? 0}, Protein : ${details.protein?.toStringAsFixed(2) ?? 0} , Carbs : ${details.carbs?.toStringAsFixed(2) ?? 0} , fat : ${details.fat?.toStringAsFixed(2) ?? 0}',
                                                          style: FontUtils.h12(
                                                            fontColor: AppColors
                                                                .middleGray,
                                                            fontWeight:
                                                                FWT.medium,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  logMealButton(mName),
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
                        ? const SizedBox()
                        : buildButton(
                            context: context,
                            bgColor: AppColors.primaryBlue,
                            hasImage: false,
                            onPressed: () {
                              log("null");
                              Get.toNamed("/AddNewItemScreen", arguments: {
                                "title": widget.type,
                                "date": widget.dateTime,
                              });
                            },
                            textColor: Colors.white,
                            title: StringUtils.addNewItem,
                          ).paddingOnly(
                            bottom: 30.h, top: 10.h, right: 14, left: 14),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget logMealButton(String mName) {
    return loadingId == mName
        ? SizedBox(height: 20.h, width: 20.w, child: const AppCenterLoader())
        : GestureDetector(
            onTap: () {
              if (loadingId == null) {
                if (!mealLog.any((element) => element["name"] == mName)) {
                  logMealPlan(mName);
                } else {
                  removeMealPlan(mName);
                }
              }
            },
            child: Container(
              height: 25.h,
              width: 25.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.skyBlue,
              ),
              child: Center(
                child: Icon(
                  mealLog.any((element) => element["name"] == mName)
                      ? Icons.check
                      : Icons.add,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          );
  }
}
