import 'dart:convert';
import 'package:either_dart/either.dart';
import '../models/error_model.dart';
import '../models/login_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class LoginRepository {
  final ApiServices apiServices = ApiServices();

  Future<Either<ErrorModel, LoginModel>> login({
  required String email,
  required String password,
}) async {
  final data = {'email': email, 'password': password};
  final response = await apiServices.post(ApiUrls.login, data);

  if (response.statusCode == 200 || response.statusCode == 201) {
    final loginModel = LoginModel.fromJson(jsonDecode(response.body));
    print(jsonDecode(response.body));
    
    final token = loginModel.data?.token?.accessToken;
    print('Login successful!');
    print('Access Token: $token');
    
    if (token != null) {

      print('Token saved to local storage.');
    } else {
      print('⚠️ Token is null!');
    }

    return Right(loginModel);
  } else {
    print('Login failed. Status: ${response.statusCode}');
    print('Response Body: ${response.body}');
    return Left(ErrorModel.fromJson(jsonDecode(response.body)));
  }
}
}
