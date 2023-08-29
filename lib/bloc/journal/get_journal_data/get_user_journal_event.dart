
abstract class GetUserJournalEvent{}

class GetUserJournalData extends GetUserJournalEvent{
  String date;
  GetUserJournalData({required this.date});
}

class GenMealData extends GetUserJournalEvent{}

class MealTrackerData extends GetUserJournalEvent{
  String date;
  MealTrackerData({required this.date});
}

class GetWaterDetails extends GetUserJournalEvent{
  String date;
  GetWaterDetails({required this.date});
}


class GetExerciseDetails extends GetUserJournalEvent{
  String date;
  GetExerciseDetails({required this.date});
}

class AddEatenMealData extends GetUserJournalEvent{
  String mealId;
  AddEatenMealData({required this.mealId});
}

