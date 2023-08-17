import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/user_survey/user_survey_event.dart';
import 'package:gymeats_mobile/bloc/user_survey/user_survey_state.dart';
import 'package:gymeats_mobile/constant/app_colors.dart';

import '../../models/get_survey_model.dart';
import '../../repository/get_survey.dart';

class UserSurveyBloc extends Bloc<UserSurveyEvent, UserSurveyState> {
  UserSurveyBloc() : super(InitialState()) {
    on<GetSurveyData>(_onGetSurveyData);
    on<CheckSurveyData>(_onSurveyCheck);
    on<SearchData>(_onSearchData);
  }

  final GetSurveyRepository getSurveyRepository = GetSurveyRepository();
  SurveyData? getSurvey;
  SurveyData? getNewSurvey;

  _onGetSurveyData(GetSurveyData event, Emitter<UserSurveyState> emit) async {
    emit(LoadingSurveyData());
    try {
      final response = await getSurveyRepository.getSurvey();
      response.fold((left) {
        emit(ErrorStateData(errMessage: left.errorMessage!));
      }, (right) {
        getSurvey = right.data;
        getNewSurvey = getSurvey;
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
    if(event.text.isEmpty){
      getNewSurvey = getSurvey;
    }else{
      getNewSurvey!.options = getSurvey!.options!
          .where((element) =>
          element.label!.toLowerCase().contains(event.text.toLowerCase()))
          .toList();
    }

    emit(LoadSurveyData(surveyData: getNewSurvey!));

  }
}
