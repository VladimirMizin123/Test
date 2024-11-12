import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
import 'package:gymeats_mobile/models/get_meallogby_date_model.dart';
import 'package:gymeats_mobile/models/recipes_add_to_grocery_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/journal/modal/barcode_scanner_modal.dart';
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

class JournalFetchMealPlanLoadingState extends JournalMealPlanState {
  final bool value;
  JournalFetchMealPlanLoadingState({required this.value});
}

class JournalFetchMealPlanErrorState extends JournalMealPlanState {}

// SKIP MEAL PLAN
class JournalSkipMealPlanSuccessState extends JournalMealPlanState {
  final String mealID;

  JournalSkipMealPlanSuccessState({required this.mealID});
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

class JournalBarcodeScannerLoadingState extends JournalMealPlanState {}

class JournalBarcodeScannerSuccessState extends JournalMealPlanState {
  final BarcodeScannerData? barcodeScannerData;

  JournalBarcodeScannerSuccessState({this.barcodeScannerData});
}

class UserInvoiceSuccessState extends JournalMealPlanState {
  final List<String> invoiceList;

  UserInvoiceSuccessState({required this.invoiceList});
}

class UserInvoiceLoadingState extends JournalMealPlanState {
  final bool isLoading;

  UserInvoiceLoadingState({required this.isLoading});
}

class JournalBarcodeScannerErrorState extends JournalMealPlanState {}

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

class JournalAddToShoppingLoadingState extends JournalMealPlanState {
  final String? productId;
  final bool isAdd;
  final bool isRemove;

  JournalAddToShoppingLoadingState({
    this.productId,
    this.isAdd = false,
    this.isRemove = false,
  });
}

class JournalAddToShoppingSuccessState extends JournalMealPlanState {
  final RecipesAddToGroceryData? recipesAddToGroceryData;
  final bool? isAdded;
  final bool? isAdd;
  final bool? isRemove;

  JournalAddToShoppingSuccessState(
      {required this.recipesAddToGroceryData,
      required this.isAdd,
      required this.isAdded,
      required this.isRemove});
}

class JournalAddToShoppingErrorState extends JournalMealPlanState {}

class JournalAddEatenLoadingState extends JournalMealPlanState {
  final String mealID;

  JournalAddEatenLoadingState({required this.mealID});
}

class JournalAddEatenSuccessState extends JournalMealPlanState {
  final bool? isAdded;
  final String mealID;

  JournalAddEatenSuccessState({required this.isAdded, required this.mealID});
}

class JournalAddEatenErrorState extends JournalMealPlanState {
  JournalAddEatenErrorState();
}

class OnGetMealLogByDateLoadingState extends JournalMealPlanState {}

class OnGetMealLogByDateErrorState extends JournalMealPlanState {}

class OnGetMealLogByDateSuccessState extends JournalMealPlanState {
  final List<MealDataByDate>? modelData;

  OnGetMealLogByDateSuccessState({required this.modelData});
}
