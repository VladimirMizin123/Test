import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/user_survey/user_survey_state.dart';
import 'package:gymeats_mobile/constant/app_colors.dart';
import 'package:gymeats_mobile/constant/app_string.dart';

import '../../app/functions.dart';
import '../../bloc/user_survey/user_survey_bloc.dart';
import '../../bloc/user_survey/user_survey_event.dart';
import '../../constant/app_TextStyle.dart';
import '../../models/get_survey_model.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../widget/app_widget.dart';
import '../../widget/svg_image.dart';
import '../../widget/user_survey_item.dart';

class UserSurveyScreen extends StatefulWidget {
  final String gender;

  const UserSurveyScreen({super.key, required this.gender});

  @override
  State<UserSurveyScreen> createState() => _UserSurveyScreenState();
}

class _UserSurveyScreenState extends State<UserSurveyScreen>
    with SingleTickerProviderStateMixin {
  int mainIndex = 0;
  UserSurveyBloc bloc = UserSurveyBloc();
  List<GetSurveyModel> getSurveyList = [];
  double percentage = 0.0;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc.add(GetSurveyData());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<UserSurveyBloc, UserSurveyState>(
            bloc: bloc,
            builder: (context, state) {
              if (state is LoadSurveyData) {
                return initView();
              }
              return Container();
            },
            listener: (context, state) {
              if (state is LoadSurveyData) {
                getSurveyList = state.list;
                percentage = (mainIndex + 1) / getSurveyList.length;
              }
            }),
      ),
    );
  }

  Widget initView() => Container(
        padding: EdgeInsets.all(20.0.h),
        child: Column(
          children: [
            Row(
              children: [
                const SvgImage(
                  image: AppStrings.icBack,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: LinearPercentIndicator(
                      animation: true,
                      lineHeight: 6.0,
                      percent: percentage,
                      barRadius: const Radius.circular(100),
                      progressColor: AppColors.terracotta,
                      backgroundColor: AppColors.lightGrey,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Image.asset(
                AppStrings.gymEatsLogo,
                fit: BoxFit.cover,
                color: setColor(gender: widget.gender),
                height: 60.h,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              getSurveyList[mainIndex].question,
              textAlign: TextAlign.center,
              style: AppTextStyle.gymEatsStyle.copyWith(
                  color: setColor(gender: widget.gender),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500),
            ).paddingOnly(top: 10),
            SizedBox(
              height: 20.h,
            ),
            commonSearchTextField(
              fontColor: Colors.white,
              controller: searchController,
              fontSize: 13,
              hintText: AppStrings.required,
              textInputType: TextInputType.text,
              context: context,
              onChange: (String value) {
                bloc.add(SearchData(text: value));
              },
            ),
            SizedBox(
              height: 30.h,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 6.0,
                  mainAxisSpacing: 8.0,
                  children: List.generate(
                    getSurveyList[mainIndex].options.length,
                    (index) {
                      return UserSurveyItems(
                        data: getSurveyList[mainIndex].options[index],
                        onClick: () {
                          bloc.add(CheckSurveyData(
                              index: index, mainIndex: mainIndex));
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !(MediaQuery.of(context).viewInsets.bottom != 0),
              child: Row(
                children: [
                  Expanded(
                    child: buildBorderButton(
                            context: context,
                            onPressed: () {},
                            textColor: setColor(gender: widget.gender),
                            borderColor: setColor(gender: widget.gender),
                            bgColor: Colors.white,
                            title: AppStrings.previous)
                        .paddingOnly(top: 25.h),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: buildButton(
                            context: context,
                            onPressed: () {},
                            textColor: Colors.white,
                            bgColor: setColor(gender: widget.gender),
                            title: AppStrings.next)
                        .paddingOnly(top: 25.h),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
