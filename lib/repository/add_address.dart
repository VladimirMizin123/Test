import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';

import '../models/error_model.dart';
import '../models/success_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class AddAddressRepository {
  final ApiServices apiServices = ApiServices();

  String userID = PreferenceUtils.getString(prefUserData);

  Future<Either<ErrorModel, SuccessModel>> addAddress({
    required double latitude,
    required double longitude,
    required String streetNum,
    required String streetName,
    required String city,
    required String state,
    required String country,
    required String addressType,
    required String zipcode,
    required bool isPrimary,
    required String userId,
    String? floor,
  }) async {
    Map<String, dynamic> data = {
      "latitude": latitude.toStringAsFixed(6),
      "longitude": longitude.toStringAsFixed(6),
      "street_Num": streetNum,
      "street_Name": streetName,
      "city": city,
      "state": state,
      "country": country,
      "addressType": addressType,
      "zipcode": zipcode,
      "isPrimary": isPrimary,
      "userId": userId,
      "extendedAddress": floor,
    };

    log("Add new address --------->>>> ${ApiUrls.addNewAddress}");
    log('data---------->>>>>> ${jsonEncode(data)}');

    final response = await apiServices.post(ApiUrls.addNewAddress, data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, SuccessModel>> updateAddress({
    required double latitude,
    required double longitude,
    required String streetNum,
    required String streetName,
    required String city,
    required String state,
    required String country,
    required String addressType,
    required String zipcode,
    required bool isPrimary,
    required String addressId,
    String? floor,
  }) async {
    Map<String, dynamic> data = {
      "latitude": latitude.toStringAsFixed(6),
      "longitude": longitude.toStringAsFixed(6),
      "street_Num": streetNum,
      "street_Name": streetName,
      "city": city,
      "state": state,
      "country": country,
      "extendedAddress": floor,
      "addressType": addressType,
      "zipcode": zipcode,
      "isPrimary": isPrimary,
    };

    log("Api :----->>>> ${'${ApiUrls.updateAddress}?addressId=$addressId'}");
    log("Request Data : ${jsonEncode(data)}");
    final response = await apiServices.put(
        '${ApiUrls.updateAddress}?addressId=$addressId', data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, SuccessModel>> deleteAddress({
    required String addressId,
  }) async {
    final response = await apiServices.delete(
      '${ApiUrls.deleteAddress}?addressId=$addressId',
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
