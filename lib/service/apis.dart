import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'api_urls.dart';

class ApiServices {
  String token = PreferenceUtils.getString(prefToken);

  Future<dynamic> get(String url,
      {Map<String, dynamic>? body, Map<String, dynamic>? queryParams}) async {
    token = PreferenceUtils.getString(prefToken);

    log("token:$token");
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

      if (body != null) {
        headers.addAll(
          {
            'Content-Type': 'application/json',
          },
        );

        http.Request req = http.Request('GET', Uri.parse(url));
        req.body = jsonEncode(body);
        req.headers.addAll(headers);

        var response = await req.send();
        log(response.statusCode.toString());

        if (response.statusCode == 200) {
          return http.Response(
            await response.stream.bytesToString(),
            response.statusCode,
            reasonPhrase: response.reasonPhrase,
          );
        }
        return http.Response(
          await response.stream.bytesToString(),
          response.statusCode,
          reasonPhrase: response.reasonPhrase,
        );
      }

      Uri uri = Uri.parse(url + _getParamsFromBody(queryParams ?? {}));
      final response = await http.get(uri, headers: headers);
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

  String _getParamsFromBody(Map<String, dynamic> body) {
    String params = body.isNotEmpty ? '?' : '';
    for (var i = 0; i < body.keys.length; i++) {
      params += '${List.from(body.keys)[i]}=${List.from(body.values)[i]}';
      if (i != body.keys.length - 1) {
        params += '&';
      }
    }
    return params;
  }

  Future<http.Response> post(String url, dynamic body,
      {bool customToast = false}) async {
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

      log("token:$token");
      print("token:$token");

      final jsonBody = jsonEncode(body);
      final response = await http.post(
        Uri.parse(url),
        body: jsonBody,
        headers: headers,
      );

      return _returnResponse(response);
    } on SocketException catch (e) {
      if (customToast) {
        showToast(message: "$url->${e.toString()}", isSuccess: false);
      }
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
      // log(url, name: 'DELETE API URL :');
      final response = await http.delete(Uri.parse(url), headers: headers);

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

  Future<http.Response> putMultipart(
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
        'PUT',
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
        'x-app-id': '51a8f429',
        'x-app-key': '1bdfc5b3d78b1efd1afb642db79892cd',
      };
      log(url, name: 'GET API URL');

      final response = await http.get(Uri.parse(url), headers: headers);

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
