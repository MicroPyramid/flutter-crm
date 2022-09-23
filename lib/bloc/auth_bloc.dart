import 'dart:convert';

import 'package:bottle_crm/model/organization.dart';
import 'package:bottle_crm/model/profile.dart';
import 'package:bottle_crm/services/crm_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc {
  String? _subDomainName;
  String? _authToken;
  Profile? _userProfile;
  List<Organization> _companies = [];
  Organization? _selectedOrganization;

  String? get subDomainName {
    return _subDomainName;
  }

  String? get authToken {
    return _authToken;
  }

  Profile? get userProfile {
    return _userProfile;
  }

  List<Organization> get companies {
    return _companies;
  }

  Organization? get selectedOrganization {
    return _selectedOrganization;
  }

  set selectedOrganization(selectedOrganization) {
    _selectedOrganization = selectedOrganization;
  }

  Future validateDomain(data) async {
    Map? result;
    await CrmService().validateSubdomain(data).then((response) {
      var res = (json.decode(response.body));
      if (res['error'] == false) {
        _subDomainName = data['sub_domain'];
        result = res;
      } else {
        result = res;
      }
    }).catchError((onError) {
      print("validate domain error>> $onError");
      result = {"status": "error", "message": "Something went wrong"};
    });
    return result;
  }

  Future login(data) async {
    try {
      Map result = {};
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      await CrmService().userLogin(data).then((response) async {
        var res = (json.decode(response.body));
        if (res['error'] == false) {
          _authToken = "JWT " + res['token'];
          preferences.setString("authToken", _authToken!);
          result = res;
        } else {
          result = res;
        }
      }).catchError((onError) {
        print("login error>> $onError");
        result = {"status": "error", "message": onError};
      });
      return result;
    } catch (e) {}
  }

  Future forgotPassword(data) async {
    Map? result;
    await CrmService().forgotPassword(data).then((response) {
      var res = (json.decode(response.body));
      result = res;
    }).catchError((onError) {
      print("forgot password Error >> $onError");
      result = {"status": "error", "message": onError};
    });
    return result;
  }

  Future register(data) async {
    Map? result = {};
    await CrmService().userRegister(data).then((response) async {
      var res = (json.decode(response.body));
      if (res['error'] == false) {
        result = res;
      } else {
        result = res;
      }
    }).catchError((onError) {
      print("register user error >> $onError");
      result = {"status": "error", "message": onError};
    });
    return result;
  }

  Future getProfileDetails() async {
    await CrmService().getUserProfile().then((response) {
      var res = (json.decode(response.body));
      if (res['user_obj'] != null) {
        _userProfile = Profile.fromJson(res['user_obj']);
      } else {
        _userProfile = null;
      }
    }).catchError((onError) {
      print("get profile Error >> $onError");
    });
  }

  Future changePassword(data) async {
    Map result = {};
    await CrmService().changePassword(data).then((response) {
      var res = (json.decode(response.body));
      result = res;
    }).catchError((onError) {
      print("change password Error >> $onError");
      result = {"status": "error", "message": "Something went wrong"};
    });
    return result;
  }

  Future fetchCompanies() async {
    try {
      await CrmService().getCompanies().then((response) {
      var res = (json.decode(response.body));
      if (res['error'] == false) {
        _companies.clear();
        res['companies'].forEach((_company) {
          Organization company = Organization.fromJson(_company);
          _companies.add(company);
        });
      }
    }).catchError((onError) {
      print("companies list error>> $onError");
    });
    } catch (e) {
    }
    
  }
}

final authBloc = AuthBloc();
