import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymeats_mobile/models/get_survey_model.dart';
import 'package:gymeats_mobile/widget/svg_image.dart';

import '../constant/app_TextStyle.dart';
import '../constant/app_string.dart';

class UserSurveyItems extends StatelessWidget {
  final DataOption data;
  final Function() onClick;

  const UserSurveyItems({super.key, required this.data, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            alignment: Alignment.center,
            decoration:
                BoxDecoration(color: data.color, shape: BoxShape.circle),
            padding: const EdgeInsets.all(10),
            child: Text(
              data.label!,
              textAlign: TextAlign.center,
              style: AppTextStyle.gymEatsStyle.copyWith(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Visibility(
            visible: data.isSelect,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Colors.white)),
              ),
            ),
          ),
          Visibility(
            visible: data.isSelect,
            child: Container(
              padding:
                  const EdgeInsets.only(right: 5, top: 8, left: 5, bottom: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                    Radius.circular(2.0)),
              ),
              child: SvgImage(
                image: AppStrings.icCheck,
                color: data.color!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
