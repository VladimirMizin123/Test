import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/models/get_custom_meal_list_model.dart';
import 'package:gymeats_mobile/models/success_model.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AddNewMealRepository {
  final ApiServices apiServices = ApiServices();

  String userID = PreferenceUtils.getString(prefUserData);

  Future<Either<ErrorModel, SuccessModel>> addMeal({
    required String name,
    File? imageUrl,
    required String protein,
    required String fat,
    required String carbs,
    required String calorie,
    required String type,
    required String userId,
    required String quantity,
  }) async {
    List<http.MultipartFile> mealItemImage = [];
    if (imageUrl != null) {
      var stream = http.ByteStream(imageUrl.openRead());
      stream.cast();
      var length = await imageUrl.length();

      var multipartFileImage = http.MultipartFile(
        'ImageUrl',
        stream,
        length,
        filename: imageUrl.path,
        contentType: MediaType(
          'image',
          imageUrl.path.split('/').last.split('.').last == 'png' ? 'png' : 'jpg',
        ),
      );

      mealItemImage.add(multipartFileImage);
    } else {
      mealItemImage = [];
    }
    Map<String, String> data = {
      'Name': name.toString(),
      'Protein': protein.toString(),
      'Fat': fat.toString(),
      'Carbs': carbs.toString(),
      'Calorie': calorie.toString(),
      'Type': type.toString(),
      'UserId': userId.toString(),
      'Quantity': quantity.toString()
    };

    log('data----CUSTOM------>>>>>> $data');

    final response = await apiServices.postMultipart(url: ApiUrls.addNewMeal, body: data, files: mealItemImage);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("addMealresponse code:${response.statusCode}");

      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(
        ErrorModel.fromJson(
          jsonDecode(response.body),
        ),
      );
    }
  }

  Future<Either<ErrorModel, SuccessModel>> updateMeal({
    required String id,
    required String name,
    File? imageUrl,
    required String protein,
    required String fat,
    required String carbs,
    required String calorie,
    required String type,
    required String userId,
    required String quantity,
  }) async {
    List<http.MultipartFile> mealItemImage = [];
    if (imageUrl != null) {
      var stream = http.ByteStream(imageUrl.openRead());
      stream.cast();
      var length = await imageUrl.length();

      var multipartFileImage = http.MultipartFile(
        'ImageUrl',
        stream,
        length,
        filename: imageUrl.path,
        contentType: MediaType(
          'image',
          imageUrl.path.split('/').last.split('.').last == 'png' ? 'png' : 'jpg',
        ),
      );

      mealItemImage.add(multipartFileImage);
    } else {
      mealItemImage = [];
    }
    Map<String, String> data = {
      'Id': id.toString(),
      'Name': name.toString(),
      'Protein': protein.toString(),
      'Fat': fat.toString(),
      'Carbs': carbs.toString(),
      'Quantity': quantity.toString(),
      'Calorie': calorie.toString(),
      'Type': type.toString(),
      'UserId': userId.toString(),
    };

    final response = await apiServices.putMultipart(url: ApiUrls.updateMeal, body: data, files: mealItemImage);
    print("updateMeal code:${response.statusCode}");
    // print("update:${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(
        ErrorModel.fromJson(
          jsonDecode(response.body),
        ),
      );
    }
  }

  /// GetUserGroceryList ====================================================================

  Future<Either<ErrorModel, GetCustomMealListModel>> getCustomMealListData(String? date) async {
    log(date != null ? '${ApiUrls.getCustomMeal}?userId=$userID&date=$date' : '${ApiUrls.getCustomMeal}?userId=$userID', name: "CUSTOME LIST");
    final response = await apiServices.get(
      date != null ? '${ApiUrls.getCustomMeal}?userId=$userID&date=$date' : '${ApiUrls.getCustomMeal}?userId=$userID',
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetCustomMealListModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(GetCustomMealListModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
