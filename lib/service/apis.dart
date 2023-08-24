import 'dart:convert';
import 'dart:io';
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
          e.toString());
    }
  }

  Future<http.Response> post(String url, dynamic body) async {
    try {
      final jsonBody = jsonEncode(body);
      final response = await http.post(Uri.parse(url),
          body: jsonBody,
          headers: {
            'Content-Type': 'application/json',
            'accept': '*/*',
            'Api_Key': ApiUrls.apiKey,
          },);
      return _returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet connection');
    } on HttpException {
      throw FetchDataException('No Service found');
    } on FormatException {
      throw InvalidInputException('Bad response format');
    } catch (e) {
      throw FetchDataException(
          e.toString());
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
          e.toString());
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
          e.toString());
    }
  }

  Future<http.Response> postWithCustomHeader(
    String url,
    dynamic body,
  ) async {

    try {
      body ??= {};
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
          e.toString());
    }
  }

  Future<http.Response> postMultipart(
      {required String url, required Map<String, String> body, required List<http.MultipartFile> files}) async {
    try {
      Map<String, String> header = {
        'content-type': 'multipart/form-data',
        'accept': '*/*',
        'Api_Key': ApiUrls.apiKey,
      };
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      );
      request.headers.addAll(header);
      if(files.isNotEmpty){
        request.files.addAll(files);
      }

      request.fields.addAll(body);
      var response = await request.send().then((value) async {
        return await http.Response.fromStream(value);
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
          e.toString());
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
          e.toString());
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
}
