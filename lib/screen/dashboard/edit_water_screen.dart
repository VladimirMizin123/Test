import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/dashboard/add_water/add_water_bloc.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_bloc.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_event.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_state.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/convert_units_widget/water_convert.dart';

import '../../bloc/dashboard/add_water/add_water_event.dart';
import '../../bloc/dashboard/add_water/add_water_state.dart';

class EditWaterScreen extends StatefulWidget {
  const EditWaterScreen({super.key});

  @override
  State<EditWaterScreen> createState() => _EditWaterScreenState();
}

class _EditWaterScreenState extends State<EditWaterScreen> {
  TextEditingController waterController = TextEditingController();

  EditWaterArguments editWaterArguments = Get.arguments;
  AddWaterBloc bloc = AddWaterBloc();
  AccountBloc accountBloc = AccountBloc();

  bool isLoader = false;
  int? waterValue;

  @override
  void initState() {
    super.initState();
    waterController.text = editWaterArguments.addedWater!;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      accountBloc.add(GetUnitInfoEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BlocConsumer(
                    bloc: accountBloc,
                    builder: (context, state) {
                      if (state is GetUnitInfoSuccessState) {
                        isLoader = false;

                        waterValue =
                            state.unitData?.waterType == 'Floz' ? 1 : 2;
                      }
                      return SizedBox(
                        height: size.height.h,
                        width: size.width.w,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 25.sp,
                                    color: AppColors.darkGray,
                                  ),
                                ),
                                Text(
                                  StringUtils.editWater,
                                  style: textTheme.displayMedium
                                      ?.copyWith(color: Colors.black),
                                ).paddingOnly(right: 28.w),
                                const SizedBox(),
                              ],
                            ).paddingOnly(top: 30.h),
                            Text(
                              'Your Daily Goal: ${editWaterArguments.dailyGoal} ${waterValue == 1 ? "Oz" : "ml"} ',
                              style: textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.middleGray),
                            ),
                            dashBoardCardView(
                              // height: 240.h,
                              width: 335.w,

                              margin: EdgeInsets.symmetric(vertical: 20.h),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // commonUserTypeTextField(hintText: '00', controller: waterController, context: context, width: 80.w, fontSize: 16.sp, fontWeight: FontWeight.w400, isSuffix: false, valueColor: AppColors.darkGray, fontColor: AppColors.darkGray, cursorColor: AppColors.darkGray, textInputType: TextInputType.number, onChange: (value) {}),
                                        SizedBox(
                                          width: 80.w,
                                          child: TextFormField(
                                            controller: waterController,
                                            cursorColor: AppColors.darkGray,
                                            keyboardType: TextInputType.number,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: AppColors.darkGray),
                                            decoration: InputDecoration(
                                              hintText: '00',
                                              hintStyle: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.grayColor),
                                              isDense: true,
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                      color: AppColors
                                                          .primaryBlue)),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                      color: AppColors
                                                          .primaryBlue)),
                                              disabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                      color: AppColors
                                                          .primaryBlue)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                      color: AppColors
                                                          .primaryBlue)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        Text(
                                          waterValue == 1
                                              ? "Oz"
                                              : StringUtils.ml,
                                          style: textTheme.bodyLarge?.copyWith(
                                              color: AppColors.darkGray),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        waterDetailsView(
                                          height: 76.h,
                                          waterIcon: AssetsUtils.waterIcon1,
                                          waterQuantity: convertMilliToOz(
                                              textValue: 250,
                                              isWatervalue: waterValue),
                                          onTap: () {
                                            waterController
                                                .text = convertMilliToOz(
                                                    isWatervalue: waterValue,
                                                    textValue: 250)
                                                .toString();
                                          },
                                        ),
                                        waterDetailsView(
                                          height: 83.h,
                                          waterIcon: AssetsUtils.waterIcon2,
                                          waterQuantity: convertMilliToOz(
                                              textValue: 500,
                                              isWatervalue: waterValue),
                                          onTap: () {
                                            waterController
                                                .text = convertMilliToOz(
                                                    isWatervalue: waterValue,
                                                    textValue: 500)
                                                .toString();
                                          },
                                        ).paddingOnly(left: 30.w),
                                        waterDetailsView(
                                          height: 96.h,
                                          waterIcon: AssetsUtils.waterIcon3,
                                          waterQuantity: convertMilliToOz(
                                              textValue: 1000,
                                              isWatervalue: waterValue),
                                          onTap: () {
                                            waterController
                                                .text = convertMilliToOz(
                                                    isWatervalue: waterValue,
                                                    textValue: 1000)
                                                .toString();
                                          },
                                        ).paddingOnly(left: 30.w),
                                      ],
                                    ).paddingOnly(top: 15.h)
                                  ],
                                ).paddingAll(16),
                              ),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 20.w),
                      );
                    },
                    listener: (BuildContext context, Object? state) {},
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder(
              bloc: bloc,
              builder: (context, state) {
                debugPrint('water state--> $state');
                if (state is UpdateWaterLoadingState) {
                  return const AppCenterLoader();
                } else {
                  return buildButton(
                      context: context,
                      title: StringUtils.save,
                      hasImage: false,
                      textColor: AppColors.skyBlue,
                      onPressed: () {
                        setState(() {
                          bloc.add(
                            UpdateWaterEvent(
                                waterML: (waterController.text == "16.91" ||
                                        waterController.text == "33.81" ||
                                        waterController.text == "67.63")
                                    ? waterController.text
                                    : convertMilliToOz(
                                            textValue: num.tryParse(
                                                waterController.text),
                                            isWatervalue: waterValue)
                                        .toString()),
                          );
                          // bloc.add(
                          //     SaveClickEvent(waterML: waterController.text));
                        });
                      },
                      bgColor: AppColors.primaryBlue);
                }
              }).paddingOnly(bottom: 20.h).paddingSymmetric(horizontal: 20.w),
        ],
      ),
    );
  }

  Widget waterDetailsView(
      {String? waterIcon,
      String? waterQuantity,
      double? height,
      void Function()? onTap}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          waterIcon.toString(),
          height: height,
          width: 48.w,
        ),
        Text(
          '$waterQuantity ${waterValue == 1 ? "Oz" : "ml"}',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.darkGray),
        ).paddingOnly(top: 3.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 25.h,
            width: 25.w,
            margin: EdgeInsets.only(top: 5.h),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.skyBlue,
            ),
            child: const Center(
              child: Icon(
                Icons.add,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class EditWaterArguments {
  final String? dailyGoal;
  final String? addedWater;

  EditWaterArguments(this.addedWater, this.dailyGoal);
}
