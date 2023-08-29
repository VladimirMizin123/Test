import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_bloc.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_state.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/widget/grocery_add_button_widget.dart';

class GroceryPlanScreen extends StatefulWidget {
  const GroceryPlanScreen({super.key});

  @override
  State<GroceryPlanScreen> createState() => _GroceryPlanScreenState();
}

class _GroceryPlanScreenState extends State<GroceryPlanScreen> {
  final routeName = '/GroceryPlanScreen';
  int selectedItemCount = 0;
  String _selectProduct = 'Product 1';
  List<String> productList = ['Product 1', 'Product 2', 'Product 3', 'Product 4', 'Product 5'];

  MealPlanBloc bloc = MealPlanBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // bloc.add(MealPlanFetchEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<MealPlanBloc, FetchMealPlanState>(
          bloc: bloc,
          listener: (context, state) {},
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
                        Image.asset(
                          AssetsUtils.user,
                          height: 25.h,
                          width: 25.w,
                          color: AppColors.darkGray,
                        ),
                        Text(StringUtils.mealPlan, style: FontUtils.h20(fontColor: AppColors.oxFF010101)),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/FoodPreferencesScreen');
                          },
                          child: Image.asset(
                            AssetsUtils.filter,
                            height: 20.h,
                            width: 20.w,
                            color: AppColors.darkGray,
                          ),
                        )
                      ],
                    ).paddingSymmetric(horizontal: 20.w, vertical: 5.h),
                    Divider(color: AppColors.darkGray, height: 3.h),
                    Text(state is FetchMealPlanSuccessState ? StringUtils.regenerateGroceryList : 'Clear My Grocery List', style: FontUtils.h18(fontColor: AppColors.primaryBlue, fontWeight: FWT.medium)).paddingSymmetric(vertical: 10.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Search for item',
                          hintStyle: FontUtils.h16(),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ListView.builder(
                          itemCount: 10,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 20.0,
                                          width: 20.0,
                                          child: Transform.scale(
                                            scale: 1.2,
                                            child: Checkbox(
                                              activeColor: AppColors.appColor,
                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              value: true,
                                              onChanged: (bool? value) {
                                              
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'almond milk',
                                          style: FontUtils.h16(fontColor: AppColors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: DropdownButtonFormField(
                                            decoration: const InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),
                                            value: _selectProduct,
                                            borderRadius: BorderRadius.circular(12),
                                            items: productList
                                                .map((e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Text(e),
                                                    ))
                                                .toList(),
                                            onChanged: (val) {
                                              setState(() {
                                                _selectProduct = val!;
                                              });
                                            }),
                                      ),
                                      SizedBox(width: 8.w),
                                      Container(
                                        height: size.height * 0.065,
                                        width: size.height * 0.065,
                                        decoration: BoxDecoration(border: Border.all(color: AppColors.skyBlue), borderRadius: BorderRadius.circular(6)),
                                        child: Center(child: SvgPicture.asset(AssetsUtils.icDelete)),
                                      ),
                                      SizedBox(width: 8.w),
                                      Container(
                                        height: size.height * 0.065,
                                        width: size.height * 0.065,
                                        decoration: BoxDecoration(border: Border.all(color: AppColors.disable), borderRadius: BorderRadius.circular(6)),
                                        child: Center(
                                            child: Text(
                                          '1',
                                          style: FontUtils.h18(fontWeight: FWT.semiBold, fontColor: AppColors.darkGray),
                                        )),
                                      ),
                                      SizedBox(width: 8.w),
                                      Container(
                                        height: size.height * 0.065,
                                        width: size.height * 0.065,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          color: AppColors.skyBlue,
                                        ),
                                        child: const Center(child: Icon(Icons.add, size: 27)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  const Divider(color: AppColors.disable, thickness: 1.1),
                                  SizedBox(height: 5.h),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    GroceryAddButtonWidget(
                      onTap: () {},
                      buttonLable: 'View Cart',
                      isFillColor: false,
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
