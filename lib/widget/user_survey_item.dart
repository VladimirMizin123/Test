import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/models/get_survey_model.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/get_all_diet_model.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/get_all_restriction_modal.dart';
import 'package:gymeats_mobile/widget/svg_image.dart';

import '../constant/app_TextStyle.dart';

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
                  border: Border.all(width: 2, color: Colors.white),
                ),
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
                  Radius.circular(2.0),
                ),
              ),
              child: SvgImage(
                image: AssetsUtils.icCheck,
                color: data.color ?? AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserSurveySearchItems extends StatefulWidget {
  final DietDetails data;
  final VoidCallback onTap;
  final int index;

  const UserSurveySearchItems(
      {super.key,
      required this.data,
      required this.onTap,
      required this.index});

  @override
  State<UserSurveySearchItems> createState() => _UserSurveySearchItemsState();
}

class _UserSurveySearchItemsState extends State<UserSurveySearchItems> {
  List<Color> colorList = [
    Colors.indigoAccent.withOpacity(0.8),
    Colors.redAccent.withOpacity(0.8),
    Colors.purpleAccent.withOpacity(0.8),
    Colors.deepPurpleAccent.withOpacity(0.8),
    Colors.tealAccent.withOpacity(0.8),
    Colors.pinkAccent.withOpacity(0.8),
    Colors.blueAccent.withOpacity(0.8),
    Colors.lightBlueAccent.withOpacity(0.8),
    Colors.cyanAccent.withOpacity(0.8),
    Colors.lightGreenAccent.withOpacity(0.8),
    Colors.greenAccent.withOpacity(0.8),
    Colors.yellowAccent.withOpacity(0.8),
    Colors.deepOrangeAccent.withOpacity(0.8),
    Colors.amberAccent.withOpacity(0.8),
    Colors.orangeAccent.withOpacity(0.8),
    Colors.limeAccent.withOpacity(0.8),
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: colorList[widget.index % colorList.length],
                shape: BoxShape.circle),
            padding: const EdgeInsets.all(10),
            child: Text(
              widget.data.dietName.toString(),
              textAlign: TextAlign.center,
              style: AppTextStyle.gymEatsStyle.copyWith(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Visibility(
            visible: widget.data.select,
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
            visible: widget.data.select,
            child: Container(
              padding:
                  const EdgeInsets.only(right: 5, top: 8, left: 5, bottom: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
              ),
              child: SvgImage(
                image: AssetsUtils.icCheck,
                color: colorList[widget.index % colorList.length],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserSurveyPreferenceSearchItems extends StatefulWidget {
  final Edge data;
  final VoidCallback onTap;
  final int index;

  const UserSurveyPreferenceSearchItems(
      {super.key,
      required this.data,
      required this.onTap,
      required this.index});

  @override
  State<UserSurveyPreferenceSearchItems> createState() =>
      _UserSurveyPreferenceSearchItemsState();
}

class _UserSurveyPreferenceSearchItemsState
    extends State<UserSurveyPreferenceSearchItems> {
  List<Color> colorList = [
    Colors.indigoAccent.withOpacity(0.8),
    Colors.redAccent.withOpacity(0.8),
    Colors.purpleAccent.withOpacity(0.8),
    Colors.deepPurpleAccent.withOpacity(0.8),
    Colors.tealAccent.withOpacity(0.8),
    Colors.pinkAccent.withOpacity(0.8),
    Colors.blueAccent.withOpacity(0.8),
    Colors.lightBlueAccent.withOpacity(0.8),
    Colors.cyanAccent.withOpacity(0.8),
    Colors.lightGreenAccent.withOpacity(0.8),
    Colors.greenAccent.withOpacity(0.8),
    Colors.yellowAccent.withOpacity(0.8),
    Colors.deepOrangeAccent.withOpacity(0.8),
    Colors.amberAccent.withOpacity(0.8),
    Colors.orangeAccent.withOpacity(0.8),
    Colors.limeAccent.withOpacity(0.8),
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: colorList[widget.index % colorList.length],
                shape: BoxShape.circle),
            padding: const EdgeInsets.all(10),
            child: Text(
              widget.data.node.name,
              textAlign: TextAlign.center,
              style: AppTextStyle.gymEatsStyle.copyWith(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Visibility(
            visible: widget.data.node.isRestricted,
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
            visible: widget.data.node.isRestricted,
            child: Container(
              padding:
                  const EdgeInsets.only(right: 5, top: 8, left: 5, bottom: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
              ),
              child: SvgImage(
                image: AssetsUtils.icCheck,
                color: colorList[widget.index % colorList.length],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
