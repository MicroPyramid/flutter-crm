// import 'package:bottle_crm/bloc/setting_bloc.dart';
// import 'package:bottle_crm/model/document.dart';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:bottle_crm/ui/screens/http_excepion.dart';
import 'package:bottle_crm/config/api_config.dart';

import 'network_services.dart';

class CrmService {
  NetworkService networkService = NetworkService();
  String baseUrl = ApiConfig.getApiUrl();

  // Method to set custom API URL
  void setBaseUrl(String url) {
    baseUrl = url.endsWith('/') ? url : '$url/';
  }

  // Header handling now centralized in NetworkService
  // These methods are deprecated and will be removed

  Future<Response> userRegister(data) async {
    try {
      return await networkService.post(Uri.parse(baseUrl + 'auth/register/'),
          body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } on HandshakeException {
      throw HttpException("Server Issue");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> googleLogin(String idToken) async {
    try {
      print("=== GOOGLE LOGIN DEBUG ===");
      print("Base URL: $baseUrl");
      print("Full URL: ${baseUrl}auth/google/");
      print("ID Token length: ${idToken.length}");
      print("==========================");
      
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      return await networkService.post(Uri.parse(baseUrl + 'auth/google/'), 
          headers: headers,
          body: jsonEncode({'idToken': idToken}));
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } on FormatException {
      throw HttpException("server issue");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> validateSubdomain(data) async {
    try {
      return await networkService
          .post(Uri.parse(baseUrl + 'auth/validate-subdomain/'), body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> forgotPassword(data) async {
    try {
      return await networkService
          .post(Uri.parse(baseUrl + 'auth/forgot-password/'), body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> getUserProfile() async {
    try {
      return await networkService.get(Uri.parse(baseUrl + 'profile/'));
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> changePassword(data) async {
    try {
      return await networkService.post(
          Uri.parse(baseUrl + 'profile/change-password/'),
          body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> getCompanies() async {
    try {
      return await networkService.get(
          Uri.parse(baseUrl + 'auth/companies-list/'));
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> getDashboardDetails() async {
    try {
      return await networkService.get(Uri.parse(baseUrl + 'dashboard/'));
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
  ///////////////////// ACCONUTS-SERVICES ////////////////////////////

  Future<Response> getAccounts({queryParams, offset}) async {
    
    var url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString =
          Uri(queryParameters: Map<String, dynamic>.from(queryParams)).query;
      url = Uri.parse(baseUrl + 'accounts/' + '?' + queryString);
      if (offset != null && offset != "") {
        url = Uri.parse(url.toString() + '&offset=$offset');
      }
    } else {
      url = Uri.parse(baseUrl + 'accounts/');
      if (offset != null && offset != "") {
        url = Uri.parse(url.toString() + "?offset=$offset");
      }
    }
    print(url);
    return await networkService.get(url);
  }

  Future<Response> deleteAccount(id) async {
    try {
      
      return await networkService.delete(Uri.parse(baseUrl + 'accounts/$id/'),
          );
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> createAccount(data, File file) async {
    try {
      if (file.path == "") {
        
        return await networkService.post(Uri.parse(baseUrl + 'accounts/'),
            body: data);
      } else {
        var uri = Uri.parse(
          baseUrl + 'accounts/',
        );
        var request = http.MultipartRequest(
          'POST',
          uri,
        )
          ..fields.addAll(Map<String, String>.from(data))
          ..files.add(
              await http.MultipartFile.fromPath('document_file', 'assets/images/sentry_logo.png'));
        await networkService.addAuthHeadersToMultipartRequest(request);
        var response = await request.send();
        return await http.Response.fromStream(response);
      }
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> editAccount(data, id) async {
    try {
      
      return await networkService.put(Uri.parse(baseUrl + 'accounts/$id/'),
          body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> getToEditAccount(id) async {
    
    return await networkService.get(Uri.parse(baseUrl + 'accounts/$id/'),
        );
  }

  ///////////////////// CONTACTS-SERVICES ///////////////////////////////

  Future<Response> getContacts({queryParams, offset}) async {
    
    var url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString =
          Uri(queryParameters: Map<String, dynamic>.from(queryParams)).query;
      url = Uri.parse(baseUrl + 'contacts/' + '?' + queryString);
      if (offset != null && offset != "") {
        url = Uri.parse(url.toString() + '&offset=$offset');
      }
    } else {
      url = Uri.parse(baseUrl + 'contacts/');
      if (offset != null && offset != "") {
        url = Uri.parse(url.toString() + '?offset=$offset');
      }
    }
    print(url);
    return await networkService.get(url);
  }

  Future<Response> createContact(data, File file) async {
    try {
      if (file.path == "") {
        
        return await networkService.post(Uri.parse(baseUrl + 'contacts/'),
            body: data);
      } else {
        var uri = Uri.parse(
          baseUrl + 'contacts/',
        );
        var request = http.MultipartRequest(
          'POST',
          uri,
        );
        await networkService.addAuthHeadersToMultipartRequest(request);
        request.fields.addAll(Map<String, String>.from(data));
        request.files.add(
            await http.MultipartFile.fromPath('document_file', file.path));
        var response = await request.send();
        return await http.Response.fromStream(response);
      }
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> editContact(data, id) async {
    try {
      
      return await networkService.put(Uri.parse(baseUrl + 'contacts/$id/'),
          body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> deleteContact(id) async {
    try {
      
      return await networkService.delete(Uri.parse(baseUrl + 'contacts/$id/'),
          );
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  ///////////////////// LEADS-SERVICES ///////////////////////////////

  Future<Response> getLeads({queryParams, offset}) async {
    
    var url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString = Uri(
        queryParameters: queryParams,
      ).query;
      url = Uri.parse(baseUrl + 'leads/' + '?' + queryString);
      if (offset != null && offset != "") {
        url = Uri.parse(url.toString() + '&offset=$offset');
      }
    } else {
      url = Uri.parse(baseUrl + 'leads/');
      if (offset != null && offset != "") {
        url = Uri.parse(url.toString() + "?offset=$offset");
      }
    }
    print(url);
    return await networkService.get(url);
  }

  Future<Response> getLeadToUpdate(leadId) async {
    
    return await networkService.get(Uri.parse(baseUrl + 'leads/$leadId/'),
        );
  }

  Future<Response> createLead(data, File file) async {
    try {
      if (file.path == "") {
        
        return await networkService.post(Uri.parse(baseUrl + 'leads/'),
            body: data);
      } else {
        
        var uri = Uri.parse(
          baseUrl + 'leads/',
        );
        var request = http.MultipartRequest(
          'POST',
          uri,
        );
        await networkService.addAuthHeadersToMultipartRequest(request);
        request.fields.addAll(Map<String, String>.from(data));
        request.files.add(
            await http.MultipartFile.fromPath('document_file', file.path));
        var response = await request.send();
        return await http.Response.fromStream(response);
      }
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> editLead(data, id) async {
    try {
      
      return await networkService.put(Uri.parse(baseUrl + 'leads/$id/'),
          body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> deleteLead(id) async {
    try {
      
      return await networkService.delete(Uri.parse(baseUrl + 'leads/$id/'),
          );
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  ///////////////////// USERS-SERVICES ///////////////////////////////

  Future<Response> getUsers({Map? queryParams}) async {
    
    Uri url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString =
          Uri(queryParameters: Map<String, dynamic>.from(queryParams)).query;
      url = Uri.parse(baseUrl + 'users/' + '?' + queryString);
    } else {
      url = Uri.parse(baseUrl + 'users/');
    }
    return await networkService.get(url);
  }

  Future<Response> deleteUser(id) async {
    try {
      
      return await networkService.delete(Uri.parse(baseUrl + 'users/$id/'),
          );
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> createUser(user, File file) async {
    try {
      if (file.path == "") {
        
        return await networkService.post(Uri.parse(baseUrl + 'users/'),
            body: user);
      } else {
        
        var uri = Uri.parse(
          baseUrl + 'users/',
        );
        var request = http.MultipartRequest(
          'POST',
          uri,
        );
        await networkService.addAuthHeadersToMultipartRequest(request);
        request.fields.addAll(Map<String, String>.from(user));
        request.files.add(
            await http.MultipartFile.fromPath('document_file', file.path));
        var response = await request.send();
        return await http.Response.fromStream(response);
      }
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> editUser(user, id) async {
    try {
      
      return await networkService.put(Uri.parse(baseUrl + 'users/$id/'),
          body: user);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }


  ///////////////////// Events-SERVICES ///////////////////////////////

  Future<Response> getEvents({Map? queryParams}) async {
    
    Uri url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString =
          Uri(queryParameters: Map<String, dynamic>.from(queryParams)).query;
      url = Uri.parse(baseUrl + 'events/' + '?' + queryString);
    } else {
      url = Uri.parse(baseUrl + 'events/');
    }
    print(url);
    return await networkService.get(url);
  }

  Future<Response> deleteEvent(id) async {
    try {
      
      return await networkService.delete(Uri.parse(baseUrl + 'events/$id/'),
          );
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> createEvent(user) async {
    try {
        
        return await networkService.post(Uri.parse(baseUrl + 'events/'),
            body: user);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> editEvent(user, id) async {
    try {
      
      return await networkService.put(Uri.parse(baseUrl + 'events/$id/'),
          body: user);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  ///////////////////// DOCUMENTS-SERVICES ///////////////////////////////

  Future<Response> getDocuments({queryParams}) async {
    
    String url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString = Uri(
        queryParameters: queryParams,
      ).query;
      url = baseUrl + 'documents/' + '?' + queryString;
    } else {
      url = baseUrl + 'documents/';
    }
    return await networkService.get(url);
  }

  getFileSizes(files) {
    List _fileSizeList = [];
    // files.forEach((Document file) async {
    //   http.Response r = await http.head(Uri.parse(file.documentFile));
    //   if (r.headers['content-length'] != null) {
    //     String fileSize = r.headers['content-length'].toString();
    //     _fileSizeList.add([file.id, fileSize]);
    //   } else {
    //     _fileSizeList.add([file.id, "0"]);
    //   }
    // });
    // print(_fileSizeList);
    return _fileSizeList;
  }

  Future createDocument(document, PlatformFile file) async {
    try {
      
      var uri = Uri.parse(
        baseUrl + 'documents/',
      );
      var request = http.MultipartRequest(
        'POST',
        uri,
      );
      await networkService.addAuthHeadersToMultipartRequest(request);
      request.fields.addAll({
        'title': document['title'],
        'teams': document['teams'],
        'shared_to': document['shared_to']
      });
      request.files.add(
          await http.MultipartFile.fromPath('document_file', file.path!));
      final response = await request.send();
      return await response.stream.bytesToString();
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future editDocument(document, PlatformFile file, id) async {
    
    var uri = Uri.parse(
      baseUrl + 'documents/$id/',
    );
    var request = http.MultipartRequest(
      'PUT',
      uri,
    );
    await networkService.addAuthHeadersToMultipartRequest(request);
    request.fields.addAll({
      'title': document['title'],
      'teams': document['teams'],
      'shared_to': document['shared_to'],
      'status': document['status']
    });
    request.files
        .add(await http.MultipartFile.fromPath('document_file', file.path!));
    return await request.send();
  }

  Future<Response> deleteDocument(id) async {
    try {
      
      return await networkService.delete(Uri.parse(baseUrl + 'documents/$id/'),
          );
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  ///////////////////// TEAMS-SERVICES ///////////////////////////////

  Future<Response> getTeams({queryParams, offset}) async {
    
    Uri url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value.runtimeType != String);
      queryParams.removeWhere((key, value) => value == "[]");
      queryParams.removeWhere((key, value) => value == "");
      queryParams.removeWhere((key, value) => value == null);
      String queryString =
          Uri(queryParameters: Map<String, dynamic>.from(queryParams)).query;
      url = Uri.parse(baseUrl + 'teams/' + '?' + queryString);
      if (offset != null && offset != "") {
        url = Uri.parse(url.toString() + '&offset=$offset');
      }
    } else {
      url = Uri.parse(baseUrl + 'teams/');
      if (offset != null && offset != "") {
        url = Uri.parse(url.toString() + '?offset=$offset');
      }
    }
    print(url);
    return await networkService.get(url);
  }

  Future<Response> createTeam(data) async {
    try {
      data.removeWhere((key, value) => value == "[]");
      data.removeWhere((key, value) => value == "");
      data.removeWhere((key, value) => value == null);
      
      return await networkService.post(Uri.parse(baseUrl + 'teams/'),
          body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> deleteTeam(id) async {
    
    return await networkService.delete(Uri.parse(baseUrl + 'teams/$id/'),
        );
  }

  Future<Response> editTeam(
    data,
    id,
  ) async {
    
    data.removeWhere((key, value) => value == "[]");
    data.removeWhere((key, value) => value == "");
    data.removeWhere((key, value) => value == null);
    return await networkService.put(Uri.parse(baseUrl + 'teams/$id/'),
        body: data);
  }

  ///////////////////// OPPORTUNITIES-SERVICES ////////////////////////////

  Future<Response> getOpportunities({queryParams, offset}) async {
    
    Uri url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString =
          Uri(queryParameters: Map<String, dynamic>.from(queryParams)).query;
      url = Uri.parse(baseUrl + 'opportunities/' + '?' + queryString);
      if (offset != null && offset != "") {
        url = Uri.parse(url.toString() + '&offset=$offset');
      }
    } else {
      url = Uri.parse(baseUrl + 'opportunities/');
      if (offset != null && offset != "") {
        url = Uri.parse(url.toString() + '?offset=$offset');
      }
    }
    print(url);
    return await networkService.get(url);
  }

  Future<Response> deletefromModule(moduleName, id) async {
    try {
      
      return await networkService.delete(
          Uri.parse(baseUrl + '$moduleName/$id/'),
          );
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  // Future createOpportunity(opportunity, [PlatformFile file]) async {
  //   file = null;
  //   
  //   var uri = Uri.parse(
  //     baseUrl + 'opportunities/',
  //   );
  //   var request = http.MultipartRequest(
  //     'POST',
  //     uri,
  //   )
  //     // Headers automatically added by NetworkService
  //     ..fields.addAll({
  //       'name': opportunity['name'],
  //       'account': opportunity['account'],
  //       'amount': opportunity['amount'],
  //       'currency': opportunity['currency'],
  //       'stage': opportunity['stage'],
  //       'lead_source': opportunity['lead_source'],
  //       'probability': opportunity['probability'],
  //       'description': opportunity['description'],
  //       'teams': opportunity['teams'],
  //       'assigned_to': opportunity['assigned_to'],
  //       'contacts': opportunity['contacts'],
  //       'due_date': opportunity['due_date'],
  //       'tags': opportunity['tags'],
  //     });
  //   if (file != null) {
  //     request.files.add(await http.MultipartFile.fromPath(
  //         'opportunity_attachment', file.path));
  //   }
  //   final response = await request.send();
  //   return await response.stream.bytesToString();
  // }

  Future<Response> createOpportunity(data, File file) async {
    try {
      if (file.path == "") {
        data.removeWhere((key, value) => value == "[]");
        data.removeWhere((key, value) => value == "");
        data.removeWhere((key, value) => value == null);
        
        return await networkService.post(Uri.parse(baseUrl + 'opportunities/'),
            body: data);
      } else {
        
        var uri = Uri.parse(
          baseUrl + 'opportunities/',
        );
        var request = http.MultipartRequest(
          'POST',
          uri,
        );
        await networkService.addAuthHeadersToMultipartRequest(request);
        request.fields.addAll(Map<String, String>.from(data));
        request.files.add(
            await http.MultipartFile.fromPath('document_file', file.path));
        var response = await request.send();
        return await http.Response.fromStream(response);
      }
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> editOpportunity(data, id, [PlatformFile? file]) async {
    try {
      
      data.removeWhere((key, value) => value == "[]");
      data.removeWhere((key, value) => value == "");
      data.removeWhere((key, value) => value == null);
      return await networkService.put(Uri.parse(baseUrl + 'opportunities/$id/'),
          body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  // Future editOpportunity(opportunity, id, [PlatformFile file]) async {
  //   
  //   var uri = Uri.parse(
  //     baseUrl + 'opportunities`/$id/',
  //   );

  //   var request = http.MultipartRequest(
  //     'PUT',
  //     uri,
  //   )
  //     // Headers automatically added by NetworkService
  //     ..fields.addAll({
  //       'name': opportunity['name'],
  //       'account': opportunity['account'],
  //       'amount': opportunity['amount'],
  //       'currency': opportunity['currency'],
  //       'stage': opportunity['stage'],
  //       'lead_source': opportunity['lead_source'],
  //       'probability': opportunity['probability'],
  //       'description': opportunity['description'],
  //       'teams': opportunity['teams'],
  //       'assigned_to': opportunity['assigned_to'],
  //       'contacts': opportunity['contacts'],
  //       'tags': opportunity['tags'],
  //     })
  //     // ..files.add(await http.MultipartFile.fromPath(
  //     //     'opportunity_attachment', file.path))
  //         ;
  //   final response = await request.send();
  //   return await response.stream.bytesToString();

  ///////////////////// TASKS-SERVICES ///////////////////////////////

  Future<Response> getTasks({queryParams, offset}) async {
    
    Uri? url;
    if (queryParams != null) {
      String queryString =
          Uri(queryParameters: Map<String, dynamic>.from(queryParams)).query;
      url = Uri.parse(baseUrl + 'tasks/' + '?' + queryString);
      if (offset != null && offset != "") {
        url = Uri.parse(url.toString() + '&offset=$offset');
      }
    } else {
      if (offset != null && offset != "") {
        url = Uri.parse(url.toString() + '?offset=$offset');
      }
      url = Uri.parse(baseUrl + 'tasks/');
    }
    print(url);
    return await networkService.get(url);
  }

  Future<Response> createTask(data) async {
    try {
      
      data.removeWhere((key, value) => value == "[]");
      data.removeWhere((key, value) => value == "");
      data.removeWhere((key, value) => value == null);
      return await networkService.post(Uri.parse(baseUrl + 'tasks/'),
          body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> editTask(data, id) async {
    
    data.removeWhere((key, value) => value == "[]");
    data.removeWhere((key, value) => value == "");
    data.removeWhere((key, value) => value == null);
    return await networkService.put(Uri.parse(baseUrl + 'tasks/$id/'),
        body: data);
  }

  Future<Response> deleteTask(id) async {
    
    return await networkService.delete(Uri.parse(baseUrl + 'tasks/$id/'),
        );
  }

  ///////////////////// SETTINGS-SERVICES ///////////////////////////////

  Future<Response> getApiSettings({queryParams, offset}) async {
    
    Uri? url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString =
          Uri(queryParameters: Map<String, dynamic>.from(queryParams)).query;
      url = Uri.parse(baseUrl + 'api-settings/' + '?' + queryString);
      if (offset != null && offset != "") {
        url = Uri.parse(url.toString() + '&offset=$offset');
      }
    } else {
      if (offset != null && offset != "") {
        url = Uri.parse(url.toString() + '?offset=$offset');
      }
      url = Uri.parse(baseUrl + 'api-settings/');
    }
    print(url);
    return await networkService.get(url);
  }

  /// CONTACTS
  Future<Response> getSettingsContacts({queryParams}) async {
    
    String url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString =
          Uri(queryParameters: Map<String, dynamic>.from(queryParams)).query;
      url = baseUrl + 'settings/contacts/' + '?' + queryString;
    } else {
      url = baseUrl + 'settings/contacts/';
    }
    return await networkService.get(url);
  }

  Future<Response> deleteSettingsContacts(id) async {
    
    return await networkService.delete(
        Uri.parse(baseUrl + 'settings/contacts/$id/'),
        );
  }

  /// BLOCKED DOMAINS
  Future<Response> getBlockedDomains({queryParams}) async {
    
    String url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString =
          Uri(queryParameters: Map<String, dynamic>.from(queryParams)).query;
      url = baseUrl + 'settings/block-domains/' + '?' + queryString;
    } else {
      url = baseUrl + 'settings/block-domains/';
    }
    return await networkService.get(url);
  }

  Future<Response> deleteBlockedDomains(id) async {
    
    return await networkService.delete(
        Uri.parse(baseUrl + 'settings/block-domains/$id/'),
        );
  }

  /// BLOCKED EMAILS
  Future<Response> getBlockedEmails({queryParams}) async {
    
    String url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString =
          Uri(queryParameters: Map<String, dynamic>.from(queryParams)).query;
      url = baseUrl + 'settings/block-emails/' + '?' + queryString;
    } else {
      url = baseUrl + 'settings/block-emails/';
    }
    return await networkService.get(url);
  }

  Future<Response> deleteBlockedEmails(id) async {
    
    return await networkService.delete(
        Uri.parse(baseUrl + 'settings/block-emails/$id/'),
        );
  }

  Future<Response> createSetting(data) async {
    try {
      
      data.removeWhere((key, value) => value == "[]");
      data.removeWhere((key, value) => value == "");
      data.removeWhere((key, value) => value == null);
      String _url;
      // if (settingsBloc.currentSettingsTab == "Contacts") {
      _url = '/settings/contacts';
      // } else if (settingsBloc.currentSettingsTab == "Blocked Domains") {
      //   _url = '/settings/block-domains';
      // } else {
      //   _url = '/settings/block-emails';
      // }
      return await networkService.post(Uri.parse(baseUrl + '$_url/'),
          body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> editSetting(data, id) async {
    
    data.removeWhere((key, value) => value == "[]");
    data.removeWhere((key, value) => value == "");
    data.removeWhere((key, value) => value == null);
    String _url;
    // if (settingsBloc.currentSettingsTab == "Contacts") {
    _url = '/settings/contacts';
    // } else if (settingsBloc.currentSettingsTab == "Blocked Domains") {
    //   _url = '/settings/block-domains';
    // } else {
    //   _url = '/settings/block-emails';
    // }
    return await networkService.put(Uri.parse(baseUrl + '$_url/$id/'),
        body: data);
  }

  ///////////////////// CASES-SERVICES ///////////////////////////////

  Future<Response> getCases({queryParams, offset}) async {
    
    Uri url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      queryParams.removeWhere((key, value) => value == null);
      queryParams.removeWhere((key, value) => value == []);

      String queryString =
          Uri(queryParameters: Map<String, dynamic>.from(queryParams)).query;
      url = Uri.parse(baseUrl + 'cases/' + '?' + queryString);
      if (offset != null && offset != "") {
        url = Uri.parse(url.toString() + '&offset=$offset');
      }
    } else {
      url = Uri.parse(baseUrl + 'cases/');
      if (offset != null && offset != "") {
        url = Uri.parse(url.toString() + '?offset=$offset');
      }
    }
    print(url);
    return await networkService.get(url);
  }

  Future<Response> createCase(data, File file) async {
    try {
      if (file.path == "") {
        // data.removeWhere((key, value) => value == "[]");
        // data.removeWhere((key, value) => value == "");
        data.removeWhere((key, value) => value == null);
        
        return await networkService.post(Uri.parse(baseUrl + 'cases/'),
            body: data);
      } else {
        
        var uri = Uri.parse(
          baseUrl + 'leads/',
        );
        var request = http.MultipartRequest(
          'POST',
          uri,
        );
        await networkService.addAuthHeadersToMultipartRequest(request);
        request.fields.addAll(Map<String, String>.from(data));
        request.files.add(
            await http.MultipartFile.fromPath('document_file', file.path));
        var response = await request.send();
        return await http.Response.fromStream(response);
      }
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> editCase(data, id, [PlatformFile? file]) async {
    try {
      
      // data.removeWhere((key, value) => value == "[]");
      // data.removeWhere((key, value) => value == "");
      data.removeWhere((key, value) => value == null);
      return await networkService.put(Uri.parse(baseUrl + 'cases/$id/'),
          body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
}
