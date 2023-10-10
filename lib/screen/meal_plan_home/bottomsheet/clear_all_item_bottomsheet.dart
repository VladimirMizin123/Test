import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_bloc.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_event.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_state.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class ClearAllItemBottomSheet extends StatefulWidget {
  final AddNewGroceryItemBloc bloc;
  const ClearAllItemBottomSheet({super.key, required this.bloc});

  @override
  State<ClearAllItemBottomSheet> createState() =>
      _ClearAllItemBottomSheetState();
}

class _ClearAllItemBottomSheetState extends State<ClearAllItemBottomSheet> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BlocConsumer<AddNewGroceryItemBloc, AddNewGroceryItemState>(
        bloc: widget.bloc,
        listener: (context, state) {
          if (state is ClearGroceryListSuccessState) {
            Get.back();
          }

          if (state is ClearGroceryListErrorState) {
            Get.back();
          }
        },
        builder: (context, state) {
          return Material(
            color: AppColors.whiteColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
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
                    SvgPicture.asset(AssetsUtils.icQuestionMarkIcon),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        'Are you sure you want to clear all items?',
                        style: FontUtils.h24(
                            fontColor: AppColors.darkGray,
                            fontWeight: FWT.medium),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        simpleTextBorderButton(
                            height: screenSize.height * 0.05,
                            width: screenSize.width * 0.43,
                            context: context,
                            buttonLable: StringUtils.cancel,
                            onTap: () {
                              Get.back();
                            },
                            isDarkColor: true),
                        simpleTextBorderButton(
                          height: screenSize.height * 0.05,
                          width: screenSize.width * 0.43,
                          context: context,
                          isLoadingWidget: state is ClearGroceryListLoadingState
                              ? true
                              : false,
                          buttonLable: 'Clear',
                          onTap: () {
                            widget.bloc.add(ClearGroceryEvent());
                          },
                          isDarkColor: true,
                          isFillColor: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
