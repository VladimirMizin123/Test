import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
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
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Text(StringUtils.writeTermsInstructions,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400)),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text("1. ${StringUtils.termsInformationTitle1}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500)),
                        10.h.height,
                        Text(
                          StringUtils.termsStep1,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400),
                          softWrap: true,
                        ),
                        10.h.height,
                        Text(
                          "2. ${StringUtils.termsInformationTitle2}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        Text(
                          StringUtils.term2,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        10.h.height,
                        Column(
                          children: [
                            bulletPointWidget(text: StringUtils.termInfo1),
                            bulletPointWidget(text: StringUtils.termInfo2),
                            bulletPointWidget(text: StringUtils.termInfo3),
                            bulletPointWidget(text: StringUtils.termInfo4),
                          ],
                        ),
                        //
                        10.h.height,
                        Text(
                          "3. ${StringUtils.termsInformationTitle3}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        Text(
                          StringUtils.term3,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        10.h.height,
                        Column(
                          children: [
                            bulletPointWidget(text: StringUtils.term3Info1),
                            bulletPointWidget(text: StringUtils.term3Info2),
                            bulletPointWidget(text: StringUtils.term3Info3),
                          ],
                        ),
                        10.h.height,
                        Text(
                          StringUtils.term3Footer,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        //
                        10.h.height,
                        Text(
                          "4. ${StringUtils.termsInformationTitle4}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        Column(
                          children: [
                            bulletPointWidget(text: StringUtils.term4),
                            bulletPointWidget(text: StringUtils.term42),
                          ],
                        ),
                        //
                        10.h.height,
                        Text(
                          "5. ${StringUtils.termsInformationTitle5}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        Text(
                          StringUtils.term5,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        10.h.height,
                        Column(
                          children: [
                            bulletPointWidget(text: StringUtils.term5Info1),
                            bulletPointWidget(text: StringUtils.term5Info2),
                            bulletPointWidget(text: StringUtils.term5Info3),
                            bulletPointWidget(text: StringUtils.term5Info4),
                          ],
                        ),
                        //
                        10.h.height,
                        Text(
                          "6. ${StringUtils.termsInformationTitle6}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        Column(
                          children: [
                            bulletPointWidget(text: StringUtils.term6),
                          ],
                        ),
                        //
                        10.h.height,
                        Text(
                          "7. ${StringUtils.termsInformationTitle7}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        bulletPointWidget(text: StringUtils.term7),
                        //
                        10.h.height,
                        Text(
                          "8. ${StringUtils.termsInformationTitle8}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        bulletPointWidget(text: StringUtils.term8),
                        //
                        10.h.height,
                        Text(
                          "9. ${StringUtils.termsInformationTitle9}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        Text(
                          StringUtils.term9,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        10.h.height,
                        Column(
                          children: [
                            bulletPointWidget(text: StringUtils.term9Info1),
                            bulletPointWidget(text: StringUtils.term9Info2),
                            bulletPointWidget(text: StringUtils.term9Info3),
                            bulletPointWidget(text: StringUtils.term9Info4),
                          ],
                        ),
                        10.h.height,
                        Text(
                          StringUtils.term9Footer,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        //
                        10.h.height,
                        Text(
                          "10. ${StringUtils.termsInformationTitle10}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        bulletPointWidget(text: StringUtils.term10),
                        //
                        10.h.height,
                        Text(
                          "11. ${StringUtils.termsInformationTitle11}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        bulletPointWidget(text: StringUtils.term11),
                        //
                        10.h.height,
                        Text(
                          "12. ${StringUtils.termsInformationTitle12}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        bulletPointWidget(text: StringUtils.term12),
                        //
                        10.h.height,
                        Text(
                          "13. ${StringUtils.termsInformationTitle13}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        bulletPointWidget(text: StringUtils.term13),
                        //
                        10.h.height,
                        Text(
                          "14. ${StringUtils.termsInformationTitle14}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        bulletPointWidget(text: StringUtils.term14),
                        //
                        10.h.height,
                        Text(
                          "15. ${StringUtils.termsInformationTitle15}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        bulletPointWidget(text: StringUtils.term15),
                        //
                        10.h.height,
                        Text(
                          "16. ${StringUtils.termsInformationTitle16}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.h.height,
                        Text(
                          StringUtils.term16,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        10.h.height,
                        contactFooter(),
                        20.h.height,
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
