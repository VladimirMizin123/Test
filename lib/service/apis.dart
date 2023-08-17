import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'api_urls.dart';

class ApiServices {

  Future<dynamic> get(String url) async {
    try {
      final response = await http.get(Uri.parse(url),headers: {
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
      throw FetchDataException(
          'Error occurred while Communication with Server with StatusCode : ${e.toString()}');
    }
  }

  Future<http.Response> post(String url, dynamic body) async {
    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode(body),
          headers: {
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
      throw FetchDataException(
          'Error occurred while Communication with Server with StatusCode : ${e.toString()}');
    }
  }

  Future<dynamic> put(String url, dynamic body) async {
    try {
      final response = await http.put(Uri.parse(url), body: body,headers: {
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
      throw FetchDataException(
          'Error occurred while Communication with Server with StatusCode : ${e.toString()}');
    }
  }

  Future<dynamic> delete(String url) async {
    try {
      final response = await http.delete(Uri.parse(url),headers: {
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
      throw FetchDataException(
          'Error occurred while Communication with Server with StatusCode : ${e.toString()}');
    }
  }

  Future<http.Response> postWithCustomHeader(
    String url,
    dynamic body,
  ) async {

    try {
      if (body == null) {
        body = {};
      }
      final response = await http
          .post(Uri.parse(url), body: jsonEncode(body), headers: {
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
      throw FetchDataException(
          'Error occurred while Communication with Server with StatusCode : ${e.toString()}');
    }
  }

  Future<http.Response> postMultipart(
      String url, Map<String, String> body, String file,
      {String? keyName}) async {
    try {
      final response =
          await http.MultipartRequest("POST", Uri.parse(url))
            ..files.add(await http.MultipartFile.fromPath(
              keyName ?? 'file',
              file,
            ))
            ..fields.addAll(body)
            ..headers.addAll({
              'content-type': 'application/json',
              'accept': '*/*',
              'Api_Key': ApiUrls.apiKey,
            });
      final res = await response.send().then((value) async {
        return await http.Response.fromStream(value);
      });

      return _returnResponse(res);
    } on SocketException {
      throw NoInternetException('No Internet connection');
    } on HttpException {
      throw FetchDataException('No Service found');
    } on FormatException {
      throw InvalidInputException('Bad response format');
    } catch (e) {
      throw FetchDataException(
          'Error occurred while Communication with Server with StatusCode : ${e.toString()}');
    }
  }

  Future<dynamic> getWithHeader(String url) async {
    try {
      final response = await http.get(Uri.parse(url), headers: {
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
      throw FetchDataException(
          'Error occurred while Communication with Server with StatusCode : ${e.toString()}');
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
        throw BadRequestException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
