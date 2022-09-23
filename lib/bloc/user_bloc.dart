import 'dart:convert';
import 'dart:io';

import 'package:bottle_crm/model/user.dart';
import 'package:bottle_crm/services/crm_services.dart';

class UserBloc {
  List<User> _activeUsers = [];
  List<User> _inActiveUsers = [];
  List _usersObjForDropdown = [];
  List _statusObjForDropdown = [];
  List _rolesObjForDropdown = [];
  User? _currentUser;
  String _currentUserStatus = "Active";
  int? _currentUserIndex;
  String? _currentEditUserId;
  Map _currentEditUser = {
    'username': "",
    'role': "USER",
    'status': "Active",
    'profile_pic': "",
    'date_joined': "",
    'email': "",
    'phone': "",
    "password": "",
    'first_name': "",
    'last_name': "",
    'has_marketing_access': false,
    'has_sales_access': false,
    'is_active': "True",
    'is_organization_admin': false,
    'description':"",
  };

  Future fetchUsers({filtersData}) async {
    Map? _copyFiltersData =
        filtersData != null ? new Map.from(filtersData) : null;

    await CrmService().getUsers(queryParams: _copyFiltersData).then((response) {
      _activeUsers.clear();
      _inActiveUsers.clear();

      var res = json.decode(response.body);
      if (res['active_users']['active_users'] != null)
        res['active_users']['active_users'].forEach((_user) {
          User user = User.fromJson(_user);
          _activeUsers.add(user);
        });
      res['inactive_users']['inactive_users'].forEach((_user) {
        User user = User.fromJson(_user);
        _activeUsers.add(user);
      });
      //_statusObjForDropdown = res['status'];
      //_rolesObjForDropdown = res['roles'];
      if (res['active_users'] != null) {
        // _users.clear();
        // _usersObjForDropdown.clear();
        // res['active_users'].forEach((_user) {
        //   Profile user = Profile.fromJson(_user);
        //   _users.add(user);
        // });
        _usersObjForDropdown.clear();
        _activeUsers.forEach((_user) {
          Map user = {};
          user['id'] = _user.id;
          user['name'] = _user.firstName! + ' ' + _user.lastName!;
          _usersObjForDropdown.add(user);
        });
      }
      if (res['roles'] != null) {
        _rolesObjForDropdown.clear();
        res['roles'].forEach((_role) {
          _rolesObjForDropdown.add(_role[1]);
        });
      }
      if (res['status'] != null) {
        _statusObjForDropdown.clear();
        res['status'].forEach((_status) {
          _statusObjForDropdown.add(_status[1]);
        });
      }
    }).catchError((onError) {
      print('fetchUsers Error >> $onError');
    });
  }

  Future createUser({File? file}) async {
    Map? _result;
    Map _copyOfCurrentEditUser = Map.from(_currentEditUser);
    _copyOfCurrentEditUser['has_marketing_access'] =
        json.encode(_copyOfCurrentEditUser['has_marketing_access']);
    _copyOfCurrentEditUser['has_sales_access'] =
        json.encode(_copyOfCurrentEditUser['has_sales_access']);
    _copyOfCurrentEditUser['role'] = _copyOfCurrentEditUser['is_admin'];
    _copyOfCurrentEditUser['status'] = _copyOfCurrentEditUser['is_active'];
    await CrmService()
        .createUser(_copyOfCurrentEditUser, file!)
        .then((response) async {
      var res = json.decode(response.body);
      if (res['error'] == false) {
        await fetchUsers();
      }
      _result = res;
    }).catchError((onError) {
      print("createUser Error >> $onError");
      _result = {"status": "error", "message": onError};
    });
    return _result;
  }

  editUser() async {
    Map? _result;
    Map _copyOfCurrentEditUser = Map.from(_currentEditUser);
    _copyOfCurrentEditUser['has_marketing_access'] =
        json.encode(_copyOfCurrentEditUser['has_marketing_access']);
    _copyOfCurrentEditUser['has_sales_access'] =
        json.encode(_copyOfCurrentEditUser['has_sales_access']);
    _copyOfCurrentEditUser['role'] = _copyOfCurrentEditUser['is_admin'];
    _copyOfCurrentEditUser['status'] = _copyOfCurrentEditUser['is_active'];
    await CrmService()
        .editUser(_copyOfCurrentEditUser, _currentEditUserId)
        .then((response) async {
      var res = json.decode(response.body);
      if (res['error'] == false) {
        await fetchUsers();
      }
      _result = res;
    }).catchError((onError) {
      print("editUser Error >> $onError");
      _result = {"status": "error", "message": onError};
    });
    return _result;
  }

  Future deleteUser(User user) async {
    Map? result;
    await CrmService().deleteUser(user.id).then((response) async {
      var res = (json.decode(response.body));
      await fetchUsers();
      result = res;
    }).catchError((onError) {
      print("deleteUser Error >> $onError");
      result = {"status": "error", "message": onError};
    });
    return result;
  }

  cancelCurrentEditUser() {
    _currentEditUserId = null;
    _currentEditUser = {
      'username': "",
      'role': "",
      'profile_pic': "",
      'date_joined': "",
      'email': "",
      'phone': "",
      "password": "",
      'first_name': "",
      'last_name': "",
      'has_marketing_access': false,
      'has_sales_access': false,
      'is_active': "True",
      'is_organization_admin': "USER",
    };
  }

  updateCurrentEditUser(User user) {
    _currentEditUserId = user.id.toString();

    _currentEditUser['username'] = user.firstName;
    _currentEditUser['role'] = user.role;
    _currentEditUser['profile_pic'] = user.profilePic;
    //_currentEditUser['date_joined'] = user.dateOfJoin;
    _currentEditUser['email'] = user.email;
    _currentEditUser['first_name'] = user.firstName;
    _currentEditUser['last_name'] = user.lastName;
    _currentEditUser['has_marketing_access'] = user.hasMarktingAccess;
    _currentEditUser['has_sales_access'] = user.hasSalesAccess;

    if (user.isActive == true) {
      _currentEditUser['is_active'] = "True";
    } else {
      _currentEditUser['is_active'] = "False";
    }
    if (user.role == "ADMIN") {
      _currentEditUser['is_organization_admin'] = true;
      _currentEditUser['has_marketing_access'] = true;
      _currentEditUser['has_sales_access'] = true;
    } else {
      _currentEditUser['is_organization_admin'] = false;
    }
  }

  List<User> get activeUsers {
    return _activeUsers;
  }

  List<User> get inActiveUsers {
    return _inActiveUsers;
  }

  List get statusObjForDropdown {
    return _statusObjForDropdown;
  }

  List get rolesObjForDropdown {
    return _rolesObjForDropdown;
  }

  User? get currentUser {
    return _currentUser;
  }

  set currentUser(user) {
    _currentUser = user;
  }

  String get currentUserStatus {
    return _currentUserStatus;
  }

  List get usersObjForDropdown {
    return _usersObjForDropdown;
  }

  set currentUserStatus(status) {
    _currentUserStatus = status;
  }

  int? get currentUserIndex {
    return _currentUserIndex;
  }

  set currentUserIndex(index) {
    _currentUserIndex = index;
  }

  set currentEditUserId(id) {
    _currentEditUserId = id;
  }

  String? get currentEditUserId {
    return _currentEditUserId;
  }

  Map get currentEditUser {
    return _currentEditUser;
  }
}

final userBloc = UserBloc();
