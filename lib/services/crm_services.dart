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

  Future<Response> changePassword(data) async {
    await updateHeaders();
    return await networkService.post(baseUrl + 'profile/change-password/',
        headers: getFormatedHeaders(_headers), body: data);
  }

  Future<Response> getDashboardDetails() async {
    await updateHeaders();
    return await networkService.get(baseUrl + 'dashboard/',
        headers: getFormatedHeaders(_headers));
  }
  ///////////////////// ACCONUTS-SERVICES ////////////////////////////

  Future<Response> getAccounts({queryParams}) async {
    await updateHeaders();
    String url;
    if (queryParams != null) {
      String queryString =
          Uri(queryParameters: getFormatedHeaders(queryParams)).query;
      url = baseUrl + 'accounts/' + '?' + queryString;
    } else {
      url = baseUrl + 'accounts/';
    }
    return await networkService.get(url, headers: getFormatedHeaders(_headers));
  }

  Future<Response> deleteAccount(id) async {
    await updateHeaders();
    return await networkService.delete(baseUrl + 'accounts/$id/',
        headers: getFormatedHeaders(_headers));
  }

  Future<Response> createAccount(contact) async {
    await updateHeaders();
    return await networkService.post(baseUrl + 'accounts/',
        headers: getFormatedHeaders(_headers), body: contact);
  }

  Future<Response> editAccount(data, id) async {
    await updateHeaders();
    return await networkService.put(baseUrl + 'accounts/$id/',
        headers: getFormatedHeaders(_headers), body: data);
  }

  Future<Response> getToEditAccount(id) async {
    await updateHeaders();
    return await networkService.get(baseUrl + 'accounts/$id/',
        headers: getFormatedHeaders(_headers));
  }

  ///////////////////// CONTACTS-SERVICES ///////////////////////////////

  Future<Response> getContacts() async {
    await updateHeaders();
    return await networkService.get(baseUrl + 'contacts/',
        headers: getFormatedHeaders(_headers));
  }

  ///////////////////// LEADS-SERVICES ///////////////////////////////

  Future<Response> getLeads({queryParams}) async {
    await updateHeaders();
    String url;
    if (queryParams != null) {
      String queryString =
          Uri(queryParameters: getFormatedHeaders(queryParams)).query;
      url = baseUrl + 'leads/' + '?' + queryString;
    } else {
      url = baseUrl + 'leads/';
    }
    return await networkService.get(url, headers: getFormatedHeaders(_headers));
  }

  Future<Response> getLeadToUpdate(leadId) async {
    await updateHeaders();
    return await networkService.get(baseUrl + 'leads/$leadId/',
        headers: getFormatedHeaders(_headers));
  }

  Future<Response> createLead(data) async {
    await updateHeaders();
    return await networkService.post(baseUrl + 'leads/',
        headers: getFormatedHeaders(_headers), body: data);
  }

  Future<Response> editLead(data, id) async {
    await updateHeaders();
    return await networkService.put(baseUrl + 'leads/$id/',
        headers: getFormatedHeaders(_headers), body: data);
  }

  Future<Response> deleteLead(id) async {
    await updateHeaders();
    return await networkService.delete(baseUrl + 'leads/$id/',
        headers: getFormatedHeaders(_headers));
  }

  ///////////////////// TEAMS-SERVICES ///////////////////////////////

  Future<Response> getTeams() async {
    await updateHeaders();
    return await networkService.get(baseUrl + 'users/get-teams-and-users/',
        headers: getFormatedHeaders(_headers));
  }
}
