import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import '../utils/CustomException.dart';

class BaseApiService {
  final String _baseUrl = 'https://ejalshakti.gov.in/wqmis/api/';
  static const String ejalShakti = "https://ejalshakti.gov.in/wqmis/api/";
  static const String reverseGeocoding = "https://reversegeocoding.nic.in/";
  static const String github = "https://api.github.com/repos/";

  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body, // Accepts raw JSON as string
  }) async {
    final Uri url = Uri.parse('$_baseUrl$endpoint');

    headers ??= {};
    headers.putIfAbsent('Content-Type', () => 'application/json');

    log('POST Request: URL: $url');
    log('POST_Request--- : ${body.toString()}');
    log('Headers: ${headers.toString()}');

    try {
      await _checkConnectivity();
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.headers['content-type']?.contains(',') ?? false) {
        response.headers['content-type'] = 'application/json; charset=utf-8';
      }

      log('Response Status Code: ${response.statusCode} : Headers: ${response.headers}');
      log('Response Body: ${response.body}');

      return _processResponse(response);
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      throw NetworkException('No internet connection');
    } catch (e) {
      log('Exception during GET request: $e');
      throw ApiException('');
    }
  }

  Future<dynamic> get(String endpoint,
      {ApiType apiType = ApiType.ejalShakti,
      Map<String, String>? headers}) async {
    final String baseUrl = getBaseUrl(apiType);
    final Uri url = Uri.parse('$baseUrl$endpoint');

    headers ??= {};
    headers.putIfAbsent('Content-Type', () => 'application/json');

    log('GET Request: URL: $url \n Headers: ${headers.toString()}');

    try {
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
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      throw NetworkException('No internet connection');
    } catch (e) {
      log('Exception during GET request: $e');
      throw ApiException('API Error : $e');
    }
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkException(
          'No internet connection. Please check your connection and try again.');
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw ApiException(
            'Bad Request ${handleErrorResp(response.body, '')}');
      case 404:
        throw ApiException('Page not found (404) ,Please contact to admin');
      case 401:
        throw ApiException(
            'Unauthorized ${handleErrorResp(response.body, '')}');
      case 500:
        throw ApiException(
            handleErrorResp(response.body, 'Internal Server Error'));
      case 502:
        throw ApiException(
            'Bad Gateway ${handleErrorResp(response.body, '')}');
      case 408:
        throw ApiException('Request Timeout : Please Try after some time');
      default:
        throw ApiException(
            'Unexpected error ${response.statusCode} \n ${handleErrorResp(response.body, '')}');
    }
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

enum ApiType {
  ejalShakti,
  reverseGeocoding,
  github,
}
