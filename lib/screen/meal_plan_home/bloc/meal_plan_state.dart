import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
import 'package:gymeats_mobile/models/get_meallogby_date_model.dart';
import 'package:gymeats_mobile/models/recipes_add_to_grocery_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/nutritionix_get_nx_meal_info_by_name_modal.dart';
import 'package:gymeats_mobile/screen/journal/modal/barcode_scanner_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/add_user_restriction_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/fatch_meal_details_model.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/get_all_restriction_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/product_restaurant_search_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/swap_meal_model.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/user_restriction_modal.dart';

abstract class FetchMealPlanState {}

class InitialState extends FetchMealPlanState {}

// FETCH MEAL PLAN
class FetchMealPlanSuccessState extends FetchMealPlanState {
  final List<FetchMealPlanData> mealPlanList;

  FetchMealPlanSuccessState({required this.mealPlanList});
}

class FetchMealPlanLoadingState extends FetchMealPlanState {}

class FetchMealPlanErrorState extends FetchMealPlanState {
  bool hasGrocery;
  FetchMealPlanErrorState({this.hasGrocery = false});
}

class OnGetMealLogByDateLoadingState extends FetchMealPlanState {}

class OnGetMealLogByDateSuccessState extends FetchMealPlanState {
  final List<MealDataByDate>? modelData;
  bool hasGrocery;

  OnGetMealLogByDateSuccessState(
      {required this.modelData, this.hasGrocery = false});
}

// SKIP MEAL PLAN
class SkipMealPlanSuccessState extends FetchMealPlanState {
  final bool skipMealPlanData;
  final String mealID;

  SkipMealPlanSuccessState(
      {required this.skipMealPlanData, required this.mealID});
}

class SkipMealPlanLoadingState extends FetchMealPlanState {}

class SkipMealPlanErrorState extends FetchMealPlanState {}

class SwapMealPlanSuccessState extends FetchMealPlanState {
  final bool swapMealPlanData;
  final String mealID;

  SwapMealPlanSuccessState(
      {required this.swapMealPlanData, required this.mealID});
}

class SwapMealPlanLoadingState extends FetchMealPlanState {}

class SwapMealPlanErrorState extends FetchMealPlanState {}

class ClearGroceryListSuccessState extends FetchMealPlanState {}

class ClearGroceryListLoadingState extends FetchMealPlanState {}

class ClearGroceryListErrorState extends FetchMealPlanState {}

class AddToGrocerySuccessState extends FetchMealPlanState {
  final bool isAdded;

  AddToGrocerySuccessState({required this.isAdded});
}

class AddToGroceryLoadingState extends FetchMealPlanState {}

class AddToGroceryErrorState extends FetchMealPlanState {}

class FetchSwapMealSuccessState extends FetchMealPlanState {
  final List<SimilarMealData>? similarMealData;

  FetchSwapMealSuccessState({this.similarMealData});
}

class FetchSwapMealLoadingState extends FetchMealPlanState {}

class FetchSwapMealErrorState extends FetchMealPlanState {}

class MealDetailsSuccessState extends FetchMealPlanState {
  final FetchModelData? fetchModelData;

  MealDetailsSuccessState({this.fetchModelData});
}

class MealDetailsLoadingState extends FetchMealPlanState {}

class MealDetailsErrorState extends FetchMealPlanState {}

class RestaurantSearchSuccessState extends FetchMealPlanState {
  final RestaurantSearchData? restaurantSearchData;

  RestaurantSearchSuccessState({this.restaurantSearchData});
}

class RestaurantSearchLoadingState extends FetchMealPlanState {}

class RestaurantSearchErrorState extends FetchMealPlanState {}

class SwapMealDetailsState extends FetchMealPlanState {
  final SimilarMealData? similarMealData;
  final String? mealId;
  final int? day;
  final DateTime? dateTime;

  SwapMealDetailsState(
      {this.similarMealData, this.mealId, this.day, this.dateTime});
}

class GroceryAddToShoppingLoadingState extends FetchMealPlanState {
  final String? productId;
  final bool isAdd;
  final bool isRemove;

  GroceryAddToShoppingLoadingState({
    this.productId,
    this.isAdd = false,
    this.isRemove = false,
  });
}

class GroceryAddToShoppingSuccessState extends FetchMealPlanState {
  final RecipesAddToGroceryData? recipesAddToGroceryData;
  final bool? isAdded;
  final bool? isAdd;
  final bool? isRemove;

  GroceryAddToShoppingSuccessState(
      {required this.recipesAddToGroceryData,
      required this.isAdd,
      required this.isAdded,
      required this.isRemove});
}

class GroceryAddToShoppingErrorState extends FetchMealPlanState {}

class GrocerySearchLoadingState extends FetchMealPlanState {
  GrocerySearchLoadingState();
}

class GrocerySearchSuccessState extends FetchMealPlanState {
  final List<Cart>? groceryMultiSearchProductList;

  GrocerySearchSuccessState({required this.groceryMultiSearchProductList});
}

class GrocerySearchErrorState extends FetchMealPlanState {
  GrocerySearchErrorState();
}

class GetAllRestrictionLoadingState extends FetchMealPlanState {}

class GetAllRestrictionErrorState extends FetchMealPlanState {}

class GetAllRestrictionSuccessState extends FetchMealPlanState {
  final List<Edge>? edgesRestrictionList;

  GetAllRestrictionSuccessState({this.edgesRestrictionList});
}

class AddRestrictionLoadingState extends FetchMealPlanState {}

class AddRestrictionErrorState extends FetchMealPlanState {}

class AddRestrictionSuccessState extends FetchMealPlanState {
  final List<AddUserRestrictionDataModal> data;

  AddRestrictionSuccessState({required this.data});
}

class GetUserRestrictionLoadingState extends FetchMealPlanState {}

class GetUserRestrictionErrorState extends FetchMealPlanState {}

class GetUserRestrictionSuccessState extends FetchMealPlanState {
  final List<UserRestrictionData>? edgesRestrictionList;

  GetUserRestrictionSuccessState({this.edgesRestrictionList});
}

class BarcodeScannerLoadingState extends FetchMealPlanState {}

class BarcodeScannerSuccessState extends FetchMealPlanState {
  final BarcodeScannerData? barcodeScannerData;

  BarcodeScannerSuccessState({this.barcodeScannerData});
}

class BarcodeScannerErrorState extends FetchMealPlanState {}

class NutritionixGetNxMealInfoByNameLoadingState extends FetchMealPlanState {
  NutritionixGetNxMealInfoByNameLoadingState();
}

class NutritionixGetNxMealInfoByNameSuccessState extends FetchMealPlanState {
  final NutritionixGetNxMealInfoByNameModelData
      nutritionixGetNxMealInfoByNameModelData;

  NutritionixGetNxMealInfoByNameSuccessState(
      {required this.nutritionixGetNxMealInfoByNameModelData});
}

class NutritionixGetNxMealInfoByNameErrorState extends FetchMealPlanState {
  NutritionixGetNxMealInfoByNameErrorState();
}
