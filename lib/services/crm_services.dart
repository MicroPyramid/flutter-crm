// import 'package:bottle_crm/bloc/setting_bloc.dart';
// import 'package:bottle_crm/model/document.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bottle_crm/ui/screens/http_excepion.dart';

import 'network_services.dart';

class CrmService {
  NetworkService networkService = NetworkService();
  // final baseUrl = 'https://bottlecrm.com/api/';
  final baseUrl = 'https://api.bottle-dev.com/api/';
  Map _headers = {};

  updateHeaders() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    _headers['Authorization'] = preferences.getString('authToken');
    if (preferences.getString('org') != null) {
      _headers['org'] = preferences.getString('org');
    }
  }

  getFormatedHeaders(headers) {
    return new Map<String, String>.from(headers);
  }

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

  Future<Response> userLogin(body) async {
    try {
      return await networkService.post(Uri.parse(baseUrl + 'auth/login/'),
          body: body);
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
      await updateHeaders();
      return await networkService.get(Uri.parse(baseUrl + 'profile/'),
          headers: await getFormatedHeaders(_headers));
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> changePassword(data) async {
    try {
      await updateHeaders();
      return await networkService.post(
          Uri.parse(baseUrl + 'profile/change-password/'),
          headers: getFormatedHeaders(_headers),
          body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> getCompanies() async {
    try {
      await updateHeaders();
      return await networkService.get(
          Uri.parse(baseUrl + 'auth/companies-list/'),
          headers: await getFormatedHeaders(_headers));
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> getDashboardDetails() async {
    try {
      await updateHeaders();
      return await networkService.get(Uri.parse(baseUrl + 'dashboard/'),
          headers: await getFormatedHeaders(_headers));
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
  ///////////////////// ACCONUTS-SERVICES ////////////////////////////

  Future<Response> getAccounts({queryParams, offset}) async {
    await updateHeaders();
    var url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString =
          Uri(queryParameters: getFormatedHeaders(queryParams)).query;
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
    return await networkService.get(url, headers: getFormatedHeaders(_headers));
  }

  Future<Response> deleteAccount(id) async {
    try {
      await updateHeaders();
      return await networkService.delete(Uri.parse(baseUrl + 'accounts/$id/'),
          headers: getFormatedHeaders(_headers));
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> createAccount(data, File file) async {
    try {
      if (file.path == "") {
        await updateHeaders();
        return await networkService.post(Uri.parse(baseUrl + 'accounts/'),
            headers: getFormatedHeaders(_headers), body: data);
      } else {
        var uri = Uri.parse(
          baseUrl + 'accounts/',
        );
        var request = http.MultipartRequest(
          'POST',
          uri,
        )
          ..headers.addAll(getFormatedHeaders(_headers))
          ..fields.addAll(Map<String, String>.from(data))
          ..files.add(
              await http.MultipartFile.fromPath('document_file', 'assets/images/sentry_logo.png'));
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
      await updateHeaders();
      return await networkService.put(Uri.parse(baseUrl + 'accounts/$id/'),
          headers: getFormatedHeaders(_headers), body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> getToEditAccount(id) async {
    await updateHeaders();
    return await networkService.get(baseUrl + 'accounts/$id/',
        headers: getFormatedHeaders(_headers));
  }

  ///////////////////// CONTACTS-SERVICES ///////////////////////////////

  Future<Response> getContacts({queryParams, offset}) async {
    await updateHeaders();
    var url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString =
          Uri(queryParameters: getFormatedHeaders(queryParams)).query;
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
    return await networkService.get(url, headers: getFormatedHeaders(_headers));
  }

  Future<Response> createContact(data, File file) async {
    try {
      if (file.path == "") {
        await updateHeaders();
        return await networkService.post(Uri.parse(baseUrl + 'contacts/'),
            headers: getFormatedHeaders(_headers), body: data);
      } else {
        var uri = Uri.parse(
          baseUrl + 'contacts/',
        );
        var request = http.MultipartRequest(
          'POST',
          uri,
        )
          ..headers.addAll(getFormatedHeaders(_headers))
          ..fields.addAll(Map<String, String>.from(data))
          ..files.add(
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
      await updateHeaders();
      return await networkService.put(Uri.parse(baseUrl + 'contacts/$id/'),
          headers: getFormatedHeaders(_headers), body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> deleteContact(id) async {
    try {
      await updateHeaders();
      return await networkService.delete(Uri.parse(baseUrl + 'contacts/$id/'),
          headers: getFormatedHeaders(_headers));
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  ///////////////////// LEADS-SERVICES ///////////////////////////////

  Future<Response> getLeads({queryParams, offset}) async {
    await updateHeaders();
    var url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString = Uri(
        queryParameters: getFormatedHeaders(queryParams),
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
    return await networkService.get(url, headers: getFormatedHeaders(_headers));
  }

  Future<Response> getLeadToUpdate(leadId) async {
    await updateHeaders();
    return await networkService.get(baseUrl + 'leads/$leadId/',
        headers: getFormatedHeaders(_headers));
  }

  Future<Response> createLead(data, File file) async {
    try {
      if (file.path == "") {
        await updateHeaders();
        return await networkService.post(Uri.parse(baseUrl + 'leads/'),
            headers: getFormatedHeaders(_headers), body: data);
      } else {
        await updateHeaders();
        var uri = Uri.parse(
          baseUrl + 'leads/',
        );
        var request = http.MultipartRequest(
          'POST',
          uri,
        )
          ..headers.addAll(getFormatedHeaders(_headers))
          ..fields.addAll(Map<String, String>.from(data))
          ..files.add(
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
      await updateHeaders();
      return await networkService.put(Uri.parse(baseUrl + 'leads/$id/'),
          headers: getFormatedHeaders(_headers), body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> deleteLead(id) async {
    try {
      await updateHeaders();
      return await networkService.delete(Uri.parse(baseUrl + 'leads/$id/'),
          headers: getFormatedHeaders(_headers));
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  ///////////////////// USERS-SERVICES ///////////////////////////////

  Future<Response> getUsers({Map? queryParams}) async {
    await updateHeaders();
    Uri url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString =
          Uri(queryParameters: getFormatedHeaders(queryParams)).query;
      url = Uri.parse(baseUrl + 'users/' + '?' + queryString);
    } else {
      url = Uri.parse(baseUrl + 'users/');
    }
    return await networkService.get(url, headers: getFormatedHeaders(_headers));
  }

  Future<Response> deleteUser(id) async {
    try {
      await updateHeaders();
      return await networkService.delete(Uri.parse(baseUrl + 'users/$id/'),
          headers: getFormatedHeaders(_headers));
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> createUser(user, File file) async {
    try {
      if (file.path == "") {
        await updateHeaders();
        return await networkService.post(Uri.parse(baseUrl + 'users/'),
            headers: getFormatedHeaders(_headers), body: user);
      } else {
        await updateHeaders();
        var uri = Uri.parse(
          baseUrl + 'users//',
        );
        var request = http.MultipartRequest(
          'POST',
          uri,
        )
          ..headers.addAll(getFormatedHeaders(_headers))
          ..fields.addAll(Map<String, String>.from(user))
          ..files.add(
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
      await updateHeaders();
      return await networkService.put(Uri.parse(baseUrl + 'users/$id/'),
          headers: getFormatedHeaders(_headers), body: user);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }


  ///////////////////// Events-SERVICES ///////////////////////////////

  Future<Response> getEvents({Map? queryParams}) async {
    await updateHeaders();
    Uri url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString =
          Uri(queryParameters: getFormatedHeaders(queryParams)).query;
      url = Uri.parse(baseUrl + 'events/' + '?' + queryString);
    } else {
      url = Uri.parse(baseUrl + 'events/');
    }
    print(url);
    return await networkService.get(url, headers: getFormatedHeaders(_headers));
  }

  Future<Response> deleteEvent(id) async {
    try {
      await updateHeaders();
      return await networkService.delete(Uri.parse(baseUrl + 'events/$id/'),
          headers: getFormatedHeaders(_headers));
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> createEvent(user) async {
    try {
        await updateHeaders();
        return await networkService.post(Uri.parse(baseUrl + 'events/'),
            headers: getFormatedHeaders(_headers), body: user);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> editEvent(user, id) async {
    try {
      await updateHeaders();
      return await networkService.put(Uri.parse(baseUrl + 'events/$id/'),
          headers: getFormatedHeaders(_headers), body: user);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  ///////////////////// DOCUMENTS-SERVICES ///////////////////////////////

  Future<Response> getDocuments({queryParams}) async {
    await updateHeaders();
    String url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString = Uri(
        queryParameters: getFormatedHeaders(queryParams),
      ).query;
      url = baseUrl + 'documents/' + '?' + queryString;
    } else {
      url = baseUrl + 'documents/';
    }
    return await networkService.get(url, headers: getFormatedHeaders(_headers));
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
      await updateHeaders();
      var uri = Uri.parse(
        baseUrl + 'documents/',
      );
      var request = http.MultipartRequest(
        'POST',
        uri,
      )
        ..headers.addAll(getFormatedHeaders(_headers))
        ..fields.addAll({
          'title': document['title'],
          'teams': document['teams'],
          'shared_to': document['shared_to']
        })
        ..files.add(
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
    await updateHeaders();
    var uri = Uri.parse(
      baseUrl + 'documents/$id/',
    );
    var request = http.MultipartRequest(
      'PUT',
      uri,
    )
      ..headers.addAll(getFormatedHeaders(_headers))
      ..fields.addAll({
        'title': document['title'],
        'teams': document['teams'],
        'shared_to': document['shared_to'],
        'status': document['status']
      })
      ..files
          .add(await http.MultipartFile.fromPath('document_file', file.path!));
    return await request.send();
  }

  Future<Response> deleteDocument(id) async {
    try {
      await updateHeaders();
      return await networkService.delete(Uri.parse(baseUrl + 'documents/$id/'),
          headers: getFormatedHeaders(_headers));
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  ///////////////////// TEAMS-SERVICES ///////////////////////////////

  Future<Response> getTeams({queryParams, offset}) async {
    await updateHeaders();
    Uri url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value.runtimeType != String);
      queryParams.removeWhere((key, value) => value == "[]");
      queryParams.removeWhere((key, value) => value == "");
      queryParams.removeWhere((key, value) => value == null);
      String queryString =
          Uri(queryParameters: getFormatedHeaders(queryParams)).query;
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
    return await networkService.get(url, headers: getFormatedHeaders(_headers));
  }

  Future<Response> createTeam(data) async {
    try {
      data.removeWhere((key, value) => value == "[]");
      data.removeWhere((key, value) => value == "");
      data.removeWhere((key, value) => value == null);
      await updateHeaders();
      return await networkService.post(Uri.parse(baseUrl + 'teams/'),
          headers: getFormatedHeaders(_headers), body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> deleteTeam(id) async {
    await updateHeaders();
    return await networkService.delete(Uri.parse(baseUrl + 'teams/$id/'),
        headers: getFormatedHeaders(_headers));
  }

  Future<Response> editTeam(
    data,
    id,
  ) async {
    await updateHeaders();
    data.removeWhere((key, value) => value == "[]");
    data.removeWhere((key, value) => value == "");
    data.removeWhere((key, value) => value == null);
    return await networkService.put(Uri.parse(baseUrl + 'teams/$id/'),
        headers: getFormatedHeaders(_headers), body: data);
  }

  ///////////////////// OPPORTUNITIES-SERVICES ////////////////////////////

  Future<Response> getOpportunities({queryParams, offset}) async {
    await updateHeaders();
    Uri url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString =
          Uri(queryParameters: getFormatedHeaders(queryParams)).query;
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
    return await networkService.get(url, headers: getFormatedHeaders(_headers));
  }

  Future<Response> deletefromModule(moduleName, id) async {
    try {
      await updateHeaders();
      return await networkService.delete(
          Uri.parse(baseUrl + '$moduleName/$id/'),
          headers: getFormatedHeaders(_headers));
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  // Future createOpportunity(opportunity, [PlatformFile file]) async {
  //   file = null;
  //   await updateHeaders();
  //   var uri = Uri.parse(
  //     baseUrl + 'opportunities/',
  //   );
  //   var request = http.MultipartRequest(
  //     'POST',
  //     uri,
  //   )
  //     ..headers.addAll(getFormatedHeaders(_headers))
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
        await updateHeaders();
        return await networkService.post(Uri.parse(baseUrl + 'opportunities/'),
            headers: getFormatedHeaders(_headers), body: data);
      } else {
        await updateHeaders();
        var uri = Uri.parse(
          baseUrl + 'opportunities/',
        );
        var request = http.MultipartRequest(
          'POST',
          uri,
        )
          ..headers.addAll(getFormatedHeaders(_headers))
          ..fields.addAll(Map<String, String>.from(data))
          ..files.add(
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
      await updateHeaders();
      data.removeWhere((key, value) => value == "[]");
      data.removeWhere((key, value) => value == "");
      data.removeWhere((key, value) => value == null);
      return await networkService.put(Uri.parse(baseUrl + 'opportunities/$id/'),
          headers: getFormatedHeaders(_headers), body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  // Future editOpportunity(opportunity, id, [PlatformFile file]) async {
  //   await updateHeaders();
  //   var uri = Uri.parse(
  //     baseUrl + 'opportunities`/$id/',
  //   );

  //   var request = http.MultipartRequest(
  //     'PUT',
  //     uri,
  //   )
  //     ..headers.addAll(getFormatedHeaders(_headers))
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
    await updateHeaders();
    Uri? url;
    if (queryParams != null) {
      String queryString =
          Uri(queryParameters: getFormatedHeaders(queryParams)).query;
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
    return await networkService.get(url, headers: getFormatedHeaders(_headers));
  }

  Future<Response> createTask(data) async {
    try {
      await updateHeaders();
      data.removeWhere((key, value) => value == "[]");
      data.removeWhere((key, value) => value == "");
      data.removeWhere((key, value) => value == null);
      return await networkService.post(Uri.parse(baseUrl + 'tasks/'),
          headers: getFormatedHeaders(_headers), body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> editTask(data, id) async {
    await updateHeaders();
    data.removeWhere((key, value) => value == "[]");
    data.removeWhere((key, value) => value == "");
    data.removeWhere((key, value) => value == null);
    return await networkService.put(Uri.parse(baseUrl + 'tasks/$id/'),
        headers: getFormatedHeaders(_headers), body: data);
  }

  Future<Response> deleteTask(id) async {
    await updateHeaders();
    return await networkService.delete(Uri.parse(baseUrl + 'tasks/$id/'),
        headers: getFormatedHeaders(_headers));
  }

  ///////////////////// SETTINGS-SERVICES ///////////////////////////////

  Future<Response> getApiSettings({queryParams, offset}) async {
    await updateHeaders();
    Uri? url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString =
          Uri(queryParameters: getFormatedHeaders(queryParams)).query;
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
    return await networkService.get(url, headers: getFormatedHeaders(_headers));
  }

  /// CONTACTS
  Future<Response> getSettingsContacts({queryParams}) async {
    await updateHeaders();
    String url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString =
          Uri(queryParameters: getFormatedHeaders(queryParams)).query;
      url = baseUrl + 'settings/contacts/' + '?' + queryString;
    } else {
      url = baseUrl + 'settings/contacts/';
    }
    return await networkService.get(url, headers: getFormatedHeaders(_headers));
  }

  Future<Response> deleteSettingsContacts(id) async {
    await updateHeaders();
    return await networkService.delete(
        Uri.parse(baseUrl + 'settings/contacts/$id/'),
        headers: getFormatedHeaders(_headers));
  }

  /// BLOCKED DOMAINS
  Future<Response> getBlockedDomains({queryParams}) async {
    await updateHeaders();
    String url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString =
          Uri(queryParameters: getFormatedHeaders(queryParams)).query;
      url = baseUrl + 'settings/block-domains/' + '?' + queryString;
    } else {
      url = baseUrl + 'settings/block-domains/';
    }
    return await networkService.get(url, headers: getFormatedHeaders(_headers));
  }

  Future<Response> deleteBlockedDomains(id) async {
    await updateHeaders();
    return await networkService.delete(
        Uri.parse(baseUrl + 'settings/block-domains/$id/'),
        headers: getFormatedHeaders(_headers));
  }

  /// BLOCKED EMAILS
  Future<Response> getBlockedEmails({queryParams}) async {
    await updateHeaders();
    String url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      String queryString =
          Uri(queryParameters: getFormatedHeaders(queryParams)).query;
      url = baseUrl + 'settings/block-emails/' + '?' + queryString;
    } else {
      url = baseUrl + 'settings/block-emails/';
    }
    return await networkService.get(url, headers: getFormatedHeaders(_headers));
  }

  Future<Response> deleteBlockedEmails(id) async {
    await updateHeaders();
    return await networkService.delete(
        Uri.parse(baseUrl + 'settings/block-emails/$id/'),
        headers: getFormatedHeaders(_headers));
  }

  Future<Response> createSetting(data) async {
    try {
      await updateHeaders();
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
          headers: getFormatedHeaders(_headers), body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Response> editSetting(data, id) async {
    await updateHeaders();
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
        headers: getFormatedHeaders(_headers), body: data);
  }

  ///////////////////// CASES-SERVICES ///////////////////////////////

  Future<Response> getCases({queryParams, offset}) async {
    await updateHeaders();
    Uri url;
    if (queryParams != null) {
      queryParams.removeWhere((key, value) => value == "");
      queryParams.removeWhere((key, value) => value == null);
      queryParams.removeWhere((key, value) => value == []);

      String queryString =
          Uri(queryParameters: getFormatedHeaders(queryParams)).query;
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
    return await networkService.get(url, headers: getFormatedHeaders(_headers));
  }

  Future<Response> createCase(data, File file) async {
    try {
      if (file.path == "") {
        // data.removeWhere((key, value) => value == "[]");
        // data.removeWhere((key, value) => value == "");
        data.removeWhere((key, value) => value == null);
        await updateHeaders();
        return await networkService.post(Uri.parse(baseUrl + 'cases/'),
            headers: getFormatedHeaders(_headers), body: data);
      } else {
        await updateHeaders();
        var uri = Uri.parse(
          baseUrl + 'leads/',
        );
        var request = http.MultipartRequest(
          'POST',
          uri,
        )
          ..headers.addAll(getFormatedHeaders(_headers))
          ..fields.addAll(Map<String, String>.from(data))
          ..files.add(
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
      await updateHeaders();
      // data.removeWhere((key, value) => value == "[]");
      // data.removeWhere((key, value) => value == "");
      data.removeWhere((key, value) => value == null);
      return await networkService.put(Uri.parse(baseUrl + 'cases/$id/'),
          headers: getFormatedHeaders(_headers), body: data);
    } on SocketException {
      throw HttpException("Network Error, check your internet");
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
}
