import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/screen/grocery/screen/item_catalog/bottomsheet/item_catalog_filter_bottomsheet.dart';
import 'package:gymeats_mobile/widget/custom_radio_button_widget.dart';

class ItemCatalogSortByBottomSheet extends StatefulWidget {
  final String? selectedSort;
  final RangeValues? rangeValues;
  const ItemCatalogSortByBottomSheet({
    super.key,
    this.selectedSort,
    this.rangeValues,
  });

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
    return Material(
      color: AppColors.whiteColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
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
              24.height,
              myFilterWidget('Cheapest first'),
              myFilterWidget('Expensive'),
              16.height,
              ItemCatalogFilterBottomSheet(
                value: widget.rangeValues,
                onShowItem: (value) {
                  var hello = value..addAll({"value": selectedValue});
                  Get.back(result: hello);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myFilterWidget(String title) {
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
                },
              ),
              10.width,
              Text(title, style: FontUtils.h16(fontColor: AppColors.black)),
            ],
          ),
          11.height,
          const Divider(color: AppColors.disable, thickness: 1, height: 0),
          11.height,
        ],
      ),
    );
  }
}
