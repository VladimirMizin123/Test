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
import 'package:gymeats_mobile/screen/grocery/modal/create_order_response_model.dart' as cor;
import 'package:gymeats_mobile/screen/grocery/modal/create_product_request_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/create_product_response_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart' as gms;
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
import 'package:get/utils.dart';
import 'package:gymeats_mobile/service/signalr_service.dart';
import '../../restaurants/model/get_user_address_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart'
    as user_address;
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart' as gtm;
import 'package:shared_preferences/shared_preferences.dart';


class GroceryRepository {
  final ApiServices apiServices = ApiServices();

  String userID = PreferenceUtils.getString(prefUserData);

  Future<Either<ErrorModel, GetGroceryShoppingListModel>>
      fetchGroceryShoppingList() async {
    String apiURL = '${ApiUrls.getShoppingList}/$userID';
    final response = await apiServices.get(apiURL);
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

  Future<Either<ErrorModel, gms.GroceryMultiSearchModel>> grocerySearch(
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
      gms.GroceryMultiSearchModel searchModel =
          gms.GroceryMultiSearchModel.fromJson(jsonDecode(response.body));
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

  Future<String> getCurrentAddress() async {
    final prefs = await SharedPreferences.getInstance();
    print('=============================');
    print('IS MANUAL LOCATION: ${PreferenceUtils.isManualLocation}');
    print('===================');

    final cachedAddress = prefs.getString('currentUserAddress');
    final addressUpdated = prefs.getBool('AddressUpdated') ?? false;

    if (cachedAddress != null &&
        !addressUpdated &&
        PreferenceUtils.isManualLocation) {
      return cachedAddress.trim();
    }

    final foodMenuAddressRaw = prefs.getString('foodMenuAddress');
    print('FOOD MENU ADDRESS: $foodMenuAddressRaw');

    if (foodMenuAddressRaw != null && foodMenuAddressRaw.isNotEmpty) {
      try {
        final parsed = jsonDecode(foodMenuAddressRaw);

        String? streetNumRaw = parsed['user_street_num'];
        String? streetNum;

        if (streetNumRaw != null && streetNumRaw.trim().isNotEmpty) {
          streetNum = streetNumRaw;
        }

        if (streetNum == null || streetNum.isEmpty) {
          print('Invalid or missing street number, skipping...');
        } else {
          final parts = [
            streetNum,
            parsed['user_street_name'],
            parsed['user_city'],
            parsed['user_country']
          ]
              .where((e) => e != null && e.toString().trim().isNotEmpty)
              .map((e) => e.toString().trim())
              .toList();

          final address = parts.join(", ");
          print('FOOD MENU ADDRESS STRING: $address');

          if (address.isNotEmpty) {
            await prefs.setString('currentUserAddress', address);
            await prefs.setBool('AddressUpdated', false);
            return address;
          }
        }
      } catch (e) {
        print('Error parsing foodMenuAddress: $e');
      }
    }

    final addressResult = await getUserAddressData();

    if (addressResult.isRight) {
      var add = addressResult.right.data
          ?.firstWhereOrNull((element) => element.isPrimary ?? false);
      add ??= addressResult.right.data?.first;

      if (add != null) {
        final parts = [
          add.streetNum,
          add.streetName,
          add.city,
          add.country
        ]
            .where((e) => e != null && e.trim().isNotEmpty)
            .cast<String>()
            .toList();

        final address = parts.join(", ").trim();

        if (address.isNotEmpty) {
          await prefs.setString('currentUserAddress', address);
          await prefs.setBool('AddressUpdated', false);
          return address;
        }
      }
    }

    return '';
  }

  Future<void> ensureCategoriesCached(String address) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = 'categoryCache_$address';

      final cachedCategoriesString = prefs.getString(cacheKey);
      if (cachedCategoriesString != null) {
        print('categories already cached');
        return;
      }

      print('Fetching categories for address: $address');

      final signalR = SignalRService();
      final userID = PreferenceUtils.getString(prefUserData);

      final categories = await signalR.getRestaurantCategories(address, userID);

      final categoryData = (categories as List<dynamic>)
          .map<Map<String, dynamic>>((category) => {
                'title': category['name'],
                'id': category['id'],
                'image': category['imageSrc'],
              })
          .toList();

      await prefs.setString(cacheKey, jsonEncode(categoryData));
      print('Categories cached for: $address');
    } catch (e) {
      print('Failed to cache categories: $e');
    }
  }


