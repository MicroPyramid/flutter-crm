import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class NetworkService {
  static NetworkService _instance = new NetworkService.internal();
  NetworkService.internal();
  factory NetworkService() => _instance;
  var _connectivityResult;
  http.Response response;
  var client = http.Client();

  Future<http.Response> get(String url, {Map headers}) async {
    return client.get(url, headers: headers).then((http.Response response) {
      return handleResponse(response);
    });
  }

  Future<http.Response> post(String url, {Map headers, body, encoding}) {
    if (_connectivityResult == ConnectivityResult.none) {
      // response = Response(
      //   data: {
      //     'message' : 'Please check internet connection'
      //   },
      //   statusCode: 0
      // );
    } else {
      return client
          .post(url, headers: headers, body: body, encoding: encoding)
          .then((http.Response response) {
        return handleResponse(response);
      });
    }
  }

  Future<http.Response> put(String url, {Map headers, body, encoding}) {
    if (_connectivityResult == ConnectivityResult.none) {
      // response = Response(
      //   data: {
      //     'message' : 'Please check internet connection'
      //   },
      //   statusCode: 0
      // );
    } else {
      return client
          .put(url, headers: headers, body: body, encoding: encoding)
          .then((http.Response response) {
        return handleResponse(response);
      });
    }
  }

  Future<http.Response> delete(String url, {Map headers}) {
    if (_connectivityResult == ConnectivityResult.none) {
      // response = Response(
      //   data: {
      //     'message' : 'Please check internet connection'
      //   },
      //   statusCode: 0
      // );
    } else {
      return client
          .delete(url, headers: headers)
          .then((http.Response response) {
        return handleResponse(response);
      });
    }
  }

  http.Response handleResponse(http.Response response) {
    final int responseCode = response.statusCode;
    final responseBody = response.body;
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
