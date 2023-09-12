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

class GetSelectedImagePath extends GetUserJournalEvent {
  final String? imagePath;
  GetSelectedImagePath({required this.imagePath});
}

class AddEatenMealData extends GetUserJournalEvent {
  String mealId;
  AddEatenMealData({required this.mealId});
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
