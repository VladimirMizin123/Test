import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_shopping_modal.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_item_details.dart';
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
  List<GroceryShoppingData> edgesList = [];
  AskReceiveOrder? askReceiveOrder;
  bool isListClearByClick = false;
  bool isGroceryFetchLoadingState = true;
  List<GroceryShoppingData> searchEdgesList = [];
  bool isSearchOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      groceryBloc.add(AddGroceryToShoppingListFromSuggesticEvent(latitude: '44718980.05717322', longitude: '44718980.05717322'));
      groceryBloc.add(GroceryFetchEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<GroceryBloc, GroceryState>(
          bloc: groceryBloc,
          listener: (context, state) {
            // FETCH STATE - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            if (state is GroceryFetchLoadingState) {
              isGroceryFetchLoadingState = true;
            }
            if (state is GroceryFetchSuccessState) {
              edgesList = state.edgesList ?? [];
              isGroceryFetchLoadingState = false;
              int count = 0;
              for (var i = 0; i < edgesList.length; i++) {
                if (edgesList[i].isAddedForViewCart == true) {
                  count = count + 1;
                }
              }
              selectedItemCount = count;
            }

            // Grocery Add-Remove STATE - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            if (state is GroceryAddToShoppingLoadingState) {
              for (var i = 0; i < edgesList.length; i++) {
                if (edgesList[i].productId! == state.productId) {
                  edgesList[i].isAddItem = state.isAdd;
                  edgesList[i].isRemoveItem = state.isRemove;

                  break;
                }
              }
              int count = 0;
              for (var i = 0; i < edgesList.length; i++) {
                if (edgesList[i].isAddedForViewCart == true) {
                  count = count + 1;
                }
              }
              selectedItemCount = count;
            }

            if (state is GroceryAddToShoppingSuccessState) {
              for (var i = 0; i < edgesList.length; i++) {
                if (edgesList[i].productId == state.recipesAddToGroceryData!.productId) {
                  edgesList[i].isAddItem = false;
                  edgesList[i].isRemoveItem = false;
                  edgesList[i].quantity = state.recipesAddToGroceryData!.quantity;
                  break;
                }
              }
              int count = 0;
              for (var i = 0; i < edgesList.length; i++) {
                if (edgesList[i].isAddedForViewCart == true) {
                  count = count + 1;
                }
              }
              selectedItemCount = count;
            }
            
            if (state is GroceryAddToShoppingErrorState) {
              for (var i = 0; i < edgesList.length; i++) {
                  edgesList[i].isAddItem = false;
                  edgesList[i].isRemoveItem = false;
              }
            }

            // Grocery Delete STATE - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            if (state is RemoveGroceryLoadingState) {
              for (var i = 0; i < edgesList.length; i++) {
                if (edgesList[i].productId! == state.productId) {
                  edgesList[i].isDeleteLoading = true;
                  break;
                }
              }
              int count = 0;
              for (var i = 0; i < edgesList.length; i++) {
                if (edgesList[i].isAddedForViewCart == true) {
                  count = count + 1;
                }
              }
              selectedItemCount = count;
            }

            if (state is RemoveGrocerySuccessState) {
              for (var i = 0; i < edgesList.length; i++) {
                if (edgesList[i].productId == state.productID) {
                  edgesList[i].isDeleteLoading = false;
                  edgesList.removeWhere((e) => e.productId == state.productID);
                  break;
                }
              }
              int count = 0;
              for (var i = 0; i < edgesList.length; i++) {
                if (edgesList[i].isAddedForViewCart == true) {
                  count = count + 1;
                }
              }
              selectedItemCount = count;
            }

            if (state is RemoveGroceryErrorState) {
              for (var i = 0; i < edgesList.length; i++) {
                if (edgesList[i].productId == state.productID) {
                  edgesList[i].isDeleteLoading = false;
                  break;
                }
              }
              int count = 0;
              for (var i = 0; i < edgesList.length; i++) {
                if (edgesList[i].isAddedForViewCart == true) {
                  count = count + 1;
                }
              }
              selectedItemCount = count;
            }

            if (state is GroceryAskReceiveOrderEventState) {
              askReceiveOrder = state.askReceiveOrder;
            }

            if (state is ClearShoppingListSuccessState) {
              if (state.isClear) {
                setState(() {
                  edgesList.clear();
                  Navigator.pop(context);
                  isListClearByClick = true;
                });
              }
            }
            int count = 0;
            for (var i = 0; i < edgesList.length; i++) {
              if (edgesList[i].isAddedForViewCart == true) {
                count = count + 1;
              }
            }
            selectedItemCount = count;
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
                        Text('Grocery List', style: FontUtils.h20(fontColor: AppColors.oxFF010101, fontWeight: FWT.semiBold)),
                      ],
                    ).paddingSymmetric(horizontal: 20.w, vertical: 5.h),
                    Divider(color: AppColors.darkGray, height: 3.h),
                    edgesList.isEmpty && isListClearByClick
                        ? Text('Clear My Grocery List', style: FontUtils.h18(fontColor: AppColors.grayColor, fontWeight: FWT.medium)).paddingSymmetric(vertical: 10.h)
                        : edgesList.isEmpty
                            ? GestureDetector(
                                onTap: () {
                                  groceryBloc.add(GroceryFetchEvent());
                                },
                                child: Text(StringUtils.regenerateGroceryList, style: FontUtils.h18(fontColor: AppColors.primaryBlue, fontWeight: FWT.medium)).paddingSymmetric(vertical: 10.h),
                              )
                            : GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return ClearAllItemBottomSheet(
                                        bloc: groceryBloc,
                                      );
                                    },
                                    isDismissible: false,
                                  );
                                },
                                child: Text('Clear My Grocery List', style: FontUtils.h18(fontColor: AppColors.primaryBlue, fontWeight: FWT.medium)).paddingSymmetric(vertical: 10.h),
                              ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          boxShadow: boxShadowWidget,
                        ),
                        child: TextFormField(
                          onTap: () {
                            // Get.toNamed('/GrocerySearchScreen')!.then((value) {
                            //   groceryBloc.add(GroceryFetchEvent());
                            // });
                          },
                          onChanged: (String? value) {
                            setState(() {
                              if (value != null || value != '') {
                                isSearchOn = true;
                                searchEdgesList = edgesList.where((item) => item.productName!.toLowerCase().contains(value!.toLowerCase())).toList();
                              } else {
                                isSearchOn = false;
                              }
                            });
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search for item',
                            hintStyle: FontUtils.h16(),
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Expanded(
                      child: edgesList.isEmpty
                          ? isGroceryFetchLoadingState
                              ? SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: ListView.builder(
                                    itemCount: 10,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.vertical,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                        child: Shimmer.fromColors(
                                            baseColor: AppColors.disable.withOpacity(0.20),
                                            highlightColor: AppColors.disable.withOpacity(0.20),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(color: AppColors.disable, borderRadius: BorderRadius.circular(7)),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Container(
                                                      height: 40,
                                                      width: 120,
                                                      decoration: BoxDecoration(color: AppColors.disable, borderRadius: BorderRadius.circular(7)),
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
                                                        decoration: BoxDecoration(color: AppColors.disable, borderRadius: BorderRadius.circular(7)),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        height: 50,
                                                        decoration: BoxDecoration(color: AppColors.disable, borderRadius: BorderRadius.circular(7)),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        height: 50,
                                                        decoration: BoxDecoration(color: AppColors.disable, borderRadius: BorderRadius.circular(7)),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        height: 50,
                                                        decoration: BoxDecoration(color: AppColors.disable, borderRadius: BorderRadius.circular(7)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                const Divider(color: AppColors.disable, thickness: 1.2),
                                              ],
                                            )),
                                      );
                                    },
                                  ),
                                )
                              : Column(
                                  children: [
                                    SvgPicture.asset(AssetsUtils.emptyShoppingListIcon),
                                    Text(
                                      'Your Grocery List is empty.\nPlease, search for an Item\nor check your Meal Plan.',
                                      textAlign: TextAlign.center,
                                      style: FontUtils.h14(fontWeight: FWT.regular),
                                    ),
                                  ],
                                )
                          : isSearchOn
                              ? searchEdgesList.isNotEmpty
                                  ? SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: ListView.builder(
                                        itemCount: searchEdgesList.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Get.toNamed('/GroceryItemDetails', arguments: GroceryItemDetailsArguments(groceryShoppingData: searchEdgesList[index]))!.then((value) {
                                                groceryBloc.add(GroceryFetchEvent());
                                              });
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            height: 20.0,
                                                            width: 20.0,
                                                            child: Transform.scale(
                                                              scale: 1.2,
                                                              child: Checkbox(
                                                                activeColor: AppColors.appColor,
                                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                value: searchEdgesList[index].isAddedForViewCart,
                                                                onChanged: (bool? value) {
                                                                  setState(() {
                                                                    int count = 0;
                                                                    searchEdgesList[index].isAddedForViewCart = !searchEdgesList[index].isAddedForViewCart!;

                                                                    for (var i = 0; i < searchEdgesList.length; i++) {
                                                                      if (searchEdgesList[i].isAddedForViewCart == true) {
                                                                        count = count + 1;
                                                                      }
                                                                    }

                                                                    selectedItemCount = count;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 12),
                                                          Expanded(
                                                            child: SingleChildScrollView(
                                                              scrollDirection: Axis.horizontal,
                                                              child: Text(
                                                                searchEdgesList[index].productName ?? '',
                                                                overflow: TextOverflow.ellipsis,
                                                                style: FontUtils.h16(fontColor: AppColors.black),
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
                                                          child: DropdownButtonFormField(
                                                              padding: EdgeInsets.zero,
                                                              decoration: const InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),
                                                              value: _selectProduct,
                                                              borderRadius: BorderRadius.circular(12),
                                                              items: productList
                                                                  .map((e) => DropdownMenuItem(
                                                                        value: e,
                                                                        child: Text(e),
                                                                      ))
                                                                  .toList(),
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  _selectProduct = val!;
                                                                });
                                                              }),
                                                        ),
                                                        SizedBox(width: 8.w),
                                                        searchEdgesList[index].quantity! > 1
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  groceryBloc.add(GroceryAddToShoppingListEvent(
                                                                    productID: searchEdgesList[index].productId!,
                                                                    mealmeStoreId: searchEdgesList[index].mealmeStoreId!,
                                                                    price: searchEdgesList[index].price.toString(),
                                                                    productName: searchEdgesList[index].productName!,
                                                                    quantity: (searchEdgesList[index].quantity! - 1).toString(),
                                                                    recipeId: searchEdgesList[index].recipeId!,
                                                                    unitOfMeasurement: searchEdgesList[index].unitOfMeasurement!,
                                                                    unitSize: searchEdgesList[index].unitSize.toString(),
                                                                    isAdd: false,
                                                                    isRemove: true,
                                                                    isChecked: searchEdgesList[index].isAddedForViewCart ?? false,
                                                                  ));
                                                                },
                                                                child: Container(
                                                                  height: size.height * 0.070,
                                                                  width: size.height * 0.070,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(6),
                                                                    color: AppColors.skyBlue,
                                                                  ),
                                                                  child: Center(
                                                                    child: searchEdgesList[index].isRemoveItem ?? false ? Transform.scale(scale: 0.5, child: const CircularProgressIndicator()) : const Icon(Icons.remove, size: 27),
                                                                  ),
                                                                  // child: const Center(child: Icon(Icons.remove, size: 27)),
                                                                ),
                                                              )
                                                            : GestureDetector(
                                                                onTap: () {
                                                                  groceryBloc.add(RemoveGroceryEvent(productID: searchEdgesList[index].productId!));
                                                                },
                                                                child: Container(
                                                                  height: size.height * 0.070,
                                                                  width: size.height * 0.070,
                                                                  decoration: BoxDecoration(border: Border.all(color: AppColors.skyBlue), borderRadius: BorderRadius.circular(6)),
                                                                  child: Center(child: searchEdgesList[index].isDeleteLoading ?? false ? Transform.scale(scale: 0.5, child: const CircularProgressIndicator()) : SvgPicture.asset(AssetsUtils.icDelete)),
                                                                ),
                                                              ),
                                                        SizedBox(width: 8.w),
                                                        Container(
                                                          height: size.height * 0.070,
                                                          width: size.height * 0.070,
                                                          decoration: BoxDecoration(border: Border.all(color: AppColors.disable), borderRadius: BorderRadius.circular(6)),
                                                          child: Center(
                                                              child: Text(
                                                            searchEdgesList[index].quantity.toString(),
                                                            style: FontUtils.h18(fontWeight: FWT.semiBold, fontColor: AppColors.darkGray),
                                                          )),
                                                        ),
                                                        SizedBox(width: 8.w),
                                                        GestureDetector(
                                                          onTap: () {
                                                            groceryBloc.add(GroceryAddToShoppingListEvent(
                                                              productID: searchEdgesList[index].productId!,
                                                              mealmeStoreId: searchEdgesList[index].mealmeStoreId!,
                                                              price: searchEdgesList[index].price.toString(),
                                                              productName: searchEdgesList[index].productName!,
                                                              quantity: (searchEdgesList[index].quantity! + 1).toString(),
                                                              recipeId: searchEdgesList[index].recipeId!,
                                                              unitOfMeasurement: searchEdgesList[index].unitOfMeasurement!,
                                                              unitSize: searchEdgesList[index].unitSize.toString(),
                                                              isAdd: true,
                                                              isRemove: false,
                                                              isChecked: searchEdgesList[index].isAddedForViewCart ?? false,
                                                            ));
                                                          },
                                                          child: Container(
                                                            height: size.height * 0.070,
                                                            width: size.height * 0.070,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(6),
                                                              color: AppColors.skyBlue,
                                                            ),
                                                            child: Center(
                                                              child: searchEdgesList[index].isAddItem ?? false ? Transform.scale(scale: 0.5, child: const CircularProgressIndicator()) : const Icon(Icons.add, size: 27),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    const Divider(color: AppColors.disable, thickness: 1.1),
                                                    SizedBox(height: 5.h),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : const Text('No Search Found!')
                              : SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: ListView.builder(
                                    itemCount: edgesList.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.toNamed('/GroceryItemDetails', arguments: GroceryItemDetailsArguments(groceryShoppingData: edgesList[index]))!.then((value) {
                                            groceryBloc.add(GroceryFetchEvent());
                                          });
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        height: 20.0,
                                                        width: 20.0,
                                                        child: Transform.scale(
                                                          scale: 1.2,
                                                          child: Checkbox(
                                                            activeColor: AppColors.appColor,
                                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                            value: edgesList[index].isAddedForViewCart,
                                                            onChanged: (bool? value) {
                                                              setState(() {
                                                                int count = 0;
                                                                edgesList[index].isAddedForViewCart = !edgesList[index].isAddedForViewCart!;

                                                                for (var i = 0; i < edgesList.length; i++) {
                                                                  if (edgesList[i].isAddedForViewCart == true) {
                                                                    count = count + 1;
                                                                  }
                                                                }

                                                                selectedItemCount = count;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: SingleChildScrollView(
                                                          scrollDirection: Axis.horizontal,
                                                          child: Text(
                                                            edgesList[index].productName ?? '',
                                                            overflow: TextOverflow.ellipsis,
                                                            style: FontUtils.h16(fontColor: AppColors.black),
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
                                                      child: DropdownButtonFormField(
                                                          padding: EdgeInsets.zero,
                                                          decoration: const InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),
                                                          value: _selectProduct,
                                                          borderRadius: BorderRadius.circular(12),
                                                          items: productList
                                                              .map((e) => DropdownMenuItem(
                                                                    value: e,
                                                                    child: Text(e),
                                                                  ))
                                                              .toList(),
                                                          onChanged: (val) {
                                                            setState(() {
                                                              _selectProduct = val!;
                                                            });
                                                          }),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    edgesList[index].quantity! > 1
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              groceryBloc.add(GroceryAddToShoppingListEvent(
                                                                productID: edgesList[index].productId!,
                                                                mealmeStoreId: edgesList[index].mealmeStoreId!,
                                                                price: edgesList[index].price.toString(),
                                                                productName: edgesList[index].productName!,
                                                                quantity: (edgesList[index].quantity! - 1).toString(),
                                                                recipeId: edgesList[index].recipeId!,
                                                                unitOfMeasurement: edgesList[index].unitOfMeasurement!,
                                                                unitSize: edgesList[index].unitSize.toString(),
                                                                isAdd: false,
                                                                isRemove: true,
                                                                isChecked: edgesList[index].isAddedForViewCart ?? false,
                                                              ));
                                                            },
                                                            child: Container(
                                                              height: size.height * 0.070,
                                                              width: size.height * 0.070,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(6),
                                                                color: AppColors.skyBlue,
                                                              ),
                                                              child: Center(
                                                                child: edgesList[index].isRemoveItem ?? false ? Transform.scale(scale: 0.5, child: const CircularProgressIndicator()) : const Icon(Icons.remove, size: 27),
                                                              ),
                                                              // child: const Center(child: Icon(Icons.remove, size: 27)),
                                                            ),
                                                          )
                                                        : GestureDetector(
                                                            onTap: () {
                                                              groceryBloc.add(RemoveGroceryEvent(productID: edgesList[index].productId!));
                                                            },
                                                            child: Container(
                                                              height: size.height * 0.070,
                                                              width: size.height * 0.070,
                                                              decoration: BoxDecoration(border: Border.all(color: AppColors.skyBlue), borderRadius: BorderRadius.circular(6)),
                                                              child: Center(child: edgesList[index].isDeleteLoading ?? false ? Transform.scale(scale: 0.5, child: const CircularProgressIndicator()) : SvgPicture.asset(AssetsUtils.icDelete)),
                                                            ),
                                                          ),
                                                    SizedBox(width: 8.w),
                                                    Container(
                                                      height: size.height * 0.070,
                                                      width: size.height * 0.070,
                                                      decoration: BoxDecoration(border: Border.all(color: AppColors.disable), borderRadius: BorderRadius.circular(6)),
                                                      child: Center(
                                                          child: Text(
                                                        edgesList[index].quantity.toString(),
                                                        style: FontUtils.h18(fontWeight: FWT.semiBold, fontColor: AppColors.darkGray),
                                                      )),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    GestureDetector(
                                                      onTap: () {
                                                        groceryBloc.add(GroceryAddToShoppingListEvent(
                                                          productID: edgesList[index].productId!,
                                                          mealmeStoreId: edgesList[index].mealmeStoreId!,
                                                          price: edgesList[index].price.toString(),
                                                          productName: edgesList[index].productName!,
                                                          quantity: (edgesList[index].quantity! + 1).toString(),
                                                          recipeId: edgesList[index].recipeId!,
                                                          unitOfMeasurement: edgesList[index].unitOfMeasurement!,
                                                          unitSize: edgesList[index].unitSize.toString(),
                                                          isAdd: true,
                                                          isRemove: false,
                                                          isChecked: edgesList[index].isAddedForViewCart ?? false,
                                                        ));
                                                      },
                                                      child: Container(
                                                        height: size.height * 0.070,
                                                        width: size.height * 0.070,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(6),
                                                          color: AppColors.skyBlue,
                                                        ),
                                                        child: Center(
                                                          child: edgesList[index].isAddItem ?? false ? Transform.scale(scale: 0.5, child: const CircularProgressIndicator()) : const Icon(Icons.add, size: 27),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10.h),
                                                const Divider(color: AppColors.disable, thickness: 1.1),
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
                        List<GroceryShoppingData> edgesDummyList = [];
                        if (edgesList.isNotEmpty) {
                          for (var i = 0; i < edgesList.length; i++) {
                            if (edgesList[i].isAddedForViewCart == true) {
                              edgesDummyList.add(edgesList[i]);
                            }
                          }
                        }

                        if (edgesDummyList.isNotEmpty) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return ReceiveOrderAskBottomSheet(groceryBloc: groceryBloc, selectedEdgesList: edgesDummyList);
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
