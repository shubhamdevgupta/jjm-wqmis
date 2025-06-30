import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:jjm_wqmis/utils/Aesen.dart';
import 'package:jjm_wqmis/utils/UserSessionManager.dart';

import 'package:jjm_wqmis/utils/custom_screen/CustomException.dart';

class BaseApiService {
  final String _baseUrl = 'https://ejalshakti.gov.in/wqmis/api/';
  static const String ejalShakti = "https://ejalshakti.gov.in/wqmis/api/";
  static const String reverseGeocoding = "https://reversegeocoding.nic.in/";
  static const String github = "https://api.github.com/repos/";
  final encryption = AesEncryption(); // Put this at the top of your BaseApiService class


  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body, // Accepts raw JSON as string
  }) async {
    final Uri url = Uri.parse('$_baseUrl$endpoint');

    headers ??= {};
    headers.putIfAbsent('Content-Type', () => 'application/json');

    headers['APIKey'] = await getEncryptedToken();

    log('POST Request: URL: $url');
    log('POST_Request ency--- : ${body.toString()}');
    log('Headers: ${headers.toString()}');

      await _checkConnectivity();
      final response = await http.post(url, headers: headers, body: body,);

      if (response.headers['content-type']?.contains(',') ?? false) {
        response.headers['content-type'] = 'application/json; charset=utf-8';
      }

      log('Response Status Code: ${response.statusCode} : Headers: ${response.headers}');
      log('Response Body: ${response.body}');

      return _processResponse(response);
  }

  Future<dynamic> get(String endpoint,
      {ApiType apiType = ApiType.ejalShakti,
      Map<String, String>? headers}) async {
    final String baseUrl = getBaseUrl(apiType);
    final Uri url = Uri.parse('$baseUrl$endpoint');

    headers ??= {};
    headers.putIfAbsent('Content-Type', () => 'application/json');

    headers['APIKey'] = await getEncryptedToken();

    log('GET Request: URL: $url');
    log('GET Request: Headers: ${headers.toString()}');

      await _checkConnectivity();

      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.headers['content-type']?.contains(',') ?? false) {
        response.headers['content-type'] = 'application/json; charset=utf-8';
      }
      log('Response: ${response.statusCode} : Body: ${response.body}');

      return _processResponse(response);
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkException(
          'No internet connection. Please check your connection and try again.');
    }
  }


  dynamic _processResponse(http.Response response) {
    try {
      switch (response.statusCode) {
        case 200:
            final rawJson = json.decode(response.body);
            if (rawJson is Map<String, dynamic> && rawJson.containsKey('EncryptedData')) {
              final encryptedData = rawJson['EncryptedData'];
              final decryptedString = encryption.decryptText(encryptedData);
              final decryptedJson = json.decode(decryptedString);
              log('Decrypted Response:  ${decryptedString.toString()}');

              return decryptedJson;
            }
            return rawJson;

        case 400:
          throw ApiException(
              'Something went wrong with your request. Please check and try again.',
              response.statusCode.toString());

        case 401:
          throw ApiException(
              'Your session has expired or you are not authorized. Please log in again.',
              response.statusCode.toString());

        case 404:
          throw ApiException(
              'Oops! The page or service you’re trying to reach is not available. Please contact support.',
              response.statusCode.toString());

        case 408:
          throw ApiException(
              'The request timed out. Please check your connection and try again.',
              response.statusCode.toString());

        case 500:
          throw ApiException(
              'Server encountered an error. Please try again later.',
              response.statusCode.toString());

        case 502:
          throw ApiException(
              'We’re experiencing server issues. Please try again shortly.',
              response.statusCode.toString());

        default:
          throw ApiException(
              'Unexpected error occurred [${response.statusCode}]. Please try again.',
              response.statusCode.toString());
      }
    } catch (e) {
      if (e is AppException) {
        rethrow; // Let known exceptions pass through
      }
      throw ApiException('An unexpected error occurred: $e', response.statusCode.toString());
    }
  }


  String buildEncryptedQuery(Map<String, dynamic> params) {
    return params.entries.map((entry) {
      final key = entry.key;
      final value = encryption.encryptText(entry.value.toString());
      return "$key=$value";
    }).join("&");
  }

  String getBaseUrl(ApiType apiType) {
    switch (apiType) {
      case ApiType.ejalShakti:
        return ejalShakti;
      case ApiType.reverseGeocoding:
        return reverseGeocoding;
      case ApiType.github:
        return github;
    }
  }

  String handleErrorResp(String responseBody, String defMessage) {
    final Map<String, dynamic> jsonData = jsonDecode(responseBody);
    //   final String errType = jsonData['ExceptionType'] ?? '';
    final String message = jsonData['ExceptionMessage'] ?? defMessage;
    String res = " $message";
    return res;
  }


}


Map<String, dynamic> encryptJsonBody(Map<String, dynamic> json) {
  return json.map((key, value) {
    if (value == null || value.toString().trim().isEmpty) {
      // Skip encryption, keep it as is (or return empty string)
      return MapEntry(key, value);
    }
    var encryption = AesEncryption();
    final encryptedValue = encryption.encryptText(value.toString());
    return MapEntry(key, encryptedValue);
  });
}

// final encryptedBody = encryptDataClassBody(User(name: "Shakti", age: 25));   Make sure User have toJson() method
// body: jsonEncode(encryptedBody)  == > pass encryptedBody to post method by jsonEncode
Map<String, dynamic> encryptDataClassBody(dynamic input) {
  final Map<String, dynamic> rawMap = (input is Map<String, dynamic>) ? input : input.toJson();
  return encryptJsonBody(rawMap);
}

Future<String> getEncryptedToken() async {
  final session = UserSessionManager();

  await session.init();
  print("TOKEN :  ${session.token}");
  return session.token.toString();
}
enum ApiType {
  ejalShakti,
  reverseGeocoding,
  github,
}
