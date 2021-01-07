import 'dart:convert';

import 'package:flutter_crm/model/profile.dart';
import 'package:flutter_crm/services/crm_services.dart';
import 'package:http/http.dart';

class UserBloc {
  List<Profile> _activeUsers = [];
  List<Profile> _inActiveUsers = [];
  List _statusObjForDropdown = [];
  List _rolesObjForDropdown = [];
  Profile _currentUser;
  String _currentUserStatus = "Active";
  int _currentUserIndex;
  String _currentEditUserId;
  Map _currentEditUser = {
    'username': "",
    'role': "",
    'profile_pic': "",
    'date_joined': "",
    'email': "",
    "password": "",
    'first_name': "",
    'last_name': "",
    'has_marketing_access': false,
    'has_sales_access': false,
    'is_active': "True",
    'is_admin': "USER",
  };

  Future fetchUsers({filtersData}) async {
    Map _copyFiltersData =
        filtersData != null ? new Map.from(filtersData) : null;

    await CrmService().getUsers(queryParams: _copyFiltersData).then((response) {
      _activeUsers.clear();
      _inActiveUsers.clear();

      var res = json.decode(response.body);

      res['active_users'].forEach((_user) {
        Profile user = Profile.fromJson(_user);
        _activeUsers.add(user);
      });
      res['inactive_users'].forEach((_user) {
        Profile user = Profile.fromJson(_user);
        _activeUsers.add(user);
      });
      _statusObjForDropdown = res['status'];
      _rolesObjForDropdown = res['roles'];

      print('fetch Users Response >> $res');
    }).catchError((onError) {
      print('fetchUsers Error >> $onError');
    });
  }

  Future deleteUser(Profile user) async {
    Map result;
    await CrmService().deleteUser(user.id).then((response) async {
      var res = (json.decode(response.body));
      print('deleteUser Response >> $res');
      await fetchUsers();
      result = res;
    }).catchError((onError) {
      print("deleteUser Error >> $onError");
      result = {"status": "error", "message": "Something went wrong."};
    });
    return result;
  }

  Future createUser() async {
    Map _result;
    Map _copyOfCurrentEditUser = Map.from(_currentEditUser);
    _copyOfCurrentEditUser['has_marketing_access'] =
        json.encode(_copyOfCurrentEditUser['has_marketing_access']);
    _copyOfCurrentEditUser['has_sales_access'] =
        json.encode(_copyOfCurrentEditUser['has_sales_access']);

    _copyOfCurrentEditUser['role'] = _copyOfCurrentEditUser['is_admin'];
    _copyOfCurrentEditUser['status'] = _copyOfCurrentEditUser['is_active'];

    print(_copyOfCurrentEditUser);

    await CrmService()
        .createUser(_copyOfCurrentEditUser)
        .then((response) async {
      var res = json.decode(response.body);
      if (res["error"] != null || res["error"] != "") {
        if (res['error'] == false) {
          await fetchUsers();
          cancelCurrentEditUser();
        }
      }
      _result = res;
      print("createUser Response >> \n $res");
    }).catchError((onError) {
      print("createUser Error >> \n $onError");
      _result = {"status": "error", "message": "Something went wrong."};
    });
    return _result;
  }

  cancelCurrentEditUser() {
    _currentEditUserId = null;
    _currentEditUser = {
      'username': "",
      'role': "",
      'profile_pic': "",
      'date_joined': "",
      'email': "",
      "password": "",
      'first_name': "",
      'last_name': "",
      'has_marketing_access': false,
      'has_sales_access': false,
      'is_active': "True",
      'is_admin': "USER",
    };
  }

  updateCurrentEditUser(Profile user) {
    _currentEditUserId = user.id.toString();

    _currentEditUser['username'] = user.userName;
    _currentEditUser['role'] = user.role;
    _currentEditUser['profile_pic'] = user.profileUrl;
    _currentEditUser['date_joined'] = user.dateOfJoin;
    _currentEditUser['email'] = user.email;
    _currentEditUser['first_name'] = user.firstName;
    _currentEditUser['last_name'] = user.lastName;
    _currentEditUser['has_marketing_access'] = user.hasMarketingAccess;
    _currentEditUser['has_sales_access'] = user.hasSalesAccess;

    if (user.isActive == true) {
      _currentEditUser['is_active'] = "True";
    } else {
      _currentEditUser['is_active'] = "False";
    }
    if (user.isAdmin == true) {
      _currentEditUser['is_admin'] = "ADMIN";
    } else {
      _currentEditUser['is_admin'] = "USER";
    }
  }

  editUser() async {
    Map _result;
    Map _copyOfCurrentEditUser = Map.from(_currentEditUser);
    _copyOfCurrentEditUser['has_marketing_access'] =
        json.encode(_copyOfCurrentEditUser['has_marketing_access']);
    _copyOfCurrentEditUser['has_sales_access'] =
        json.encode(_copyOfCurrentEditUser['has_sales_access']);

    _copyOfCurrentEditUser['role'] = _copyOfCurrentEditUser['is_admin'];
    _copyOfCurrentEditUser['status'] = _copyOfCurrentEditUser['is_active'];

    print(_copyOfCurrentEditUser);

    await CrmService()
        .editUser(_copyOfCurrentEditUser, _currentEditUserId)
        .then((response) async {
      var res = json.decode(response.body);
      if (res["error"] != null || res["error"] != "") {
        if (res['error'] == false) {
          await fetchUsers();
          cancelCurrentEditUser();
        }
      }
      _result = res;
      print("editUser Response >> \n $res");
    }).catchError((onError) {
      print("editUser Error >> \n $onError");
      _result = {"status": "error", "message": "Something went wrong."};
    });
    return _result;
  }

  List<Profile> get activeUsers {
    return _activeUsers;
  }

  List<Profile> get inActiveUsers {
    return _inActiveUsers;
  }

  List get statusObjForDropdown {
    return _statusObjForDropdown;
  }

  List get rolesObjForDropdown {
    return _rolesObjForDropdown;
  }

  Profile get currentUser {
    return _currentUser;
  }

  set currentUser(Profile user) {
    _currentUser = user;
  }

  String get currentUserStatus {
    return _currentUserStatus;
  }

  set currentUserStatus(String status) {
    _currentUserStatus = status;
  }

  int get currentUserIndex {
    return _currentUserIndex;
  }

  set currentUserIndex(int index) {
    _currentUserIndex = index;
  }

  String get currentEditUserId {
    return _currentEditUserId;
  }

  Map get currentEditUser {
    return _currentEditUser;
  }
}

final userBloc = UserBloc();
