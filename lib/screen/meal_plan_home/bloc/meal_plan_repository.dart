import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
import 'package:gymeats_mobile/models/get_grocery_item_list_model.dart';
import 'package:gymeats_mobile/models/get_meallogby_date_model.dart';
import 'package:gymeats_mobile/models/recipes_add_to_grocery_modal.dart';
import 'package:gymeats_mobile/models/success_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/add_grocery_to_shopping_list_from_suggestic_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/nutritionix_get_nx_meal_info_by_name_modal.dart';
import 'package:gymeats_mobile/screen/journal/modal/barcode_scanner_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/add_items_shopping_list_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/add_user_restriction_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/fatch_meal_details_model.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/get_all_restriction_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/product_restaurant_search_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/swap_meal_model.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/user_restriction_modal.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';

class MealPlanRepository {
  final ApiServices apiServices = ApiServices();

  String userID = PreferenceUtils.getString(prefUserData);

  Future<Either<ErrorModel, FetchMealPlanModel>> fetchMealPlan() async {
    int mealPlanScreenCountState =
        PreferenceUtils.getInt(userMealPlanCountState);
    String apiURL = '';
    if (mealPlanScreenCountState == 0) {
      apiURL = '${ApiUrls.genMealPlan}/$userID';
      print('genMealPlan apiURL : $apiURL');
    } else {
      apiURL = '${ApiUrls.getMealPlan}/$userID';
      print('getMealPlan apiURL : $apiURL');
    }
    final response = await apiServices.get(apiURL);
    // print('Meal response.body : ${response.body}');
    // print('Meal response.statusCode : ${response.statusCode}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      // print('Meal response.body123 : ${response.body}');
      await PreferenceUtils.setInt(userMealPlanCountState, 1);
      return Right(FetchMealPlanModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 401) {
      PreferenceUtils.clearPrefs();
      Get.offAllNamed('/LoginScreen');

      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, GetMealLogByDate>> getMealLogByDate(
      String date) async {
    String apiURL = '${ApiUrls.getMealLogByDate}/$userId?date=$date';
    final response = await apiServices.get(apiURL);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetMealLogByDate.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, GetAllRestrictionModal>> getAllRestriction() async {
    final response = await apiServices.get(ApiUrls.getAllRestrictionList);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // int count = getListCount(jsonDecode(response.body['data']));
      // debugPrint("count --> $count");
      return Right(GetAllRestrictionModal.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, GetUserRestrictionModal>>
      getUserRestriction() async {
    final response =
        await apiServices.get('${ApiUrls.getUserRestrictionList}/$userID');
    if (response.statusCode == 200 || response.statusCode == 201) {
      // int count = getListCount(jsonDecode(response.body['data']));
      // debugPrint("count --> $count");
      return Right(GetUserRestrictionModal.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, AddUserRestrictionModal>> addUserRestriction(
      {List<String> restrictionList = const []}) async {
    final response = await apiServices.post(
        '${ApiUrls.addRestrictionAndGetMealPlan}/$userID', restrictionList);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // int count = getListCount(jsonDecode(response.body['data']));
      // debugPrint("count --> $count");
      return Right(AddUserRestrictionModal.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  // Future<Either<ErrorModel, SkipMealPlanModel>> skipMealPlan({required String mealID}) async {
  //   final response = await apiServices.get('${ApiUrls.skipMeal}/$userID?mealId=$mealID');
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     return Right(SkipMealPlanModel.fromJson(jsonDecode(response.body)));
  //   } else {
  //     return Left(ErrorModel.fromJson(jsonDecode(response.body)));
  //   }
  // }

  Future<Either<ErrorModel, SuccessModel>> recipeAddToGrocery(
      {required List<AddItemsToShoppingListModal>
          addItemsToShoppingList}) async {
    final response = await apiServices.post(
      ApiUrls.addItemsToShoppingList,
      {"userId": userID, "itemList": addItemsToShoppingList},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, SwapMealModel>> fetchSwapMealItem(
      {required String recipeID, required int serving}) async {
    final response = await apiServices.get(
        '${ApiUrls.getSwapMeal}/$userID?recipeId=$recipeID&serving=$serving');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SwapMealModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

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

  Future<Either<ErrorModel, SuccessModel>> addSwapMeal({
    String? recipeId,
    String? mealId,
  }) async {
    final response = await apiServices.get(
        '${ApiUrls.addSwapMeal}/$userID?recipeId=$recipeId&mealId=$mealId');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, SuccessModel>> clearUserGroceryList({
    String? recipeId,
    String? mealId,
  }) async {
    final response =
        await apiServices.delete('${ApiUrls.clearUserGroceryList}/$userID');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, FetchMealDetailsModel>> fetchMealDetails(
      {required String recipeID}) async {
    final response = await apiServices
        .get('${ApiUrls.getRecipeDetailById}/$userID?recipeId=$recipeID');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(FetchMealDetailsModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, NutritionixGetNxMealInfoByNameModel>>
      groceryDetailsMealInfo({
    required String productName,
  }) async {
    String apiURL = '${ApiUrls.getNxMealInfoByName}?name=$productName';

    // log(apiURL, name: 'API URL :');
    final response = await apiServices.get(apiURL);
    // log(response.body, name: 'API RESPONSE :');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(NutritionixGetNxMealInfoByNameModel.fromJson(
          jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, RestaurantSearchModel>> restaurantSearch({
    required String name,
    required String latitude,
    required String longitude,
    required String maximumMiles,
    required bool pickup,
  }) async {
    final response = await apiServices.post(
        '${ApiUrls.productRestaurantSearch}?name=$name&latitude=$latitude&longitude=$longitude',
        {}
        // {
        //   "name": name,
        //   "latitude": latitude,
        //   "longitude": longitude,
        //   "maximum_miles": maximumMiles,
        //   "pickup": pickup,
        // },
        );

    log('RES : ${ApiUrls.productRestaurantSearch}');
    log('RES : ${response.body}');
    log('RES : ${response.statusCode}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(RestaurantSearchModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

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
      return Right(
          RecipesAddToGroceryModel.fromJson(jsonDecode(response.body)));
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

  Future<Either<ErrorModel, BarcodeScannerModal>> fetchBarcode(
      String barcodeID) async {
    final response =
        await apiServices.get('${ApiUrls.byBarcodeScan}/$barcodeID');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(BarcodeScannerModal.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, SuccessModel>> clearGroceryList() async {
    final response =
        await apiServices.delete('${ApiUrls.clearUserGroceryList}/$userID');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, GetUserGroceryListModel>>
      addGroceryToShoppingListFromSuggestic() async {
    String apiURL = '${ApiUrls.addGroceryToShoppingListFromSuggestic}/$userID';
    // log(apiURL, name: 'API URL :');
    final response = await apiServices.get(apiURL);
    // log(response.body, name: 'API RESPONSE :');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetUserGroceryListModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
