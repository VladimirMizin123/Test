import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
import 'package:gymeats_mobile/models/skip_meal_plan_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/fatch_meal_details_model.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/product_restaurant_search_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/swap_meal_model.dart';

abstract class JournalMealPlanState {}

class InitialState extends JournalMealPlanState {}

// FETCH MEAL PLAN
class JournalFetchMealPlanSuccessState extends JournalMealPlanState {
  final List<FetchMealPlanData> mealPlanList;

  JournalFetchMealPlanSuccessState({required this.mealPlanList});
}

class JournalFetchMealPlanLoadingState extends JournalMealPlanState {}

class JournalFetchMealPlanErrorState extends JournalMealPlanState {}

// SKIP MEAL PLAN
class JournalSkipMealPlanSuccessState extends JournalMealPlanState {
  final SkipMealPlanData skipMealPlanData;
  final String mealID;

  JournalSkipMealPlanSuccessState({required this.skipMealPlanData, required this.mealID});
}

class JournalSkipMealPlanLoadingState extends JournalMealPlanState {}

class JournalSkipMealPlanErrorState extends JournalMealPlanState {}

class JournalAddToGrocerySuccessState extends JournalMealPlanState {
  final bool isAdded;

  JournalAddToGrocerySuccessState({required this.isAdded});
}

class JournalAddToGroceryLoadingState extends JournalMealPlanState {}

class JournalAddToGroceryErrorState extends JournalMealPlanState {}

class JournalFetchSwapMealSuccessState extends JournalMealPlanState {
  final List<SimilarMealData>? similarMealData;

  JournalFetchSwapMealSuccessState({this.similarMealData});
}

class JournalFetchSwapMealLoadingState extends JournalMealPlanState {}

class JournalFetchSwapMealErrorState extends JournalMealPlanState {}

class JournalMealDetailsSuccessState extends JournalMealPlanState {
  final FetchModelData? fetchModelData;

  JournalMealDetailsSuccessState({this.fetchModelData});
}

class JournalMealDetailsLoadingState extends JournalMealPlanState {}

class JournalMealDetailsErrorState extends JournalMealPlanState {}

class JournalRestaurantSearchSuccessState extends JournalMealPlanState {
  final RestaurantSearchData? restaurantSearchData;

  JournalRestaurantSearchSuccessState({this.restaurantSearchData});
}

class JournalRestaurantSearchLoadingState extends JournalMealPlanState {}

class JournalRestaurantSearchErrorState extends JournalMealPlanState {}

class JournalSwapMealDetailsState extends JournalMealPlanState {
  final SimilarMealData? similarMealData;
  final String? mealId;
  final int? day;

  JournalSwapMealDetailsState({this.similarMealData, this.mealId, this.day});
}

class JournalBarcodeScannerState extends JournalMealPlanState {
  final String? barcode;

  JournalBarcodeScannerState({required this.barcode});
}


class JournalSearchLoadingState extends JournalMealPlanState {
  JournalSearchLoadingState();
}

class JournalSearchSuccessState extends JournalMealPlanState {
  final List<Cart>? groceryMultiSearchProductList;

  JournalSearchSuccessState({required this.groceryMultiSearchProductList});
}

class JournalSearchErrorState extends JournalMealPlanState {
  JournalSearchErrorState();
}
