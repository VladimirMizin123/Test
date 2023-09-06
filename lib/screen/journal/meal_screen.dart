import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_bloc.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_state.dart';
import '../../constant/asset_utils.dart';
import '../../constant/color_utils.dart';
import '../../constant/font_utils.dart';
import '../../constant/string_utils.dart';
import '../../models/fetch_meal_plan_model.dart';
import '../../widget/app_widget.dart';
import '../../widget/svg_image.dart';


class MealScreen extends StatefulWidget {
  const MealScreen({Key? key}) : super(key: key);

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  final routeName = '/MealScreen';

  MealPlanBloc bloc = MealPlanBloc();

  List<MealData>? mealList = [];
  List<FetchMealPlanData> mealPlanList = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mealList = Get.arguments[0];
    print("Meal Data List->${mealList!.length}");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<MealPlanBloc, FetchMealPlanState>(
        bloc: bloc,
        listener: (BuildContext context, FetchMealPlanState state) {
          if (state is FetchMealPlanSuccessState) {
            mealPlanList = state.mealPlanList;
          }
        },
        builder: (BuildContext context, FetchMealPlanState state) {
          return SafeArea(
              child: SizedBox(
            height: size.height.h,
            width: size.width.w,
            child: Column(
              children: [
                Expanded(
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
                        const SvgImage(
                          image: AssetsUtils.icBack,
                          color: AppColors.darkGray,
                        ),
                        Text("Breakfast",
                            style:
                                FontUtils.h20(fontColor: AppColors.oxFF010101)),
                        SizedBox(
                          height: 20.h,
                          width: 20.w
                        )
                      ],
                    ).paddingSymmetric(horizontal: 20.w, vertical: 5.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 6),
                      child: Container(
                        height: 48.h,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlue.withOpacity(0.10),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: const Offset(
                                  0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SvgImage(
                              image: AssetsUtils.icSearch,
                            ).marginOnly(left: 15),
                            Expanded(
                              child: TextFormField(
                                controller: controller,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                onChanged: (value) {
                                  // onChange(value);
                                },
                                decoration: InputDecoration(
                                  filled: false,
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
                                  // onClear();
                                  Get.toNamed("/ScanBarcodeScreen");
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
                    Text(
                      StringUtils.basedMeal,
                      style: FontUtils.h16(fontColor: AppColors.middleGray),
                    ),
                    SingleChildScrollView(
                      child: ListView.builder(
                        itemCount: mealList!.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return mealPlanCard(
                            onTap: () {
                              // Get.toNamed('/MealDetailsScreen', arguments: MealPlanArguments(mealData: e.meals![index]));
                            },
                            mealData: mealList![index],
                            context: context,
                            onSkipMealTap: () {
                              // showModalBottomSheet(
                              //   context: context,
                              //   builder: (context) {
                              //     return SkipMealBottomSheet(
                              //       bloc: bloc,
                              //       mealData: mealList![index],
                              //     );
                              //   },
                              //   isDismissible: false,
                              // );
                            },
                            onSwapMealTap: () {
                              // showModalBottomSheet(
                              //   context: context,
                              //   builder: (context) {
                              //     return SwapMealBottomSheet(mealPlanBloc: bloc, mealData: mealList![index], day: e.day);
                              //   },
                              // );
                            },
                          );
                        },
                      ),
                    )
                  ],
                )),
                buildButton(
                        context: context,
                        title: StringUtils.addNewItem,
                        hasImage: false,
                        textColor: AppColors.skyBlue,
                        onPressed: () {
                          Get.toNamed("/AddNewItemScreen");
                          // bloc.add(SaveClickEvent(
                          //     userId: userId,
                          //     workoutTime: minutesController.text,
                          //     exerciseName: entryController.text,
                          //     caloriesBurned: caloriesBurnedController.text,
                          //     createdBy: ''));
                        },
                        bgColor: AppColors.primaryBlue)
                    .paddingOnly(bottom: 20.h,left: 20.w,right: 20.w)
              ],
            ),
          ));
        },
      ),
    );
  }
}
