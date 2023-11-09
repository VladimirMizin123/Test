import 'dart:convert';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/screen/account_screen/model/change_password_model.dart';
import 'package:gymeats_mobile/screen/account_screen/model/get_all_programs_model.dart';
import 'package:gymeats_mobile/screen/account_screen/model/get_current_program_model.dart';
import 'package:gymeats_mobile/screen/account_screen/model/get_profile_details_model.dart';
import 'package:gymeats_mobile/screen/account_screen/model/get_profile_image_model.dart';
import 'package:gymeats_mobile/screen/account_screen/model/get_unit_info_model.dart';
import 'package:gymeats_mobile/screen/account_screen/model/programs_info_model.dart';
import 'package:gymeats_mobile/screen/account_screen/model/update_diet_program_model.dart';
import 'package:gymeats_mobile/screen/account_screen/model/update_profile_details_model.dart';
import 'package:gymeats_mobile/screen/account_screen/model/update_profile_image_model.dart';
import 'package:gymeats_mobile/screen/account_screen/model/update_unit_info_model.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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
      return Right(getAllProgramsResponseModelFromJson(response.body));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Get Current Programs ====================================================================

  Future<Either<ErrorModel, GetCurrentProgramResponseModel>>
      getCurrentProgramData() async {
    final response = await apiServices.get(
      '${ApiUrls.getCurrentProgram}$userID',
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(getCurrentProgramResponseModelFromJson(response.body));
    } else if (response.statusCode == 400) {
      return Right(getCurrentProgramResponseModelFromJson(response.body));
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
      return Right(getProgramInfoResponseModelFromJson(response.body));
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
      return Right(updateDietProgramResponseModelFromJson(response.body));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Get Profile Image ====================================================================

  Future<Either<ErrorModel, GetProfileImageResponseModel>> getProfileImage(
      {String programId = ''}) async {
    final response =
        await apiServices.get('${ApiUrls.getProfileImage}?userId=$userID');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(getProfileImageResponseModelFromJson(response.body));
    } else if (response.statusCode == 400) {
      return Right(getProfileImageResponseModelFromJson(response.body));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Get Profile Details ====================================================================

  Future<Either<ErrorModel, GetProfileDetailsResponseModel>> getProfileDetails(
      {String programId = ''}) async {
    final response =
        await apiServices.get('${ApiUrls.getProfileDetails}$userID');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(getProfileDetailsResponseModelFromJson(response.body));
    } else if (response.statusCode == 400) {
      return Right(getProfileDetailsResponseModelFromJson(response.body));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Update Profile Details ====================================================================

  Future<Either<ErrorModel, UpdateProfileDetailsResponseModel>>
      updateProfileDetails({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required int goal,
    required int weight,
    required int targetWeight,
    required double heightInCm,
    required DateTime birthDate,
    required String gender,
  }) async {
    Map<String, dynamic> data = {
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "goal": goal,
      "weight": weight,
      "targetWeight": targetWeight,
      "heightInCm": heightInCm,
      "birthDate": birthDate.toIso8601String().toString(),
      "gender": gender
    };

    final response =
        await apiServices.post('${ApiUrls.updateProfileDetails}$userID', data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(updateProfileDetailsResponseModelFromJson(response.body));
    } else if (response.statusCode == 400) {
      return Right(updateProfileDetailsResponseModelFromJson(response.body));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Update Profile Image ====================================================================

  Future<Either<ErrorModel, UpdateProfileImageResponseModel>>
      updateProfileImage({
    required File imageFile,
  }) async {
    http.MultipartFile profileImage;

    var stream = http.ByteStream(imageFile.openRead());
    stream.cast();
    var length = await imageFile.length();

    var multipartFileImage = http.MultipartFile(
      'profileImage',
      stream,
      length,
      filename: imageFile.path,
      contentType: MediaType(
        'profileImage',
        imageFile.path.split('/').last.split('.').last == 'png' ? 'png' : 'jpg',
      ),
    );

    profileImage = multipartFileImage;

    final response = await apiServices.postMultipart(
      url: '${ApiUrls.updateProfileImage}$userID',
      files: [profileImage],
      body: {},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(updateProfileImageResponseModelFromJson(response.body));
    } else if (response.statusCode == 400) {
      return Right(updateProfileImageResponseModelFromJson(response.body));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Update Profile Details ====================================================================

  Future<Either<ErrorModel, ChangePasswordResponseModel>>
      changeProfilePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required String email,
  }) async {
    Map<String, dynamic> data = {
      "currentPassword": currentPassword,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
      "email": email
    };

    final response = await apiServices.post(ApiUrls.changePassword, data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(changePasswordResponseModelFromJson(response.body));
    } else if (response.statusCode == 400) {
      return Right(changePasswordResponseModelFromJson(response.body));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Get Unit Info ====================================================================

  Future<Either<ErrorModel, GetUnitInfoResponseModel>> getUnitInfo() async {
    final response = await apiServices.get(
      ApiUrls.getUnitInfo + userID,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(getUnitInfoResponseModelFromJson(response.body));
    } else if (response.statusCode == 400) {
      return Right(getUnitInfoResponseModelFromJson(response.body));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Update Unit Info ====================================================================

  Future<Either<ErrorModel, UpdateUnitInfoResponseModel>> updateUnitInfo({
    required String unitId,
    required int weightType,
    required int heightType,
    required int energyType,
    required int waterType,
  }) async {
    Map<String, dynamic> data = {
      "unitId": unitId,
      "weightType": weightType,
      "heightType": heightType,
      "energyType": energyType,
      "waterType": waterType,
      "userId": userID
    };
    print('=data==>${data}');

    final response = await apiServices.put(ApiUrls.updateUnitInfo, data);
    print('==response==>${response.statusCode}====${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(updateUnitInfoResponseModelFromJson(response.body));
    } else if (response.statusCode == 400) {
      return Right(updateUnitInfoResponseModelFromJson(response.body));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
