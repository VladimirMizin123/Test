import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/screen/account_screen/about/pivacy/pivacy_screen_widget.dart';

import '../../../../constant/string_utils.dart';
import '../../../../widget/back_button_widget.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({super.key});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              privacyTitleWidget(
                widget: Container(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                BackButtonWidget(),
                              ],
                            ),
                            SizedBox(
                              width: 80.w,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Privacy Policy",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(StringUtils.writePolicyInstructions,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400)),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "1. ${StringUtils.policyInformationTitle1}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          StringUtils.policy1,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          "a. ${StringUtils.personalInformation}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ).paddingOnly(left: 5),
                        SizedBox(height: 10.h),
                        Column(
                          children: [
                            bulletPointWidget(text: StringUtils.policyStep1),
                            bulletPointWidget(text: StringUtils.policyStep2),
                            bulletPointWidget(text: StringUtils.policyStep3),
                          ],
                        ).paddingOnly(left: 8),
                        // 1.b
                        SizedBox(height: 15.h),
                        Text(
                          "b. ${StringUtils.healthInformation}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ).paddingOnly(left: 5),
                        SizedBox(height: 10.h),
                        bulletPointWidget(
                                text: StringUtils.healthInformationInstruction)
                            .paddingOnly(left: 8),
                        10.h.height,
                        // 1.c
                        Text(
                          "c. ${StringUtils.paymentInformation}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ).paddingOnly(left: 5),
                        SizedBox(height: 10.h),
                        bulletPointWidget(
                                text: StringUtils.paymentInformationInstruction)
                            .paddingOnly(left: 8),
                        10.h.height,
                        //
                        // 1.d
                        Text(
                          "d. ${StringUtils.usageData}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ).paddingOnly(left: 5),
                        SizedBox(height: 10.h),
                        bulletPointWidget(
                                text: StringUtils.usageDataInstruction)
                            .paddingOnly(left: 8),
                        10.h.height,
                        //
                        Text(
                          "2. ${StringUtils.policyInformationTitle2}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        Text(
                          StringUtils.policy2,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        10.h.height,
                        Column(
                          children: [
                            bulletPointWidget(text: StringUtils.policyInfo1),
                            bulletPointWidget(text: StringUtils.policyInfo2),
                            bulletPointWidget(text: StringUtils.policyInfo3),
                            bulletPointWidget(text: StringUtils.policyInfo4),
                            bulletPointWidget(text: StringUtils.policyInfo5),
                            bulletPointWidget(text: StringUtils.policyInfo6),
                          ],
                        ),
                        10.h.height,
                        Text(
                          "3. ${StringUtils.policy3}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        Text(
                          StringUtils.policy3Instruction,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        10.h.height,
                        // 3.a
                        Text(
                          "a. ${StringUtils.policy3a}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ).paddingOnly(left: 5),
                        SizedBox(height: 10.h),
                        bulletPointWidget(text: StringUtils.policy3aDescription)
                            .paddingOnly(left: 8),
                        10.h.height,
                        //
                        // 3.b
                        Text(
                          "b. ${StringUtils.policy3b}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ).paddingOnly(left: 5),
                        SizedBox(height: 10.h),
                        bulletPointWidget(text: StringUtils.policy3bDescription)
                            .paddingOnly(left: 8),
                        10.h.height,
                        //
                        // 3.c
                        Text(
                          "c. ${StringUtils.policy3c}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ).paddingOnly(left: 5),
                        SizedBox(height: 10.h),
                        bulletPointWidget(text: StringUtils.policy3cDescription)
                            .paddingOnly(left: 8),
                        10.h.height,
                        //
                        Text(
                          "4. ${StringUtils.policy4}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        bulletPointWidget(text: StringUtils.policy4Instruction)
                            .paddingOnly(left: 8),
                        //
                        Text(
                          "5. ${StringUtils.policy5}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        Text(
                          StringUtils.policy5Instruction,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        10.h.height,
                        Column(
                          children: [
                            bulletPointWidget(text: StringUtils.policy5Info1),
                            bulletPointWidget(text: StringUtils.policy5Info2),
                            bulletPointWidget(text: StringUtils.policy5Info3),
                            bulletPointWidget(text: StringUtils.policy5Info4),
                            bulletPointWidget(text: StringUtils.policy5Info5),
                          ],
                        ),
                        10.h.height,
                        Text(
                          StringUtils.policy5Footer,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        10.h.height,
                        //
                        Text(
                          "6. ${StringUtils.policy6}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        bulletPointWidget(text: StringUtils.policy6Instruction)
                            .paddingOnly(left: 8),
                        //
                        Text(
                          "7. ${StringUtils.policy7}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        bulletPointWidget(text: StringUtils.policy7Instruction)
                            .paddingOnly(left: 8),
                        //
                        //
                        Text(
                          "8. ${StringUtils.policy8}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        bulletPointWidget(text: StringUtils.policy8Instruction)
                            .paddingOnly(left: 8),
                        //
                        Text(
                          "9. ${StringUtils.policy9}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        bulletPointWidget(text: StringUtils.policy9Instruction)
                            .paddingOnly(left: 8),
                        //
                        Text(
                          "10. ${StringUtils.policy10}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        Text(
                          StringUtils.policy10Instruction,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        15.h.height,
                        contactFooter(),
                        15.h.height,
                      ],
                    ).paddingOnly(left: 20.w, right: 20.w, top: 20.h)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
