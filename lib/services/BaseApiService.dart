import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import '../utils/CustomException.dart';
import '../utils/GlobalExceptionHandler.dart';

class BaseApiService {
  final String _baseUrl = 'https://ejalshakti.gov.in/krcpwa/api/';

  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    await _checkConnectivity();
    final Uri url = Uri.parse('$_baseUrl$endpoint');

    // Log the request
    log('POST Request: URL: $url');
    log('Headers: ${headers?.toString() ?? "No Headers"}');
    log('Body: ${body?.toString() ?? "No Body"}');

    try {
      final bool isJson =
          headers != null && headers['Content-Type'] == 'application/json';
      final response = await http.post(
        url,
        headers: headers,
        body: isJson ? jsonEncode(body) : body, // Encode only if JSON
      );
      if (response.statusCode == 200) {
        log('Request Successful');
      } else {
        log('Request Failed with Status Code: ${response.statusCode}');
      }

      // Log the response
      log('Response: ${response.statusCode}');
      log('Response Body: ${response.body}');

      return _processResponse(response);
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      throw NetworkException(
          'Unable to connect to server. Please check your internet connection.');
    } on NetworkException catch (e) {
      log('Error during network exception: $e');
      NetworkException(e.message);
    } on Exception catch (e) {
      log('Error during POST request: $e');
      GlobalExceptionHandler.handleException(e); // No context needed
    }
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final Uri url = Uri.parse('$_baseUrl$endpoint');

    // Log the request
    log('GET Request: URL: $url');
    log('Headers: ${headers?.toString() ?? "No Headers"}');

    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      // Log the response
      log('Response: ${response.statusCode}');
      log('Response Body: ${response.body}');

      return _processResponse(response);
    } on Exception catch (e) {
      log('Error during GET request: $e');
      GlobalExceptionHandler.handleException(e); // No context needed
      rethrow;
    }
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection
      throw NetworkException(
          'No internet connection. Please check your connection and try again.');
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw ApiException('Bad Request: ${response.body}');
      case 401:
        throw ApiException('Unauthorized: ${response.body}');
      case 500:
        throw ApiException('Internal Server Error: ${response.body}');
      default:
        throw ApiException('Unexpected error: ${response.statusCode}');
    }
  }
}
