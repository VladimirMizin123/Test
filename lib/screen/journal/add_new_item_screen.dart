import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/journal/add_new_item/add_new_meal_bloc.dart';
import 'package:gymeats_mobile/bloc/journal/add_new_item/add_new_meal_event.dart';
import 'package:gymeats_mobile/bloc/journal/add_new_item/add_new_meal_item_state.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/journal/bottomsheet/image_picker_bottomsheet.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../constant/color_utils.dart';

class AddNewItemScreen extends StatefulWidget {
  const AddNewItemScreen({super.key});

  @override
  State<AddNewItemScreen> createState() => _AddNewItemScreenState();
}

class _AddNewItemScreenState extends State<AddNewItemScreen> {
  final routeName = '/AddNewItemScreen';
  AddNewMealBloc getAddNewMealBloc = AddNewMealBloc();
  TextEditingController nameController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController calController = TextEditingController();
  TextEditingController fatController = TextEditingController();
  TextEditingController carbsController = TextEditingController();
  TextEditingController proteinController = TextEditingController();

  String pickedImageFilePath = '';
  bool isButtonEnable = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          StringUtils.addNewItem,
          style: textTheme.displayMedium?.copyWith(color: Colors.black),
        ),
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios, color: AppColors.darkGray, size: 20.h),
          onPressed: () => Navigator.pop(context),
        ).paddingOnly(left: 10.w),
      ),
      body: BlocConsumer<AddNewMealBloc, AddNewMealState>(
          bloc: getAddNewMealBloc,
          listener: (context, state) {
            if (state is SelectedImagePathState) {
              pickedImageFilePath = state.imgPath!.path ?? '';
              setState(() {
                if (pickedImageFilePath.isEmpty) {
                  isButtonEnable = false;
                } else if (nameController.text.isEmpty) {
                  isButtonEnable = false;
                } else if (weightController.text.isEmpty) {
                  isButtonEnable = false;
                } else if (calController.text.isEmpty ||
                    (double.parse(calController.text) >
                        double.parse(
                            PreferenceUtils.getString(totalCalorie)))) {
                  isButtonEnable = false;
                } else if (fatController.text.isEmpty ||
                    (double.parse(fatController.text) >
                        double.parse(PreferenceUtils.getString(totalFat)))) {
                  isButtonEnable = false;
                } else if (carbsController.text.isEmpty ||
                    (double.parse(carbsController.text) >
                        double.parse(PreferenceUtils.getString(totalCarbs)))) {
                  isButtonEnable = false;
                } else if (proteinController.text.isEmpty ||
                    (double.parse(proteinController.text) >
                        double.parse(
                            PreferenceUtils.getString(totalProtein)))) {
                  isButtonEnable = false;
                } else {
                  isButtonEnable = true;
                }
              });
              setState(() {});
              print(
                  'Picked Image File Path --------------- $pickedImageFilePath');
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: dashBoardCardView(
                    width: double.infinity.w,
                    height: MediaQuery.of(context).size.height.h,
                    margin: EdgeInsets.only(top: 5.h),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return ImagePickerBottomSheet(
                                    addNewMealBloc: getAddNewMealBloc,
                                  );
                                },
                              );
                            },
                            child: pickedImageFilePath.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      height: 160.h,
                                      width: double.infinity.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          color: AppColors.disable),
                                      child: Image.file(
                                        File(pickedImageFilePath),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 160.h,
                                    width: double.infinity.w,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        color: AppColors.disable),
                                    child: Center(
                                      child: Text(
                                        StringUtils.addPhoto,
                                        style: textTheme.headlineSmall
                                            ?.copyWith(
                                                color: AppColors.middleGray),
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 10),
                          // commonTextField(
                          //   context: context,
                          //   controller: itemNameController,
                          //   hintText: StringUtils.itemName,
                          // ).paddingOnly(top: 10.h),
                          TextFormField(
                            controller: nameController,
                            cursorColor: AppColors.darkGray,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(
                                fontSize: 16, color: AppColors.darkGray),
                            decoration: InputDecoration(
                              hintText: 'Item Name',
                              hintStyle: const TextStyle(
                                  fontSize: 14, color: AppColors.grayColor),
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.grayColor)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.primaryBlue)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.primaryBlue)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.primaryBlue)),
                            ),
                            onChanged: (value) {
                              setState(() {
                                if (pickedImageFilePath.isEmpty) {
                                  isButtonEnable = false;
                                } else if (nameController.text.isEmpty) {
                                  isButtonEnable = false;
                                } else if (weightController.text.isEmpty) {
                                  isButtonEnable = false;
                                } else if (calController.text.isEmpty ||
                                    (double.parse(calController.text) >
                                        double.parse(PreferenceUtils.getString(
                                            totalCalorie)))) {
                                  isButtonEnable = false;
                                } else if (fatController.text.isEmpty ||
                                    (double.parse(fatController.text) >
                                        double.parse(PreferenceUtils.getString(
                                            totalFat)))) {
                                  isButtonEnable = false;
                                } else if (carbsController.text.isEmpty ||
                                    (double.parse(carbsController.text) >
                                        double.parse(PreferenceUtils.getString(
                                            totalCarbs)))) {
                                  isButtonEnable = false;
                                } else if (proteinController.text.isEmpty ||
                                    (double.parse(proteinController.text) >
                                        double.parse(PreferenceUtils.getString(
                                            totalProtein)))) {
                                  isButtonEnable = false;
                                } else {
                                  isButtonEnable = true;
                                }
                              });
                              setState(() {});
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(StringUtils.weight,
                                  style: textTheme.bodyLarge
                                      ?.copyWith(color: Colors.black)),
                              SizedBox(
                                width: 80.w,
                                child: TextFormField(
                                  controller: weightController,
                                  cursorColor: AppColors.darkGray,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                      fontSize: 16, color: AppColors.darkGray),
                                  decoration: InputDecoration(
                                    hintText: '00',
                                    hintStyle: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.grayColor),
                                    isDense: true,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: AppColors.primaryBlue)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: AppColors.primaryBlue)),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: AppColors.primaryBlue)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: AppColors.primaryBlue)),
                                  ),
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        if (pickedImageFilePath.isEmpty) {
                                          isButtonEnable = false;
                                        } else if (nameController
                                            .text.isEmpty) {
                                          isButtonEnable = false;
                                        } else if (weightController
                                            .text.isEmpty) {
                                          isButtonEnable = false;
                                        } else if (calController.text.isEmpty ||
                                            (double.parse(calController.text) >
                                                double.parse(
                                                    PreferenceUtils.getString(
                                                        totalCalorie)))) {
                                          isButtonEnable = false;
                                        } else if (fatController.text.isEmpty ||
                                            (double.parse(fatController.text) >
                                                double.parse(
                                                    PreferenceUtils.getString(
                                                        totalFat)))) {
                                          isButtonEnable = false;
                                        } else if (carbsController.text.isEmpty ||
                                            (double.parse(carbsController.text) >
                                                double.parse(
                                                    PreferenceUtils.getString(
                                                        totalCarbs)))) {
                                          isButtonEnable = false;
                                        } else if (proteinController
                                                .text.isEmpty ||
                                            (double.parse(proteinController.text) >
                                                double.parse(
                                                    PreferenceUtils.getString(
                                                        totalProtein)))) {
                                          isButtonEnable = false;
                                        } else {
                                          isButtonEnable = true;
                                        }
                                      },
                                    );
                                    setState(() {});
                                  },
                                ),
                              ),
                              // Container(
                              //   height: 45.h,
                              //   width: 86.w,
                              //   decoration: BoxDecoration(
                              //     border: Border.all(
                              //         color: Colors.grey.shade300, // Set border color
                              //         width: 1.0), // Set border width
                              //     borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                              //   ),
                              //   child: TextFormField(
                              //     controller: weightController,
                              //     keyboardType: TextInputType.number,
                              //     cursorColor: AppColors.middleGray,
                              //     style: const TextStyle(fontWeight: FontWeight.w400, color: AppColors.darkGray),
                              //     onChanged: (value) {},
                              //     decoration: InputDecoration(
                              //       filled: false,
                              //       hintText: '00',
                              //       hintStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: AppColors.darkGray),
                              //       enabledBorder: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(8),
                              //         borderSide: const BorderSide(color: Colors.transparent),
                              //       ),
                              //       border: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(8),
                              //         borderSide: const BorderSide(color: Colors.transparent),
                              //       ),
                              //       disabledBorder: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(8),
                              //         borderSide: const BorderSide(color: Colors.transparent),
                              //       ),
                              //       focusedBorder: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(8),
                              //         borderSide: const BorderSide(color: Colors.transparent),
                              //       ),
                              //       suffix: const Text(StringUtils.oz),
                              //       suffixStyle: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500, color: Colors.grey),
                              //     ),
                              //   ),
                              // )
                            ],
                          ).paddingSymmetric(vertical: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 1,
                                child: dashBoardCardView(
                                  margin: const EdgeInsets.only(right: 4),
                                  child: calciumDataView(
                                    label: 'cal',
                                    title: 'Cal',
                                    percent: calController.text.isEmpty
                                        ? 0
                                        : (double.parse(calController.text) >
                                                double.parse(
                                                    PreferenceUtils.getString(
                                                        totalCalorie)))
                                            ? 0
                                            : (double.parse(
                                                    calController.text) /
                                                double.parse(
                                                    PreferenceUtils.getString(
                                                        totalCalorie))),
                                    gramCount: calController.text.isEmpty
                                        ? '0'
                                        : calController.text,
                                    progressColor: AppColors.primaryBlue,
                                    textTheme: textTheme,
                                    totalGram:
                                        '${double.parse(PreferenceUtils.getString(totalCalorie)).toStringAsFixed(2)} cal',
                                    controller: calController,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: dashBoardCardView(
                                  margin: const EdgeInsets.only(left: 4),
                                  child: calciumDataView(
                                    label: 'fat',
                                    title: 'Fat',
                                    percent: fatController.text.isEmpty
                                        ? 0
                                        : (double.parse(fatController.text) >
                                                double.parse(
                                                    PreferenceUtils.getString(
                                                        totalFat)))
                                            ? 0
                                            : (double.parse(
                                                    fatController.text) /
                                                double.parse(
                                                    PreferenceUtils.getString(
                                                        totalFat))),
                                    gramCount: fatController.text.isEmpty
                                        ? '0'
                                        : fatController.text,
                                    progressColor: AppColors.primaryBlue,
                                    textTheme: textTheme,
                                    totalGram:
                                        '${double.parse(PreferenceUtils.getString(totalFat)).toStringAsFixed(2)} g',

                                    // percent: 0.77,
                                    // gramCount: fatController.text,
                                    // progressColor: AppColors.coral,
                                    // textTheme: textTheme,
                                    // totalGram: '${double.parse(PreferenceUtils.getString(totalFat)).floor()} g',
                                    controller: fatController,
                                  ),
                                ),
                              ),
                            ],
                          ).paddingSymmetric(vertical: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 1,
                                child: dashBoardCardView(
                                  margin: const EdgeInsets.only(right: 4),
                                  child: calciumDataView(
                                    title: 'Carbs',
                                    label: 'carbs',
                                    percent: carbsController.text.isEmpty
                                        ? 0
                                        : (double.parse(carbsController.text) >
                                                double.parse(
                                                    PreferenceUtils.getString(
                                                        totalCarbs)))
                                            ? 0
                                            : (double.parse(
                                                    carbsController.text) /
                                                double.parse(
                                                    PreferenceUtils.getString(
                                                        totalCarbs))),
                                    gramCount: carbsController.text.isEmpty
                                        ? '0'
                                        : carbsController.text,
                                    progressColor: AppColors.primaryBlue,
                                    textTheme: textTheme,
                                    totalGram:
                                        '${double.parse(PreferenceUtils.getString(totalCarbs)).toStringAsFixed(2)} g',

                                    // textTheme: textTheme,
                                    // gramCount: carbsController.text,
                                    // percent: 0.77,
                                    // totalGram: '${double.parse(PreferenceUtils.getString(totalCarbs)).floor()} g',
                                    // progressColor: AppColors.mint,
                                    controller: carbsController,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: dashBoardCardView(
                                  margin: const EdgeInsets.only(left: 4),
                                  child: calciumDataView(
                                    title: 'Protein',
                                    label: 'protein',

                                    percent: proteinController.text.isEmpty
                                        ? 0
                                        : (double.parse(
                                                    proteinController.text) >
                                                double.parse(
                                                    PreferenceUtils.getString(
                                                        totalProtein)))
                                            ? 0
                                            : (double.parse(
                                                    proteinController.text) /
                                                double.parse(
                                                    PreferenceUtils.getString(
                                                        totalProtein))),
                                    gramCount: proteinController.text.isEmpty
                                        ? '0'
                                        : proteinController.text,
                                    progressColor: AppColors.primaryBlue,
                                    textTheme: textTheme,
                                    totalGram:
                                        '${double.parse(PreferenceUtils.getString(totalProtein)).toStringAsFixed(2)} g',

                                    // textTheme: textTheme,
                                    // gramCount: proteinController.text,
                                    // percent: 0.66,
                                    // totalGram: '${double.parse(PreferenceUtils.getString(totalProtein)).floor()} g',
                                    // progressColor: AppColors.skyBlue,
                                    controller: proteinController,
                                  ),
                                ),
                              ),
                            ],
                          ).paddingSymmetric(vertical: 4),
                        ],
                      ).paddingAll(10),
                    ),
                  ),
                ),
                BlocBuilder(
                  bloc: getAddNewMealBloc,
                  builder: (context, state) {
                    if (state is LoadingState) {
                      return const AppCenterLoader().paddingOnly(bottom: 10.h);
                    } else {
                      return buildButton(
                        context: context,
                        bgColor: isButtonEnable
                            ? AppColors.primaryBlue
                            : AppColors.disable,
                        hasImage: false,
                        onPressed: () {
                          // ADD NEW ITEM API,
                          if (pickedImageFilePath.isEmpty) {
                            Fluttertoast.showToast(msg: 'Please Select Image');
                          } else if (nameController.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: 'Please fill correct Name value');
                          } else if (weightController.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: 'Please fill correct Weight value');
                          } else if (calController.text.isEmpty ||
                              (double.parse(calController.text) >
                                  double.parse(PreferenceUtils.getString(
                                      totalCalorie)))) {
                            Fluttertoast.showToast(
                                msg: 'Please fill correct Cal value');
                          } else if (fatController.text.isEmpty ||
                              (double.parse(fatController.text) >
                                  double.parse(
                                      PreferenceUtils.getString(totalFat)))) {
                            Fluttertoast.showToast(
                                msg: 'Please fill correct Fat value');
                          } else if (carbsController.text.isEmpty ||
                              (double.parse(carbsController.text) >
                                  double.parse(
                                      PreferenceUtils.getString(totalCarbs)))) {
                            Fluttertoast.showToast(
                                msg: 'Please fill correct Carbs value');
                          } else if (proteinController.text.isEmpty ||
                              (double.parse(proteinController.text) >
                                  double.parse(PreferenceUtils.getString(
                                      totalProtein)))) {
                            Fluttertoast.showToast(
                                msg: 'Please fill correct Protein value');
                          } else {
                            getAddNewMealBloc.add(
                              AddNewMeal(
                                name: nameController.text,
                                imageUrl: File(pickedImageFilePath),
                                protein: proteinController.text,
                                fat: fatController.text,
                                carbs: carbsController.text,
                                calorie: calController.text,
                                type: Get.arguments,
                                userId: userId,
                              ),
                            );
                          }
                        },
                        textColor: Colors.white,
                        title: StringUtils.saveNewItem,
                      ).paddingOnly(bottom: 30.h, top: 10.h);
                    }
                  },
                )
              ],
            ).paddingSymmetric(horizontal: 20.w);
          }),
    );
  }

  Widget calciumDataView({
    String? title,
    String? gramCount,
    TextTheme? textTheme,
    String? totalGram,
    double? percent,
    Color? progressColor,
    String? label,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title.toString(),
          style: textTheme?.bodyLarge?.copyWith(color: AppColors.darkGray),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            commonProgressbar(
                progressColor: progressColor,
                width: 70.w,
                lineHeight: 8.0,
                percent: percent ?? 0.5),
          ],
        ),
        Text(
          '$gramCount / $totalGram',
          style: textTheme?.bodyMedium
              ?.copyWith(color: AppColors.darkGray, height: 1.7),
        ),
        SizedBox(
          width: 70,
          child: commonTextField(
            textInputType: TextInputType.number,
            context: context,
            hintText: label,
            isPassword: false,
            controller: controller,
            onChanged: (String? value) {
              if (value != null && value != '') {
                setState(() {
                  List<String> myData = totalGram!.split(' ');

                  if (double.parse(value) > double.parse(myData[0])) {
                    showToast(
                        message: 'Value Can\'t be more than ${myData[0]}',
                        isSuccess: false);
                  }

                  if (pickedImageFilePath.isEmpty) {
                    isButtonEnable = false;
                  } else if (nameController.text.isEmpty) {
                    isButtonEnable = false;
                  } else if (weightController.text.isEmpty) {
                    isButtonEnable = false;
                  } else if (calController.text.isEmpty ||
                      (double.parse(calController.text) >
                          double.parse(
                              PreferenceUtils.getString(totalCalorie)))) {
                    isButtonEnable = false;
                  } else if (fatController.text.isEmpty ||
                      (double.parse(fatController.text) >
                          double.parse(PreferenceUtils.getString(totalFat)))) {
                    isButtonEnable = false;
                  } else if (carbsController.text.isEmpty ||
                      (double.parse(carbsController.text) >
                          double.parse(
                              PreferenceUtils.getString(totalCarbs)))) {
                    isButtonEnable = false;
                  } else if (proteinController.text.isEmpty ||
                      (double.parse(proteinController.text) >
                          double.parse(
                              PreferenceUtils.getString(totalProtein)))) {
                    isButtonEnable = false;
                  } else {
                    isButtonEnable = true;
                  }
                });
              } else {
                setState(() {
                  if (pickedImageFilePath.isEmpty) {
                    isButtonEnable = false;
                  } else if (nameController.text.isEmpty) {
                    isButtonEnable = false;
                  } else if (weightController.text.isEmpty) {
                    isButtonEnable = false;
                  } else if (calController.text.isEmpty ||
                      (double.parse(calController.text) >
                          double.parse(
                              PreferenceUtils.getString(totalCalorie)))) {
                    isButtonEnable = false;
                  } else if (fatController.text.isEmpty ||
                      (double.parse(fatController.text) >
                          double.parse(PreferenceUtils.getString(totalFat)))) {
                    isButtonEnable = false;
                  } else if (carbsController.text.isEmpty ||
                      (double.parse(carbsController.text) >
                          double.parse(
                              PreferenceUtils.getString(totalCarbs)))) {
                    isButtonEnable = false;
                  } else if (proteinController.text.isEmpty ||
                      (double.parse(proteinController.text) >
                          double.parse(
                              PreferenceUtils.getString(totalProtein)))) {
                    isButtonEnable = false;
                  } else {
                    isButtonEnable = true;
                  }
                });
              }
              setState(() {});
            },
          ),
        ).paddingSymmetric(vertical: 5),
      ],
    );
  }

  Widget commonProgressbar(
      {Color? progressColor,
      double? width,
      double? lineHeight,
      double? percent}) {
    return LinearPercentIndicator(
      width: width,
      barRadius: Radius.circular(10.r),
      animation: true,
      lineHeight: lineHeight!,
      animationDuration: 2000,
      percent: percent ?? 0.5,
      center: const Text(""),
      linearStrokeCap: LinearStrokeCap.round,
      progressColor: progressColor,
    ).paddingAll(5);
  }
}
