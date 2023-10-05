import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
import 'package:gymeats_mobile/models/get_dashboard_model.dart';
import 'package:gymeats_mobile/models/get_meallogby_date_model.dart';
import 'package:gymeats_mobile/models/recipes_add_to_grocery_modal.dart';
import 'package:gymeats_mobile/models/skip_meal_plan_model.dart';
import 'package:gymeats_mobile/models/success_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_search_modal.dart';
import 'package:gymeats_mobile/screen/journal/modal/barcode_scanner_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/swap_meal_model.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';

class JournalPlanRepository {
  final ApiServices apiServices = ApiServices();

  String userID = PreferenceUtils.getString(prefUserData);

  Future<Either<ErrorModel, FetchMealPlanModel>> fetchMealPlan() async {
    int mealPlanScreenCountState = PreferenceUtils.getInt(userMealPlanCountState);
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

  Future<Either<ErrorModel, BarcodeScannerModal>> fetchBarcode(String barcodeID) async {
    final response = await apiServices.get('${ApiUrls.byBarcodeScan}/$barcodeID');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(BarcodeScannerModal.fromJson(jsonDecode(response.body)));
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

  Future<Either<ErrorModel, GroceryMultiSearchModel>> grocerySearch({
    required String latitude,
    required String longitude,
    required List<GrocerySearchModel> grocerySearchModal,
  }) async {
    String apiURL = ApiUrls.productGroceryMultipleSearch;

    // log(apiURL, name: 'API URL :');
    final response = await apiServices.post(
      apiURL,
      {
        "latitude": latitude,
        "longitude": longitude,
        "groceries": grocerySearchModal,
      },
    );
    // log(response.body, name: 'API RESPONSE :');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GroceryMultiSearchModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  // Future<Either<ErrorModel, SuccessModel>> addEaten({
  //   required String mealID,
  // }) async {
  //   String apiURL = ApiUrls.addEatenMeal;

  //   // log(apiURL, name: 'API URL :');
  //   final response = await apiServices.post(
  //     apiURL,
  //     {
  //     "mealId": mealID,"userId":userID
  //     },
  //   );
  //   // log(response.body, name: 'API RESPONSE :');

  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     return Right(SuccessModel.fromJson(jsonDecode(response.body)));
  //   } else {
  //     return Left(ErrorModel.fromJson(jsonDecode(response.body)));
  //   }
  // }
  Future<Either<ErrorModel, SuccessModel>> addEatenMeal({
    required String mealId,
    String? mealName,
    num? calorie,
    String? mealType,
    num? noOfServing,
    String? recipeId,
    num? protein,
    num? fat,
    num? carbs,
  }) async {
    Map<String, dynamic> data = {
      "mealName": mealName ?? '',
      "suggesticMealId": mealId,
      "calorie": calorie ?? 0,
      "mealType": mealType ?? '',
      "noOfServing": noOfServing ?? 0,
      "recipeId": recipeId,
      "protein": protein ?? 0,
      "fat": fat ?? 0,
      "carbs": carbs ?? 0,
      "value": 2,
      "userId": userID,
    };
    final response = await apiServices.post(ApiUrls.addMealLog, data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  // Future<Either<ErrorModel, FetchMealDetailsModel>> fetchMealDetails({required String recipeID}) async {
  //   final response = await apiServices.get('${ApiUrls.getRecipeDetailById}/$userID?recipeId=$recipeID');
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     return Right(FetchMealDetailsModel.fromJson(jsonDecode(response.body)));
  //   } else {
  //     return Left(ErrorModel.fromJson(jsonDecode(response.body)));
  //   }
  // }

  // Future<Either<ErrorModel, RestaurantSearchModel>> restaurantSearch({
  //   required String name,
  //   required String latitude,
  //   required String longitude,
  //   required String maximumMiles,
  //   required bool pickup,
  // }) async {
  //   final response = await apiServices.post('${ApiUrls.productRestaurantSearch}?name=$name&latitude=$latitude&longitude=$longitude', {}
  //       // {
  //       //   "name": name,
  //       //   "latitude": latitude,
  //       //   "longitude": longitude,
  //       //   "maximum_miles": maximumMiles,
  //       //   "pickup": pickup,
  //       // },
  //       );

  //   log('RES : ${ApiUrls.productRestaurantSearch}');
  //   log('RES : ${response.body}');
  //   log('RES : ${response.statusCode}');
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     return Right(RestaurantSearchModel.fromJson(jsonDecode(response.body)));
  //   } else {
  //     return Left(ErrorModel.fromJson(jsonDecode(response.body)));
  //   }
  // }

  Future<Either<ErrorModel, RecipesAddToGroceryModel>> recipeAddToShoppingList({
    required String productID,
    required String productName,
    required String quantity,
    required String price,
    required String unitSize,
    required String unitOfMeasurement,
    required String recipeId,
    required String mealmeStoreId,
    required bool isChecked,
  }) async {
    String apiURL = ApiUrls.addItemShoppingList;

    // log(apiURL, name: 'API URL :');

    final response = await apiServices.post(apiURL, {
      "userId": userID,
      "productId": productID,
      "productName": productName,
      "quantity": quantity,
      "price": price,
      "unitSize": unitSize,
      "unitOfMeasurement": unitOfMeasurement,
      "recipeId": recipeId,
      "mealmeStoreId": mealmeStoreId,
      "isChecked": isChecked,
    });
    // log(response.body, name: 'API RESPONSE :');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(RecipesAddToGroceryModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  
}
