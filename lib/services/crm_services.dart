import 'dart:convert';

import 'package:flutter_crm/bloc/account_bloc.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'network_services.dart';

class CrmService {
  NetworkService networkService = NetworkService();
  final baseUrl = 'https://bottlecrm.com/';
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
    return await networkService.post(baseUrl + 'api-common/registration/',
        body: data);
  }

  Future<Response> userLogin(headers, body) async {
    print(headers);
    print(body);
    return await networkService.post(baseUrl + 'api-common/login/',
        body: body, headers: getFormatedHeaders(headers));
  }

  Future<Response> validateSubdomain(data) async {
    return await networkService.post(baseUrl + 'api-common/validate-subdomain/',
        body: data);
  }

  Future<Response> getUserProfile() async {
    await updateHeaders();
    return await networkService.get(baseUrl + 'api-common/profile/',
        headers: getFormatedHeaders(_headers));
  }
}
