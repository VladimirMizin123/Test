import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/custom_checkbox_widget.dart';

class PriceSelectionBottomSheet extends StatefulWidget {
  const PriceSelectionBottomSheet({super.key, this.priceRange});
  final RangeValues? priceRange;
  @override
  State<PriceSelectionBottomSheet> createState() =>
      _PriceSelectionBottomSheetState();
}

class _PriceSelectionBottomSheetState extends State<PriceSelectionBottomSheet> {
  RangeValues _currentRangeValues = const RangeValues(0, 500);

  @override
  void initState() {
    super.initState();
    _currentRangeValues = widget.priceRange ?? const RangeValues(0, 500);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Material(
      color: AppColors.whiteColor,
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25), topRight: Radius.circular(25)),
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
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.disable),
                  )),
              const SizedBox(height: 10),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text('Price',
                          style: FontUtils.h22(
                              fontColor: AppColors.darkGray,
                              fontWeight: FWT.semiBold)),
                    ],
                  )),
              const SizedBox(height: 20),
              RangeSlider(
                values: _currentRangeValues,
                max: 500,
                min: 0,
                divisions: 50,
                labels: RangeLabels(
                  _currentRangeValues.start.round().toString(),
                  _currentRangeValues.end.round().toString(),
                ),
                activeColor: AppColors.green,
                inactiveColor: AppColors.green.withOpacity(0.4),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('min ${_currentRangeValues.start}',
                      style: FontUtils.h14(fontColor: AppColors.darkGray)),
                  Text('max ${_currentRangeValues.end}',
                      style: FontUtils.h14(fontColor: AppColors.darkGray)),
                ],
              ),
              const SizedBox(height: 15),
              simpleTextBorderButton(
                context: context,
                color: AppColors.green,
                buttonLable: 'Apply',
                height: screenSize.height * 0.065,
                width: screenSize.width,
                isLoadingWidget: false,
                onTap: () {
                  Get.back(result: {
                    'priceRange': _currentRangeValues,
                    'isFilter': true,
                  });
                },
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
