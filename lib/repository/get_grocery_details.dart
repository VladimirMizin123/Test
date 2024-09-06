import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/models/get_grocery_item_list_model.dart';
import 'package:gymeats_mobile/models/success_model.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';

class AddNewGroceryItemRepository {
  final ApiServices apiServices = ApiServices();

  String userID = PreferenceUtils.getString(prefUserData);

  /// AddNewUserGrocery ====================================================================

  Future<Either<ErrorModel, SuccessModel>> addGroceryItem({
    required String userId,
    required List<Map<String, dynamic>> groceryItems,
  }) async {
    Map<String, dynamic> data = {
      "userId": userId.toString(),
      "groceryItems": groceryItems,
    };

    final response = await apiServices.post(
      ApiUrls.addNewGroceryItem,
      data,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// GetUserGroceryList ====================================================================

  Future<Either<ErrorModel, GetUserGroceryListModel>>
      getGroceryListData() async {
    final response =
        await apiServices.get('${ApiUrls.getGroceryItemList}?userId=$userID');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetUserGroceryListModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(GetUserGroceryListModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Delete User Grocery Item ====================================================================

  Future<Either<ErrorModel, SuccessModel>> deleteGroceryItem({
    required String userGroceryListId,
  }) async {
    String apiURL = '${ApiUrls.removeUserGroceryItem}/$userGroceryListId';

    final response = await apiServices.delete(apiURL);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Update New User Grocery ====================================================================

  Future<Either<ErrorModel, SuccessModel>> updateGroceryItem({
    required String id,
    required String itemName,
    required int quantity,
    required String measurementType,
    required String measurementValue,
    required String userId,
    required bool isChecked,
  }) async {
    Map<String, dynamic> data = {
      "id": id,
      "itemName": itemName,
      "quantity": quantity,
      "measurementType": measurementType,
      "measurementValue": measurementValue,
      "userId": userId,
      "isChecked": isChecked,
    };

    final response = await apiServices.put(
      ApiUrls.updateUserGroceryItem,
      data,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(
        ErrorModel.fromJson(
          jsonDecode(response.body),
        ),
      );
    }
  }

  /// Clear User Grocery List ====================================================================

  Future<Either<ErrorModel, GetUserGroceryListModel>> clearGroceryList() async {
    final response =
        await apiServices.delete('${ApiUrls.clearUserGroceryList}/$userID');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetUserGroceryListModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, GetUserGroceryListModel>>
      addGroceryToShoppingListFromSuggestic(
          {String? latitude, String? longitude}) async {
    String apiURL =
        '${ApiUrls.addGroceryToShoppingListFromSuggestic}/$userID?latitude=$latitude&loingitude=$longitude';
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
