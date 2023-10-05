abstract class GetUserJournalEvent {}

class GetUserJournalData extends GetUserJournalEvent {
  String date;
  GetUserJournalData({required this.date});
}

class GenMealData extends GetUserJournalEvent {}

class MealTrackerData extends GetUserJournalEvent {
  String date;
  MealTrackerData({required this.date});
}

class GetWaterDetails extends GetUserJournalEvent {
  String date;
  GetWaterDetails({required this.date});
}

class GetExerciseDetails extends GetUserJournalEvent {
  String date;
  GetExerciseDetails({required this.date});
}

class GetAllExerciseDetails extends GetUserJournalEvent {
  GetAllExerciseDetails();
}

class GetSelectedImagePath extends GetUserJournalEvent {
  final String? imagePath;
  GetSelectedImagePath({required this.imagePath});
}

class AddEatenMealData extends GetUserJournalEvent {
  String? mealId;
  String? userId;
  String? mealName;
  String? mealType;
  num? calorie;
  num? noOfServing;
  String? recipeId;
  num? protein;
  num? fat;
  num? carbs;
  num? value;
  String? title;

  AddEatenMealData({this.mealId, this.userId, this.mealName, this.mealType, this.calorie, this.noOfServing, this.recipeId, this.protein, this.fat, this.carbs, this.value, this.title});
}

class AddNewItemEvent extends GetUserJournalEvent {
  AddNewItemEvent();
}

class AddNewDietEvent extends GetUserJournalEvent {
  final String? dietName;
  final String? proteinPercentage;
  final String? carbsPercentage;
  final String? fatPercentage;
  final String? surplusPercentage;
  final String? deficitPercentage;
  final String? mealSchedule;
  final String? colorCode;
  final bool? isDefault;

  AddNewDietEvent({required this.dietName, required this.proteinPercentage, required this.carbsPercentage, required this.fatPercentage, required this.surplusPercentage, required this.deficitPercentage, required this.mealSchedule, required this.colorCode, required this.isDefault});
}

class DailyRecapEvent extends GetUserJournalEvent {
  DailyRecapEvent();
}

class DailyRecapAnsEvent extends GetUserJournalEvent {
  final String? queID;
  final bool? recapAns;

  DailyRecapAnsEvent({required this.queID, required this.recapAns});
}

class RemoveWaterEvent extends GetUserJournalEvent {
  final String? quantity;

  RemoveWaterEvent({this.quantity});
}

class JournalGetDashboardDataEvent extends GetUserJournalEvent {}
