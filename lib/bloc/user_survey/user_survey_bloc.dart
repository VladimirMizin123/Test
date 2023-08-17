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
  SurveyData? getSurveyList;
  SurveyData? getNewSurveyList ;

  _onGetSurveyData(GetSurveyData event, Emitter<UserSurveyState> emit) async {
    emit(LoadingSurveyData());
    try {
      final response = await getSurveyRepository.getSurvey();
      response.fold((left) {
        emit(ErrorStateData(errMessage: left.errorMessage!));
      }, (right) {
        getSurveyList = right.data;

        emit(LoadSurveyData(surveyData: getSurveyList!));
      });
    } catch (e) {
      emit(ErrorStateData(errMessage: e.toString()));
    }
  }

  _onSurveyCheck(CheckSurveyData event, Emitter<UserSurveyState> emit) {
    // getNewSurveyList..isSelect =
    //     !getNewSurveyList[event.mainIndex].options[event.index].isSelect;
    // emit(LoadSurveyData(list: getNewSurveyList));
  }

  _onSearchData(SearchData event, Emitter<UserSurveyState> emit) {
    /*debugPrint("event.text--> ${event.text.isEmpty}");

    if (event.text.isEmpty) {
      getSurveyList[event.mainIndex]
          .options
          .map((e) => e.isSearch = true)
          .toList();
      getNewSurveyList.clear();
      getNewSurveyList.addAll(getSurveyList);
      emit(LoadSurveyData(list: getNewSurveyList));
    } else {
      for (var element in getSurveyList[event.mainIndex].options) {
        if (element.label.toLowerCase().contains(event.text.toLowerCase())) {
          // element.isSearch = true;
          getNewSurveyList[event.mainIndex].options.add(element);
        } *//*else {
          element.isSearch = false;
        }*//*
      }
      *//*  getNewSurveyList[event.mainIndex].options.map((e) {
        if (e.isSearch) {
          getNewSurveyList[event.mainIndex].options.add(e);
        }
      });*//*

      emit(LoadSurveyData(list: getNewSurveyList));
    }*/
  }
}
