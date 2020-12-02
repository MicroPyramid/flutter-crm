import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'network_services.dart';

class CrmService {
  NetworkService networkService = NetworkService();
  final baseUrl = 'https://bottlecrm.com/api/';
  Map _headers = {"Authorization": "", "company": ""};

  updateHeaders() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    _headers['Authorization'] = preferences.getString("authToken");
    _headers['company'] = preferences.getString("subdomain");
  }

  getFormatedHeaders(headers) {
    return new Map<String, String>.from(headers);
  }

  Future<Response> userRegister(data) async {
    return await networkService.post(baseUrl + 'auth/register/', body: data);
  }

  Future<Response> userLogin(headers, body) async {
    print(headers);
    print(body);
    return await networkService.post(baseUrl + 'auth/login/',
        body: body, headers: getFormatedHeaders(headers));
  }

  Future<Response> validateSubdomain(data) async {
    return await networkService.post(baseUrl + 'auth/validate-subdomain/',
        body: data);
  }

  Future<Response> forgotPassword(data) async {
    return await networkService.post(baseUrl + 'auth/forgot-password/',
        body: data);
  }

  Future<Response> getUserProfile() async {
    await updateHeaders();
    return await networkService.get(baseUrl + 'profile/',
        headers: getFormatedHeaders(_headers));
  }

  Future<Response> getDashboardDetails() async {
    await updateHeaders();
    return await networkService.get(baseUrl + 'dashboard/',
        headers: getFormatedHeaders(_headers));
  }

  Future<Response> changePassword(data) async {
    await updateHeaders();
    return await networkService.post(baseUrl + 'profile/change-password/',
        headers: getFormatedHeaders(_headers), body: data);
  }
}
