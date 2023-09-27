import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/models/get_user_details_byId.dart';

import '../app/sharedPrefrence.dart';
import '../models/error_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class GetUserDetailsByIDDataRepository {
  final ApiServices apiServices = ApiServices();

  Future<Either<ErrorModel, GetUserDetailsById>> getUserDetailsData(
      String userId) async {
    final response =
        await apiServices.get('${ApiUrls.getUserDetailsById}/$userId');
    print("getUserDetailsResponse : ${jsonDecode(response.body)}");
    print("getUserDetailsResponse statusCode: ${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetUserDetailsById.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
