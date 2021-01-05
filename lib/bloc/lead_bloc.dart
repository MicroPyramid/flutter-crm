import 'dart:convert';

import 'package:flutter_crm/model/lead.dart';
import 'package:flutter_crm/model/profile.dart';
import 'package:flutter_crm/services/crm_services.dart';
import 'package:flutter_crm/utils/utils.dart';

class LeadBloc {
  List<Lead> _openLeads = [];
  List<Lead> _closedLeads = [];
  List<String> _source = [];
  List<String> _status = [];
  List _tags = [];

  Lead _currentLead;
  String _currentLeadType = "Open";
  List<Profile> _users = [];
  List<String> _countries = [];
  List _countriesList = [];

  List<String> _leadsTitles = [];
  List _usersObjForDropdown = [];
  String _currentEditLeadId;
  Map _currentEditLead = {
    "first_name": "",
    "last_name": "",
    "phone": "",
    "account_name": "",
    "title": "",
    "email": "",
    "website": "",
    "description": "",
    "teams": [],
    // "users": [],
    "assigned_to": [],
    "address_line": "",
    "street": "",
    "postcode": "",
    "city": "",
    "state": "",
    "country": "",
    "status": "",
    "source": "",
    "tags": <String>[]
  };

  Future fetchLeads({filtersData}) async {
    Map _copyFiltersData =
        filtersData != null ? new Map.from(filtersData) : null;
    if (filtersData != null) {
      _copyFiltersData['tags'] = _copyFiltersData['tags'].length > 0
          ? jsonEncode(_copyFiltersData['tags'])
          : "";
      _copyFiltersData['assigned_to'] =
          _copyFiltersData['assigned_to'].length > 0
              ? jsonEncode(_copyFiltersData['assigned_to'])
              : "";
      _copyFiltersData['source'] =
          _copyFiltersData['source'] != null ? _copyFiltersData['source'] : "";
      _copyFiltersData['status'] =
          _copyFiltersData['status'] != null ? _copyFiltersData['status'] : "";
    }
    await CrmService().getLeads(queryParams: _copyFiltersData).then((response) {
      var res = json.decode(response.body);

      if (res['open_leads'] != null) {
        _openLeads.clear();
        _leadsTitles.clear();
        res['open_leads'].forEach((_lead) {
          Lead lead = Lead.fromJson(_lead);
          _openLeads.add(lead);
        });

        _openLeads.forEach((Lead lead) {
          _leadsTitles.add(lead.title);
        });
      }

      if (res['close_leads'] != null) {
        _closedLeads.clear();
        res['close_leads'].forEach((_lead) {
          Lead lead = Lead.fromJson(_lead);
          _closedLeads.add(lead);
        });
      }

      if (res['source'] != null) {
        _source.clear();
        res['source'].forEach((_leadsource) {
          _source.add(_leadsource[1]);
        });
      }

      if (res['status'] != null) {
        _status.clear();
        res['status'].forEach((_leadstatus) {
          _status.add(_leadstatus[1]);
        });
      }

      if (res['tags'] != null) {
        _tags = res['tags'];
      }

      if (res['users'] != null) {
        _users.clear();
        res['users'].forEach((_user) {
          Profile user = Profile.fromJson(_user);
          _users.add(user);
        });
        _usersObjForDropdown.clear();
        _users.forEach((_user) {
          Map user = {};
          user['id'] = _user.id;
          user['name'] = _user.firstName + ' ' + _user.lastName;
          _usersObjForDropdown.add(user);
        });
      }

      if (res['countries'] != null) {
        _countries.clear();
        _countriesList = res['countries'];
        res['countries'].forEach((country) {
          _countries.add(country[1]);
        });
      }
    });
    // .catchError((onError) {
    //   print('fetchLeads error $onError');
    // });
  }

  editLead() async {
    Map _copyCurrentEditLead = new Map.from(_currentEditLead);
    _copyCurrentEditLead['status'] =
        _copyCurrentEditLead['status'].toLowerCase();
    _copyCurrentEditLead['source'] =
        _copyCurrentEditLead['source'].toLowerCase();
    _copyCurrentEditLead['teams'] = (_copyCurrentEditLead['teams']
        .map((team) => team.toString())).toList().toString();
    _copyCurrentEditLead['assigned_to'] = (_copyCurrentEditLead['assigned_to']
        .map((assignedTo) => assignedTo.toString())).toList().toString();

    _copyCurrentEditLead['tags'] = jsonEncode(_copyCurrentEditLead['tags']);
    _countriesList.forEach((country) {
      if (country[1] == _copyCurrentEditLead['country']) {
        _copyCurrentEditLead['country'] = country[0];
      }
    });
    await CrmService()
        .editLead(_copyCurrentEditLead, _currentEditLeadId)
        .then((response) {
      var res = json.decode(response.body);
      print(res);
    }).catchError((onError) {
      print('fetchLeads $onError');
    });
  }

