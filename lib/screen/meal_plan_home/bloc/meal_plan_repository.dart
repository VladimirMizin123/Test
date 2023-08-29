import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
import 'package:gymeats_mobile/models/recipes_add_to_grocery_modal.dart';
import 'package:gymeats_mobile/models/skip_meal_plan_model.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/fatch_meal_details_model.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/product_restaurant_search_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/swap_meal_model.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';

class MealPlanRepository {
  final ApiServices apiServices = ApiServices();

  int mealPlanScreenCountState = PreferenceUtils.getInt(userMealPlanCountState);
  String userID = PreferenceUtils.getString(prefsUserID);

  Future<Either<ErrorModel, FetchMealPlanModel>> fetchMealPlan() async {
    String apiURL = '';
    if (mealPlanScreenCountState == 0) {
      apiURL = '${ApiUrls.genMealPlan}/$userID';
    } else {
      apiURL = '${ApiUrls.getMealPlan}/$userID';
    }
    final response = await apiServices.get(apiURL);
    if (response.statusCode == 200 || response.statusCode == 201) {
      await PreferenceUtils.setInt(userMealPlanCountState, 1);
      return Right(FetchMealPlanModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, SkipMealPlanModel>> skipMealPlan({required String mealID}) async {
    final response = await apiServices.get('${ApiUrls.skipMeal}/$userID?mealId=$mealID');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SkipMealPlanModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, RecipesAddToGroceryModel>> recipeAddToGrocery({required String databaseIdOfRecipes}) async {
    final response = await apiServices.post('${ApiUrls.addToShoppingList}/$userID', {
      "databaseIdOfRecipes": [databaseIdOfRecipes]
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(RecipesAddToGroceryModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, SwapMealModel>> fetchSwapMealItem({required String recipeID, required int serving}) async {
    final response = await apiServices.get('${ApiUrls.getSwapMeal}/$userID?recipeId=$recipeID&serving=$serving');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SwapMealModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, FetchMealDetailsModel>> fetchMealDetails({required String recipeID}) async {
    final response = await apiServices.get('${ApiUrls.getRecipeDetailById}/$userID?recipeId=$recipeID');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(FetchMealDetailsModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, ProductRestaurantSearchScreen>> restaurantSearch({
    required String name,
    required String latitude,
    required String longitude,
    required String maximumMiles,
    required bool pickup,
  }) async {
    final response = await apiServices.post('${ApiUrls.productRestaurantSearch}?name=$name', {}
        // {
        //   "name": name,
        //   "latitude": latitude,
        //   "longitude": longitude,
        //   "maximum_miles": maximumMiles,
        //   "pickup": pickup,
        // },
        );

    print('RES : ${ApiUrls.productRestaurantSearch}');
    print('RES : ${response.body}');
    print('RES : ${response.statusCode}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(ProductRestaurantSearchScreen.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
