import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/my_address/my_address_bloc.dart';
import 'package:gymeats_mobile/bloc/my_address/my_address_event.dart';
import 'package:gymeats_mobile/screen/account_screen/account/account_scrren_widget.dart';
import 'package:gymeats_mobile/screen/account_screen/map_address/map_address_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import '../../../bloc/my_address/my_address_state.dart';
import '../../../constant/asset_utils.dart';
import '../../../constant/color_utils.dart';
import '../../../widget/divider_widget.dart';
import '../../../widget/svg_image.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  MyAddressBloc addressBloc = MyAddressBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
          child: BlocProvider(
        create: (context) => MyAddressBloc(),
        child: BlocBuilder<MyAddressBloc, MyAddressState>(
          builder: (context, state) {
            if (state is InitialState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AccountTitleWidget(
                    title: "My Address",
                    widget: Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200, spreadRadius: 1)
                        ],
                      ),
                      // height: 1.h,
                      margin:
                          EdgeInsets.only(top: 150.h, right: 23.w, left: 23.w),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 20.w),
                                    child: Radio(
                                      value: "Home",
                                      groupValue: state,
                                      onChanged: (value) {
                                        //changeOption(value, context);
                                        BlocProvider.of<MyAddressBloc>(context)
                                            .add(MyAddressLoadEvent(
                                                firstOption: 'Home'));
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 17.w,
                                  ),
                                  const Text("Home",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 20.w),
                                    child: const SvgImage(
                                      image: AssetsUtils.forwardArrow,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const DividerWidget(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 20.w),
                                    child: Radio(
                                      value: "Office",
                                      groupValue: state,
                                      onChanged: (value) {
                                        BlocProvider.of<MyAddressBloc>(context)
                                            .add(MyAddressLoadEvent(
                                                firstOption: 'Office'));
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 17.w,
                                  ),
                                  const Text("Office",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 20.w),
                                    child: const SvgImage(
                                      image: AssetsUtils.forwardArrow,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  buildButton(
                          context: context,
                          title: "Add New Address",
                          onPressed: () {
                            Get.to(
                              const MapAddressScreen(),
                            );
                          },
                          textColor: AppColors.whiteColor,
                          bgColor: AppColors.primaryBlueColor)
                      .paddingOnly(right: 23.w, left: 23.w),
                ],
              ).paddingOnly(bottom: 20.h);
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AccountTitleWidget(
                  title: "My Address",
                  widget: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade200, spreadRadius: 1)
                      ],
                    ),
                    // height: 1.h,
                    margin:
                        EdgeInsets.only(top: 150.h, right: 23.w, left: 23.w),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 20.w),
                                  child: Radio(
                                    activeColor: AppColors.primaryBlueColor,
                                    value: "Home",
                                    groupValue: (state as RadioClickState)
                                        .selectedState,
                                    onChanged: (value) {
                                      //changeOption(value, context);
                                      BlocProvider.of<MyAddressBloc>(context)
                                          .add(MyAddressLoadEvent(
                                              firstOption: 'Home'));
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 17.w,
                                ),
                                const Text("Home",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 20.w),
                                  child: const SvgImage(
                                    image: AssetsUtils.forwardArrow,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const DividerWidget(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 20.w),
                                  child: Radio(
                                    activeColor: AppColors.primaryBlueColor,
                                    value: "Office",
                                    groupValue: (state).selectedState,
                                    onChanged: (value) {
                                      BlocProvider.of<MyAddressBloc>(context)
                                          .add(MyAddressLoadEvent(
                                              firstOption: 'Office'));
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 17.w,
                                ),
                                const Text("Office",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 20.w),
                                  child: const SvgImage(
                                    image: AssetsUtils.forwardArrow,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                buildButton(
                        context: context,
                        title: "Add New Address",
                        onPressed: () {
                          Get.to(
                            const MapAddressScreen(),
                          );
                        },
                        textColor: AppColors.whiteColor,
                        bgColor: AppColors.primaryBlueColor)
                    .paddingOnly(right: 23.w, left: 23.w),
              ],
            ).paddingOnly(bottom: 20.h);
          },
        ),
      )),
    );
  }
}
