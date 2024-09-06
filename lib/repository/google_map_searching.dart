import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/models/find_address_model.dart';
import 'package:gymeats_mobile/models/find_latlng_model.dart';
import 'package:gymeats_mobile/models/search_address_model.dart';

import '../models/error_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class GoogleMapSearchRepository {
  final ApiServices apiServices = ApiServices();

  String userID = PreferenceUtils.getString(prefUserData);
  // String userID = '2b85411b-3c0c-424b-98e0-6534a5216726';

  Future<Either<ErrorModel, SearchAddressResponseModel>> searchLocation(
      String value) async {
    final response = await apiServices.get(ApiUrls.searchLocationURL(value));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(
          SearchAddressResponseModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, FindLatLngResponseModel>> findLatLng(
      String value) async {
    print('==userID====>$userID');
    final response = await apiServices.get(ApiUrls.findLatLngURL(value));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(FindLatLngResponseModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, FindAddressResponseModel>> findAddressURL(
      {String? lat, String? lng}) async {
    try {
      final response =
          await apiServices.get(ApiUrls.findAddressURL(lat: lat, lng: lng));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(
            FindAddressResponseModel.fromJson(jsonDecode(response.body)));
      } else {
        return Left(ErrorModel.fromJson(jsonDecode(response.body)));
      }
    } catch (e) {
      return Left(ErrorModel(
        errorMessage: "unable to find address",
        success: false,
      ));
    }
  }
}
