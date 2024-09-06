import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_bloc.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_event.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/models/get_grocery_item_list_model.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/widget/search_product_sheet.dart';
import 'package:gymeats_mobile/widget/confirmation_dialog.dart';

class CheckListSheet extends StatefulWidget {
  const CheckListSheet({
    super.key,
    this.groceryDetails,
  });
  final List<GroceryDetails>? groceryDetails;

  @override
  State<CheckListSheet> createState() => _CheckListSheetState();
}

class _CheckListSheetState extends State<CheckListSheet> {
  RxBool isDelete = false.obs;
  List<GroceryDetails> groceryList = [];

  @override
  void initState() {
    groceryList = widget.groceryDetails ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        height: context.height * 0.75,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
            Text(
              StringUtils.shoppingList,
              style: FontUtils.h20(
                fontColor: AppColors.black,
                fontWeight: FWT.medium,
              ),
            ),
            16.height,
            const Divider(thickness: 1, height: 0, color: AppColors.lightGrey),
            12.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => GestureDetector(
                    onTap: () => isDelete.value = !isDelete.value,
                    child: Text(
                      isDelete.value ? "Done" : "Edit",
                      style: FontUtils.h14(
                        fontColor: AppColors.black,
                        fontWeight: FWT.lightMedium,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ConfirmationDialog(
                        text: StringUtils.doYouWantToClearAllGroceryItem,
                        btnText: StringUtils.delete,
                        onConfirm: () {
                          Get.back();
                          AddNewGroceryItemBloc()
                              .add(ClearUserGroceryEvent(showToast: false));
                          groceryList.clear();
                          setState(() {});
                          Get.back();
                        },
                      ),
                    );
                  },
                  child: Text(
                    StringUtils.clearAll,
                    style: FontUtils.h14(
                      fontColor: AppColors.black,
                      fontWeight: FWT.lightMedium,
                    ),
                  ),
                ),
              ],
            ),
            28.height,
            Expanded(
              child: Builder(
                builder: (context) {
                  return groceryList.isEmpty
                      ? Center(
                          child: Text(
                            StringUtils.groceryNotFound,
                            style: FontUtils.h16(fontColor: AppColors.black),
                          ),
                        )
                      : ListView.separated(
                          physics: const ClampingScrollPhysics(),
                          itemCount: groceryList.length,
                          separatorBuilder: (context, index) => Column(
                            children: [
                              16.height,
                              const Divider(
                                  thickness: 1,
                                  height: 0,
                                  color: AppColors.lightGrey),
                              16.height,
                            ],
                          ),
                          itemBuilder: (context, index) {
                            return checkListTile(groceryList[index]);
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget checkListTile(GroceryDetails details) {
    bool isSelected = details.isChecked ?? false;
    return Row(
      children: [
        Obx(
          () => isDelete.value
              ? GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ConfirmationDialog(
                        text: StringUtils.doYouWantToRemoveGroceryItem,
                        btnText: StringUtils.delete,
                        onConfirm: () {
                          Get.back();
                          AddNewGroceryItemBloc().add(
                            RemoveGroceryItemEvent(
                              userGroceryListId: details.id,
                              showToast: false,
                            ),
                          );
                          try {
                            groceryList.removeWhere(
                                (element) => element.id == details.id);
                            setState(() {});
                          } catch (e) {
                            log(e.toString());
                          }
                        },
                      ),
                    );
                  },
                  child: SvgPicture.asset(AssetsUtils.icRemoveRed),
                )
              : Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: isSelected,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity:
                        const VisualDensity(horizontal: -4.0, vertical: -4.0),
                    onChanged: (bool? value) {
                      details.isChecked = value;
                      AddNewGroceryItemBloc().add(
                        UpdateAddNewGroceryItem(
                          userId: details.userId ?? "",
                          id: details.id ?? "",
                          itemName: details.itemName ?? "",
                          quantity: details.quantity ?? 0,
                          measurementType: details.measurementType ?? "",
                          measurementValue: details.measurementValue ?? "",
                          isChecked: details.isChecked ?? false,
                          showToast: false,
                        ),
                      );
                      setState(() {});
                    },
                    activeColor: AppColors.appColor,
                  ),
                ),
        ),
        15.width,
        Expanded(
          flex: 3,
          child: Text(
            details.itemName ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FontUtils.h16(
              fontColor: AppColors.black,
            ).copyWith(
              decoration: isSelected ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
        5.width,
        Expanded(
          flex: 1,
          child: Text(
            "${details.quantity ?? 0}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FontUtils.h16(
              fontColor: AppColors.black,
            ).copyWith(
              decoration: isSelected ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
        15.width,
        Expanded(
          flex: 2,
          child: Text(
            (details.measurementType?.isEmpty ?? true)
                ? StringUtils.piece
                : details.measurementType?.capitalizeFirst ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FontUtils.h16(
              fontColor: AppColors.black,
            ).copyWith(
              decoration: isSelected ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ],
    );
  }
}
