import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_bloc.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_event.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_state.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/convert_units_widget/water_convert.dart';

import '../../bloc/dashboard/add_water/add_water_bloc.dart';
import '../../bloc/dashboard/add_water/add_water_event.dart';
import '../../bloc/dashboard/add_water/add_water_state.dart';

class AddWaterScreen extends StatefulWidget {
  const AddWaterScreen({super.key});

  @override
  State<AddWaterScreen> createState() => _AddWaterScreenState();
}

class _AddWaterScreenState extends State<AddWaterScreen> {
  final routeName = '/add-water-screen';
  TextEditingController waterController = TextEditingController();

  AddWaterArguments addWaterArguments = Get.arguments;
  AddWaterBloc bloc = AddWaterBloc();

  AccountBloc accountBloc = AccountBloc();
  int? waterValue;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      accountBloc.add(GetUnitInfoEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: BlocConsumer(
                    bloc: accountBloc,
                    builder: (context, state) {
                      if (state is GetUnitInfoSuccessState) {
                        waterValue =
                            state.unitData?.waterType == 'Floz' ? 1 : 2;

                        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        //   accountBloc.add(GetUnitInfoEvent());
                        // });
                      }
                      return Column(
                        children: [
                          SizedBox(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: const Icon(
                                        Icons.arrow_back_ios,
                                        size: 19,
                                        color: AppColors.darkGray,
                                      ),
                                    ),
                                    Text(StringUtils.addWater,
                                        style: FontUtils.h20(
                                            fontColor: AppColors.oxFF010101)),
                                    const SizedBox(),
                                  ],
                                ).paddingSymmetric(vertical: 5.h),
                                Text(
                                  'Your Daily Goal: ${addWaterArguments.dailyGoal} ${waterValue == 1 ? StringUtils.oz : "ml"}',
                                  style: textTheme.bodyMedium
                                      ?.copyWith(color: AppColors.middleGray),
                                ),
                                dashBoardCardView(
                                  // height: 240.h,
                                  width: 335.w,
                                  margin: EdgeInsets.symmetric(vertical: 20.h),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
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
                                                onChanged: (value) {
                                                  //*
                                                  // if (addWaterArguments
                                                  //         .isWatervalue ==
                                                  //     1) {
                                                  //   num? valueA = num.tryParse(value);
                                                  //   if (valueA != null &&
                                                  //       valueA != 0) {
                                                  //     _debouncer.run(() async {
                                                  //       print("value:$valueA");
                                                  //       if (valueA != 0) {
                                                  //         waterController
                                                  //             .text = convertOzToMilli(
                                                  //                 isWatervalue:
                                                  //                     addWaterArguments
                                                  //                         .isWatervalue,
                                                  //                 textValue:
                                                  //                     int.tryParse(
                                                  //                         value))
                                                  //             .toString();
                                                  //         setState(() {});
                                                  //       }
                                                  //     });
                                                  //   }
                                                  // }
                                                  //*
                                                },
                                                controller: waterController,
                                                cursorColor: AppColors.darkGray,
                                                keyboardType:
                                                    TextInputType.number,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: AppColors.darkGray),
                                                decoration: InputDecoration(
                                                  hintText: '00',
                                                  hintStyle: const TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          AppColors.grayColor),
                                                  isDense: true,
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: AppColors
                                                                  .primaryBlue)),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: AppColors
                                                                  .primaryBlue)),
                                                  disabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: AppColors
                                                                  .primaryBlue)),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: AppColors
                                                                  .primaryBlue)),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5.w),
                                            Text(
                                              waterValue == 1
                                                  ? StringUtils.oz
                                                  : StringUtils.ml,
                                              style: textTheme.bodyLarge
                                                  ?.copyWith(
                                                      color:
                                                          AppColors.darkGray),
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
                                                // waterController.text = '250';
                                                waterController.text =
                                                    convertMilliToOz(
                                                            isWatervalue:
                                                                waterValue,
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
                                                // waterController.text = '500';
                                                waterController.text =
                                                    convertMilliToOz(
                                                            isWatervalue:
                                                                waterValue,
                                                            textValue: 500)
                                                        .toString();
                                              },
                                            ).paddingOnly(left: 30.w),
                                            waterDetailsView(
                                              height: 96.h,
                                              waterIcon: AssetsUtils.waterIcon3,
                                              waterQuantity: convertMilliToOz(
                                                  isWatervalue: waterValue,
                                                  textValue: 1000),
                                              onTap: () {
                                                // waterController.text = '1000';
                                                waterController.text =
                                                    convertMilliToOz(
                                                            isWatervalue:
                                                                waterValue,
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
                            ).paddingSymmetric(horizontal: 15.w),
                          ),
                        ],
                      );
                    },
                    listener: (BuildContext context, Object? state) {},
                  ),
                ),
              ),
              BlocBuilder(
                      bloc: bloc,
                      builder: (context, state) {
                        debugPrint('water state--> $state');
                        if (state is LoadingState) {
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
                                    // SaveClickEvent(
                                    //   waterML: waterController.text,
                                    // ),
                                    SaveClickEvent(
                                        waterML: (waterController.text ==
                                                    "8.45" ||
                                                waterController.text ==
                                                    "16.91" ||
                                                waterController.text == "33.81")
                                            ? waterController.text
                                            : convertMilliToOz(
                                                    textValue: num.tryParse(
                                                        waterController.text),
                                                    isWatervalue: waterValue)
                                                .toString()),
                                  );
                                });
                              },
                              bgColor: AppColors.primaryBlue);
                        }
                      })
                  .paddingOnly(bottom: 20.h)
                  .paddingSymmetric(horizontal: 20.w),
            ],
          ),
        ),
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
          '$waterQuantity ${waterValue == 1 ? StringUtils.oz : "ml"}',
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

class AddWaterArguments {
  final String? dailyGoal;
  final int? isWatervalue;

  AddWaterArguments({this.isWatervalue, this.dailyGoal});
}
