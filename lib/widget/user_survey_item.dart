import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/extention/ext_on_list.dart';
import 'package:gymeats_mobile/models/get_survey_model.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/get_all_restriction_modal.dart';
import 'package:gymeats_mobile/constant/app_TextStyle.dart';

class UserSurveyItems extends StatelessWidget {
  final DataOption data;
  final double scale;
  final Function() onClick;

  const UserSurveyItems({
    super.key,
    required this.data,
    this.scale = 1.5,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.scale(
          scale: scale,
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: Theme.of(context).primaryColor,
            ),
            child: GestureDetector(
              onTap: () => onClick.call(),
              child: AbsorbPointer(
                absorbing: true,
                child: Radio(
                  visualDensity:
                      const VisualDensity(horizontal: -4.0, vertical: -4.0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  groupValue: data.isSelect,
                  value: true,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        ).paddingOnly(left: 10),
        Expanded(
            child: Text(
          data.label!,
          style: AppTextStyle.gymEatsStyle.copyWith(
            color:
                data.isSelect ? Theme.of(context).primaryColor : Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        )),
      ].addBetweenItems(const SizedBox(width: 15)),
    ).paddingOnly(top: 10, bottom: 10);
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
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.scale(
          scale: 1.5,
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: Theme.of(context).primaryColor,
            ),
            child: GestureDetector(
              onTap: () => widget.onTap.call(),
              child: AbsorbPointer(
                absorbing: true,
                child: Radio(
                  visualDensity:
                      const VisualDensity(horizontal: -4.0, vertical: -4.0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  groupValue: widget.data.node.isRestricted,
                  value: true,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (_) => {},
                ),
              ),
            ),
          ),
        ).paddingOnly(left: 10),
        Expanded(
            child: Text(
          widget.data.node.name,
          style: AppTextStyle.gymEatsStyle.copyWith(
            color: widget.data.node.isRestricted
                ? Theme.of(context).primaryColor
                : Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        )),
      ].addBetweenItems(const SizedBox(width: 15)),
    ).paddingOnly(top: 10, bottom: 10);
  }
}
