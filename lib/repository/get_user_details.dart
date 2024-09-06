import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/models/get_user_details_byId.dart';

import '../models/error_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class GetUserDetailsByIDDataRepository {
  final ApiServices apiServices = ApiServices();

  Future<Either<ErrorModel, GetUserDetailsById>> getUserDetailsData(
      String userId) async {
    final response =
        await apiServices.get('${ApiUrls.getUserDetailsById}/$userId');
    log(response.body.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetUserDetailsById.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
