import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_bloc.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/models/get_grocery_item_list_model.dart';
import 'package:gymeats_mobile/screen/appmanager/app_manager_screen.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart'
    as grocery;
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_cart_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';

enum AskReceiveOrder { bringTheOrder, pickMySelf }

class ReceiveOrderAskBottomSheet extends StatefulWidget {
  final AddNewGroceryItemBloc? addNewGroceryItemBloc;
  final GroceryBloc? groceryBloc;
  final List<GroceryDetails>? selectedEdgesList;
  final int? selectedIndex;
  final String? isFrom;
  const ReceiveOrderAskBottomSheet(
      {super.key,
      this.addNewGroceryItemBloc,
      this.selectedEdgesList,
      this.groceryBloc,
      this.selectedIndex,
      this.isFrom});

  @override
  State<ReceiveOrderAskBottomSheet> createState() =>
      _ReceiveOrderAskBottomSheetState();
}

class _ReceiveOrderAskBottomSheetState
    extends State<ReceiveOrderAskBottomSheet> {
  int selectedIndex = -1;
  int apiIndex = -1;
  bool loading = false;
  RestaurantBloc restaurantBloc = RestaurantBloc();
  @override
  void initState() {
    super.initState();
    widget.groceryBloc?.add(grocery.GetDeliveryStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BlocConsumer<GroceryBloc, GroceryState>(
      bloc: widget.groceryBloc,
      listener: (context, state) {
        // FETCH STATE - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        /// Delivery Status state --------------------------------------------------------
        if (state is GetDeliveryStatusSuccessState) {
          selectedIndex = state.data['isPickUp'] == true ? 1 : 0;
          apiIndex = state.data['isPickUp'] == true ? 1 : 0;
          loading = false;
        }
        if (state is GetDeliveryStatusLoadingState) {
          loading = true;
        }
        if (state is GetDeliveryStatusErrorState) {
          loading = false;
        }
      },
      builder: (context, state) {
        return loading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Material(
                color: AppColors.whiteColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
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
                        SvgPicture.asset(AssetsUtils.icQuestionMarkGreenIcon),
                        const SizedBox(height: 15),
                        Text(
                          'How would you like to receive your order?',
                          style: FontUtils.h20(
                              fontColor: AppColors.darkGray,
                              fontWeight: FWT.semiBold),
                        ),
                        const SizedBox(height: 15),
                        myWidget(
                            title: 'Bring me the order',
                            isSelected: selectedIndex == 0 ? true : false,
                            onTap: () {
                              setState(() {
                                selectedIndex = 0;
                              });
                            }),
                        const SizedBox(height: 10),
                        myWidget(
                            title: 'I will pick it myself',
                            isSelected: selectedIndex == 1 ? true : false,
                            onTap: () {
                              setState(() {
                                selectedIndex = 1;
                              });
                            }),
                        const SizedBox(height: 15),
                        simpleTextBorderButton(
                          context: context,
                          color: AppColors.green,
                          buttonLable: selectedIndex == -1 ? 'Back' : 'Confirm',
                          height: screenSize.height * 0.065,
                          width: screenSize.width,
                          isLoadingWidget: false,
                          onTap: () {
                            if (selectedIndex == -1) {
                              Get.back();
                            } else {
                              if (selectedIndex == apiIndex) {
                                if (widget.isFrom == 'isFromCheckout') {
                                  Get.back();
                                } else {
                                  Get.toNamed('/GroceryCartScreen',
                                          arguments: GroceryCartScreenArguments(
                                              edgesList:
                                                  widget.selectedEdgesList!,
                                              askReceiveOrder:
                                                  selectedIndex == 0
                                                      ? AskReceiveOrder
                                                          .bringTheOrder
                                                      : AskReceiveOrder
                                                          .pickMySelf))!
                                      .then((value) {
                                    Get.back();
                                  });
                                }
                              } else {
                                restaurantBloc.add(
                                  UpdateDeliveryStatusEvent(
                                    pickUp: selectedIndex == 0 ? false : true,
                                  ),
                                );

                                restaurantBloc
                                    .add(ClearShoppingListItemEvent());

                                if (widget.isFrom == 'isFromCheckout') {
                                  Get.offAll(
                                    () => const AppManagerScreen(
                                      selectIndex: 1,
                                    ),
                                  );
                                } else {
                                  Get.toNamed('/GroceryCartScreen',
                                          arguments: GroceryCartScreenArguments(
                                              edgesList:
                                                  widget.selectedEdgesList!,
                                              askReceiveOrder:
                                                  selectedIndex == 0
                                                      ? AskReceiveOrder
                                                          .bringTheOrder
                                                      : AskReceiveOrder
                                                          .pickMySelf))!
                                      .then((value) {
                                    Get.back();
                                  });
                                }
                              }

                              // List<GroceryShoppingData> edgesDummyList = [];
                              // for (var i = 0; i < widget.edgesList.length; i++) {
                              //   if (widget.edgesList[i].isActive == true) {
                              //     edgesDummyList.add(widget.edgesList[i]);
                              //   }
                              // }
                              // if (edgesDummyList.isNotEmpty) {
                              ///
                            }
                          },
                          isDarkColor: true,
                          isFillColor: selectedIndex == -1 ? false : true,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }

  Widget myWidget(
      {bool isSelected = false, VoidCallback? onTap, String? title}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? AppColors.primaryBlue : Colors.transparent),
          color: AppColors.whiteColor,
          boxShadow: boxShadowWidget,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title!,
                style: FontUtils.h16(
                    fontColor: AppColors.darkGray, fontWeight: FWT.medium),
              ),
              Container(
                height: 22.h,
                width: 22.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryBlue, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: isSelected,
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryBlue),
                        height: 14.h,
                        width: 14.w,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
