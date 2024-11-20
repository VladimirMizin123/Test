import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/models/set_address_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';

import '../models/error_model.dart';

import '../service/api_urls.dart';
import '../service/apis.dart';

class GetAddressRepository {
  final ApiServices apiServices = ApiServices();

  String userID = PreferenceUtils.getString(prefUserData);

  /// GetUserAddressList ====================================================================

  Future<Either<ErrorModel, GetUserAddressModel>> getUserAddressData() async {
    log("api : ${'${ApiUrls.getUserAddress}/$userID'}");
    final response = await apiServices.get('${ApiUrls.getUserAddress}/$userID');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetUserAddressModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(GetUserAddressModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// SetUserAddress ====================================================================

  Future<Either<ErrorModel, SetAddressResponseModel>> setUserAddressPrimary(
      String addressId) async {
    final response = await apiServices.put(
        '${ApiUrls.setUserAddressPrimary}/$userID?addressId=$addressId', {});

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SetAddressResponseModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(SetAddressResponseModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
