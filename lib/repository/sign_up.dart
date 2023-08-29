import 'dart:convert';
import 'package:either_dart/either.dart';
import '../app/sharedPrefrence.dart';
import '../constant/string_utils.dart';
import '../models/error_model.dart';
import '../models/sign_up_data_navigate_model.dart';
import '../models/sign_up_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class SignUpRepository {
  final ApiServices apiServices = ApiServices();

  Future<Either<ErrorModel, SignUpModel>> signUp({
    required UserSignUpDataModel model,
  }) async {
    List<http.MultipartFile> profileImage = [];
    if (model.userProfileImage != null) {
      var stream = http.ByteStream(model.userProfileImage!.openRead());
      stream.cast();
      var length = await model.userProfileImage!.length();
      var multipartFileImage = http.MultipartFile(
          'profileImage', stream, length,
          filename: model.userProfileImage!.path,
          contentType: MediaType(
              'image',
              model.userProfileImage!.path.split('/').last.split('.').last ==
                      'png'
                  ? 'png'
                  : 'jpeg'));

      profileImage.add(multipartFileImage);
    }

    Map<String, String> data = {
      "FirstName": model.firstName!,
      "LastName": model.lastName!,
      "Email": model.email!,
      "UserName": model.email!,
      "Password": model.password!,
      "ConfirmPassword": model.confirmPassword!,
      "UserDetail.Age": model.age!,
      "UserDetail.Height": model.height!,
      "UserDetail.Weight": model.weight!,
      "UserDetail.Gender": model.gender! == AppStrings.male
          ? 'Male'
          : model.gender! == AppStrings.female
              ? 'Female'
              : 'Non-binary',
      "UserDetail.SurveyId": model.surveyId!,
      "UserDetail.DietId": model.dietId!,
      "UserAddress.Latitude": model.latitude!,
      "UserAddress.Longitude": model.longitude!,
    };
    final response = await apiServices.postMultipart(
        url: ApiUrls.register, body: data, files: profileImage);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SignUpModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
