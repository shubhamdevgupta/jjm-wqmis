import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import '../utils/CustomException.dart';
import '../utils/GlobalExceptionHandler.dart';

class BaseApiService {
  final String _baseUrl = 'https://ejalshakti.gov.in/wqmis/api/';

  // POST Request Function
  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body, // Accepts raw JSON as string
  }) async {
    final Uri url = Uri.parse('$_baseUrl$endpoint');

    // Ensure headers are not null and set default Content-Type
    headers ??= {};
    headers.putIfAbsent('Content-Type', () => 'application/json');

    // Log the request
    log('POST Request: URL: $url');
    log('Headers: ${headers.toString()}');
    try {
      await _checkConnectivity();
      final response = await http.post(
        url,
        headers: headers,
        body: body, // Sending raw JSON body
      );

      if (response.headers['content-type']?.contains(',') ?? false) {
        response.headers['content-type'] = 'application/json; charset=utf-8';
      }

      // Logging the full response for better debugging
      log('Response Status Code: ${response.statusCode}');
      log('Response Headers: ${response.headers}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException("API Error: ${response.statusCode}");
      }
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      throw NetworkException('No internet connection');
    } catch (e) {
      log('Exception during POST request: $e');
      throw Exception('Error during POST request');
    }
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final Uri url = Uri.parse('$_baseUrl$endpoint');
    // Ensure headers are not null and set default Content-Type
    headers ??= {};
    headers.putIfAbsent('Content-Type', () => 'application/json');

    // Log the request
    log('GET Request: URL: $url');
    log('Headers: ${headers.toString()}');

    try {
      await _checkConnectivity();

      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.headers['content-type']?.contains(',') ?? false) {
        response.headers['content-type'] = 'application/json; charset=utf-8';
      }
      // Log the response
      log('Response: ${response.statusCode}');
      log('Response Body: ${response.body}');

      return _processResponse(response);
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      throw NetworkException('No internet connection');
    } catch (e) {
      log('Exception during GET request: $e');
      throw ApiException('Error during GET request $e');
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
      case 404:
        throw ApiException('Page not found: ${response.body}');
      case 401:
        throw ApiException('Unauthorized: ${response.body}');
      case 500:
        throw ApiException('Internal Server Error: ${response.body}');
      default:
        throw ApiException('Unexpected error: ${response.statusCode} - ${response.body}');
    }
  }
}
