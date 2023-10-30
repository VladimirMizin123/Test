import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/screen/account_screen/about/pivacy/pivacy_screen_widget.dart';

import '../../../../constant/string_utils.dart';
import '../../../../widget/back_button_widget.dart';

class ConditionScreen extends StatefulWidget {
  const ConditionScreen({super.key});

  @override
  State<ConditionScreen> createState() => _ConditionScreenState();
}

class _ConditionScreenState extends State<ConditionScreen> {
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
                              width: 50.w,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Terms and Conditions",
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
                        Text(StringUtils.writeTermsInstructions,
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400)),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text("1. ${StringUtils.termsInformationTitle1}",
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.w500)),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          StringUtils.termsStep1,
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w400),
                          softWrap: true,
                        ),
                        SizedBox(
                          height: 9.h,
                        ),
                        Text("2. ${StringUtils.termsInformationTitle2}",
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.w500)),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(StringUtils.term2,
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400)),
                        SizedBox(
                          height: 10.h,
                        ),
                        bulletPointWidget(text: StringUtils.termInfo1),
                        bulletPointWidget(text: StringUtils.termInfo2),
                        bulletPointWidget(text: StringUtils.termInfo3),
                        bulletPointWidget(text: StringUtils.termInfo4),
                        bulletPointWidget(text: StringUtils.termInfo5),
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
