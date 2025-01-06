import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/screen/restaurants/res_category_data_service/res_categorydata_service.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart';
import 'package:gymeats_mobile/screen/restaurants/bottomsheet/filter_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

// ignore: must_be_immutable
class FilterScreen extends StatefulWidget {
  FilterScreen({
    super.key,
    // required this.cousinesList,
    required this.restaurantList,
    required this.selectedCategory,
    required this.rating,
    required this.isFastDelivery,
    required this.isPickup,
    required this.catgoryDataList,
    this.getUserAddres,
    required this.result,
    required this.restaurantBloc,
  });
  // final CousinesList cousinesList;
  final List<RestaurantList> restaurantList;
  List selectedCategory;
  final List rating;
  final bool isFastDelivery;
  final bool isPickup;
  final List<Map<String, dynamic>> catgoryDataList;
  final UserAddress? getUserAddres;
  final String? result;
  final RestaurantBloc restaurantBloc;

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List mealData = [
    {
      'image': AssetsUtils.food,
      'title': 'Asian',
    },
    {
      'image': AssetsUtils.food1,
      'title': 'Italian',
    },
    {
      'image': AssetsUtils.food2,
      'title': 'Chinese',
    },
    {
      'image': AssetsUtils.food,
      'title': 'Asian',
    },
    {
      'image': AssetsUtils.food1,
      'title': 'Italian',
    },
    {
      'image': AssetsUtils.food2,
      'title': 'Chinese',
    },
    {
      'image': AssetsUtils.food,
      'title': 'Asian',
    },
    {
      'image': AssetsUtils.food1,
      'title': 'Italian',
    },
    {
      'image': AssetsUtils.food2,
      'title': 'Chinese',
    },
    {
      'image': AssetsUtils.food,
      'title': 'Asian',
    },
    {
      'image': AssetsUtils.food1,
      'title': 'Italian',
    },
    {
      'image': AssetsUtils.food2,
      'title': 'Chinese',
    },
  ];
  List selectedTabData = [];
  List selectedCategoryData = [];
  Set<RestaurantList> data = {};
  Set<RestaurantList> ratingFilter = {};
  Set<RestaurantList> finalData = {};
  Map<String, dynamic> alldata = {};
  List rating = [];
  List price = [];
  bool isFilter = false;
  bool isFastDelivery = false;
  List mealType = [
    'Rating',
    'Fast Delivery',
  ];
  showBottomSheet({String? type}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FilterBottomSheet(
          filterType: type!,
          selectedValue: type == 'Price' ? price : rating,
        );
      },
      isDismissible: false,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
      ),
    ).then((value) {
      if (value != null) {
        setState(() {
          type == 'Price' ? price = value : rating = value;
        });
      } else {
        setState(() {});
      }
    });
  }

  List localList = [];
  @override
  void initState() {
    localList = widget.selectedCategory.map((e) => e).toList();
    selectedCategoryData = widget.selectedCategory;
    rating = widget.rating;
    data = Set.from(widget.restaurantList);
    isFastDelivery = widget.isFastDelivery;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.h),
            Center(
              child: Image.asset(
                AssetsUtils.gymEatsSpoon,
                height: 22.h,
                width: 56.w,
                color: AppColors.terracotta,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    ratingFilter.clear();
                    finalData.clear();

                    if (rating.isNotEmpty) {
                      if (rating.length == 1) {
                        ratingFilter.addAll(data
                            .where((element) =>
                                element.weightedRatingValue! <=
                                int.parse(rating.first))
                            .toList());
                      } else {
                        ratingFilter.addAll(data
                            .where((element) =>
                                element.weightedRatingValue! >=
                                    int.parse(rating.first) &&
                                element.weightedRatingValue! <=
                                    int.parse(rating.last))
                            .toList());
                      }

                      if (selectedCategoryData.isNotEmpty) {
                        for (var i = 0; i < ratingFilter.length; i++) {
                          for (var j = 0;
                              j < ratingFilter.elementAt(i).cuisines!.length;
                              j++) {
                            for (var k = 0;
                                k < selectedCategoryData.length;
                                k++) {
                              if (ratingFilter
                                  .elementAt(i)
                                  .cuisines![j]
                                  .contains(selectedCategoryData[k])) {
                                finalData.add(ratingFilter.elementAt(i));
                              }
                            }
                          }
                        }

                        if (isFastDelivery == true) {
                          List<RestaurantList> data = List.from(finalData);

                          data.sort(
                            (a, b) {
                              return a.quotes!.cheapestDelivery!.timeEstimate!
                                  .minimum!
                                  .compareTo(b.quotes!.cheapestDelivery!
                                      .timeEstimate!.minimum!);
                            },
                          );

                          finalData = Set.from(data);

                          alldata = {
                            'restaurantData': finalData,
                            'filterTab': selectedCategoryData,
                            'rating': rating,
                            'fastDelivery': isFastDelivery
                          };
                        } else {
                          alldata = {
                            'restaurantData': finalData,
                            'filterTab': selectedCategoryData,
                            'rating': rating,
                            'fastDelivery': isFastDelivery
                          };
                        }
                      } else {
                        if (isFastDelivery == true) {
                          List<RestaurantList> data = List.from(ratingFilter);

                          data.sort(
                            (a, b) {
                              return a.quotes!.cheapestDelivery!.timeEstimate!
                                  .minimum!
                                  .compareTo(b.quotes!.cheapestDelivery!
                                      .timeEstimate!.minimum!);
                            },
                          );

                          ratingFilter = Set.from(data);

                          alldata = {
                            'restaurantData': ratingFilter,
                            'filterTab': selectedCategoryData,
                            'rating': rating,
                            'fastDelivery': isFastDelivery
                          };
                        } else {
                          alldata = {
                            'restaurantData': ratingFilter,
                            'filterTab': selectedCategoryData,
                            'rating': rating,
                            'fastDelivery': isFastDelivery
                          };
                        }
                      }
                    }

                    /// WHEN RATING IS NOT SELECTED AND CATEGORY SELECTED ------------------------------------------------------

                    else if (selectedCategoryData.isNotEmpty) {
                      for (var i = 0; i < data.length; i++) {
                        for (var j = 0;
                            j < data.elementAt(i).cuisines!.length;
                            j++) {
                          for (var k = 0;
                              k < selectedCategoryData.length;
                              k++) {
                            if (data
                                .elementAt(i)
                                .cuisines![j]
                                .contains(selectedCategoryData[k])) {
                              finalData.add(data.elementAt(i));
                            }
                          }
                        }
                      }

                      if (isFastDelivery == true) {
                        List<RestaurantList> data = List.from(finalData);

                        data.sort(
                          (a, b) {
                            return a.quotes!.cheapestDelivery!.timeEstimate!
                                .minimum!
                                .compareTo(b.quotes!.cheapestDelivery!
                                    .timeEstimate!.minimum!);
                          },
                        );

                        finalData = Set.from(data);

                        alldata = {
                          'restaurantData': finalData,
                          'filterTab': selectedCategoryData,
                          'rating': rating,
                          'fastDelivery': isFastDelivery
                        };
                      } else {
                        alldata = {
                          'restaurantData': finalData,
                          'filterTab': selectedCategoryData,
                          'rating': rating,
                          'fastDelivery': isFastDelivery
                        };
                      }
                    } else if (isFastDelivery == true) {
                      widget.restaurantList.sort(
                        (a, b) {
                          return a
                              .quotes!.cheapestDelivery!.timeEstimate!.minimum!
                              .compareTo(b.quotes!.cheapestDelivery!
                                  .timeEstimate!.minimum!);
                        },
                      );

                      finalData = Set.from(widget.restaurantList);
                      alldata = {
                        'restaurantData': finalData,
                        'filterTab': selectedCategoryData,
                        'rating': rating,
                        'fastDelivery': isFastDelivery
                      };
                    } else {
                      alldata = {
                        'restaurantData': data,
                        'filterTab': selectedCategoryData,
                        'rating': rating,
                        'fastDelivery': isFastDelivery
                      };
                    }

                    Get.back(result: alldata);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 19,
                    color: AppColors.darkGray,
                  ),
                ),
                Text(
                  'All Filters',
                  style: FontUtils.h20(fontColor: AppColors.oxFF010101),
                ),
                const SizedBox(),
              ],
            ).paddingSymmetric(horizontal: 15.w),
            21.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Sort by',
                style: FontUtils.h24(
                  fontColor: const Color(0xff000000),
                  fontWeight: FWT.medium,
                ),
              ),
            ),

            /// Tab bar ----------------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.only(
                  top: 16, bottom: 24, right: 16, left: 16),
              child: SizedBox(
                height: 40.h,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: mealType.length,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        if (index == 0) {
                          showBottomSheet(type: 'Rating');
                        } else {
                          if (widget.isPickup == false) {
                            setState(() {
                              isFastDelivery = !isFastDelivery;
                            });
                          } else {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return SimpleDialog(
                                  shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: Text(
                                        'Fast delivery option is not available for Pickup Services',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w, vertical: 0.h),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.red.withOpacity(0.8),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Close',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: index == 0 && rating.isNotEmpty ||
                                  index == 1 && isFastDelivery
                              ? AppColors.coral
                              : AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          children: [
                            index == 0
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: Icon(
                                      Icons.star,
                                      color: rating.isNotEmpty
                                          ? AppColors.terracotta
                                          : AppColors.darkGray,
                                    ),
                                  )
                                : const SizedBox(),
                            Text(
                              mealType[index],
                              style: FontUtils.h18(
                                fontColor: index == 0 && rating.isNotEmpty ||
                                        index == 1 && isFastDelivery
                                    ? AppColors.terracotta
                                    : AppColors.darkGray,
                                fontWeight: FWT.medium,
                              ),
                            ),
                            index == 0
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      size: 15,
                                      color: index == 0 && rating.isNotEmpty ||
                                              index == 1 && isFastDelivery
                                          ? AppColors.terracotta
                                          : AppColors.darkGray,
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Browse by category',
                style: FontUtils.h24(
                  fontColor: Colors.black,
                  fontWeight: FWT.medium,
                ),
              ),
            ),

            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: MediaQuery.of(context).size.height * 0.13,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: widget.catgoryDataList.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (localList
                          .contains(widget.catgoryDataList[index]["title"])) {
                        setState(() {
                          localList
                              .remove(widget.catgoryDataList[index]["title"]);
                        });
                      } else {
                        setState(() {
                          localList.add(widget.catgoryDataList[index]["title"]);
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: localList.contains(
                                widget.catgoryDataList[index]["title"])
                            ? AppColors.coral
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: localList.contains(
                                widget.catgoryDataList[index]["title"])
                            ? Border.all(color: AppColors.terracotta)
                            : const Border(),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff004C63).withOpacity(0.08),
                            offset: const Offset(0, 0),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: SvgPicture.asset(
                              widget.catgoryDataList[index]["image"],
                              height: 45.h,
                              width: 45.w,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            widget.catgoryDataList[index]["title"],
                            style: FontUtils.h17(
                              fontColor: Colors.black,
                              fontWeight: FWT.semiBold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (localList.isNotEmpty) {
                          Get.back();
                          localList.clear();
                          selectedCategoryData.clear();
                          rating.clear();
                          isFastDelivery = false;
                          widget.restaurantBloc.add(
                            GetRestaurantListEvent(
                              widget.getUserAddres?.latitude ?? 0,
                              widget.getUserAddres?.longitude ?? 0,
                              widget.result == 'Bring me the order'
                                  ? false
                                  : true,
                              localList.isNotEmpty
                                  ? localList
                                  : categoryDataList
                                      .map((e) => e["title"])
                                      .toList(),
                            ),
                          );
                        }
                      });
                    },
                    child: Container(
                      height: 48,
                      width: MediaQuery.of(context).size.width / 2.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(
                          color: localList.isNotEmpty ||
                                  rating.isNotEmpty ||
                                  isFastDelivery
                              ? AppColors.terracotta
                              : AppColors.disabledColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Clear',
                          style: FontUtils.h18(
                            fontColor: localList.isNotEmpty ||
                                    rating.isNotEmpty ||
                                    isFastDelivery
                                ? AppColors.terracotta
                                : AppColors.disabledColor,
                            fontWeight: FWT.medium,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      selectedCategoryData = localList;
                      widget.restaurantBloc.add(
                        GetRestaurantListEvent(
                          widget.getUserAddres?.latitude ?? 0,
                          widget.getUserAddres?.longitude ?? 0,
                          widget.result == 'Bring me the order' ? false : true,
                          selectedCategoryData.isNotEmpty
                              ? selectedCategoryData
                              : categoryDataList
                                  .map((e) => e["title"])
                                  .toList(),
                        ),
                      );

                      if (
                          // selectedCategoryData
                          selectedCategoryData.isNotEmpty ||
                              rating.isNotEmpty ||
                              isFastDelivery) {
                        isFilter = true;
                      }

                      if (isFilter == false) {
                        showToast(
                          message: 'Select atleast 1 Category',
                          isSuccess: false,
                          color: AppColors.black,
                        );
                      } else {
                        ratingFilter.clear();
                        finalData.clear();

                        /// WHEN RATING IS SELECTED ------------------------------------------------------

                        if (rating.isNotEmpty) {
                          /// WHEN ONLY ONE RATING IS SELECTED ------------------------------------------------------

                          if (rating.length == 1) {
                            ratingFilter.addAll(data
                                .where((element) =>
                                    element.weightedRatingValue! <=
                                    int.parse(rating.first))
                                .toList());
                          }

                          /// WHEN RANGE OF RATING IS SELECTED ------------------------------------------------------

                          else {
                            ratingFilter.addAll(data
                                .where((element) =>
                                    element.weightedRatingValue! >=
                                        int.parse(rating.first) &&
                                    element.weightedRatingValue! <=
                                        int.parse(rating.last))
                                .toList());
                          }

                          /// WHEN CATEGORY IS SELECTED ------------------------------------------------------

                          if (
                              // selectedCategoryData
                              selectedCategoryData.isNotEmpty) {
                            for (var i = 0; i < ratingFilter.length; i++) {
                              for (var j = 0;
                                  j <
                                      ratingFilter
                                          .elementAt(i)
                                          .cuisines!
                                          .length;
                                  j++) {
                                for (var k = 0;
                                    k <
                                        // selectedCategoryData
                                        selectedCategoryData.length;
                                    k++) {
                                  if (ratingFilter
                                      .elementAt(i)
                                      .cuisines![j]
                                      .contains(selectedCategoryData[k])) {
                                    finalData.add(ratingFilter.elementAt(i));
                                  }
                                }
                              }
                            }

                            /// WHEN FAST DELIVERY IS SELECTED ------------------------------------------------------

                            if (isFastDelivery == true) {
                              List<RestaurantList> data = List.from(finalData);

                              data.sort(
                                (a, b) {
                                  return a.quotes!.cheapestDelivery!
                                      .timeEstimate!.minimum!
                                      .compareTo(b.quotes!.cheapestDelivery!
                                          .timeEstimate!.minimum!);
                                },
                              );

                              finalData = Set.from(data);

                              alldata = {
                                'restaurantData': finalData,
                                'filterTab': selectedCategoryData,
                                // selectedCategoryData,
                                'rating': selectedCategoryData,
                                'fastDelivery': isFastDelivery
                              };
                            } else {
                              alldata = {
                                'restaurantData': finalData,
                                'filterTab': selectedCategoryData,
                                // selectedCategoryData,
                                'rating': rating,
                                'fastDelivery': isFastDelivery
                              };
                            }
                          } else {
                            if (isFastDelivery == true) {
                              List<RestaurantList> data =
                                  List.from(ratingFilter);

                              data.sort(
                                (a, b) {
                                  return a.quotes!.cheapestDelivery!
                                      .timeEstimate!.minimum!
                                      .compareTo(b.quotes!.cheapestDelivery!
                                          .timeEstimate!.minimum!);
                                },
                              );

                              ratingFilter = Set.from(data);

                              alldata = {
                                'restaurantData': ratingFilter,
                                'filterTab': selectedCategoryData,
                                // selectedCategoryData,
                                'rating': rating,
                                'fastDelivery': isFastDelivery
                              };
                            } else {
                              alldata = {
                                'restaurantData': ratingFilter,
                                'filterTab': selectedCategoryData,
                                // selectedCategoryData,
                                'rating': rating,
                                'fastDelivery': isFastDelivery
                              };
                            }
                          }
                        }

                        /// WHEN RATING IS NOT SELECTED AND CATEGORY SELECTED ------------------------------------------------------

                        else if (
                            // selectedCategoryData
                            localList.isNotEmpty) {
                          for (var i = 0; i < data.length; i++) {
                            for (var j = 0;
                                j < data.elementAt(i).cuisines!.length;
                                j++) {
                              for (var k = 0;
                                  k <
                                      // selectedCategoryData
                                      selectedCategoryData.length;
                                  k++) {
                                if (data.elementAt(i).cuisines![j].contains(
                                    // selectedCategoryData
                                    selectedCategoryData[k])) {
                                  finalData.add(data.elementAt(i));
                                }
                              }
                            }
                          }

                          /// WHEN FAST DELIVERY SELECTED ------------------------------------------------------
                          if (isFastDelivery == true) {
                            List<RestaurantList> data = List.from(finalData);

                            data.sort(
                              (a, b) {
                                return a.quotes!.cheapestDelivery!.timeEstimate!
                                    .minimum!
                                    .compareTo(b.quotes!.cheapestDelivery!
                                        .timeEstimate!.minimum!);
                              },
                            );

                            finalData = Set.from(data);

                            alldata = {
                              'restaurantData': finalData,
                              'filterTab': selectedCategoryData,
                              // selectedCategoryData,
                              'rating': rating,
                              'fastDelivery': isFastDelivery
                            };
                          }

                          /// WHEN FAST DELIVERY NOT SELECTED ------------------------------------------------------
                          else {
                            alldata = {
                              'restaurantData': finalData,
                              'filterTab': selectedCategoryData,
                              // selectedCategoryData,
                              'rating': rating,
                              'fastDelivery': isFastDelivery
                            };
                          }
                        }

                        /// WHEN RATING AND CATEGORY ARE NOT SELECTED BUT FAST DELIVERY SELECTED ------------------------------------------------------
                        else if (isFastDelivery == true) {
                          widget.restaurantList.sort(
                            (a, b) {
                              return a.quotes!.cheapestDelivery!.timeEstimate!
                                  .minimum!
                                  .compareTo(b.quotes!.cheapestDelivery!
                                      .timeEstimate!.minimum!);
                            },
                          );

                          finalData = Set.from(widget.restaurantList);
                          alldata = {
                            'restaurantData': finalData,
                            'filterTab': selectedCategoryData,
                            // selectedCategoryData,
                            'rating': rating,
                            'fastDelivery': isFastDelivery
                          };
                        }

                        Get.back(result: alldata);
                      }
                    },
                    child: Container(
                      height: 48,
                      width: MediaQuery.of(context).size.width / 2.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color:
                            // selectedCategoryData
                            localList.isNotEmpty ||
                                    rating.isNotEmpty ||
                                    isFastDelivery
                                ? AppColors.terracotta
                                : AppColors.disabledColor,
                        border: Border.all(
                          color:
                              // selectedCategoryData
                              localList.isNotEmpty ||
                                      rating.isNotEmpty ||
                                      isFastDelivery
                                  ? AppColors.terracotta
                                  : AppColors.disabledColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Apply',
                          style: FontUtils.h18(
                            fontColor: Colors.white,
                            fontWeight: FWT.medium,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
