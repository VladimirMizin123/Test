import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/user_survey/user_survey_event.dart';
import 'package:gymeats_mobile/bloc/user_survey/user_survey_state.dart';
import 'package:gymeats_mobile/constant/app_string.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import '../../models/get_survey_model.dart';
import '../../repository/get_survey.dart';
import '../../screen/user_photo_selection/user_photo_selection_screen.dart';

class UserSurveyBloc extends Bloc<UserSurveyEvent, UserSurveyState> {
  UserSurveyBloc() : super(InitialState()) {
    on<GetSurveyData>(_onGetSurveyData);
    on<CheckSurveyData>(_onSurveyCheck);
    on<SearchData>(_onSearchData);
    on<NextPrevSurveyClick>(_onNextPrevSurveyClick);
  }

  final GetSurveyRepository getSurveyRepository = GetSurveyRepository();
  SurveyDataQuestion? getSurvey;
  SurveyDataQuestion? getNewSurvey;
  List<SurveyDataQuestion> listSurveyData = [];

  _onGetSurveyData(GetSurveyData event, Emitter<UserSurveyState> emit) async {
    emit(LoadingSurveyData());
    try {
      final response = await getSurveyRepository.getSurvey();
      response.fold((left) {
        emit(ErrorStateData(errMessage: left.errorMessage!));
      }, (right) {
        getSurvey = right.data;
        getNewSurvey = getSurvey;
        listSurveyData.add(getNewSurvey!);
        emit(LoadSurveyData(surveyData: getNewSurvey!));
      });
    } catch (e) {
      emit(ErrorStateData(errMessage: e.toString()));
    }
  }

  _onSurveyCheck(CheckSurveyData event, Emitter<UserSurveyState> emit) {
    getNewSurvey!.options![event.index].isSelect =
        !getNewSurvey!.options![event.index].isSelect;
    emit(LoadSurveyData(surveyData: getNewSurvey!));
  }

  _onSearchData(SearchData event, Emitter<UserSurveyState> emit) {
    debugPrint("getSurvey 1-->${getSurvey!.options!.length}");

    getNewSurvey = SurveyDataQuestion(
        options: getSurvey!.options!
            .where((item) =>
                item.label!.toLowerCase().contains(event.text.toLowerCase()))
            .toList(),
        label: getSurvey!.label,
        answerType: getSurvey!.answerType,
        createdBy: getSurvey!.createdBy,
        id: getSurvey!.id,
        isPrimary: getSurvey!.isPrimary);

    emit(LoadSurveyData(surveyData: getNewSurvey!));
  }

  _onNextPrevSurveyClick(
      NextPrevSurveyClick event, Emitter<UserSurveyState> emit) {
    debugPrint("listSurveyData--> ${listSurveyData.length}");
    if (event.isNext) {
      bool isTrueInList =
          getNewSurvey!.options!.any((element) => element.isSelect == true);
      if (isTrueInList) {
        if (getNewSurvey!.options![event.index].questionDiet == 1) {
          getNewSurvey = getNewSurvey!.options![event.index].question;
          listSurveyData.add(getNewSurvey!);
          emit(LoadSurveyData(surveyData: getNewSurvey!));
        } else {
          Get.to(const UserPhotoSelectionScreen());
        }
      } else {
        showToast(
            message: AppStrings.userSurveySelectionError, isSuccess: false);
      }
    } else {
      if (listSurveyData.isNotEmpty) {
        listSurveyData.removeLast();
        getNewSurvey = listSurveyData[event.index];

        emit(LoadSurveyData(surveyData: getNewSurvey!));
      } else {
        Get.back();
      }
    }
  }
}
