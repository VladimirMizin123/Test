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
    // required String itemName,
    // required int quantity,
    // required String measurementType,
    // required String measurementValue,
  }) async {
    Map<String, dynamic> data = {
      // "itemName": itemName.toString(),
      // "quantity": quantity,
      // "measurementType": measurementType.toString(),
      // "measurementValue": measurementValue,
      "userId": userId.toString(),
      "groceryItems": groceryItems,
    };

    print('---data-->>>>>$data');
    final response = await apiServices.post(
      ApiUrls.addNewGroceryItem,
      data,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('SUCESSBODYYY--${response.body}');

      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      print('FailBODYYY--${response.body}');
      return Left(
        ErrorModel.fromJson(
          jsonDecode(response.body),
        ),
      );
    }
  }

  /// GetUserGroceryList ====================================================================

  Future<Either<ErrorModel, GetUserGroceryListModel>>
      getGroceryListData() async {
    final response = await apiServices.get(
      ApiUrls.getGroceryItemList,
    );
    print("response123 : ${response.body}");
    print("response statusCode: ${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetUserGroceryListModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Delete User Grocery List ====================================================================

  Future<Either<ErrorModel, SuccessModel>> deleteGroceryItem({
    required String userGroceryListId,
  }) async {
    String apiURL = '${ApiUrls.removeUserGroceryItem}/$userGroceryListId';

    // log(apiURL, name: 'API URL :');
    final response = await apiServices.delete(apiURL);
    // log(response.body, name: 'API RESPONSE :');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
