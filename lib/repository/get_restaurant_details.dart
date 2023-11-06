import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/models/success_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/add_items_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/create_checkout_request_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/create_order_request_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/create_order_response_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/create_product_request_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/create_product_response_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_cousines_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_shopping_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/update_cart_items_model.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';

class RestaurantRepository {
  final ApiServices apiServices = ApiServices();

  String userID = PreferenceUtils.getString(prefUserData);

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

  /// Get Restaurant List ====================================================================

  Future<Either<ErrorModel, GetRestaurantListModel>> getRestaurantListData({
    required dynamic latitude,
    required dynamic longitude,
    required String userStreetNum,
    required String userStreetName,
    required String userCity,
    required String userState,
    required String userCountry,
    required String userZipcode,
    required bool pickup,
    required int maximumMiles,
  }) async {
    Map<String, dynamic> data = {
      "latitude": latitude,
      "longitude": longitude,
      "user_street_num": userStreetNum,
      "user_street_name": userStreetName,
      "user_city": userCity,
      "user_state": userState,
      "user_country": userCountry,
      "user_zipcode": userZipcode,
      "pickup": pickup,
      "maximum_miles": maximumMiles
    };

    log('data---------->>>>>> $data');

    final response = await apiServices.post(
      ApiUrls.getRestaurantList,
      data,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetRestaurantListModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(GetRestaurantListModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Get Restaurant Menu List ====================================================================

  Future<Either<ErrorModel, GetRestaurantMenuListModel>> getRestaurantMenuList(
      {String? restaurantId, bool? pickup, String? mealType}) async {
    final response = await apiServices.post(
        '${ApiUrls.getRestaurantMenuList}/$userID?restaurantId=$restaurantId&mealType=$mealType&pickup=$pickup',
        {});
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(
          GetRestaurantMenuListModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(
          GetRestaurantMenuListModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Get Cousines List ====================================================================

  Future<Either<ErrorModel, GetCousinesListModel>> getCousinesListData({
    required dynamic latitude,
    required dynamic longitude,
    required String userStreetNum,
    required String userStreetName,
    required String userCity,
    required String userState,
    required String userCountry,
    required String userZipcode,
    required bool pickup,
    required int maximumMiles,
  }) async {
    Map<String, dynamic> data = {
      "latitude": latitude,
      "longitude": longitude,
      "user_street_num": userStreetNum,
      "user_street_name": userStreetName,
      "user_city": userCity,
      "user_state": userState,
      "user_country": userCountry,
      "user_zipcode": userZipcode,
      "pickup": pickup,
      "maximum_miles": maximumMiles
    };

    log('data---------->>>>>> $data');

    final response = await apiServices.post(
      ApiUrls.getCousinesList,
      data,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetCousinesListModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(GetCousinesListModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Add Shopping List ====================================================================

  Future<Either<ErrorModel, SuccessModel>> addMenuToCartRestaurant(
      {required List<AddRestaurantItemsToShoppingListModel>
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

  /// Get Shopping List ====================================================================

  Future<Either<ErrorModel, GetShoppingListData>> getShoppingList() async {
    final response =
        await apiServices.get('${ApiUrls.getShoppingList}/$userID');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetShoppingListData.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(GetShoppingListData.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Update Shopping List ====================================================================

  Future<Either<ErrorModel, SuccessModel>> updateMenuToCartRestaurant(
      {required UpdateRestaurantItemsToShoppingListModel
          updateItemsToShoppingList}) async {
    final response = await apiServices.put(
      ApiUrls.updateShoppingList,
      updateItemsToShoppingList,
    );

    log('updateItemsToShoppingList---------->>>>>> ${updateItemsToShoppingList.itemOptions}');

    log('response.statusCode---------->>>>>> ${response.statusCode}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Remove Shopping List Item====================================================================

  Future<Either<ErrorModel, SuccessModel>> removeShoppingListItem(
      {String? productID}) async {
    final response = await apiServices
        .delete('${ApiUrls.removeProduct}?userId=$userID&productId=$productID');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    }
    // else if (response.statusCode == 400) {
    //   log('GetRestaurantMenuListErrorState---------->>>>>>}');
    //
    //   return Right(
    //       GetRestaurantMenuListModel.fromJson(jsonDecode(response.body)));
    // }
    else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Create Order ====================================================================

  Future<Either<ErrorModel, CreateOrderResponseModel>> createOrder(
      {required CreateOrderModel createOrderModel}) async {
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
}