  createLead() async {
    print(_currentEditLead);
    Map _copyCurrentEditLead = new Map.from(_currentEditLead);
    _copyCurrentEditLead['status'] =
        _copyCurrentEditLead['status'].toLowerCase();
    _copyCurrentEditLead['source'] =
        _copyCurrentEditLead['source'].toLowerCase();
    _copyCurrentEditLead['teams'] = [
      ..._copyCurrentEditLead['teams'].map((team) => team.toString())
    ].toString();
    _copyCurrentEditLead['assigned_to'] = (_copyCurrentEditLead['assigned_to']
        .map((assignedTo) => assignedTo.toString())).toList();

    _copyCurrentEditLead['tags'] = _copyCurrentEditLead['tags'];

    _countriesList.forEach((country) {
      if (country[1] == _copyCurrentEditLead['country']) {
        _copyCurrentEditLead['country'] = country[0];
      }
    });
    print('Print before POST');
    print(_copyCurrentEditLead);
    await CrmService().createLead(_copyCurrentEditLead).then((response) {
      var res = json.decode(response.body);
      print(res);
    }).catchError((onError) {
      print('createLead Error : $onError');
    });
  }

  cancelCurrentEditLead() {
    _currentEditLead = {
      "first_name": "",
      "last_name": "",
      "phone": "",
      "account_name": "",
      "title": "",
      "email": "",
      "website": "",
      "description": "",
      "teams": [],
      // "users": [],
      "assigned_to": [],
      "address_line": "",
      "street": "",
      "postcode": "",
      "city": "",
      "state": "",
      "country": "",
      "status": "",
      "source": "",
      "tags": List<String>()
    };
  }

  updateCurrentEditLead(Lead editLead) async {
    _currentEditLeadId = editLead.id.toString();
    print(_currentEditLeadId);

    List teams = [];
    List assignedUsers = [];
    List<String> tags = [];

    await CrmService().getLeadToUpdate(editLead.id).then((response) {
      var res = json.decode(response.body);
      print("Update Current Edit Lead Teams, >>");
      teams.clear();
      res['teams'].forEach((team) {
        teams.add(team['id']);
      });
      print(teams);
    });

    editLead.assignedTo.forEach((user) {
      assignedUsers.add(user.id);
    });

    for (var tag in editLead.tags) {
      tags.add(tag['name']);
    }

    _currentEditLead['first_name'] = editLead.firstName;
    _currentEditLead['last_name'] = editLead.lastName;
    _currentEditLead['phone'] = editLead.phone;
    _currentEditLead['account_name'] = editLead.accountName;
    _currentEditLead['title'] = editLead.title;
    _currentEditLead['email'] = editLead.email;
    _currentEditLead['website'] = editLead.website;
    _currentEditLead['description'] = editLead.description;
    _currentEditLead['teams'] = teams;
    // _currentEditLead['users'] = editLead.users;
    _currentEditLead['assigned_to'] = assignedUsers;
    _currentEditLead['address_line'] = editLead.addressLine;
    _currentEditLead['street'] = editLead.street;
    _currentEditLead['postcode'] = editLead.postcode;
    _currentEditLead['city'] = editLead.city;
    _currentEditLead['state'] = editLead.state;
    _currentEditLead['country'] = editLead.country;
    _currentEditLead['status'] = editLead.status.capitalizeFirstofEach();
    _currentEditLead['source'] = editLead.source.capitalizeFirstofEach();
    _currentEditLead['tags'] = tags;
  }

  Future deleteLead(Lead lead) async {
    Map result;
    await CrmService().deleteLead(lead.id).then((response) {
      var res = (json.decode(response.body));
      print("deleteLead Response >> $res");

      result = res;
    }).catchError((onError) {
      print("deleteLead Error >> $onError");
      result = {"status": "error", "message": "Something went wrong."};
    });
    return result;
  }

  List get tags {
    return _tags;
  }

  Map get currentEditLead {
    return _currentEditLead;
  }

  set currentEditLead(currentEditLead) {
    _currentEditLead = currentEditLead;
  }

  String get currentEditLeadId {
    return _currentEditLeadId;
  }

  set currentEditLeadId(id) {
    _currentEditLeadId = id;
  }

  List<Lead> get openLeads {
    return _openLeads;
  }

  List<Lead> get closedLeads {
    return _closedLeads;
  }

  List<String> get source {
    return _source;
  }

  List<String> get status {
    return _status;
  }

  List<String> get leadsTitles {
    return _leadsTitles;
  }

  List<Profile> get users {
    return _users;
  }

  Lead get currentLead {
    return _currentLead;
  }

  set currentLead(lead) {
    _currentLead = lead;
  }

  String get currentLeadType {
    return _currentLeadType;
  }

  set currentLeadType(type) {
    _currentLeadType = type;
  }

  List<String> get countries {
    return _countries;
  }

  List get countriesList {
    return _countriesList;
  }

  set countriesList(countriesList) {
    _countriesList = countriesList;
  }

  List get usersObjForDropdown {
    return _usersObjForDropdown;
  }
}

final leadBloc = LeadBloc();
