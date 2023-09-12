import 'package:gymeats_mobile/screen/grocery/modal/grocery_search_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/swap_meal_model.dart';

abstract class JournalPlanEvent {}

class JournalPlanFetchEvent extends JournalPlanEvent {
  JournalPlanFetchEvent();
}

class JournalSkipMealPlanEvent extends JournalPlanEvent {
  final String mealID;
  JournalSkipMealPlanEvent({required this.mealID});
}

class JournalAddToGroceryListEvent extends JournalPlanEvent {
  final String databaseIdOfRecipes;
  JournalAddToGroceryListEvent({required this.databaseIdOfRecipes});
}

class JournalFetchSwapMealItemEvent extends JournalPlanEvent {
  final String? recipeID;
  final int? serving;

  JournalFetchSwapMealItemEvent({this.recipeID, this.serving});
}

class JournalFetchMealDetailsEvent extends JournalPlanEvent {
  final String? recipeID;

  JournalFetchMealDetailsEvent({this.recipeID});
}

class JournalSwapMealDetailsEvent extends JournalPlanEvent {
  final SimilarMealData? similarMealData;
  final int? day;
  final String? mealId;

  JournalSwapMealDetailsEvent({this.similarMealData, this.day, this.mealId});
}

class JournalRestaurantSearchEvent extends JournalPlanEvent {
  final String? name;
  final String? latitude;
  final String? longitude;
  final String? maximumMiles;
  final bool? pickup;

  JournalRestaurantSearchEvent({this.name, this.latitude, this.longitude, this.maximumMiles, this.pickup});
}

class JournalAddExerciseEvent extends JournalPlanEvent {
  final DateTime dateTime;

  JournalAddExerciseEvent({required this.dateTime});
}



class JournalScanBarcodeEvent extends JournalPlanEvent {
  final String barcode;

  JournalScanBarcodeEvent({required this.barcode});
}

class JournalSearchEvent extends JournalPlanEvent {
  final List<GrocerySearchModel>? journalSearchModelList;

  JournalSearchEvent({required this.journalSearchModelList});
}
