import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/bloc/user_survey/user_survey_event.dart';
import 'package:gymeats_mobile/bloc/user_survey/user_survey_state.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import '../../models/get_survey_model.dart';
import '../../repository/get_survey.dart';

class UserSurveyBloc extends Bloc<UserSurveyEvent, UserSurveyState> {
  UserSurveyBloc() : super(InitialState()) {
    on<GetSurveyData>(_onGetSurveyData);
    on<CheckSurveyData>(_onSurveyCheck);
    on<SearchData>(_onSearchData);
    on<NextPrevSurveyClick>(_onNextPrevSurveyClick);
    on<GetAllRestrictionEvent>(_onGetAllRestriction);
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
        emit(LoadSurveyData(surveyData: getNewSurvey!, isAPIData: true));
      });
    } catch (e) {
      emit(ErrorStateData(errMessage: e.toString()));
    }
  }

  _onGetAllRestriction(GetAllRestrictionEvent event, Emitter<UserSurveyState> emit) async {
    emit(GetAllRestrictionLoadingState());
    try {
      final response = await getSurveyRepository.getAllRestriction();
      response.fold((left) {
        emit(ErrorStateData(errMessage: left.errorMessage!));
      }, (right) {
        emit(GetAllRestrictionSuccessState(edgesRestrictionList: right.data.restrictions.edgesRestrictionList));
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
    getNewSurvey = SurveyDataQuestion(options: getSurvey!.options!.where((item) => item.label!.toLowerCase().contains(event.text.toLowerCase())).toList(), label: getSurvey!.label, answerType: getSurvey!.answerType, createdBy: getSurvey!.createdBy, id: getSurvey!.id, isPrimary: getSurvey!.isPrimary);

    emit(LoadSurveyData(surveyData: getNewSurvey!));
  }

  _onNextPrevSurveyClick(NextPrevSurveyClick event, Emitter<UserSurveyState> emit) {
    if (event.isNext) {
      bool isTrueInList = getNewSurvey!.options!.any((element) => element.isSelect == true);
      if (isTrueInList) {
        if (getNewSurvey!.options![event.index].questionDiet == 1) {
          getNewSurvey = getNewSurvey!.options![event.index].question;
          listSurveyData.add(getNewSurvey!);
          emit(LoadSurveyData(surveyData: getNewSurvey!));
        } else {
          emit(NextScreenState(dietId: getNewSurvey!.options![event.index].diet!.id!));
        }
      } else {
        showToast(
            message: StringUtils.userSurveySelectionError, isSuccess: false);
      }
    } else {
      if (listSurveyData.isNotEmpty) {
        if (listSurveyData.length > 1) {
          listSurveyData.removeLast();
          getNewSurvey = listSurveyData[listSurveyData.length - 1];

          emit(LoadSurveyData(surveyData: getNewSurvey!));
        } else {
          emit(PreviousScreenState());

          // Get.back();
        }
      } else {
        emit(PreviousScreenState());

        // Get.back();
      }
    }
  }
}
