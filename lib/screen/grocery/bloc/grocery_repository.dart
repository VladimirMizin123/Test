import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/models/recipes_add_to_grocery_modal.dart';
import 'package:gymeats_mobile/models/success_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/create_checkout_request_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/create_order_request_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/create_order_response_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/create_product_request_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/create_product_response_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_shopping_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/nutritionix_get_nx_meal_info_by_name_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/remove_grocery_modal.dart';
import 'package:gymeats_mobile/screen/journal/modal/barcode_scanner_modal.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';
import 'package:gymeats_mobile/service/hive_singleton.dart';

import '../../restaurants/model/get_user_address_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart'
    as userAddress;

class GroceryRepository {
  final ApiServices apiServices = ApiServices();

  String userID = PreferenceUtils.getString(prefUserData);

  // String userID = '2b85411b-3c0c-424b-98e0-6534a5216726';

  Future<Either<ErrorModel, GetGroceryShoppingListModel>>
      fetchGroceryShoppingList() async {
    // String apiURL = '${ApiUrls.getAllItemFromShoppingList}?userId=$userID';
    String apiURL = '${ApiUrls.getShoppingList}/$userID';
    // log(apiURL, name: 'API URL :');
    final response = await apiServices.get(apiURL);
    // log(response.body, name: 'API RESPONSE :');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(
          GetGroceryShoppingListModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, RecipesAddToGroceryModel>> recipeAddToGrocery({
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
      return Right(
          RecipesAddToGroceryModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, DeleteGroceryShoppingItemModel>> removeGrocery({
    required String productID,
  }) async {
    String apiURL =
        '${ApiUrls.removeProduct}?userId=$userID&productId=$productID';

    // log(apiURL, name: 'API URL :');
    final response = await apiServices.delete(apiURL);
    // log(response.body, name: 'API RESPONSE :');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(
          DeleteGroceryShoppingItemModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, GroceryMultiSearchModel>> grocerySearch(
      {required String latitude,
      required String longitude,
      required List<GrocerySearchModel> grocerySearchModal,
      required userAddress.UserAddress? getUserAddress}) async {
    String apiURL = ApiUrls.productGroceryMultipleSearch;

    String? tempGroceryName;
    int? quantity;
    for (var element in grocerySearchModal) {
      tempGroceryName = element.groceryName ?? "";
      quantity = element.quantity;
    }

    print("getUserAddress :${getUserAddress?.toJson()}");
    Map<String, dynamic> data = {
      "latitude": getUserAddress?.latitude?.toStringAsFixed(6),
      "longitude": getUserAddress?.longitude?.toStringAsFixed(6),
      "user_street_num": getUserAddress?.streetNum,
      "user_street_name": getUserAddress?.streetName,
      "user_city": getUserAddress?.city,
      "user_state": getUserAddress?.state,
      "user_country": getUserAddress?.country,
      "user_zipcode": getUserAddress?.zipcode,
      "pickup": false,
      "groceries": [
        {
          "groceryName": tempGroceryName,
          "quantity": quantity,
        }
      ]
    };

    final response = await apiServices.post(
      apiURL,
      data,
    );
    print("data:$data");
    log(apiURL);
    log("res:${response.body}");
    log("code:${response.statusCode}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GroceryMultiSearchModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, NutritionixGetNxMealInfoByNameModel>>
      groceryDetailsMealInfo({
    required String productName,
  }) async {
    /*--------------Hive box Nx Data--------------------*/
    late HiveSingleton hiveSingleton;
    hiveSingleton = HiveSingleton();
    var resultKeys = await hiveSingleton.getAllKeys();
    var resultKey = resultKeys.firstWhere(
      (key) => key.toLowerCase() == productName.toLowerCase(),
      orElse: () => '',
    );
    if (resultKey.isNotEmpty) {
      log('localdbtask Key found: $resultKey');
      var specificValue = await hiveSingleton.getValueByKey(resultKey);
      log('localdbtask if Value associated with the key: $specificValue');
      Map<String, dynamic> finalOutput = {
        'success': true,
        'message': null,
        'errorMessage': null,
        'data': specificValue
      };
      return Right(NutritionixGetNxMealInfoByNameModel.fromJson(finalOutput));
    } else {
      log('localdbtask else Key not found');
      var matchingKeys = await hiveSingleton.findKeysWithAnyWord(productName);
      if (matchingKeys != null) {
        var specificValue = await hiveSingleton.getValueByKey(matchingKeys);
        log('localdbtask if Data associated with matching key ($matchingKeys): $specificValue');
        Map<String, dynamic> finalOutput = {
          'success': true,
          'message': null,
          'errorMessage': null,
          'data': specificValue
        };
        return Right(NutritionixGetNxMealInfoByNameModel.fromJson(finalOutput));
      } else {
        log('localdbtask else No matching key found');
      }
    }
    /*--------------Hive box Nx Data--------------------*/

    String apiURL = '${ApiUrls.getNxMealInfoByName}?name=$productName';

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
          // log(responseNutritionixItemInfo.body, name: 'API RESPONSE :');

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

  Future<Either<ErrorModel, RecipesAddToGroceryModel>> addToShoppingList(
      {required String databaseIdOfRecipes}) async {
    final response =
        await apiServices.post('${ApiUrls.addToShoppingList}/$userID', {
      "databaseIdOfRecipes": [databaseIdOfRecipes]
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(
          RecipesAddToGroceryModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, RecipesAddToGroceryModel>>
      clearShoppingList() async {
    final response =
        await apiServices.delete('${ApiUrls.clearShoppingList}/$userID');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(
          RecipesAddToGroceryModel.fromJson(jsonDecode(response.body)));
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

  Future<Either<ErrorModel, SuccessModel>> addNewCustomMeal(
      {String? name,
      String? protein,
      String? fat,
      String? carbs,
      String? calorie,
      String? type}) async {
    final response = await apiServices.postMultipart(
      url: ApiUrls.addNewCustomMeal,
      body: {
        'Name': name ?? '',
        'Protein': protein ?? '',
        'Fat': fat ?? '',
        'Carbs': carbs ?? '',
        'Calorie': calorie ?? '',
        'Type': type ?? '',
        'userId': userID ?? '',
      },
      files: [],
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// GetUserGroceryList ====================================================================

  Future<Either<ErrorModel, GetUserAddressModel>> getUserAddressData() async {
    final response = await apiServices.get(
      '${ApiUrls.getUserAddress}/$userID',
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetUserAddressModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(GetUserAddressModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Create Order ====================================================================

  Future<Either<ErrorModel, CreateOrderResponseModel>> createOrder(
      {required CreateGroceryOrderModel createOrderModel}) async {
    final response = await apiServices.post(
      ApiUrls.createOrder,
      createOrderModel,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(
          CreateOrderResponseModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Create Product ====================================================================

  Future<Either<ErrorModel, CreateProductResponseModel>> createProduct(
      {required CreateProductRequestModel createProductRequestModel}) async {
    final response = await apiServices.post(
      ApiUrls.createProduct,
      createProductRequestModel,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(
          CreateProductResponseModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Create Checkout====================================================================

  Future<Either<ErrorModel, SuccessModel>> createCheckout(
      {required CreateCheckOutRequestModel createCheckOutRequestModel}) async {
    final response = await apiServices.post(
      ApiUrls.createCheckout,
      createCheckOutRequestModel,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Get Delivery Status ====================================================================

  Future<Either<ErrorModel, SuccessModel>> getDeliveryStatus() async {
    final response =
        await apiServices.get('${ApiUrls.getDeliveryStatus}/$userId');

    if (response.statusCode == 200 || response.statusCode == 201) {
      log('response.body---------->>>>>> ${response.body}');

      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
