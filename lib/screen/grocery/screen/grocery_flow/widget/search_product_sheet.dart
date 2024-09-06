import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/widget/categories_tile_widget.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/widget/custom_search_field.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/widget/product_card_widget.dart';

class SearchProductSheet extends StatefulWidget {
  const SearchProductSheet({super.key});

  @override
  State<SearchProductSheet> createState() => _SearchProductSheetState();
}

class _SearchProductSheetState extends State<SearchProductSheet> {
  RxBool searchItem = true.obs;
  String? searchText;
  TextEditingController searchController = TextEditingController();

  List<String> get categoriesList => [
        "Milk",
        "Milk products",
        "Milk chocolate",
      ];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        height: context.height * 0.95,
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            const SheetHandle(),
            24.height,
            Row(
              children: [
                Expanded(
                  child: CustomSearchField(
                    onChange: (p0) => {
                      setState(() {
                        searchText = p0;
                      })
                    },
                    hintText: "Search for item",
                    showPrefixIcon: false,
                    controller: searchController,
                  ),
                ),
                10.width,
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Text(
                    StringUtils.cancel,
                    style: FontUtils.h14(
                      fontColor: AppColors.black,
                      fontWeight: FWT.lightMedium,
                    ),
                  ),
                )
              ],
            ).paddingOnly(left: 20, right: 20),
            24.height,
            Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderColor),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DefaultTabController(
                length: 2,
                child: TabBar(
                  labelStyle: FontUtils.h18(fontColor: AppColors.green),
                  unselectedLabelStyle:
                      FontUtils.h18(fontColor: AppColors.green),
                  labelColor: AppColors.green,
                  unselectedLabelColor: AppColors.green,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.mint,
                  ),
                  onTap: (value) {
                    searchItem.value = value == 0;
                  },
                  tabs: const [
                    Tab(text: "Items (128)"),
                    Tab(text: "Categories (3)"),
                  ],
                ),
              ).paddingAll(2),
            ).paddingOnly(left: 20, right: 20),
            Obx(
              () => Expanded(
                child: searchItem.value
                    ? ListView.separated(
                        itemCount: 10,
                        padding: const EdgeInsets.fromLTRB(0, 28, 0, 28),
                        separatorBuilder: (context, index) => Column(
                          children: [
                            16.height,
                            const Divider(
                                color: AppColors.lightGrey,
                                thickness: 1,
                                height: 0),
                            16.height,
                          ],
                        ),
                        itemBuilder: (context, index) {
                          return ProductCardWidget(
                            imgSize: 60,
                            onCartTap: () {},
                            onRemove: () {},
                            onAdd: () {},
                          );
                        },
                      )
                    : ListView.separated(
                        itemCount: 3,
                        padding: const EdgeInsets.fromLTRB(0, 28, 0, 28),
                        separatorBuilder: (context, index) => Column(
                          children: [
                            16.height,
                            const Divider(
                                color: AppColors.lightGrey,
                                thickness: 1,
                                height: 0),
                            16.height,
                          ],
                        ),
                        itemBuilder: (context, index) {
                          return CategoriesTileWidget(
                            onTap: () => Get.back(),
                          ).paddingOnly(right: 6, left: 6);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 4,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.disable,
        ),
      ),
    );
  }
}
