import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
                                fontSize: 16.sp, fontWeight: FontWeight.w400)),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text("1. ${StringUtils.policyInformationTitle1}",
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.w500)),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(StringUtils.policy1,
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400)),
                        SizedBox(
                          height: 10.h,
                        ),
                        bulletPointWidget(text: StringUtils.policyStep1),
                        bulletPointWidget(text: StringUtils.policyStep2),
                        bulletPointWidget(text: StringUtils.policyStep3),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text("2. ${StringUtils.policyInformationTitle2}",
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.w500)),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(StringUtils.policy2,
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400)),
                        SizedBox(
                          height: 10.h,
                        ),
                        bulletPointWidget(text: StringUtils.policyInfo1),
                        bulletPointWidget(text: StringUtils.policyInfo2),
                        bulletPointWidget(text: StringUtils.policyInfo3),
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
