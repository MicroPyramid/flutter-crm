import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:bottle_crm/ui/screens/http_excepion.dart';

class NetworkService {
  static NetworkService _instance = new NetworkService.internal();
  factory NetworkService() => _instance;
  http.Response? response;
  var client = http.Client();

  NetworkService.internal();

  // Helper method to print long strings in chunks
  void _printLongString(String title, String content) {
    const int chunkSize = 800;
    print(title);
    if (content.length <= chunkSize) {
      print(content);
    } else {
      for (int i = 0; i < content.length; i += chunkSize) {
        int endIndex = (i + chunkSize < content.length) ? i + chunkSize : content.length;
        print("${content.substring(i, endIndex)}");
      }
    }
  }

  Future<http.Response> get(var url, {Map<String, String>? headers}) async {
    try {
      // Log request details
      print("=== GET REQUEST ===");
      print("URL: $url");
      print("Headers: $headers");
      print("==================");
      
      return client.get(url, headers: headers).then((http.Response response) {
        // Log response details
        print("=== GET RESPONSE ===");
        print("Status Code: ${response.statusCode}");
        print("Response Headers: ${response.headers}");
        _printLongString("Response Body:", response.body);
        print("===================");
        
        return handleResponse(response);
      });
    } on SocketException {
      print("=======Socket Exception");
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      print("=======Exception: $e");
      throw HttpException("Something Went Wrong");
    } finally {
      // client.close();
    }
  }

  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, body, encoding}) {
    try {
      // Log request details
      print("=== POST REQUEST ===");
      print("URL: $url");
      print("Headers: $headers");
      _printLongString("Body:", body?.toString() ?? "null");
      print("==================");
      
      return client
          .post(url, headers: headers, body: body, encoding: encoding)
          .then((http.Response response) {
        // Log response details
        print("=== POST RESPONSE ===");
        print("Status Code: ${response.statusCode}");
        print("Response Headers: ${response.headers}");
        _printLongString("Response Body:", response.body);
        print("====================");
        
        return handleResponse(response);
      });
    } on FormatException {
      print("=========Format Exception");
      throw HttpException("Server issue");
    } on SocketException {
      print("=======Socket Exception");
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      print("=======Exception: $e");
      throw HttpException("Something Went Wrong");
    } finally {
      // client.close();
    }
  }

  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, body, encoding}) {
    try {
      // Log request details
      print("=== PUT REQUEST ===");
      print("URL: $url");
      print("Headers: $headers");
      _printLongString("Body:", body?.toString() ?? "null");
      print("==================");
      
      return client
          .put(url, headers: headers, body: body, encoding: encoding)
          .then((http.Response response) {
        // Log response details
        print("=== PUT RESPONSE ===");
        print("Status Code: ${response.statusCode}");
        print("Response Headers: ${response.headers}");
        _printLongString("Response Body:", response.body);
        print("===================");
        
        return handleResponse(response);
      });
    } finally {
      // client.close();
    }
  }

  Future<http.Response> delete(Uri url, {Map<String, String>? headers}) {
    try {
      // Log request details
      print("=== DELETE REQUEST ===");
      print("URL: $url");
      print("Headers: $headers");
      print("=====================");
      
      return client
          .delete(url, headers: headers)
          .then((http.Response response) {
        // Log response details
        print("=== DELETE RESPONSE ===");
        print("Status Code: ${response.statusCode}");
        print("Response Headers: ${response.headers}");
        _printLongString("Response Body:", response.body);
        print("======================");
        
        return handleResponse(response);
      });
    } finally {
      // client.close();
    }
  }

  http.Response handleResponse(http.Response response) {
    return response;
  }

  // Future<Response> get(String url, {Map headers, Map queryParameters}) async {
  //   _connectivityResult = await (Connectivity().checkConnectivity());
  //   if(_connectivityResult == ConnectivityResult.none) {
  //     response = Response(
  //       data: {
  //         'message' : 'Please check internet connection'
  //       },
  //       statusCode: 0
  //     );
  //   } else {
  //     response = await dio.get(url, options: Options(headers: headers), queryParameters: queryParameters);
  //   }
  //   return handleResponse(response);
  // }
}
