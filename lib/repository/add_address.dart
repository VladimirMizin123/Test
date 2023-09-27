import 'dart:convert';

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
  }) async {
    Map<String, dynamic> data = {
      "latitude": latitude,
      "longitude": longitude,
      "street_Num": streetNum,
      "street_Name": streetName,
      "city": city,
      "state": state,
      "country": country,
      "addressType": addressType,
      "zipcode": zipcode,
      "isPrimary": isPrimary,
      "userId": userId,
    };

    final response = await apiServices.post(ApiUrls.addNewAddress, data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
