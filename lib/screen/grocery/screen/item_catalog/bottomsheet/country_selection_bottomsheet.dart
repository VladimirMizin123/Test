import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/custom_checkbox_widget.dart';

class CountrySelectionBottomSheet extends StatefulWidget {
  const CountrySelectionBottomSheet({super.key});

  @override
  State<CountrySelectionBottomSheet> createState() => _CountrySelectionBottomSheetState();
}

class _CountrySelectionBottomSheetState extends State<CountrySelectionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Material(
      color: AppColors.whiteColor,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 3.h,
                    width: 80.w,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.disable),
                  )),
              const SizedBox(height: 10),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text('Country', style: FontUtils.h22(fontColor: AppColors.darkGray, fontWeight: FWT.semiBold)),
                      const Spacer(),
                      Text('Clear all', style: FontUtils.h16(fontColor: AppColors.darkGray)),
                    ],
                  )),
              const SizedBox(height: 20),
              myFilterWidget('USA', true),
              myFilterWidget('France', false),
              myFilterWidget('Switzerland ', false),
              const SizedBox(height: 15),
              simpleTextBorderButton(
                context: context,
                color: AppColors.green,
                buttonLable: 'Apply',
                height: screenSize.height * 0.065,
                width: screenSize.width,
                isLoadingWidget: false,
                onTap: () {},
                isDarkColor: true,
                isFillColor: true,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget myFilterWidget(String title, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              Text(title, style: FontUtils.h16(fontColor: AppColors.black)),
              const Spacer(),
              CustomCheckboxWidget(
                  value: value,
                  onChanged: (bool? value) {
                    return null;
                  }),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(color: AppColors.disable, thickness: 1.2),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
