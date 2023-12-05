import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'api_urls.dart';

class ApiServices {
  String token = PreferenceUtils.getString(prefToken);

  Future<dynamic> get(String url) async {
    token = PreferenceUtils.getString(prefToken);
    try {
      Map<String, String>? headers;
      if (token.isEmpty) {
        headers = {
          'accept': '*/*',
          'Api_Key': ApiUrls.apiKey,
        };
      } else {
        headers = {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
          'Api_Key': ApiUrls.apiKey,
        };
      }
      log(url, name: 'GET API URL');
      log(headers.toString(), name: 'GET API HEADER');
      final response = await http.get(Uri.parse(url), headers: headers);
      log(response.body, name: 'GET API RESPONSE');
      return _returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet connection');
    } on HttpException {
      throw FetchDataException('No Service found');
    } on FormatException {
      throw InvalidInputException('Bad response format');
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }

  Future<http.Response> post(String url, dynamic body) async {
    try {
      Map<String, String>? headers;
      if (token.isEmpty) {
        headers = {
          'Content-Type': 'application/json',
          'accept': '*/*',
          'Api_Key': ApiUrls.apiKey,
        };
      } else {
        headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'accept': '*/*',
          'Api_Key': ApiUrls.apiKey,
        };
      }
      log(url, name: 'POST API URL :');
      log(body.toString(), name: 'POST BODY  :');
      final jsonBody = jsonEncode(body);
      final response = await http.post(
        Uri.parse(url),
        body: jsonBody,
        headers: headers,
      );
      log(response.body, name: 'API RESPONSE : ${response.statusCode}');
      return _returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet connection');
    } on HttpException {
      throw FetchDataException('No Service found');
    } on FormatException {
      throw InvalidInputException('Bad response format');
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }

  Future<dynamic> put(String url, dynamic body) async {
    Map<String, String>? headers;

    try {
      if (token.isEmpty) {
        headers = {
          'Content-Type': 'application/json',
          'accept': '*/*',
          'Api_Key': ApiUrls.apiKey,
        };
      } else {
        headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'accept': '*/*',
          'Api_Key': ApiUrls.apiKey,
        };
      }
      debugPrint('post url--> $url');

      final jsonBody = jsonEncode(body);
      final response =
          await http.put(Uri.parse(url), body: jsonBody, headers: headers);
      return _returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet connection');
    } on HttpException {
      throw FetchDataException('No Service found');
    } on FormatException {
      throw InvalidInputException('Bad response format');
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }

  Future<dynamic> delete(String url) async {
    try {
      Map<String, String>? headers;
      if (token.isEmpty) {
        headers = {
          'Content-Type': 'application/json',
          'accept': '*/*',
          'Api_Key': ApiUrls.apiKey,
        };
      } else {
        headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'accept': '*/*',
          'Api_Key': ApiUrls.apiKey,
        };
      }
      log(url, name: 'DELETE API URL :');
      final response = await http.delete(Uri.parse(url), headers: headers);
      log(response.body, name: 'DELETE API RESPONSE :');
      return _returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet connection');
    } on HttpException {
      throw FetchDataException('No Service found');
    } on FormatException {
      throw InvalidInputException('Bad response format');
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }

  Future<http.Response> postWithCustomHeader(
    String url,
    dynamic body,
  ) async {
    try {
      body ??= {};
      final response =
          await http.post(Uri.parse(url), body: jsonEncode(body), headers: {
        'content-type': 'application/json',
        'accept': '*/*',
        'Api_Key': ApiUrls.apiKey,
      });
      return _returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet connection');
    } on HttpException {
      throw FetchDataException('No Service found');
    } on FormatException {
      throw InvalidInputException('Bad response format');
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }

  Future<http.Response> postMultipart(
      {required String url,
      required Map<String, String> body,
      required List<http.MultipartFile> files}) async {
    try {
      Map<String, String>? headers;
      if (token.isEmpty) {
        headers = {
          'Content-Type': 'multipart/form-data',
          'accept': '*/*',
          'Api_Key': ApiUrls.apiKey,
        };
      } else {
        headers = {
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $token',
          'accept': '*/*',
          'Api_Key': ApiUrls.apiKey,
        };
      }
      debugPrint('post url--> $url');
      debugPrint('token--> $token');
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      );
      request.headers.addAll(headers);
      if (files.isNotEmpty) {
        request.files.addAll(files);
      }

      request.fields.addAll(body);
      var response = await request.send().then((value) async {
        return await http.Response.fromStream(value);
      });
      debugPrint("postMultipart response--> ${response.body}");
      return _returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet connection');
    } on HttpException {
      throw FetchDataException('No Service found');
    } on FormatException {
      throw InvalidInputException('Bad response format');
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }

  Future<dynamic> getWithHeader(String url) async {
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'accept': '*/*',
        'Api_Key': ApiUrls.apiKey,
      });
      log(url, name: 'URL - - - - - ');
      log('${response.statusCode}', name: 'STATUS CODE - - - - - ');
      log(response.body, name: 'RESPONSE - - - - - ');
      return _returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet connection');
    } on HttpException {
      throw FetchDataException('No Service found');
    } on FormatException {
      throw InvalidInputException('Bad response format');
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }

  http.Response _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 201:
        return response;
      case 200:
        return response;
      case 400:
        return response;
      case 401:
        return response;
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<dynamic> getNutritionix(String url) async {
    token = PreferenceUtils.getString(prefToken);
    try {
      Map<String, String>? headers;
      headers = {
        'x-app-id': '10f24f16',
        'x-app-key': 'f6b94efc0c0a331c85d37a78368dea7d',
      };
      log(url, name: 'GET API URL');
      log(headers.toString(), name: 'GET API HEADER');
      final response = await http.get(Uri.parse(url), headers: headers);
      log(response.body, name: 'GET API RESPONSE');
      return _returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet connection');
    } on HttpException {
      throw FetchDataException('No Service found');
    } on FormatException {
      throw InvalidInputException('Bad response format');
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }

}
