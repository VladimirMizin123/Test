import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MealDetailsScreen extends StatefulWidget {
  const MealDetailsScreen({super.key});

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 4.h),
              Image.asset(
                AssetsUtils.gymEatsLogo,
                height: 20.h,
                width: 56.w,
                color: AppColors.primaryBlue,
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.w, bottom: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.arrow_back_ios_new_rounded),
                    Text(StringUtils.planMealDetails, style: FontUtils.h20(fontColor: AppColors.oxFF010101, fontWeight: FWT.bold)),
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
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Smoked Mackerel Salad With Fennel And Apple',
                          style: FontUtils.h18(fontColor: AppColors.black, fontWeight: FWT.medium),
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '1 serving, 120g',
                            style: FontUtils.h14(fontColor: AppColors.middleGray, fontWeight: FWT.lightMedium),
                          )),
                      SizedBox(height: 12.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image(
                          image: const AssetImage('assets/image/defaultImage.png'),
                          height: screenSize.height * 0.20,
                          width: screenSize.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: tabView(
                                title: 'Ingredients',
                                isSelected: selectedIndex == 0 ? true : false,
                                onTap: () {
                                  setState(() {
                                    selectedIndex = 0;
                                  });
                                }),
                          ),
                          Expanded(
                            flex: 1,
                            child: tabView(
                                title: 'Info',
                                isSelected: selectedIndex == 1 ? true : false,
                                onTap: () {
                                  setState(() {
                                    selectedIndex = 1;
                                  });
                                }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      selectedIndex == 0
                          ? Column(
                              children: [
                                ListView.builder(
                                  itemCount: 5,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          const CircleAvatar(
                                            maxRadius: 5,
                                            backgroundColor: AppColors.mint,
                                          ),
                                          const SizedBox(width: 20),
                                          const Text('almond milk'),
                                          const Spacer(),
                                          Checkbox(
                                            value: true,
                                            onChanged: (bool? value) {},
                                            activeColor: AppColors.appColor,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              ],
                            )
                          : Column(children: [
                              GridView.builder(
                                  itemCount: 4,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2, crossAxisSpacing: 6.w, mainAxisSpacing: 6.h),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: AppColors.whiteColor,
                                          boxShadow: const [
                                            BoxShadow(color: AppColors.black, blurRadius: 30, spreadRadius: -30),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('Cal', style: FontUtils.h20(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                commonProgressbar(progressColor: AppColors.primaryBlue, width: screenSize.width * 0.30, lineHeight: 9.0),
                                              ],
                                            ),
                                            Text('320 / 2000 cal', style: FontUtils.h15(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                          ],
                                        ));
                                  }),
                              const SizedBox(height: 10),
                              Align(alignment: Alignment.centerLeft, child: Text('Nutritional Information', style: FontUtils.h24(fontColor: AppColors.darkGray, fontWeight: FWT.semiBold))),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Fat', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                  Text('2g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                  Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                  Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Divider(color: AppColors.disabledColor, height: 2.h),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Fat', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                  Text('2g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                  Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                  Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Divider(color: AppColors.disabledColor, height: 2.h),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Fat', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                  Text('2g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                  Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                  Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                ],
                              ),
                            ]),
                      const SizedBox(height: 15),
                      simpleTextBorderButton(
                        context: context,
                        buttonLable: StringUtils.addToGroceryList,
                        height: screenSize.height * 0.065,
                        width: screenSize.width,
                        onTap: () {},
                        isDarkColor: true,
                        isFillColor: true,
                      ),
                      SizedBox(height: 14.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Order Best Match from Restaurant',
                            style: FontUtils.h20(fontColor: AppColors.oxFF010101, fontWeight: FWT.medium),
                          ),
                          SizedBox(width: 10.w),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.primaryBlue,
                            size: 20,
                          )
                        ],
                      ),
                      SizedBox(height: 14.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Recipe',
                          style: FontUtils.h22(fontColor: AppColors.middleGray, fontWeight: FWT.semiBold),
                        ),
                      ),
                      SizedBox(height: 7.h),
                      Row(
                        children: [
                          Expanded(flex: 1, child: myWidget(imgURL: AssetsUtils.icTimelineIcon, title: '25 Minutes', onTap: () {})),
                          const SizedBox(width: 10),
                          Expanded(flex: 1, child: myWidget(imgURL: AssetsUtils.icServingIcon, title: '3 Servings', onTap: () {})),
                          const SizedBox(width: 10),
                          Expanded(flex: 1, child: myWidget(imgURL: AssetsUtils.icIngredientsIcon, title: '10 Ingredients', onTap: () {})),
                        ],
                      ),
                      SizedBox(height: 7.h),
                      ListView.builder(
                          itemCount: 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.appColor, width: 2),
                                          shape: BoxShape.circle,
                                        ),
                                        height: 35,
                                        width: 35,
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: FontUtils.h16(fontColor: AppColors.appColor, fontWeight: FWT.medium),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Text(
                                          'Heat 1 Tbsp olive oil in a pan over medium high heat and cook the ground beef. Stir in salt, pepper, chopped garlic, oregano, thyme and paprika.',
                                          style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(color: AppColors.disabledColor, height: 2.h),
                              ],
                            );
                          }),
                      SizedBox(height: 20.h),
                      Container(
                        height: screenSize.height * 0.08,
                        width: screenSize.width * 0.40,
                        decoration: const BoxDecoration(
                            color: AppColors.coral,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(60),
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(80),
                              bottomRight: Radius.circular(12),
                            )),
                        child: Center(
                          child: Text(
                            'Enjoy!',
                            style: FontUtils.h28(fontColor: AppColors.terracotta, fontWeight: FWT.semiBold),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myWidget({required String imgURL, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.whiteColor,
            boxShadow: const [
              BoxShadow(color: AppColors.black, blurRadius: 15, spreadRadius: -20),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Column(
              children: [
                SvgPicture.asset(imgURL),
                const SizedBox(height: 10),
                Text(title, style: FontUtils.h15(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
              ],
            ),
          )),
    );
  }

  Widget tabView({required String title, bool isSelected = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isSelected ? AppColors.primaryBlue : AppColors.grayColor, width: 1.4))),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            title,
            style: FontUtils.h18(fontColor: isSelected ? AppColors.primaryBlue : AppColors.grayColor, fontWeight: FWT.semiBold),
          ),
        )),
      ),
    );
  }

  Widget commonProgressbar({Color? progressColor, double? width, double? lineHeight}) {
    return LinearPercentIndicator(
      width: width,
      barRadius: const Radius.circular(10),
      animation: true,
      lineHeight: lineHeight!,
      animationDuration: 2000,
      percent: 0.7,
      center: const Text(""),
      linearStrokeCap: LinearStrokeCap.round,
      progressColor: progressColor,
    ).paddingAll(5);
  }

  Widget calciumDataView({
    String? title,
    String? gramCount,
    TextTheme? textTheme,
    String? totalGram,
    Color? progressColor,
  }) {
    return Column(
      children: [
        Text(
          title.toString(),
          style: textTheme?.bodyLarge?.copyWith(color: AppColors.darkGray),
        ),
        commonProgressbar(progressColor: progressColor, width: 76.w, lineHeight: 10.0),
        Text(
          '$gramCount / $totalGram g',
          style: textTheme?.bodyMedium?.copyWith(color: AppColors.darkGray),
        )
      ],
    );
  }
}
