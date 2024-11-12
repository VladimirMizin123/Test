import 'dart:collection';
import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_bloc.dart';
import 'package:gymeats_mobile/bloc/journal/custom_meal_bloc/custom_meal_bloc.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/models/get_meallogby_date_model.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_bloc.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_event.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_repository.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_state.dart';
import 'package:gymeats_mobile/screen/journal/journal_meal_screen.dart';
import 'package:gymeats_mobile/screen/journal/scan_barcode_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_repository.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/fatch_meal_details_model.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';
import 'package:gymeats_mobile/widget/svg_image.dart';
import 'package:intl/intl.dart';

class JournalSearchScreen extends StatefulWidget {
  final JournalMealScreenArguments? journalMealScreenArguments;
  final String? isFrom;
  final UserAddress? getUserAddress;
  const JournalSearchScreen(
      {super.key,
      this.journalMealScreenArguments,
      this.isFrom,
      this.getUserAddress});

  @override
  State<JournalSearchScreen> createState() => _JournalSearchScreenState();
}

class _JournalSearchScreenState extends State<JournalSearchScreen> {
  JournalPlanBloc journalPlanBloc = JournalPlanBloc();
  AddNewGroceryItemBloc addNewGroceryItemBloc = AddNewGroceryItemBloc();
  AddNewMealBloc getAddNewMealBloc = AddNewMealBloc();

  List<String> invoiceList = [];
  List<Map<String, dynamic>> mealLog = [];
  Map<String, FetchMealDetailsModel> invoiceMap = {};
  final MealPlanRepository _repo = MealPlanRepository();
  final JournalPlanRepository _journal = JournalPlanRepository();

  List<Map<String, dynamic>> groceryDetails = [];
  JournalMealScreenArguments? journalMealScreenArguments = Get.arguments;

  bool invoiceLoader = false;
  String? loadingId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      journalPlanBloc.add(JournalPlanFetchEvent());
      journalPlanBloc.add(UserInvoiceListEvent());
      fetchJournalPlanBloc();
    });
  }

  Future<void> fetchJournalPlanBloc() async {
    try {
      DateTime time =
          widget.journalMealScreenArguments?.dateTime ?? DateTime.now();
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
          mealType: widget.journalMealScreenArguments?.mealType?.trim(),
          noOfServing: 0,
          recipeId: null,
          protein: model?.data?.recipe?.nutritionalInfo?.protein,
          fat: model?.data?.recipe?.nutritionalInfo?.fat,
          carbs: model?.data?.recipe?.nutritionalInfo?.carbs,
          date: widget.journalMealScreenArguments?.dateTime?.toIso8601String(),
          value: 1,
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
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: BlocConsumer<JournalPlanBloc, JournalMealPlanState>(
          bloc: journalPlanBloc,
          listener: (context, state) async {
            if (state is UserInvoiceSuccessState) {
              invoiceList =
                  LinkedHashSet<String>.from(state.invoiceList).toList();
              for (int i = 0; i < invoiceList.length; i++) {
                FetchMealDetailsModel? detail =
                    await _repo.findRecipe(invoiceList[i]);

                if (detail != null) {
                  invoiceMap[invoiceList[i]] = detail;
                }
              }

              setState(() {});
            }
            if (state is UserInvoiceLoadingState) {
              invoiceLoader = state.isLoading;
              setState(() {});
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
                          child: const Icon(Icons.keyboard_arrow_left_outlined,
                              size: 30)),
                      widget.isFrom == 'Grocery'
                          ? const SizedBox()
                          : Text(widget.journalMealScreenArguments!.mealType!,
                              style: FontUtils.h20(
                                  fontColor: AppColors.oxFF010101,
                                  fontWeight: FWT.semiBold)),
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
                    child: Container(
                      height: 48.h,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                        boxShadow: boxShadowWidget,
                      ),
                      child: Row(
                        children: [
                          const SvgImage(
                            image: AssetsUtils.icSearch,
                          ).marginOnly(left: 15),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              onTap: () {
                                Get.toNamed(
                                  "/ScanBarcodeScreen",
                                  arguments: ScanBarcodeArguments(
                                      journalPlanBloc: journalPlanBloc,
                                      selectedDateTime:
                                          (widget.journalMealScreenArguments ??
                                                  journalMealScreenArguments)!
                                              .dateTime,
                                      type: widget.journalMealScreenArguments!
                                          .mealType!.capitalizeFirst!),
                                );
                              },
                              decoration: InputDecoration(
                                filled: false,
                                isDense: true,
                                hintText: "Search for Item",
                                hintStyle: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.middleGray),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: true,
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(
                                  "/ScanBarcodeScreen",
                                  arguments: ScanBarcodeArguments(
                                      journalPlanBloc: journalPlanBloc,
                                      selectedDateTime:
                                          (widget.journalMealScreenArguments ??
                                                  journalMealScreenArguments)!
                                              .dateTime,
                                      type: widget.journalMealScreenArguments!
                                          .mealType!.capitalizeFirst!),
                                );
                              },
                              child: const SvgImage(
                                image: AssetsUtils.icBarcode,
                              ).marginOnly(right: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Previous order",
                          style: FontUtils.h16(fontColor: AppColors.middleGray),
                        ).paddingSymmetric(horizontal: 15),
                        const SizedBox(height: 10),
                        Expanded(
                          child: invoiceLoader
                              ? const AppCenterLoader()
                              : invoiceList.isEmpty
                                  ? Center(
                                      child: Text(
                                        "No previous orders found.",
                                        style: FontUtils.h16(
                                            fontColor: AppColors.middleGray),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: invoiceList.length,
                                      itemBuilder: (context, index) {
                                        String key = invoiceList[index];
                                        return GestureDetector(
                                          onTap: () async {},
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.h),
                                            width: double.infinity.w,
                                            margin: EdgeInsets.only(
                                                top: 5.h,
                                                bottom: 5.h,
                                                left: 15,
                                                right: 15),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                border: Border.all(
                                                    color: AppColors.disable)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 250.w,
                                                      child: Text(
                                                        key,
                                                        style: textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                                color: AppColors
                                                                    .darkGray,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ),
                                                    ),
                                                    if (invoiceMap
                                                        .containsKey(key))
                                                      Text(
                                                        "${invoiceMap[key]?.data?.recipe?.nutritionalInfo?.calories?.toDouble() ?? 0}",
                                                        style: textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                                color: AppColors
                                                                    .terracotta,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ),
                                                  ],
                                                ),
                                                loadingId == invoiceList[index]
                                                    ? SizedBox(
                                                        height: 20.h,
                                                        width: 20.w,
                                                        child:
                                                            const AppCenterLoader())
                                                    : GestureDetector(
                                                        onTap: () {
                                                          if (loadingId ==
                                                              null) {
                                                            if (!mealLog.any(
                                                                (element) =>
                                                                    element[
                                                                        "name"] ==
                                                                    key)) {
                                                              logMealPlan(key);
                                                            } else {
                                                              removeMealPlan(
                                                                  key);
                                                            }
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 25.h,
                                                          width: 25.w,
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: AppColors
                                                                .skyBlue,
                                                          ),
                                                          child: Center(
                                                            child: Icon(
                                                              mealLog.any((element) =>
                                                                      element[
                                                                          "name"] ==
                                                                      key)
                                                                  ? Icons.check
                                                                  : Icons.add,
                                                              color: AppColors
                                                                  .primaryBlue,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                              ],
                                            ).paddingSymmetric(
                                                horizontal: 15.w),
                                          ),
                                        );
                                      },
                                    ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
