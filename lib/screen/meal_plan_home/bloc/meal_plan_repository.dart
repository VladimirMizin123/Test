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
import 'package:gymeats_mobile/repository/get_address.dart';
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
import 'package:gymeats_mobile/service/hive_singleton.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';

class MealPlanRepository {
  final ApiServices apiServices = ApiServices();

  String userID = PreferenceUtils.getString(prefUserData);

  Future<Either<ErrorModel, FetchMealPlanModel>> fetchMealPlan() async {
    String apiURL = '';
    apiURL = '${ApiUrls.genMealPlan}/$userID';
    print('genMealPlan apiURL : $apiURL');
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
    log("Api :${apiURL}");
    final response = await apiServices.get(apiURL);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetMealLogByDate.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, ErrorModel>> removeMealLog(String mealId) async {
    String apiURL = '${ApiUrls.removeMealLog}/$mealId?userId=$userId';
    final response = await apiServices.delete(apiURL);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(ErrorModel.fromJson(jsonDecode(response.body)));
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
      {required String recipeID, required int noOfServing}) async {
    final response = await apiServices.get(
        '${ApiUrls.getSwapMeal}/$userID?recipeId=$recipeID&noOfServing=$noOfServing');

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
    int? value,
    String? date,
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
      "value": value ?? 2,
      "userId": userID,
    };
    data.addIf(date != null, "date", date);
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
    log("add swap meal:${response.body}");
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
      {required String recipeID, required String recipeName}) async {
    log('localdbtask fetchMealDetails');
    log('recipeName --  $recipeName');
    final response = await apiServices
        .get('${ApiUrls.getRecipeDetailById}/$userID?recipeId=$recipeID');
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> recipeDetailsMap = jsonDecode(response.body);

      /*--------------Hive box Nx Data--------------------*/
      late HiveSingleton hiveSingleton;
      hiveSingleton = HiveSingleton();
      var resultKeys = await hiveSingleton.getAllKeys();
      var resultKey = resultKeys.firstWhere(
        (key) => key.toLowerCase() == recipeName.toLowerCase(),
        orElse: () => '',
      );
      if (resultKey.isNotEmpty) {
        log('rushankkkkkkk Key found: $resultKey');
        var specificValue = await hiveSingleton.getValueByKey(resultKey);
        log('rushankkkkkkk if Value associated with the key: $specificValue');

        recipeDetailsMap['data']['recipe']['nutritionalInfo']['calories'] =
            specificValue["nfCalories"] ?? 0;
        recipeDetailsMap['data']['recipe']['nutritionalInfo']['protein'] =
            specificValue["nfProtein"] ?? 0;
        recipeDetailsMap['data']['recipe']['nutritionalInfo']['carbs'] =
            specificValue["nfTotalCabohydrate"] ?? 0;
        recipeDetailsMap['data']['recipe']['nutritionalInfo']['fat'] =
            specificValue["nfTotalFat"] ?? 0;
        recipeDetailsMap['data']['recipe']['nutritionalInfo']
            ['nfSaturatedFat'] = specificValue["nfSaturatedFat"] ?? 0;
        recipeDetailsMap['data']['recipe']['nutritionalInfo']['nfCholesterol'] =
            specificValue["nfCholesterol"] ?? 0;
        recipeDetailsMap['data']['recipe']['nutritionalInfo']['nfSodium'] =
            specificValue["nfSodium"] ?? 0;
        recipeDetailsMap['data']['recipe']['nutritionalInfo']
            ['nfDietaryFiber'] = specificValue["nfDietaryFiber"] ?? 0;
        recipeDetailsMap['data']['recipe']['nutritionalInfo']['nfSugars'] =
            specificValue["nfSugar"] ?? 0;
        recipeDetailsMap['data']['recipe']['nutritionalInfo']['nfPotassium'] =
            specificValue["nfPotassium"] ?? 0;
        String updatedJsonData = json.encode(recipeDetailsMap);
        return Right(
            FetchMealDetailsModel.fromJson(jsonDecode(updatedJsonData)));
      } else {
        log('rushankkkkkkk else Key not found');
        var matchingKeys = await hiveSingleton.findKeysWithAnyWord(recipeName);
        if (matchingKeys != null) {
          var specificValue = await hiveSingleton.getValueByKey(matchingKeys);
          log('rushankkkkkkk if Data associated with matching key ($matchingKeys): $specificValue');
          recipeDetailsMap['data']['recipe']['nutritionalInfo']['calories'] =
              specificValue["nfCalories"] ?? 0;
          recipeDetailsMap['data']['recipe']['nutritionalInfo']['protein'] =
              specificValue["nfProtein"] ?? 0;
          recipeDetailsMap['data']['recipe']['nutritionalInfo']['carbs'] =
              specificValue["nfTotalCabohydrate"] ?? 0;
          recipeDetailsMap['data']['recipe']['nutritionalInfo']['fat'] =
              specificValue["nfTotalFat"] ?? 0;
          recipeDetailsMap['data']['recipe']['nutritionalInfo']
              ['nfSaturatedFat'] = specificValue["nfSaturatedFat"] ?? 0;
          recipeDetailsMap['data']['recipe']['nutritionalInfo']
              ['nfCholesterol'] = specificValue["nfCholesterol"] ?? 0;
          recipeDetailsMap['data']['recipe']['nutritionalInfo']['nfSodium'] =
              specificValue["nfSodium"] ?? 0;
          recipeDetailsMap['data']['recipe']['nutritionalInfo']
              ['nfDietaryFiber'] = specificValue["nfDietaryFiber"] ?? 0;
          recipeDetailsMap['data']['recipe']['nutritionalInfo']['nfSugars'] =
              specificValue["nfSugar"] ?? 0;
          recipeDetailsMap['data']['recipe']['nutritionalInfo']['nfPotassium'] =
              specificValue["nfPotassium"] ?? 0;
          String updatedJsonData = json.encode(recipeDetailsMap);
          return Right(
              FetchMealDetailsModel.fromJson(jsonDecode(updatedJsonData)));
        } else {
          log('rushankkkkkkk else No matching key found');
        }
      }
      /*--------------Hive box Nx Data--------------------*/

      String apiNxInfoURL =
          '${ApiUrls.getNxMealInfoByName}?foodName=${Uri.encodeComponent(recipeName)}';
      log(apiNxInfoURL, name: 'API URL :');
      final responseNxInfo = await apiServices.get(apiNxInfoURL);
      log(responseNxInfo.body, name: 'API RESPONSE :');
      Map<String, dynamic> jsonNxInfo = jsonDecode(responseNxInfo.body);
      log("Json Response :${jsonEncode(jsonNxInfo)}");
      if (jsonNxInfo["success"] == false) {
        String apiNutritionixURL =
            '${ApiUrls.getNxSearchData}?branded=true&common=false&query=$recipeName';
        final responseNutritionix =
            await apiServices.getNutritionix(apiNutritionixURL);
        Map<String, dynamic> jsonNutritionix =
            jsonDecode(responseNutritionix.body);
        log(responseNutritionix.body, name: 'API RESPONSE :');
        if (jsonNutritionix['branded'] != null) {
          String apiNutritionixItemInfoURL =
              '${ApiUrls.getNxItemInfoData}?nix_item_id=${jsonNutritionix['branded'][0]['nix_item_id']}';
          final responseNutritionixItemInfo =
              await apiServices.getNutritionix(apiNutritionixItemInfoURL);
          Map<String, dynamic> jsonNutritionixItemInfo =
              jsonDecode(responseNutritionixItemInfo.body);
          log(responseNutritionixItemInfo.body, name: 'API RESPONSE :');
          if (jsonNutritionixItemInfo['foods'] != null) {
            var photos = jsonNutritionixItemInfo['foods'][0]['photo'];
            Map<String, dynamic> photoJsonData = {
              "thumb": photos['thumb'] ?? "",
              "highres": photos['highres'] ?? "",
              "is_user_uploaded": photos['is_user_uploaded'] ?? false
            };
            Map<String, dynamic> nxAddData = {
              'foodName': recipeName,
              'brandName': jsonNutritionixItemInfo['foods'][0]['brand_name'],
              'servingQuantity': jsonNutritionixItemInfo['foods'][0]
                  ['serving_qty'],
              'servingUnit': jsonNutritionixItemInfo['foods'][0]
                  ['serving_unit'],
              'servingWeightGram': jsonNutritionixItemInfo['foods'][0]
                      ['serving_weight_grams']
                  .toString(),
              'nfMetricQuantity':
                  jsonNutritionixItemInfo['foods'][0]['nf_metric_qty'] == null
                      ? '0'
                      : jsonNutritionixItemInfo['foods'][0]['nf_metric_qty']
                          .toString(),
              'nfMetricUom': jsonNutritionixItemInfo['foods'][0]
                  ['nf_metric_uom'],
              'nfCalories': jsonNutritionixItemInfo['foods'][0]['nf_calories'],
              'nfTotalFat': jsonNutritionixItemInfo['foods'][0]['nf_total_fat'],
              'nfSaturatedFat': jsonNutritionixItemInfo['foods'][0]
                  ['nf_saturated_fat'],
              'nfCholesterol': jsonNutritionixItemInfo['foods'][0]
                  ['nf_cholesterol'],
              'nfSodium': jsonNutritionixItemInfo['foods'][0]['nf_sodium'],
              'nfTotalCabohydrate': jsonNutritionixItemInfo['foods'][0]
                  ['nf_total_carbohydrate'],
              'nfDietaryFiber': jsonNutritionixItemInfo['foods'][0]
                  ['nf_dietary_fiber'],
              'nfSugar': jsonNutritionixItemInfo['foods'][0]['nf_sugars'],
              'nfProtein': jsonNutritionixItemInfo['foods'][0]['nf_protein'],
              'nfPotassium': jsonNutritionixItemInfo['foods'][0]
                  ['nf_potassium'],
              'nf_P': jsonNutritionixItemInfo['foods'][0]['nf_p'],
              'nfFullNutrients': jsonNutritionixItemInfo['foods'][0]
                  ['full_nutrients'],
              'nxBrandName': jsonNutritionixItemInfo['foods'][0]
                  ['nix_brand_name'],
              'nxBrandId': jsonNutritionixItemInfo['foods'][0]['nix_brand_id'],
              'nxItemName': jsonNutritionixItemInfo['foods'][0]
                  ['nix_item_name'],
              'nxItemId': jsonNutritionixItemInfo['foods'][0]['nix_item_id'],
              'metadata': jsonNutritionixItemInfo['foods'][0]['metadata'],
              'source': jsonNutritionixItemInfo['foods'][0]['source'],
              'ndb_No': jsonNutritionixItemInfo['foods'][0]['ndb_no'],
              'tags': jsonNutritionixItemInfo['foods'][0]['tags'],
              'alt_Measure': jsonNutritionixItemInfo['foods'][0]
                  ['alt_measures'],
              'lat': jsonNutritionixItemInfo['foods'][0]['lat'],
              'lng': jsonNutritionixItemInfo['foods'][0]['lng'],
              'photo': photoJsonData,
              'note': jsonNutritionixItemInfo['foods'][0]['note'],
              'class_Code': jsonNutritionixItemInfo['foods'][0]['class_code'],
              'brick_Code': jsonNutritionixItemInfo['foods'][0]['brick_code'],
              'tag_Id': jsonNutritionixItemInfo['foods'][0]['tag_id'],
              'updated_At': jsonNutritionixItemInfo['foods'][0]['updated_at'],
              'nf_Ingredient_Statement': jsonNutritionixItemInfo['foods'][0]
                  ['nf_ingredient_statement'],
            };
            final responseAddNxData =
                await apiServices.post(ApiUrls.addNutritionDataToDb, nxAddData);
            log(responseAddNxData.body, name: 'API ADD RESPONSE :');

            await hiveSingleton.addValueToBox(recipeName, nxAddData);

            recipeDetailsMap['data']['recipe']['nutritionalInfo']['calories'] =
                jsonNutritionixItemInfo['foods'][0]['nf_calories'];
            recipeDetailsMap['data']['recipe']['nutritionalInfo']['protein'] =
                jsonNutritionixItemInfo['foods'][0]['nf_protein'];
            recipeDetailsMap['data']['recipe']['nutritionalInfo']['carbs'] =
                jsonNutritionixItemInfo['foods'][0]['nf_total_carbohydrate'];
            recipeDetailsMap['data']['recipe']['nutritionalInfo']['fat'] =
                jsonNutritionixItemInfo['foods'][0]['nf_total_fat'];
            recipeDetailsMap['data']['recipe']['nutritionalInfo']
                    ['nfSaturatedFat'] =
                jsonNutritionixItemInfo['foods'][0]['nf_saturated_fat'];
            recipeDetailsMap['data']['recipe']['nutritionalInfo']
                    ['nfCholesterol'] =
                jsonNutritionixItemInfo['foods'][0]['nf_cholesterol'];
            recipeDetailsMap['data']['recipe']['nutritionalInfo']['nfSodium'] =
                jsonNutritionixItemInfo['foods'][0]['nf_sodium'];
            recipeDetailsMap['data']['recipe']['nutritionalInfo']
                    ['nfDietaryFiber'] =
                jsonNutritionixItemInfo['foods'][0]['nf_dietary_fiber'];
            recipeDetailsMap['data']['recipe']['nutritionalInfo']['nfSugars'] =
                jsonNutritionixItemInfo['foods'][0]['nf_sugars'];
            recipeDetailsMap['data']['recipe']['nutritionalInfo']
                    ['nfPotassium'] =
                jsonNutritionixItemInfo['foods'][0]['nf_potassium'];
            String updatedJsonData = json.encode(recipeDetailsMap);
            return Right(
                FetchMealDetailsModel.fromJson(jsonDecode(updatedJsonData)));
          } else {
            return Right(
                FetchMealDetailsModel.fromJson(jsonDecode(response.body)));
          }
        } else {
          return Right(
              FetchMealDetailsModel.fromJson(jsonDecode(response.body)));
        }
      } else {
        recipeDetailsMap['data']['recipe']['nutritionalInfo']['calories'] =
            jsonNxInfo["data"]["nfCalories"] ?? 0;
        recipeDetailsMap['data']['recipe']['nutritionalInfo']['protein'] =
            jsonNxInfo["data"]["nfProtein"] ?? 0;
        recipeDetailsMap['data']['recipe']['nutritionalInfo']['carbs'] =
            jsonNxInfo["data"]["nfTotalCabohydrate"] ?? 0;
        recipeDetailsMap['data']['recipe']['nutritionalInfo']['fat'] =
            jsonNxInfo["data"]["nfTotalFat"] ?? 0;
        recipeDetailsMap['data']['recipe']['nutritionalInfo']
            ['nfSaturatedFat'] = jsonNxInfo["data"]["nfSaturatedFat"] ?? 0;
        recipeDetailsMap['data']['recipe']['nutritionalInfo']['nfCholesterol'] =
            jsonNxInfo["data"]["nfCholesterol"] ?? 0;
        recipeDetailsMap['data']['recipe']['nutritionalInfo']['nfSodium'] =
            jsonNxInfo["data"]["nfSodium"] ?? 0;
        recipeDetailsMap['data']['recipe']['nutritionalInfo']
            ['nfDietaryFiber'] = jsonNxInfo["data"]["nfDietaryFiber"] ?? 0;
        recipeDetailsMap['data']['recipe']['nutritionalInfo']['nfSugars'] =
            jsonNxInfo["data"]["nfSugar"] ?? 0;
        recipeDetailsMap['data']['recipe']['nutritionalInfo']['nfPotassium'] =
            jsonNxInfo["data"]["nfPotassium"] ?? 0;
        String updatedJsonData = json.encode(recipeDetailsMap);

        await hiveSingleton.addValueToBox(recipeName, jsonNxInfo["data"]);
        return Right(
            FetchMealDetailsModel.fromJson(jsonDecode(updatedJsonData)));
      }
      // return Right(FetchMealDetailsModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, NutritionixGetNxMealInfoByNameModel>>
      groceryDetailsMealInfo({
    required String productName,
  }) async {
    log('localdbtask 2');

    /*--------------Hive box Nx Data--------------------*/
    late HiveSingleton hiveSingleton;
    hiveSingleton = HiveSingleton();
    var resultKeys = await hiveSingleton.getAllKeys();
    var resultKey = resultKeys.firstWhere(
      (key) => key.toLowerCase() == productName.toLowerCase(),
      orElse: () => '',
    );
    if (resultKey.isNotEmpty) {
      log('rushankkkkkkk Key found: $resultKey');
      var specificValue = await hiveSingleton.getValueByKey(resultKey);
      log('rushankkkkkkk if Value associated with the key: $specificValue');
      Map<String, dynamic> finalOutput = {
        'success': true,
        'message': null,
        'errorMessage': null,
        'data': specificValue
      };
      return Right(NutritionixGetNxMealInfoByNameModel.fromJson(finalOutput));
    } else {
      log('rushankkkkkkk else Key not found');
      var matchingKeys = await hiveSingleton.findKeysWithAnyWord(productName);
      if (matchingKeys != null) {
        var specificValue = await hiveSingleton.getValueByKey(matchingKeys);
        log('rushankkkkkkk if Data associated with matching key ($matchingKeys): $specificValue');
        Map<String, dynamic> finalOutput = {
          'success': true,
          'message': null,
          'errorMessage': null,
          'data': specificValue
        };
        return Right(NutritionixGetNxMealInfoByNameModel.fromJson(finalOutput));
      } else {
        log('rushankkkkkkk else No matching key found');
      }
    }
    /*--------------Hive box Nx Data--------------------*/

    String apiURL =
        '${ApiUrls.getNxMealInfoByName}?foodName=${Uri.encodeComponent(productName)}';

    // log(apiURL, name: 'API URL :');
    final response = await apiServices.get(apiURL);
    // log(response.body, name: 'API RESPONSE :');

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> json = jsonDecode(response.body);
      await hiveSingleton.addValueToBox(productName, json["data"]);
      return Right(NutritionixGetNxMealInfoByNameModel.fromJson(
          jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      Map<String, dynamic> json = jsonDecode(response.body);
      if (json["success"] == false) {
        String apiNutritionixURL =
            '${ApiUrls.getNxSearchData}?branded=true&common=false&query=$productName';
        final responseNutritionix =
            await apiServices.getNutritionix(apiNutritionixURL);
        Map<String, dynamic> jsonNutritionix =
            jsonDecode(responseNutritionix.body);
        log(responseNutritionix.body, name: 'API RESPONSE :');
        if (jsonNutritionix['branded'] != null) {
          String apiNutritionixItemInfoURL =
              '${ApiUrls.getNxItemInfoData}?nix_item_id=${jsonNutritionix['branded'][0]['nix_item_id']}';
          final responseNutritionixItemInfo =
              await apiServices.getNutritionix(apiNutritionixItemInfoURL);
          Map<String, dynamic> jsonNutritionixItemInfo =
              jsonDecode(responseNutritionixItemInfo.body);
          log(responseNutritionixItemInfo.body, name: 'API RESPONSE :');

          if (jsonNutritionixItemInfo['foods'] != null) {
            Map<String, dynamic> finalOutput = {
              'success': true,
              'message': null,
              'errorMessage': null,
              'data': {
                'foodName': productName,
                'brandName': jsonNutritionixItemInfo['foods'][0]['brand_name'],
                'servingQuantity': jsonNutritionixItemInfo['foods'][0]
                    ['serving_qty'],
                'servingUnit': jsonNutritionixItemInfo['foods'][0]
                    ['serving_unit'],
                'servingWeightInGram': jsonNutritionixItemInfo['foods'][0]
                        ['serving_weight_grams']
                    .toString(),
                'nfMetricQuantity': jsonNutritionixItemInfo['foods'][0]
                    ['nf_metric_qty'],
                'nfMetricUom': jsonNutritionixItemInfo['foods'][0]
                    ['nf_metric_uom'],
                'nfCalories': jsonNutritionixItemInfo['foods'][0]
                    ['nf_calories'],
                'nfTotalFat': jsonNutritionixItemInfo['foods'][0]
                    ['nf_total_fat'],
                'nfSaturatedFat': jsonNutritionixItemInfo['foods'][0]
                    ['nf_saturated_fat'],
                'nfCholesterol': jsonNutritionixItemInfo['foods'][0]
                    ['nf_cholesterol'],
                'nfSodium': jsonNutritionixItemInfo['foods'][0]['nf_sodium'],
                'nfTotalCabohydrate': jsonNutritionixItemInfo['foods'][0]
                    ['nf_total_carbohydrate'],
                'nfDietaryFiber': jsonNutritionixItemInfo['foods'][0]
                    ['nf_dietary_fiber'],
                'nfSugar': jsonNutritionixItemInfo['foods'][0]['nf_sugars'],
                'nfProtein': jsonNutritionixItemInfo['foods'][0]['nf_protein'],
                'nfPotassium': jsonNutritionixItemInfo['foods'][0]
                    ['nf_potassium'],
                'nf_P': jsonNutritionixItemInfo['foods'][0]['nf_p'],
                'nfFullNutrients': jsonNutritionixItemInfo['foods'][0]
                    ['full_nutrients'],
                'nxBrandname': jsonNutritionixItemInfo['foods'][0]
                    ['nix_brand_name'],
                'nxBrandId': jsonNutritionixItemInfo['foods'][0]
                    ['nix_brand_id'],
                'nxItemName': jsonNutritionixItemInfo['foods'][0]
                    ['nix_item_name'],
                'nxItemId': jsonNutritionixItemInfo['foods'][0]['nix_item_id'],
                'metadata': jsonNutritionixItemInfo['foods'][0]['metadata'],
                'source': jsonNutritionixItemInfo['foods'][0]['source'],
                'ndb_No': jsonNutritionixItemInfo['foods'][0]['ndb_no'],
                'tags': jsonNutritionixItemInfo['foods'][0]['tags'],
                'alt_Measure': jsonNutritionixItemInfo['foods'][0]
                    ['alt_measures'],
                'lat': jsonNutritionixItemInfo['foods'][0]['lat'],
                'lng': jsonNutritionixItemInfo['foods'][0]['lng'],
                'photo': jsonNutritionixItemInfo['foods'][0]['photo'],
                'note': jsonNutritionixItemInfo['foods'][0]['note'],
                'class_Code': jsonNutritionixItemInfo['foods'][0]['class_code'],
                'brick_Code': jsonNutritionixItemInfo['foods'][0]['brick_code'],
                'tag_Id': jsonNutritionixItemInfo['foods'][0]['tag_id'],
                'updated_At': jsonNutritionixItemInfo['foods'][0]['updated_at'],
                'nf_Ingredient_Statement': jsonNutritionixItemInfo['foods'][0]
                    ['nf_ingredient_statement'],
              }
            };

            var photos = jsonNutritionixItemInfo['foods'][0]['photo'];
            Map<String, dynamic> photoJsonData = {
              "thumb": photos['thumb'] ?? "",
              "highres": photos['highres'] ?? "",
              "is_user_uploaded": photos['is_user_uploaded'] ?? false
            };
            Map<String, dynamic> nxAddData = {
              'foodName': productName,
              'brandName': jsonNutritionixItemInfo['foods'][0]['brand_name'],
              'servingQuantity': jsonNutritionixItemInfo['foods'][0]
                  ['serving_qty'],
              'servingUnit': jsonNutritionixItemInfo['foods'][0]
                  ['serving_unit'],
              'servingWeightGram': jsonNutritionixItemInfo['foods'][0]
                      ['serving_weight_grams']
                  .toString(),
              'nfMetricQuantity':
                  jsonNutritionixItemInfo['foods'][0]['nf_metric_qty'] == null
                      ? '0'
                      : jsonNutritionixItemInfo['foods'][0]['nf_metric_qty']
                          .toString(),
              'nfMetricUom': jsonNutritionixItemInfo['foods'][0]
                  ['nf_metric_uom'],
              'nfCalories': jsonNutritionixItemInfo['foods'][0]['nf_calories'],
              'nfTotalFat': jsonNutritionixItemInfo['foods'][0]['nf_total_fat'],
              'nfSaturatedFat': jsonNutritionixItemInfo['foods'][0]
                  ['nf_saturated_fat'],
              'nfCholesterol': jsonNutritionixItemInfo['foods'][0]
                  ['nf_cholesterol'],
              'nfSodium': jsonNutritionixItemInfo['foods'][0]['nf_sodium'],
              'nfTotalCabohydrate': jsonNutritionixItemInfo['foods'][0]
                  ['nf_total_carbohydrate'],
              'nfDietaryFiber': jsonNutritionixItemInfo['foods'][0]
                  ['nf_dietary_fiber'],
              'nfSugar': jsonNutritionixItemInfo['foods'][0]['nf_sugars'],
              'nfProtein': jsonNutritionixItemInfo['foods'][0]['nf_protein'],
              'nfPotassium': jsonNutritionixItemInfo['foods'][0]
                  ['nf_potassium'],
              'nf_P': jsonNutritionixItemInfo['foods'][0]['nf_p'],
              'nfFullNutrients': jsonNutritionixItemInfo['foods'][0]
                  ['full_nutrients'],
              'nxBrandName': jsonNutritionixItemInfo['foods'][0]
                  ['nix_brand_name'],
              'nxBrandId': jsonNutritionixItemInfo['foods'][0]['nix_brand_id'],
              'nxItemName': jsonNutritionixItemInfo['foods'][0]
                  ['nix_item_name'],
              'nxItemId': jsonNutritionixItemInfo['foods'][0]['nix_item_id'],
              'metadata': jsonNutritionixItemInfo['foods'][0]['metadata'],
              'source': jsonNutritionixItemInfo['foods'][0]['source'],
              'ndb_No': jsonNutritionixItemInfo['foods'][0]['ndb_no'],
              'tags': jsonNutritionixItemInfo['foods'][0]['tags'],
              'alt_Measure': jsonNutritionixItemInfo['foods'][0]
                  ['alt_measures'],
              'lat': jsonNutritionixItemInfo['foods'][0]['lat'],
              'lng': jsonNutritionixItemInfo['foods'][0]['lng'],
              'photo': photoJsonData,
              'note': jsonNutritionixItemInfo['foods'][0]['note'],
              'class_Code': jsonNutritionixItemInfo['foods'][0]['class_code'],
              'brick_Code': jsonNutritionixItemInfo['foods'][0]['brick_code'],
              'tag_Id': jsonNutritionixItemInfo['foods'][0]['tag_id'],
              'updated_At': jsonNutritionixItemInfo['foods'][0]['updated_at'],
              'nf_Ingredient_Statement': jsonNutritionixItemInfo['foods'][0]
                  ['nf_ingredient_statement'],
            };
            final responseAddNxData =
                await apiServices.post(ApiUrls.addNutritionDataToDb, nxAddData);
            log(responseAddNxData.body, name: 'API ADD RESPONSE :');
            await hiveSingleton.addValueToBox(productName, nxAddData);
            return Right(
                NutritionixGetNxMealInfoByNameModel.fromJson(finalOutput));
          } else {
            return Left(ErrorModel.fromJson(jsonDecode(response.body)));
          }
        } else {
          return Left(ErrorModel.fromJson(jsonDecode(response.body)));
        }
      } else {
        return Left(ErrorModel.fromJson(jsonDecode(response.body)));
      }

      // return Left(ErrorModel.fromJson(jsonDecode(response.body)));
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

  Future<Either<ErrorModel, GroceryMultiSearchModel>> grocerySearch(
      {required String latitude,
      required String longitude,
      required List<GrocerySearchModel> grocerySearchModal,
      required UserAddress? getUserAddress}) async {
    String apiURL = ApiUrls.productGroceryMultipleSearch;

    UserAddress? address = getUserAddress;

    if (address == null) {
      log("Address null waiting for api call........");
      await GetAddressRepository().getUserAddressData().fold((left) => null,
          (right) {
        right.data?.forEach((element) async {
          if (element.isPrimary == true) {
            address = element;
          }
        });
        if ((right.data?.isNotEmpty ?? false) &&
            !right.data!.any((element) => (element.isPrimary ?? false))) {
          address = right.data?.first;
        }
      });
    }

    log("User Address Grocery :$address");

    Map<String, dynamic> data = {
      "latitude": address?.latitude,
      "longitude": address?.longitude,
      "groceries": grocerySearchModal,
      "user_street_num": address?.streetNum,
      "user_street_name": address?.streetName,
      "user_city": address?.city,
      "user_state": address?.state,
      "user_country": address?.country,
      "user_zipcode": address?.zipcode,
      "pickup": false,
    };

    final response = await apiServices.post(
      apiURL,
      data,
    );
    // log(response.body, name: 'API RESPONSE :');

    if (response.statusCode == 200 || response.statusCode == 201) {
      GroceryMultiSearchModel searchModel =
          GroceryMultiSearchModel.fromJson(jsonDecode(response.body));
      for (int i = 0; i < (searchModel.data?.carts?.length ?? 0); i++) {
        if (searchModel.data?.carts?[i].store?.logoPhotos?.isNotEmpty ??
            false) {
          PreferenceUtils.setString(
              "${searchModel.data?.carts?[i].store?.id}_img",
              searchModel.data?.carts?[i].store?.logoPhotos?[0] ?? "");
        }
      }
      return Right(searchModel);
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
