import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/screen/account_screen/model/get_all_programs_model.dart';
import 'package:gymeats_mobile/screen/account_screen/model/programs_info_model.dart';
import 'package:gymeats_mobile/screen/account_screen/model/update_diet_program_model.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';

class AccountRepository {
  final ApiServices apiServices = ApiServices();

  String userID = PreferenceUtils.getString(prefUserData);

  /// Get ALl Programs ====================================================================

  Future<Either<ErrorModel, GetAllProgramsResponseModel>>
      getAllProgramData() async {
    final response = await apiServices.get(
      ApiUrls.getProgramData,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(getAllProgramsResponseModelFromJson(response.body));
    } else if (response.statusCode == 400) {
      return Right(
          getAllProgramsResponseModelFromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Get Programs Info ====================================================================

  Future<Either<ErrorModel, GetProgramInfoResponseModel>> getProgramInfo(
      {String programId = ''}) async {
    final response = await apiServices.get(
      '${ApiUrls.getProgramInfo}$programId?userId=$userID',
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(getProgramInfoResponseModelFromJson(response.body));
    } else if (response.statusCode == 400) {
      return Right(
          getProgramInfoResponseModelFromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Update Programs Info ====================================================================

  Future<Either<ErrorModel, UpdateDietProgramResponseModel>>
      updateDietProgramInfo({String programId = ''}) async {
    final response = await apiServices.put(
        '${ApiUrls.updateDietProgramByProgramId}$userID?programId=$programId',
        {});

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(updateDietProgramResponseModelFromJson(response.body));
    } else if (response.statusCode == 400) {
      return Right(
          updateDietProgramResponseModelFromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
