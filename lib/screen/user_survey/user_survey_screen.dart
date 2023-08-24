import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/user_survey/user_survey_state.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';

import '../../app/functions.dart';
import '../../bloc/user_survey/user_survey_bloc.dart';
import '../../bloc/user_survey/user_survey_event.dart';
import '../../constant/app_TextStyle.dart';
import '../../models/get_survey_model.dart';
import '../../widget/app_center_loader.dart';
import '../../widget/app_widget.dart';
import '../../widget/svg_image.dart';
import '../../widget/user_survey_item.dart';

class UserSurveyScreen extends StatefulWidget {
  final String gender;

  const UserSurveyScreen({super.key, required this.gender});

  @override
  State<UserSurveyScreen> createState() => _UserSurveyScreenState();
}

class _UserSurveyScreenState extends State<UserSurveyScreen> with SingleTickerProviderStateMixin {
  UserSurveyBloc bloc = UserSurveyBloc();
  SurveyDataQuestion? getSurveyData;
  double percentage = 0.0;
  final searchController = TextEditingController();
  int optionIndex = 0;
  List<int> listIndex = [];
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
              if (state is LoadingSurveyData) {
                return const AppCenterLoader();
              }
              if (state is ErrorStateData) {
                return Center(
                    child: Text(
                  state.errMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.primaryBlue, fontSize: 20, fontWeight: FontWeight.w700),
                ));
              }
              return Container();
            },
            listener: (context, state) {
              if (state is LoadSurveyData) {
                getSurveyData = state.surveyData;

                // countOptions(getSurveyData);
                // debugPrint("count --> $count");
                // percentage = (mainIndex + 1) / getSurveyList.length;
              }
            }),
      ),
    );
  }

  Widget initView() => Container(
        padding: EdgeInsets.all(20.0.h),
        child: Column(
          children: [
            const Row(
              children: [
                SvgImage(
                  image: AssetsUtils.icBack,
                ),
/*
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
*/
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Image.asset(
                AssetsUtils.gymEatsLogo,
                fit: BoxFit.cover,
                color: setColor(gender: widget.gender),
                height: 60.h,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              getSurveyData!.label!,
              textAlign: TextAlign.center,
              style: AppTextStyle.gymEatsStyle.copyWith(color: setColor(gender: widget.gender), fontSize: 18.sp, fontWeight: FontWeight.w500),
            ).paddingOnly(top: 10),
            SizedBox(
              height: 20.h,
            ),
            commonSearchTextField(
              fontColor: Colors.white,
              controller: searchController,
              fontSize: 13,
              hintText: StringUtils.required,
              textInputType: TextInputType.text,
              context: context,
              onChange: (String value) {
                bloc.add(SearchData(
                  text: value,
                ));
              },
              onClear: () {
                searchController.clear();
                bloc.add(SearchData(
                  text: searchController.text,
                ));
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
                    getSurveyData!.options!.length,
                    (index) {
                      return UserSurveyItems(
                        data: getSurveyData!.options![index],
                        onClick: () {
                          optionIndex = index;
                          bloc.add(CheckSurveyData(
                            index: index,
                          ));
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
                            onPressed: () {
                              optionIndex = listIndex[listIndex.length - 1];
                              listIndex.removeLast();
                              bloc.add(NextPrevSurveyClick(index: optionIndex, isNext: false));
                            },
                            textColor: setColor(gender: widget.gender),
                            borderColor: setColor(gender: widget.gender),
                            bgColor: Colors.white,
                            title: StringUtils.previous)
                        .paddingOnly(top: 25.h),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: buildButton(
                            context: context,
                            onPressed: () {
                              optionIndex = getSurveyData!.options!.indexWhere((value) => value.isSelect);
                              listIndex.add(optionIndex);
                              bloc.add(NextPrevSurveyClick(index: optionIndex, isNext: true));
                            },
                            textColor: Colors.white,
                            bgColor: setColor(gender: widget.gender),
                            title: StringUtils.next)
                        .paddingOnly(top: 25.h),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
