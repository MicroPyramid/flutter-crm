import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:bottle_crm/ui/screens/http_excepion.dart';

class NetworkService {
  static NetworkService _instance = new NetworkService.internal();
  factory NetworkService() => _instance;
  http.Response? response;
  var client = http.Client();

  NetworkService.internal();

  Future<http.Response> get(var url, {Map<String, String>? headers}) async {
    try {
      return client.get(url, headers: headers).then((http.Response response) {
        return handleResponse(response);
      });
    } on SocketException {
      print("=======socket exceptiom");
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      print("=======ache");
      throw HttpException("Something Went Wrong");
    } finally {
      // client.close();
    }
  }

  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, body, encoding}) {
    try {
      return client
          .post(url, headers: headers, body: body, encoding: encoding)
          .then((http.Response response) {
        return handleResponse(response);
      });
    } on FormatException {
      print("=========Format Excepion");
      throw HttpException("Server issue");
    } on SocketException {
      print("=======socket exceptiom");
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      print("=======ache");
      throw HttpException("Something Went Wrongggg");
    } finally {
      // client.close();
    }
  }

  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, body, encoding}) {
    try {
      return client
          .put(url, headers: headers, body: body, encoding: encoding)
          .then((http.Response response) {
        return handleResponse(response);
      });
    } finally {
      // client.close();
    }
  }

  Future<http.Response> delete(Uri url, {Map<String, String>? headers}) {
    try {
      return client
          .delete(url, headers: headers)
          .then((http.Response response) {
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
