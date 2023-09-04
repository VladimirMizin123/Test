import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/models/recipes_add_to_grocery_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/add_grocery_to_shopping_list_from_suggestic_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_shopping_modal.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';

class GroceryRepository {
  final ApiServices apiServices = ApiServices();

  String userID = PreferenceUtils.getString(prefUserData);

  Future<Either<ErrorModel, AddGroceryToShoppingListFromSuggesticModal>> addGroceryToShoppingListFromSuggestic({String? latitude, String? longitude}) async {
    String apiURL = '${ApiUrls.addGroceryToShoppingListFromSuggestic}/$userID?latitude=$latitude&loingitude=$longitude';
    // log(apiURL, name: 'API URL :');
    final response = await apiServices.get(apiURL);
    // log(response.body, name: 'API RESPONSE :');
    if (response.statusCode == 200 || response.statusCode == 201) {
      await PreferenceUtils.setInt(userMealPlanCountState, 1);
      return Right(AddGroceryToShoppingListFromSuggesticModal.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, GetGroceryShoppingListModel>> fetchGroceryShoppingList() async {
    // String apiURL = '${ApiUrls.getAllItemFromShoppingList}?userId=$userID';
    String apiURL = '${ApiUrls.getShoppingList}/2b85411b-3c0c-424b-98e0-6534a5216726';
    // log(apiURL, name: 'API URL :');
    final response = await apiServices.get(apiURL);
    // log(response.body, name: 'API RESPONSE :');
    if (response.statusCode == 200 || response.statusCode == 201) {
      await PreferenceUtils.setInt(userMealPlanCountState, 1);
      return Right(GetGroceryShoppingListModel.fromJson(jsonDecode(response.body)));
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
  }) async {
    String apiURL = ApiUrls.addItemShoppingList;

    // log(apiURL, name: 'API URL :');
    final response = await apiServices.post(apiURL, {
      {
        "userId": userID,
        "productId": productID,
        "productName": productName,
        "quantity": quantity,
        "price": price,
        "unitSize": unitSize,
        "unitOfMeasurement": unitOfMeasurement,
        "recipeId": recipeId,
        "mealmeStoreId": mealmeStoreId,
      }
    });
    // log(response.body, name: 'API RESPONSE :');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(RecipesAddToGroceryModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
