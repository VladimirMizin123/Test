import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/custom_radio_button_widget.dart';

class ItemCatalogSortByBottomSheet extends StatefulWidget {
  final String? selectedSort;
  const ItemCatalogSortByBottomSheet({super.key, this.selectedSort});

  @override
  State<ItemCatalogSortByBottomSheet> createState() =>
      _ItemCatalogSortByBottomSheetState();
}

class _ItemCatalogSortByBottomSheetState
    extends State<ItemCatalogSortByBottomSheet> {
  String selectedValue = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      selectedValue = widget.selectedSort ?? '';
      setState(() {});
    });
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
                  child: Text('Sort by',
                      style: FontUtils.h22(
                          fontColor: AppColors.darkGray,
                          fontWeight: FWT.semiBold))),
              const SizedBox(height: 10),
              myFilterWidget('Cheapest first', () {}),
              myFilterWidget('Popular', () {}),
              myFilterWidget('Expensive', () {}),
              const SizedBox(height: 15),
              simpleTextBorderButton(
                context: context,
                color: AppColors.green,
                buttonLable: 'Apply',
                height: screenSize.height * 0.065,
                width: screenSize.width,
                isLoadingWidget: false,
                onTap: () {
                  Navigator.pop(context, selectedValue);
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

  Widget myFilterWidget(String title, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              CustomRadioButtonWidget(
                  value: title,
                  groupValue: selectedValue,
                  onChanged: (String? value) {
                    setState(() {
                      selectedValue = value!;
                    });
                    return null;
                  }),
              const SizedBox(width: 10),
              Text(title, style: FontUtils.h16(fontColor: AppColors.black)),
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
