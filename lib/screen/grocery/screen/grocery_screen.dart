
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_bloc.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_event.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_state.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/models/get_grocery_item_list_model.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_item_details.dart';
import 'package:gymeats_mobile/screen/journal/journal_search_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bottomsheet/clear_all_item_bottomsheet.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bottomsheet/receive_order_ask_bottomsheet.dart';
import 'package:gymeats_mobile/screen/widget/grocery_add_button_widget.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';
import 'package:shimmer/shimmer.dart';

class GroceryPlanScreen extends StatefulWidget {
  const GroceryPlanScreen({super.key});

  @override
  State<GroceryPlanScreen> createState() => _GroceryPlanScreenState();
}

class _GroceryPlanScreenState extends State<GroceryPlanScreen> {
  final routeName = '/GroceryPlanScreen';
  int selectedItemCount = 0;
  String _selectProduct = 'Spoon';
  List<String> productList = ['Spoon', 'Cup'];
  GroceryBloc groceryBloc = GroceryBloc();
  AddNewGroceryItemBloc addNewGroceryItemBloc = AddNewGroceryItemBloc();
  List<GroceryDetails> groceryDetails = [];
  List<GroceryDetails> searchGroceryDetails = [];
  bool isListClearByClick = false;
  bool isGroceryFetchLoadingState = true;
  bool isSearchOn = false;
  List<Map<String, dynamic>> checkbox = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // groceryBloc.add(AddGroceryToShoppingListFromSuggesticEvent(
      //     latitude: '41.881832', longitude: '-87.623177'));
      // groceryBloc.add(GroceryFetchEvent());
      addNewGroceryItemBloc.add(GetGroceryItemEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<AddNewGroceryItemBloc, AddNewGroceryItemState>(
          bloc: addNewGroceryItemBloc,
          listener: (context, state) async {
            /// Get Item Stat ==============================================

            ///----------Loading State
            if (state is GetGroceryListLoadingState) {
              isGroceryFetchLoadingState = true;
            }

            ///----------Success State
            if (state is GetGroceryListSuccessState) {
              groceryDetails = state.groceryDetails ?? [];

              isGroceryFetchLoadingState = false;
              if (groceryDetails.isNotEmpty) {
                for (var i = 0; i < groceryDetails.length; i++) {
                  checkbox.add({
                    'value': true,
                    'onDelete': false,
                    'onUpdateRemove': false,
                    'onUpdateAdd': false,
                  });
                }

                selectedItemCount = groceryDetails.length;
              } else {
                selectedItemCount = 0;
              }
            }

            ///----------Error State
            if (state is GetGroceryListErrorState) {
              isGroceryFetchLoadingState = false;
            }

            /// Remove Item Stat ===========================================================

            ///----------Loading State
            if (state is RemoveGroceryItemLoadingState) {
              if (isSearchOn == true) {
                for (var i = 0; i < searchGroceryDetails.length; i++) {
                  if (searchGroceryDetails[i].id! == state.userGroceryListId) {
                    checkbox[i]['onDelete'] = true;
                    break;
                  }
                }
              } else {
                for (var i = 0; i < groceryDetails.length; i++) {
                  if (groceryDetails[i].id! == state.userGroceryListId) {
                    checkbox[i]['onDelete'] = true;
                    break;
                  }
                }
              }
            }

            ///----------Success State
            if (state is RemoveGroceryItemSuccessState) {
              if (isSearchOn == true) {
                for (var i = 0; i < searchGroceryDetails.length; i++) {
                  if (searchGroceryDetails[i].id == state.userGroceryListId) {
                    searchGroceryDetails
                        .removeWhere((e) => e.id == state.userGroceryListId);

                    checkbox[i]['onDelete'] = false;

                    if (groceryDetails.isNotEmpty) {
                      checkbox.clear();
                      for (var i = 0; i < groceryDetails.length; i++) {
                        checkbox.add({
                          'value': true,
                          'onDelete': false,
                          'onUpdateRemove': false,
                          'onUpdateAdd': false,
                        });
                      }
                      selectedItemCount = groceryDetails.length;
                    }

                    break;
                  }
                }

                for (var i = 0; i < groceryDetails.length; i++) {
                  if (groceryDetails[i].id == state.userGroceryListId) {
                    groceryDetails
                        .removeWhere((e) => e.id == state.userGroceryListId);

                    checkbox[i]['onDelete'] = false;

                    if (groceryDetails.isNotEmpty) {
                      checkbox.clear();
                      for (var i = 0; i < groceryDetails.length; i++) {
                        checkbox.add({
                          'value': true,
                          'onDelete': false,
                          'onUpdateRemove': false,
                          'onUpdateAdd': false,
                        });
                      }
                      selectedItemCount = groceryDetails.length;
                    } else {
                      selectedItemCount = 0;
                    }

                    break;
                  }
                }
              } else {
                for (var i = 0; i < groceryDetails.length; i++) {
                  if (groceryDetails[i].id == state.userGroceryListId) {
                    groceryDetails
                        .removeWhere((e) => e.id == state.userGroceryListId);

                    checkbox[i]['onDelete'] = false;

                    if (groceryDetails.isNotEmpty) {
                      checkbox.clear();
                      for (var i = 0; i < groceryDetails.length; i++) {
                        checkbox.add({
                          'value': true,
                          'onDelete': false,
                          'onUpdateRemove': false,
                          'onUpdateAdd': false,
                        });
                      }
                      selectedItemCount = groceryDetails.length;
                    } else {
                      selectedItemCount = 0;
                    }

                    break;
                  }
                }
              }
            }

            ///----------Error State
            if (state is RemoveGroceryItemErrorState) {
              if (isSearchOn == true) {
                for (var i = 0; i < searchGroceryDetails.length; i++) {
                  if (searchGroceryDetails[i].id! == state.userGroceryListId) {
                    checkbox[i]['onDelete'] = false;
                    break;
                  }
                }
              } else {
                for (var i = 0; i < groceryDetails.length; i++) {
                  if (groceryDetails[i].id! == state.userGroceryListId) {
                    checkbox[i]['onDelete'] = false;
                    break;
                  }
                }
              }
            }

            /// Clear Grocery List Stat======================================================

            ///----------Success State
            if (state is ClearGrocerySuccessState) {
              groceryDetails.clear();
              checkbox.clear();
              selectedItemCount = 0;
            }

            /// Update Add Grocery Item List Stat=============================================

            ///----------Loading State
            if (state is UpdateAddGroceryListLoadingState) {
              for (var i = 0; i < groceryDetails.length; i++) {
                if (groceryDetails[i].id! == state.userGroceryListId) {
                  checkbox[i]['onUpdateAdd'] = true;
                  break;
                }
                if (isSearchOn == true) {
                  if (searchGroceryDetails[i].id! == state.userGroceryListId) {
                    checkbox[i]['onUpdateAdd'] = true;
                  }
                  break;
                }
              }
            }

            ///----------Error State
            if (state is UpdateAddGroceryListErrorState) {
              for (var i = 0; i < groceryDetails.length; i++) {
                if (groceryDetails[i].id! == state.userGroceryListId) {
                  checkbox[i]['onUpdateAdd'] = false;
                  break;
                }
                if (isSearchOn == true) {
                  if (searchGroceryDetails[i].id! == state.userGroceryListId) {
                    checkbox[i]['onUpdateAdd'] = false;
                  }
                  break;
                }
              }
            }

            ///----------Success State
            if (state is UpdateAddGroceryListSuccessState) {
              if (isSearchOn == true) {
                for (var i = 0; i < searchGroceryDetails.length; i++) {
                  if (searchGroceryDetails[i].id! == state.userGroceryListId) {
                    searchGroceryDetails[i].quantity =
                        searchGroceryDetails[i].quantity + 1;
                    checkbox[i]['onUpdateAdd'] = false;
                    break;
                  }
                }
              } else {
                for (var i = 0; i < groceryDetails.length; i++) {
                  if (groceryDetails[i].id! == state.userGroceryListId) {
                    groceryDetails[i].quantity = groceryDetails[i].quantity + 1;
                    checkbox[i]['onUpdateAdd'] = false;
                    break;
                  }
                }
              }
            }

            /// Update Remove Grocery Item List Stat===========================================

            ///----------Loading State
            if (state is UpdateRemoveGroceryListLoadingState) {
              if (isSearchOn == true) {
                for (var i = 0; i < searchGroceryDetails.length; i++) {
                  if (searchGroceryDetails[i].id! == state.userGroceryListId) {
                    checkbox[i]['onUpdateRemove'] = true;
                    break;
                  }
                }
              } else {
                for (var i = 0; i < groceryDetails.length; i++) {
                  if (groceryDetails[i].id! == state.userGroceryListId) {
                    checkbox[i]['onUpdateRemove'] = true;
                    break;
                  }
                }
              }
            }

            ///----------Error State
            if (state is UpdateRemoveGroceryListErrorState) {
              if (isSearchOn == true) {
                for (var i = 0; i < searchGroceryDetails.length; i++) {
                  if (searchGroceryDetails[i].id! == state.userGroceryListId) {
                    checkbox[i]['onUpdateRemove'] = false;
                    break;
                  }
                }
              } else {
                for (var i = 0; i < groceryDetails.length; i++) {
                  if (groceryDetails[i].id! == state.userGroceryListId) {
                    checkbox[i]['onUpdateRemove'] = false;
                    break;
                  }
                }
              }
            }

            if (state is UpdateRemoveGroceryListSuccessState) {
              if (isSearchOn == true) {
                for (var i = 0; i < searchGroceryDetails.length; i++) {
                  if (searchGroceryDetails[i].id! == state.userGroceryListId) {
                    searchGroceryDetails[i].quantity =
                        searchGroceryDetails[i].quantity - 1;
                    checkbox[i]['onUpdateRemove'] = false;
                    break;
                  }
                }
              } else {
                for (var i = 0; i < groceryDetails.length; i++) {
                  if (groceryDetails[i].id! == state.userGroceryListId) {
                    groceryDetails[i].quantity = groceryDetails[i].quantity - 1;
                    checkbox[i]['onUpdateRemove'] = false;
                    break;
                  }
                }
              }
            }
          },
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Grocery List',
                            style: FontUtils.h20(
                                fontColor: AppColors.oxFF010101,
                                fontWeight: FWT.semiBold)),
                      ],
                    ).paddingSymmetric(horizontal: 20.w, vertical: 5.h),
                    Divider(color: AppColors.darkGray, height: 3.h),
                    groceryDetails.isEmpty
                        ? SizedBox(
                            height: 20.h,
                          )
                        : GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return ClearAllItemBottomSheet(
                                    bloc: addNewGroceryItemBloc,
                                  );
                                },
                                isDismissible: false,
                              );
                            },
                            child: Text('Clear My Grocery List',
                                    style: FontUtils.h18(
                                        fontColor: AppColors.primaryBlue,
                                        fontWeight: FWT.medium))
                                .paddingSymmetric(vertical: 10.h),
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          boxShadow: boxShadowWidget,
                        ),
                        child: TextFormField(
                          readOnly: true,
                          onTap: () {
                            // Get.toNamed('/GrocerySearchScreen')!.then((value) {
                            //   groceryBloc.add(GroceryFetchEvent());
                            // });

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const JournalSearchScreen(
                                    isFrom: 'Grocery',
                                  );
                                },
                              ),
                            ).then((value) {
                              setState(() {
                                addNewGroceryItemBloc
                                    .add(GetGroceryItemEvent());
                              });
                            });
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search for item',
                            hintStyle: FontUtils.h16(),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Expanded(
                      child: groceryDetails.isEmpty
                          ? isGroceryFetchLoadingState
                              ? SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: ListView.builder(
                                    itemCount: 10,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 12),
                                        child: Shimmer.fromColors(
                                            baseColor: AppColors.disable
                                                .withOpacity(0.20),
                                            highlightColor: AppColors.disable
                                                .withOpacity(0.20),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              AppColors.disable,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7)),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Container(
                                                      height: 40,
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              AppColors.disable,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7)),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 7),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 4,
                                                      child: Container(
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .disable,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7)),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .disable,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7)),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .disable,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7)),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .disable,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                const Divider(
                                                    color: AppColors.disable,
                                                    thickness: 1.2),
                                              ],
                                            )),
                                      );
                                    },
                                  ),
                                )
                              : Column(
                                  children: [
                                    SvgPicture.asset(
                                        AssetsUtils.emptyShoppingListIcon),
                                    Text(
                                      'Your Grocery List is empty.\nPlease, search for an Item\nor check your Meal Plan.',
                                      textAlign: TextAlign.center,
                                      style: FontUtils.h14(
                                          fontWeight: FWT.regular),
                                    ),
                                  ],
                                )
                          :

                          ///Regular Data Display ===================================================

                          SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: ListView.builder(
                                itemCount: groceryDetails.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      await Get.toNamed('/GroceryItemDetails',
                                              arguments:
                                                  GroceryItemDetailsArguments(
                                                      groceryShoppingData:
                                                          groceryDetails[
                                                              index]))!
                                          .then((value) {
                                        setState(() {
                                          addNewGroceryItemBloc
                                              .add(GetGroceryItemEvent());
                                        });
                                      });
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    height: 20.0,
                                                    width: 20.0,
                                                    child: Transform.scale(
                                                      scale: 1.2,
                                                      child: Checkbox(
                                                        activeColor:
                                                            AppColors.appColor,
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        value: checkbox[index]
                                                            ['value'],
                                                        // value: edgesList[
                                                        //         index]
                                                        //     .isAddedForViewCart,
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            checkbox[index]
                                                                    ['value'] =
                                                                value!;

                                                            int count = 0;

                                                            for (var i = 0;
                                                                i <
                                                                    checkbox
                                                                        .length;
                                                                i++) {
                                                              if (checkbox[i][
                                                                      'value'] ==
                                                                  true) {
                                                                count =
                                                                    count + 1;
                                                              }
                                                            }

                                                            selectedItemCount =
                                                                count;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Text(
                                                        groceryDetails[index]
                                                                .itemName ??
                                                            '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: FontUtils.h16(
                                                            fontColor: AppColors
                                                                .black),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 6.h),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child:
                                                      DropdownButtonFormField(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          decoration: const InputDecoration(
                                                              border: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .black))),
                                                          value: _selectProduct,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          items: productList
                                                              .map((e) =>
                                                                  DropdownMenuItem(
                                                                    value: e,
                                                                    child:
                                                                        Text(e),
                                                                  ))
                                                              .toList(),
                                                          onChanged: (val) {
                                                            setState(() {
                                                              _selectProduct =
                                                                  val!;
                                                            });
                                                          }),
                                                ),
                                                SizedBox(width: 8.w),
                                                groceryDetails[index]
                                                            .quantity! >
                                                        1
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          addNewGroceryItemBloc
                                                              .add(
                                                            UpdateRemoveNewGroceryItem(
                                                              userId: userId,
                                                              id: groceryDetails[
                                                                      index]
                                                                  .id!
                                                                  .toString(),
                                                              itemName:
                                                                  groceryDetails[
                                                                          index]
                                                                      .itemName!
                                                                      .toString(),
                                                              quantity: groceryDetails[
                                                                          index]
                                                                      .quantity -
                                                                  1,
                                                              measurementType:
                                                                  groceryDetails[
                                                                          index]
                                                                      .measurementType!
                                                                      .toString(),
                                                              measurementValue:
                                                                  groceryDetails[
                                                                          index]
                                                                      .measurementValue!
                                                                      .toString(),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          height: size.height *
                                                              0.070,
                                                          width: size.height *
                                                              0.070,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: AppColors
                                                                .skyBlue,
                                                          ),
                                                          child: Center(
                                                            child: checkbox[index]
                                                                        [
                                                                        'onUpdateRemove'] ==
                                                                    true
                                                                ? Transform.scale(
                                                                    scale: 0.5,
                                                                    child:
                                                                        const CircularProgressIndicator())
                                                                : const Icon(
                                                                    Icons
                                                                        .remove,
                                                                    size: 27),
                                                          ),
                                                          // child: const Center(child: Icon(Icons.remove, size: 27)),
                                                        ),
                                                      )
                                                    : GestureDetector(
                                                        onTap: () async {
                                                          // groceryBloc.add(
                                                          //     RemoveGroceryEvent(
                                                          //         productID:
                                                          //             edgesList[index]
                                                          //                 .productId!));

                                                          addNewGroceryItemBloc
                                                              .add(
                                                            RemoveGroceryItemEvent(
                                                              userGroceryListId:
                                                                  groceryDetails[
                                                                          index]
                                                                      .id!,
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          height: size.height *
                                                              0.070,
                                                          width: size.height *
                                                              0.070,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: AppColors
                                                                      .skyBlue),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6)),
                                                          child: Center(
                                                              child: checkbox[index]
                                                                          [
                                                                          'onDelete'] ==
                                                                      true
                                                                  ? Transform.scale(
                                                                      scale:
                                                                          0.5,
                                                                      child:
                                                                          const CircularProgressIndicator())
                                                                  : SvgPicture.asset(
                                                                      AssetsUtils
                                                                          .icDelete)),
                                                        ),
                                                      ),
                                                SizedBox(width: 8.w),
                                                Container(
                                                  height: size.height * 0.070,
                                                  width: size.height * 0.070,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: AppColors
                                                              .disable),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6)),
                                                  child: Center(
                                                      child: Text(
                                                    groceryDetails[index]
                                                        .quantity
                                                        .toString(),
                                                    style: FontUtils.h18(
                                                        fontWeight:
                                                            FWT.semiBold,
                                                        fontColor:
                                                            AppColors.darkGray),
                                                  )),
                                                ),
                                                SizedBox(width: 8.w),
                                                GestureDetector(
                                                  onTap: () {
                                                    addNewGroceryItemBloc.add(
                                                      UpdateAddNewGroceryItem(
                                                        userId: userId,
                                                        id: groceryDetails[
                                                                index]
                                                            .id!
                                                            .toString(),
                                                        itemName:
                                                            groceryDetails[
                                                                    index]
                                                                .itemName!
                                                                .toString(),
                                                        quantity:
                                                            groceryDetails[
                                                                        index]
                                                                    .quantity +
                                                                1,
                                                        measurementType:
                                                            groceryDetails[
                                                                    index]
                                                                .measurementType!
                                                                .toString(),
                                                        measurementValue:
                                                            groceryDetails[
                                                                    index]
                                                                .measurementValue!
                                                                .toString(),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    height: size.height * 0.070,
                                                    width: size.height * 0.070,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      color: AppColors.skyBlue,
                                                    ),
                                                    child: Center(
                                                      child: checkbox[index][
                                                                  'onUpdateAdd'] ==
                                                              true
                                                          ? Transform.scale(
                                                              scale: 0.5,
                                                              child:
                                                                  const CircularProgressIndicator())
                                                          : const Icon(
                                                              Icons.add,
                                                              size: 27),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.h),
                                            const Divider(
                                                color: AppColors.disable,
                                                thickness: 1.1),
                                            SizedBox(height: 5.h),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                    // GroceryAddButtonWidget(
                    //   onTap: () {
                    //     for (var i = 0; i < edgesList.length; i++) {
                    //       setState(() {
                    //         edgesList[i].isActive = false;
                    //       });
                    //     }
                    //   },
                    //   buttonLable: 'UN-CHECK',
                    //   isFillColor: false,
                    //   selectedItemCount: selectedItemCount,
                    // ),
                    GroceryAddButtonWidget(
                      onTap: () {
                        List<GroceryDetails> edgesDummyList = [];
                        if (groceryDetails.isNotEmpty) {
                          for (var i = 0; i < groceryDetails.length; i++) {
                            if (checkbox[i]['value'] == true) {
                              edgesDummyList.add(groceryDetails[i]);
                            }
                          }
                        }

                        if (edgesDummyList.isNotEmpty) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return ReceiveOrderAskBottomSheet(
                                addNewGroceryItemBloc: addNewGroceryItemBloc,
                                groceryBloc: groceryBloc,
                                selectedEdgesList: edgesDummyList,
                              );
                            },
                            isDismissible: false,
                          );
                        } else {
                          Fluttertoast.showToast(msg: 'Select atleast 1 item');
                        }
                      },
                      buttonLable: 'View Cart',
                      isFillColor: false,
                      selectedItemCount: selectedItemCount,
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
