import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
// meal_plan branch code
class FoodPreferencesScreen extends StatefulWidget {
  const FoodPreferencesScreen({super.key});

  @override
  State<FoodPreferencesScreen> createState() => _FoodPreferencesScreenState();
}

class _FoodPreferencesScreenState extends State<FoodPreferencesScreen> {
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
              Expanded(
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
                          Text(StringUtils.foodPreferences, style: FontUtils.h20(fontColor: AppColors.oxFF010101, fontWeight: FWT.bold)),
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
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Tell us if you want to avoid some food.',
                        style: FontUtils.h14(fontColor: AppColors.middleGray, fontWeight: FWT.medium),
                      ),
                    ),
                    myWidget('Avoid eggs',true),
                    myWidget('Avoid fish',false),
                    myWidget('Add more sweets',true),
                    myWidget('Add more seafood',true),
                    myWidget('Avoid pork',false),
                    myWidget('Avoid nuts',false),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              simpleTextBorderButton(
                context: context,
                buttonLable: 'Save',
                height: screenSize.height * 0.065,
                width: screenSize.width,
                onTap: () {},
                isDarkColor: true,
                isFillColor: true,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget myWidget(
    String title,
    bool value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Text(title),
          const Spacer(),
          CupertinoSwitch(value: value, onChanged: (bool? value) {}, activeColor: AppColors.switchColor),
        ],
      ),
    );
  }
}
