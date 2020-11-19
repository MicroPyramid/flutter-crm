import 'dart:convert';

import 'package:flutter_crm/model/profile.dart';
import 'package:flutter_crm/services/crm_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc {
  String _subDomainName;
  String _authToken;
  Profile _userProfile;

  String get subDomainName {
    return _subDomainName;
  }

  String get authToken {
    return _authToken;
  }

  Profile get userProfile {
    return _userProfile;
  }

  Future validateDomain(data) async {
    Map result;
    await CrmService().validateSubdomain(data).then((response) {
      var res = (json.decode(response.body));
      print(res);
      if (res['error'] == false) {
        _subDomainName = data['sub_domain'];
        result = res;
      } else {
        result = res;
      }
    }).catchError((onError) {
      print(onError);
      result = {"status": "error", "message": "Something went wrong"};
    });
    return result;
  }

  Future login(data) async {
    Map result;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await CrmService()
        .userLogin({'company': _subDomainName}, data).then((response) {
      var res = (json.decode(response.body));
      print(res);
      if (res['error'] == false) {
        _authToken = "JWT " + res['token'];
        _subDomainName = res['subdomin'];
        preferences.setString("authToken", "JWT " + res['token']);
        preferences.setString("subdomain", res['subdomin']);
        result = res;
      } else {
        result = res;
      }
    }).catchError((onError) {
      print(onError);
      result = {"status": "error", "message": "Something went wrong"};
    });
    return result;
  }

  Future forgotPassword(data) async {
    Map result;
    await CrmService().forgotPassword(data).then((response) {
      var res = (json.decode(response.body));
      print(res);
      result = res;
    }).catchError((onError) {
      print(onError);
      result = {"status": "error", "message": "Something went wrong"};
    });
    return result;
  }

  Future register(data) async {
    Map result;
    await CrmService().userRegister(data).then((response) {
      var res = (json.decode(response.body));
      print(res);
      if (res['error'] == false) {
        _subDomainName = data['sub_domain'];
        result = res;
      } else {
        result = res;
      }
    }).catchError((onError) {
      print(onError);
      result = {"status": "error", "message": "Something went wrong"};
    });
    return result;
  }

  Future getProfileDetails() async {
    await CrmService().getUserProfile().then((response) {
      var res = (json.decode(response.body));
      print(res);
      if (res['user_obj'] != null) {
        _userProfile = Profile.fromJson(res['user_obj']);
      } else {
        _userProfile = null;
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  Future changePassword(data) async {
    Map result;
    await CrmService().changePassword(data).then((response) {
      var res = (json.decode(response.body));
      print(res);
      if (res['status'] == "success") {
        result = res;
      } else {
        result = res;
      }
    }).catchError((onError) {
      print(onError);
      result = {"status": "error", "message": "Something went wrong"};
    });
    return result;
  }
}

final authBloc = AuthBloc();
