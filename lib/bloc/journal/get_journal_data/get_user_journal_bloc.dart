import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/models/get_meal_tracker_data_model.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_event.dart';
import 'package:intl/intl.dart';

import '../../../app/functions.dart';
import '../../../app/sharedPrefrence.dart';
import '../../../models/fetch_meal_plan_model.dart';
import '../../../repository/add_eaten_meal.dart';
import '../../../repository/get_exercise_details.dart';
import '../../../repository/get_meal_tracker_data.dart';
import '../../../repository/get_user_journal.dart';
import '../../../repository/get_water_details.dart';
import '../../../screen/meal_plan_home/bloc/meal_plan_repository.dart';
import '../../../widget/app_widget.dart';
import 'get_user_journal_event.dart';
import 'get_user_journal_state.dart';

class GetUserJournalBloc
    extends Bloc<GetUserJournalEvent, GetUserJournalState> {
  GetUserJournalBloc() : super(InitialState()) {
    on<GetUserJournalData>(_onGetUserJournalData);
    on<GenMealData>(_onGenMealTrackerData);
    on<AddEatenMealData>(_onAddEatenMeal);
    on<MealTrackerData>(_onMealTrackerData);
    on<GetWaterDetails>(_onGetWaterDetails);
    on<GetExerciseDetails>(_onGetExerciseDetails);
    on<GetAllExerciseDetails>(_onGetAllExerciseDetails);
    on<GetSelectedImagePath>(_onGetSelectedImagePath);
    on<AddNewItemEvent>(_onAddNewItemData);
    on<AddNewDietEvent>(_onAddNewDietData);
    on<DailyRecapEvent>(_onDailyRecap);
    on<DailyRecapAnsEvent>(_onDailyRecapAns);
    on<RemoveWaterEvent>(_onRemoveWater);
    on<JournalGetDashboardDataEvent>(_onGetSurveyData);
  }

  final GetUserJournalDataRepository _journalDataRepository =
      GetUserJournalDataRepository();
  final GetMealTrackerDataRepository _trackerDataRepository =
      GetMealTrackerDataRepository();
  final MealPlanRepository _planRepository = MealPlanRepository();
  final AddEatenMealRepository _eatenMealRepository = AddEatenMealRepository();
  final GetWaterDetailsRepository _waterDetailsRepository =
      GetWaterDetailsRepository();
  final GetExerciseDetailsRepository _exerciseDetailsRepository =
      GetExerciseDetailsRepository();

  _onGetSurveyData(JournalGetDashboardDataEvent event,
      Emitter<GetUserJournalState> emit) async {
    try {
      // final response = await _journalDataRepository.getDashboardData();
      final data = await _journalDataRepository
          .getMealLogByDate(DateFormat('yyyy-MM-dd').format(event.dateTime!));

      // response.fold((left) {}, (right) {
      data.fold(
          (left) => {
                // emit(JournalLoadDashboardDataState(model: right, data: [])),
              }, (r) {
        emit(JournalLoadDashboardDataState(data: r.data));
      });
      // emit(LoadDashboardData(model: right));
      // });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
    }
  }

  _onGetUserJournalData(
      GetUserJournalData event, Emitter<GetUserJournalState> emit) async {
    try {
      emit(GetUserJournalDataLoading());
      final response =
          await _journalDataRepository.getUserJournalData(date: event.date);
      response.fold((left) {
        emit(ErrorJournalState());
      }, (right) {
        emit(LoadUserJournalData(model: right));
      });
    } catch (e) {
      emit(ErrorJournalState());
    }
  }

  List<MealData> dataList = [];
  List<TrackerData> mealTrackerList = [];

  _onGenMealTrackerData(
      GenMealData event, Emitter<GetUserJournalState> emit) async {
    try {
      await _planRepository.fetchMealPlan().fold((left) {
        emit(ErrorGenTrackState());
      }, (right) {
        dataList.clear();
        right.data!.map((e) {
          if (dateTimeYYYYMMDD(dateTimeVal: e.date.toString()) ==
              dateTimeNow()) {
            dataList.addAll(e.meals!);
          }
        }).toList();
        emit(LoadGenMealData(genMealDataList: dataList));
      });
    } catch (e) {
      emit(ErrorGenTrackState());
    }
  }

  _onMealTrackerData(
      MealTrackerData event, Emitter<GetUserJournalState> emit) async {
    try {
      await _trackerDataRepository.getMealTrackerData(date: event.date).fold(
          (left) {
        emit(ErrorGenTrackState());
      }, (right) {
        mealTrackerList.clear();
        right.data!.map((e) {
          if (dateTimeYYYYMMDD(dateTimeVal: e.date.toString()) == event.date) {
            mealTrackerList.add(e);
          }
        }).toList();
        emit(LoadMealTrackData(mealTrackDataList: mealTrackerList));
      });
    } catch (e) {
      emit(ErrorGenTrackState());
    }
  }

  _onGetWaterDetails(
      GetWaterDetails event, Emitter<GetUserJournalState> emit) async {
    try {
      await _waterDetailsRepository.getWaterDetails(date: event.date).fold(
          (left) {
        emit(ErrorWaterDataState());
      }, (right) {
        emit(LoadWaterData(data: right.data!));
      });
    } catch (e) {
      emit(ErrorWaterDataState());
    }
  }

  _onGetAllExerciseDetails(
      GetAllExerciseDetails event, Emitter<GetUserJournalState> emit) async {
    try {
      emit(AllExerciseLoadingState());
      await _exerciseDetailsRepository.getAllExerciseDetails().fold((left) {
        emit(ErrorExerciseState());
      }, (right) {
        emit(AllExerciseSuccessState(data: right.data ?? []));
      });
    } catch (e) {
      emit(ErrorExerciseState());
    }
  }

  _onGetExerciseDetails(
      GetExerciseDetails event, Emitter<GetUserJournalState> emit) async {
    try {
      emit(AllExerciseLogLoadingState());
      await _exerciseDetailsRepository
          .getExerciseDetails(date: event.date)
          .fold((left) {
        emit(ErrorExerciseState());
      }, (right) {
        emit(AllExerciseLogSuccessState(data: right.data!));
      });
    } catch (e) {
      emit(ErrorExerciseState());
    }
  }

  _onAddEatenMeal(
      AddEatenMealData event, Emitter<GetUserJournalState> emit) async {
    try {
      emit(LoadingDoneState());
      emit(AddItemLoadingState(title: event.title, itemId: event.mealId));
      await _eatenMealRepository
          .addEatenMeal(
              userId: userId,
              mealId: event.mealId ?? '',
              recipeId: event.recipeId ?? '',
              noOfServing: event.noOfServing ?? 0,
              mealName: event.mealName ?? '',
              mealType: event.mealType ?? '',
              calorie: event.calorie ?? 0,
              protein: event.protein ?? 0,
              fat: event.fat ?? 0,
              carbs: event.carbs ?? 0,
              value: event.value ?? 0)
          .fold((left) {
        emit(AddItemErrorState(title: event.title, mealID: event.mealId));
        showToast(isSuccess: false, message: left.errorMessage!);
      }, (right) {
        showToast(isSuccess: true, message: right.message!);
        print('SHOW TOAST ---------------');
        emit(AddItemSuccessState(title: event.title, mealID: event.mealId));

        dataList.map((e) {
          if (e.id!.contains(event.mealId ?? '')) {
            e.isDone = true;
          }
        }).toList();
        emit(LoadGenMealData(genMealDataList: dataList));
      });
    } catch (e) {
      emit(AddItemErrorState(title: event.title));
      showToast(isSuccess: false, message: e.toString());
    }
  }

  _onGetSelectedImagePath(
      GetSelectedImagePath event, Emitter<GetUserJournalState> emit) async {
    emit(SelectedImagePathState(imgPath: event.imagePath));
  }

  _onAddNewItemData(
      AddNewItemEvent event, Emitter<GetUserJournalState> emit) async {
    try {
      emit(AddNewItemLoadingData());
      await _eatenMealRepository.addNewItem(userId: userId, mealId: '').fold(
          (left) {
        showToast(isSuccess: false, message: left.errorMessage!);
      }, (right) {
        showToast(isSuccess: true, message: right.message!);
        emit(AddNewItemSuccessState(imgPath: ''));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
    }
  }

  _onAddNewDietData(
      AddNewDietEvent event, Emitter<GetUserJournalState> emit) async {
    try {
      emit(AddNewDietLoadingData());
      await _eatenMealRepository
          .addNewDiet(
        dietName: event.dietName ?? '',
        proteinPercentage: event.proteinPercentage ?? '',
        carbsPercentage: event.carbsPercentage ?? '',
        fatPercentage: event.fatPercentage ?? '',
        surplusPercentage: event.surplusPercentage ?? '',
        deficitPercentage: event.deficitPercentage ?? '',
        mealSchedule: event.mealSchedule ?? '',
        colorCode: event.colorCode ?? '',
        isDefault: event.isDefault ?? false,
      )
          .fold((left) {
        showToast(isSuccess: false, message: left.errorMessage!);
      }, (right) {
        showToast(isSuccess: true, message: right.message!);
        emit(AddNewDietSuccessState(imgPath: ''));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
    }
  }

  _onDailyRecap(
      DailyRecapEvent event, Emitter<GetUserJournalState> emit) async {
    try {
      emit(DailyRecapLoadingData());
      await _eatenMealRepository.dailyRecap().fold((left) {
        showToast(isSuccess: false, message: left.errorMessage!);
      }, (right) {
        // showToast(isSuccess: true, message: right.message!);
        emit(DailyRecapSuccessState(recapData: right.data));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
    }
  }

  _onDailyRecapAns(
      DailyRecapAnsEvent event, Emitter<GetUserJournalState> emit) async {
    try {
      emit(DailyRecapAnsLoadingData());
      await _eatenMealRepository
          .dailyRecapAns(queID: event.queID, recapAns: event.recapAns)
          .fold((left) {
        showToast(isSuccess: false, message: left.errorMessage!);
      }, (right) {
        emit(DailyRecapAnsSuccessState(recapData: false));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
    }
  }

  _onRemoveWater(
      RemoveWaterEvent event, Emitter<GetUserJournalState> emit) async {
    try {
      emit(RemoveWaterLoadingData());
      await _eatenMealRepository.removeWater(quantity: event.quantity).fold(
          (left) {
        showToast(isSuccess: false, message: left.errorMessage!);
        emit(RemoveWaterErrorState());
      }, (right) {
        emit(RemoveWaterErrorState());
        emit(DailyRecapAnsSuccessState(recapData: false));
        emit(RemoveWaterSuccessState(removeWater: true));
        showToast(isSuccess: false, message: right.message!);
      });
    } catch (e) {
      emit(RemoveWaterErrorState());

      showToast(isSuccess: false, message: e.toString());
    }
  }
}
