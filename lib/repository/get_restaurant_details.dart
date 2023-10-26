import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_cousines_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';
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
      {String? restaurantId, bool? pickup}) async {
    final response = await apiServices.get(
      '${ApiUrls.getRestaurantMenuList}?restaurantId=$restaurantId&pickup=$pickup',
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(
          GetRestaurantMenuListModel.fromJson(jsonDecode(response.body)));
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
}