  Future<Either<ErrorModel, NearByStoreModel>> nearByStoreSearch({
    required user_address.UserAddress? getUserAddress,
    AskReceiveOrder? askReceiveOrder,
  }) async {
    final String apiURL = ApiUrls.getStoreNearBy;
    final user_address.UserAddress? address = getUserAddress;
    final String currentAddress = await getCurrentAddress();

    print('Grocery Current Address: $currentAddress');

    await ensureCategoriesCached(currentAddress);
    final signalR = SignalRService();
    await signalR.connect();

    final bool pickup = askReceiveOrder?.index == 1;
    final Map<String, dynamic> filters = { "CategoryName": "Grocery" };

    final rawData = await signalR.getFilteredRestaurants(
      address: currentAddress,
      userId: userID,
      pageIndex: 0,
      pageSize: 20,
      filters: filters,
    );

    final restaurantsJson = rawData["Restaurants"] is String
        ? jsonDecode(rawData["Restaurants"])["Restaurants"] as List<dynamic>
        : (rawData["Restaurants"]["Restaurants"] as List<dynamic>);

    final List<gms.Store> storeList = restaurantsJson.map<gms.Store>((r) {
      String? imageUrl;

      if (r["ImageSrcSet"] != null && r["ImageSrcSet"] is String) {
        final parts = r["ImageSrcSet"].split(',');
        if (parts.isNotEmpty) {
          final firstPart = parts[0].trim();
          imageUrl = firstPart.split(' ').first;
        }
      }

      return gms.Store(
        id: r["_id"] as String?,
        name: r["name"] as String?,
        weightedRatingValue: (r["weighted_rating_value"] as num?)?.toDouble(),
        logoPhotos: imageUrl != null ? [imageUrl] : <String>[],
        phoneNumber: null,
        address: null,
        type: null,
        description: null,
        localHours: null,
        dollarSigns: null,
        pickupEnabled: null,
        deliveryEnabled: true,
        isOpen: null,
        offersFirstPartyDelivery: null,
        offersThirdPartyDelivery: null,
        miles: null,
        aggregatedRatingCount: null,
        isSelected: false,
      );
    }).toList();

    return Right(NearByStoreModel(
      success: true,
      message: "Fetched via SignalR",
      errorMessage: null,
      data: storeList,
    ));
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

  Future<Either<ErrorModel, SuccessModel>> addNewCustomMeal({
    String? name,
    String? protein,
    String? fat,
    String? carbs,
    String? calorie,
    String? type,
    String? date,
  }) async {
    final response = await apiServices.postMultipart(
      url: ApiUrls.addNewMeal,
      body: {
        'Name': name ?? '',
        'Protein': protein ?? '',
        'Fat': fat ?? '',
        'Carbs': carbs ?? '',
        'Calorie': calorie ?? '',
        'Type': type ?? '',
        'userId': userID,
        'Date': date ?? DateTime.now().toIso8601String(),
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

  Future<Either<ErrorModel, cor.CreateOrderResponseModel>> createOrder({
    required CreateGroceryOrderModel createOrderModel,
  }) async {
    try {
      print(' Mock createOrder called');

      final mockResponse = cor.CreateOrderResponseModel(
        success: true,
        errorMessage: null,
        data: cor.CreateOrderData(
          orderPlaced: true,
          orderId: "",
          userId: "",
          totalPrice: 0,
          phoneNumber: 1234567890,
          finalQuote: cor.FinalQuote(
            store: "",
            storeAddress: "",
            storeId: "",
            quoteId: "",
            tip: 0,
            totalWithTip: 10499,
            markedTotalWithTip: 10499,
            miscFees: [],
            items: [],
            quote: cor.Quote(
              subtotal: 0,
              deliveryFeeCents: 0,
              serviceFeeCents: 0,
              salesTaxCents: 0,
            ),
          ),
        ),
      );

      await Future.delayed(Duration(milliseconds: 300));

      return Right(mockResponse);
    } catch (e) {
      print(' Exception in mock createOrder: $e');
      return Left(
        ErrorModel(
          message: e.toString(),
          errorMessage: e.toString(),
        )..statusCode = 500,
      );
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

    Map<String, dynamic> extAddress = PreferenceUtils.getMenuAddress();
    reqData.addAll(extAddress);

    log("Api : ${ApiUrls.getMenuList}");
    log("Request Data : ${jsonEncode(reqData)}");

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
    String? name,
  }) async {
    try {
      if (name == null || name.trim().isEmpty) {
        return Left(ErrorModel(errorMessage: "Название ресторана отсутствует"));
      }

      final signalR = SignalRService();
      Map<String, dynamic>? signalRResult;
      try {
        signalRResult = await signalR.selectRestaurant(name, onlyCategories: true);
      } catch (e) {
        return Left(ErrorModel(errorMessage: "Grocery shop is not available"));
      }

      if (signalRResult == null) {
        return Left(ErrorModel(errorMessage: "Grocery shop is not available"));
      }

      final List<dynamic> categoryList = signalRResult['categories'] ?? [];
      final bool hasShopRestaurant = signalRResult['hasShopRestaurant'] == true;

      final List<Category> categories = List<Category>.generate(
        categoryList.length,
        (index) {
          final String categoryName = categoryList[index];
          return Category(
            name: categoryName,
            subcategoryId: null,
            subcategoryList: [],
            menuItemList: [],
            hasShopRestaurant: hasShopRestaurant,
          );
        },
      );

      final categorieModel = CategorieModel(
        success: true,
        message: null,
        errorMessage: null,
        data: Data(
          menuId: null,
          categories: categories,
          quote: null,
        ),
      );

      return Right(categorieModel);
    } catch (e) {
      return Left(ErrorModel(errorMessage: e.toString()));
    }
  }
}
