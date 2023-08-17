import 'dart:async';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/bloc/user_survey/user_survey_event.dart';
import 'package:gymeats_mobile/bloc/user_survey/user_survey_state.dart';
import 'package:gymeats_mobile/constant/app_colors.dart';

import '../../models/get_survey_model.dart';

class UserSurveyBloc extends Bloc<UserSurveyEvent, UserSurveyState> {
  UserSurveyBloc() : super(InitialState()) {
    on<GetSurveyData>(_onGetSurveyData);
    on<CheckSurveyData>(_onSurveyCheck);
    on<SearchData>(_onSearchData);
  }

  List<GetSurveyModel> getSurveyList = [];
  List<GetSurveyModel> newSurveyList = [];

  _onGetSurveyData(GetSurveyData event, Emitter<UserSurveyState> emit) {
    getSurveyList.add(GetSurveyModel(
        options: [
          Options(
              color: AppColors.primaryBlue,
              label: 'Gluten-Free',
              isSelect: false),
          Options(
              color: const Color(0xffA2A4A7), label: 'Keto', isSelect: false),
          Options(
              color: const Color(0xffABD4B8), label: 'Paleo', isSelect: false),
          Options(
              color: const Color(0xffE3BFAF),
              label: 'Vegetarian',
              isSelect: false),
          Options(
              color: const Color(0xffC3D3D8), label: 'Vegan', isSelect: false),
          Options(
              color: const Color(0xffCE6B53), label: 'Halal', isSelect: false),
          Options(
              color: const Color(0xff6A909D),
              label: 'Pescatarian',
              isSelect: false),
          Options(
              color: const Color(0xffCECECE),
              label: 'Low Sugar',
              isSelect: false),
          Options(
              color: const Color(0xff5C815C),
              label: 'Low Sugar',
              isSelect: false),
        ],
        question:
            'Do you have any nutritional preferences that you’d like to follow?'));

    getSurveyList.add(GetSurveyModel(options: [
      Options(color: AppColors.primaryBlue, label: 'Spices', isSelect: false),
      Options(color: const Color(0xffA2A4A7), label: 'Corn', isSelect: false),
      Options(
          color: const Color(0xffABD4B8), label: 'Red Meat', isSelect: false),
      Options(
          color: const Color(0xffE3BFAF), label: 'Vegetables', isSelect: false),
      Options(
          color: const Color(0xff336633), label: 'Coconut', isSelect: false),
      Options(color: const Color(0xffCE6B53), label: 'Fish', isSelect: false),
      Options(color: const Color(0xff6A909D), label: 'Celery', isSelect: false),
      Options(color: const Color(0xffCECECE), label: 'Fruits', isSelect: false),
      Options(color: const Color(0xff5F5F5F), label: 'Gluten', isSelect: false),
    ], question: 'Do you have any allergies, intolerances or preferences?'));

    getSurveyList.add(GetSurveyModel(
        options: [
          Options(
              color: AppColors.primaryBlue, label: 'Pregnant', isSelect: false),
          Options(
              color: const Color(0xffA2A4A7),
              label: 'Celiac Disease',
              isSelect: false),
          Options(
              color: const Color(0xffABD4B8), label: 'IBS', isSelect: false),
          Options(
              color: const Color(0xffE3BFAF),
              label: 'Diabetes',
              isSelect: false),
          Options(
              color: const Color(0xffC3D3D8),
              label: 'High Blood Pressure',
              isSelect: false),
          Options(
              color: const Color(0xffCE6B53),
              label: 'High Cholesterol',
              isSelect: false),
          Options(
              color: const Color(0xff6A909D), label: 'SIBO', isSelect: false),
          Options(
              color: const Color(0xffCECECE), label: 'GERD', isSelect: false),
          Options(
              color: const Color(0xff5C815C), label: 'IBD', isSelect: false),
        ],
        question:
            'Do you any health conditions that we should be considerate of?'));

    getSurveyList.add(GetSurveyModel(
        options: [
          Options(
              color: AppColors.primaryBlue,
              label: 'ACE Inhibitors',
              isSelect: false),
          Options(
              color: const Color(0xffA2A4A7),
              label: 'Anabolic Steriods',
              isSelect: false),
          Options(
              color: const Color(0xffABD4B8),
              label: 'Anti hypertensives',
              isSelect: false),
          Options(
              color: const Color(0xffE3BFAF),
              label: 'Blood Thinners',
              isSelect: false),
          Options(
              color: const Color(0xffC3D3D8),
              label: 'Corticosteroids',
              isSelect: false),
          Options(
              color: const Color(0xffCE6B53),
              label: 'Erythomycin',
              isSelect: false),
          Options(
              color: const Color(0xff6A909D),
              label: 'Potassium Sparing Diuretics',
              isSelect: false),
          Options(
              color: const Color(0xffCECECE),
              label: 'Non-Potassium Sparing Diuretics',
              isSelect: false),
          Options(
              color: const Color(0xff5C815C),
              label: 'Monoamine Oxidase Inhibitors',
              isSelect: false),
        ],
        question:
            'Are you taking any medications that we should be considerate of?'));

    newSurveyList.clear();
    newSurveyList.addAll(getSurveyList);

    emit(LoadSurveyData(list: newSurveyList));
  }

  _onSurveyCheck(CheckSurveyData event, Emitter<UserSurveyState> emit) {
    newSurveyList[event.mainIndex].options[event.index].isSelect = !newSurveyList[event.mainIndex].options[event.index].isSelect;
    emit(LoadSurveyData(list: newSurveyList));
  }

  _onSearchData(SearchData event, Emitter<UserSurveyState> emit) {
    if(event.text.isNotEmpty){
      
    }
  }
}
