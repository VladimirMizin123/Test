import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_bloc.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_event.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_state.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/journal/bottomsheet/image_picker_bottomsheet.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../constant/color_utils.dart';

class AddNewItemScreen extends StatefulWidget {
  const AddNewItemScreen({super.key});

  @override
  State<AddNewItemScreen> createState() => _AddNewItemScreenState();
}

class _AddNewItemScreenState extends State<AddNewItemScreen> {
  final routeName = '/AddNewItemScreen';
  GetUserJournalBloc getUserJournalBloc = GetUserJournalBloc();
  TextEditingController nameController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController calController = TextEditingController();
  TextEditingController fatController = TextEditingController();
  TextEditingController carbsController = TextEditingController();
  TextEditingController proteinController = TextEditingController();

  String pickedImageFilePath = '';

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
          icon: Icon(Icons.arrow_back_ios, color: AppColors.darkGray, size: 20.h),
          onPressed: () => Navigator.pop(context),
        ).paddingOnly(left: 10.w),
      ),
      body: BlocConsumer<GetUserJournalBloc, GetUserJournalState>(
          bloc: getUserJournalBloc,
          listener: (context, state) {
            if (state is SelectedImagePathState) {
              pickedImageFilePath = state.imgPath ?? '';
              setState(() {});
              print('Picked Image File Path --------------- $pickedImageFilePath');
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
                                    getUserJournalBloc: getUserJournalBloc,
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
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: AppColors.disable),
                                      child: Image.file(
                                        File(pickedImageFilePath),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 160.h,
                                    width: double.infinity.w,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: AppColors.disable),
                                    child: Center(
                                      child: Text(
                                        StringUtils.addPhoto,
                                        style: textTheme.headlineSmall?.copyWith(color: AppColors.middleGray),
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
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 16, color: AppColors.darkGray),
                            decoration: InputDecoration(
                              hintText: 'Item Name',
                              hintStyle: const TextStyle(fontSize: 14, color: AppColors.grayColor),
                              isDense: true,
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.grayColor)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryBlue)),
                              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryBlue)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryBlue)),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(StringUtils.weight, style: textTheme.bodyLarge?.copyWith(color: Colors.black)),
                              SizedBox(
                                width: 80.w,
                                child: TextFormField(
                                  controller: weightController,
                                  cursorColor: AppColors.darkGray,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(fontSize: 16, color: AppColors.darkGray),
                                  decoration: InputDecoration(
                                    hintText: '00',
                                    hintStyle: const TextStyle(fontSize: 14, color: AppColors.grayColor),
                                    isDense: true,
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryBlue)),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryBlue)),
                                    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryBlue)),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryBlue)),
                                  ),
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
                              dashBoardCardView(margin: const EdgeInsets.only(right: 4), child: calciumDataView(title: 'Cal', percent: 0.16, gramCount: '320', progressColor: AppColors.primaryBlue, textTheme: textTheme, totalGram: '2000 cal', controller: calController)),
                              dashBoardCardView(margin: const EdgeInsets.only(left: 4), child: calciumDataView(title: 'Fat', percent: 0.77, gramCount: '100', progressColor: AppColors.coral, textTheme: textTheme, totalGram: '177 g', controller: fatController)),
                            ],
                          ).paddingSymmetric(vertical: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              dashBoardCardView(margin: const EdgeInsets.only(right: 4), child: calciumDataView(title: 'Carbs', textTheme: textTheme, gramCount: '100', percent: 0.77, totalGram: '177 g', progressColor: AppColors.mint, controller: carbsController)),
                              dashBoardCardView(margin: const EdgeInsets.only(left: 4), child: calciumDataView(title: 'Protein', textTheme: textTheme, gramCount: '32', percent: 0.66, totalGram: '48 g', progressColor: AppColors.skyBlue, controller: proteinController)),
                            ],
                          ).paddingSymmetric(vertical: 4),
                        ],
                      ).paddingAll(10),
                    ),
                  ),
                ),
                buildButton(
                  context: context,
                  bgColor: AppColors.disable,
                  hasImage: false,
                  onPressed: () {
                    // ADD NEW ITEM API,
                    getUserJournalBloc.add(AddNewDietEvent(
                      dietName: 'milk',
                      proteinPercentage: proteinController.text,
                      carbsPercentage: carbsController.text,
                      fatPercentage: fatController.text,
                      surplusPercentage: '',
                      deficitPercentage: '',
                      mealSchedule: '',
                      colorCode: '',
                      isDefault: false,
                    ));
                  },
                  textColor: Colors.white,
                  title: StringUtils.saveNewItem,
                ).paddingOnly(bottom: 30.h, top: 10.h)
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
    TextEditingController? controller,
  }) {
    return Column(
      children: [
        Text(
          title.toString(),
          style: textTheme?.bodyLarge?.copyWith(color: AppColors.darkGray),
        ),
        commonProgressbar(progressColor: progressColor, width: 70.w, lineHeight: 8.0, percent: percent ?? 0.5),
        Text(
          '$gramCount / $totalGram',
          style: textTheme?.bodyMedium?.copyWith(color: AppColors.darkGray, height: 1.7),
        ),
        SizedBox(width: 70, child: commonTextField(context: context, hintText: "cal", isPassword: false, controller: controller)).paddingSymmetric(vertical: 5),
      ],
    ).paddingSymmetric(horizontal: 33.w, vertical: 6.h);
  }

  Widget commonProgressbar({Color? progressColor, double? width, double? lineHeight, double? percent}) {
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
