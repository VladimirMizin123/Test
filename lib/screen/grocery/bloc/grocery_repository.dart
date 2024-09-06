import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/models/recipes_add_to_grocery_modal.dart';
import 'package:gymeats_mobile/models/success_model.dart';
import 'package:gymeats_mobile/repository/get_address.dart';
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
import 'package:gymeats_mobile/screen/meal_plan_home/bottomsheet/receive_order_ask_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/model/categorie_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/near_by_store_model.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';
import 'package:gymeats_mobile/service/hive_singleton.dart';

import '../../restaurants/model/get_user_address_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart'
    as user_address;

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
      required user_address.UserAddress? getUserAddress,
      AskReceiveOrder? askReceiveOrder}) async {
    String apiURL = ApiUrls.productGroceryMultipleSearch;

    user_address.UserAddress? address = getUserAddress;

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
      "latitude": address?.latitude?.toStringAsFixed(6),
      "longitude": address?.longitude?.toStringAsFixed(6),
      "user_street_num": address?.streetNum,
      "user_street_name": address?.streetName,
      "user_city": address?.city,
      "user_state": address?.state,
      "user_country": address?.country,
      "user_zipcode": address?.zipcode,
      "pickup": askReceiveOrder?.index == 1,
      "groceries": grocerySearchModal
          .map(
            (e) => {
              "groceryName": e.groceryName ?? "",
              "quantity": e.quantity,
            },
          )
          .toList(),
    };
    log("Url : $apiURL");
    log("Data: $data");
    final response = await apiServices.post(
      apiURL,
      data,
    );
    log("res:${response.body}");
    log("code:${response.statusCode}");

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

  Future<Either<ErrorModel, NearByStoreModel>> nearByStoreSearch(
      {required user_address.UserAddress? getUserAddress,
      AskReceiveOrder? askReceiveOrder}) async {
    String apiURL = ApiUrls.getStoreNearBy;
    user_address.UserAddress? address = getUserAddress;
    (double?, double?) pos = await Constant.i.position;

    if (address == null && pos.$1 == null && pos.$2 == null) {
      Either<ErrorModel, GetUserAddressModel> res =
          await GetAddressRepository().getUserAddressData();
      if (res.isRight) {
        res.right.data?.forEach((element) async {
          if (element.isPrimary == true) {
            address = element;
          }
        });
        if ((res.right.data?.isNotEmpty ?? false) &&
            !res.right.data!.any((element) => (element.isPrimary ?? false))) {
          address = res.right.data?.first;
        }
      }
    }

    Map<String, dynamic> data = {
      "latitude": pos.$1?.toString() ?? address?.latitude?.toStringAsFixed(6),
      "longitude": pos.$2?.toString() ?? address?.longitude?.toStringAsFixed(6),
      "pickup": askReceiveOrder?.index == 1,
      "max_Miles": PreferenceUtils.getGroceryRadius(),
    };

    final response = await apiServices.post(apiURL, data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      NearByStoreModel searchModel =
          NearByStoreModel.fromJson(jsonDecode(response.body));
      for (int i = 0; i < (searchModel.data?.length ?? 0); i++) {
        if (searchModel.data?[i].logoPhotos?.isNotEmpty ?? false) {
          PreferenceUtils.setString("${searchModel.data?[i].id}_img",
              searchModel.data?[i].logoPhotos?[0] ?? "");
        }
      }

      return Right(searchModel);
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, NearByStoreModel>> getStoreByName({
    required String latitude,
    required String longitude,
    required user_address.UserAddress? getUserAddress,
    AskReceiveOrder? askReceiveOrder,
    String? name,
  }) async {
    String apiURL = "${ApiUrls.getStoreByName}/$name";
    user_address.UserAddress? address = getUserAddress;

    if (address == null) {
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

    (double?, double?) pos = await Constant.i.position;

    Map<String, dynamic> data = {
      "latitude": pos.$1?.toString() ?? address?.latitude?.toStringAsFixed(6),
      "longitude": pos.$2?.toString() ?? address?.longitude?.toStringAsFixed(6),
      "pickup": askReceiveOrder?.index == 1,
      "StoreType": 'grocery',
      "maximum_miles": PreferenceUtils.getGroceryRadius(),
    };

    final response = await apiServices.get(apiURL, queryParams: data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      NearByStoreModel searchModel = NearByStoreModel.fromJson(
          jsonDecode(response.body)['data'] == null
              ? {}
              : jsonDecode(response.body));
      for (int i = 0; i < (searchModel.data?.length ?? 0); i++) {
        if (searchModel.data?[i].logoPhotos?.isNotEmpty ?? false) {
          PreferenceUtils.setString("${searchModel.data?[i].id}_img",
              searchModel.data?[i].logoPhotos?[0] ?? "");
        }
      }

      return Right(searchModel);
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, NutritionixGetNxMealInfoByNameModel>>
      groceryDetailsMealInfo({
    required String productName,
    bool needCal = false,
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
      // log('localdbtask if Value associated with the key: $specificValue');
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

    String apiURL =
        '${ApiUrls.getNxMealInfoByName}?foodName=${Uri.encodeComponent(productName)}';

    log("Api : $apiURL");

    // log(apiURL, name: 'API URL :');
    final response = await apiServices.get(apiURL);
    log("Response : ${response.body}");
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

        log("Second Api Call :$apiNutritionixURL");
        final responseNutritionix =
            await apiServices.getNutritionix(apiNutritionixURL);
        Map<String, dynamic> jsonNutritionix =
            jsonDecode(responseNutritionix.body);
        // log(responseNutritionix.body, name: 'API RESPONSE :');
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
            await apiServices.post(ApiUrls.addNutritionDataToDb, nxAddData);
            await hiveSingleton.addValueToBox(productName, nxAddData);
            return Right(
                NutritionixGetNxMealInfoByNameModel.fromJson(finalOutput));
          } else {
            if (needCal) {
              return Right(
                NutritionixGetNxMealInfoByNameModel.fromJson({
                  'success': true,
                  'message': null,
                  'errorMessage': null,
                  'data': {
                    'foodName': productName,
                    'nfCalories': jsonNutritionix['branded'][0]["nf_calories"],
                  },
                }),
              );
            } else {
              return Left(ErrorModel.fromJson(jsonDecode(response.body)));
            }
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
        'userId': userID,
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
    log("Get User Data Grocery");
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
    log(ApiUrls.createOrder);
    log("Request Data : ${createOrderModel.toJson()}");
    final response = await apiServices.post(
      ApiUrls.createOrder,
      createOrderModel,
    );
    log(response.body);
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

  Future<Either<ErrorModel, CategorieModel>> getMenuList(
      user_address.UserAddress? address,
      int? askReceiveOrder,
      String? storeId,
      String? subCategorieId) async {
    (double?, double?) pos = await Constant.i.position;

    Map<String, dynamic> reqData = {
      "latitude": pos.$1 ?? address?.latitude,
      "longitude": pos.$2 ?? address?.longitude,
      "pickup": askReceiveOrder != 0,
      "storeId": storeId,
      "sub_categorieId": subCategorieId,
    };

    final response = await apiServices.post(ApiUrls.getMenuList, reqData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(CategorieModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(CategorieModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, CategorieModel>> getStoreCategorieList(
    user_address.UserAddress? address,
    int? askReceiveOrder,
    String? storeId, {
    (double?, double?)? position,
  }) async {
    (double?, double?) pos = position ?? await Constant.i.position;
    Map<String, dynamic> reqData = {
      "storeId": storeId,
      "latitude": pos.$1 ?? address?.latitude,
      "longitude": pos.$2 ?? address?.longitude,
      "pickup": askReceiveOrder != 0,
    };

    final response =
        await apiServices.post(ApiUrls.getStoreCategorieList, reqData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(CategorieModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(CategorieModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
