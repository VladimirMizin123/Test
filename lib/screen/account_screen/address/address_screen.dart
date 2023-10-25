import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/controller/account_controller/address_controller.dart';
import 'package:gymeats_mobile/screen/account_screen/account_scrren_widget.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import '../../../constant/asset_utils.dart';
import '../../../constant/color_utils.dart';
import '../../../widget/divider_widget.dart';
import '../../../widget/svg_image.dart';
import '../edit_profile/edit_profile_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  AddressScreenController addressScreenController =
      Get.put(AddressScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(child: GetBuilder<AddressScreenController>(
        builder: (controller) {
          controller = addressScreenController;
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
                  margin: EdgeInsets.only(top: 150.h, right: 23.w, left: 23.w),
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
                                  groupValue:
                                      addressScreenController.selectedAddress,
                                  onChanged: (value) {
                                    addressScreenController.selectedAddress =
                                        value!;
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
                                  groupValue:
                                      addressScreenController.selectedAddress,
                                  onChanged: (value) {
                                    addressScreenController.selectedAddress =
                                        value!;
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
                          const EditProfileSceen(),
                        );
                      },
                      textColor: AppColors.whiteColor,
                      bgColor: AppColors.primaryBlueColor)
                  .paddingOnly(right: 23.w, left: 23.w),
            ],
          ).paddingOnly(bottom: 20.h);
        },
      )),
    );
  }
}
