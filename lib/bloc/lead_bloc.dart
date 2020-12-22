import 'dart:convert';

import 'package:flutter_crm/model/lead.dart';
import 'package:flutter_crm/model/profile.dart';
import 'package:flutter_crm/services/crm_services.dart';

class LeadBloc {
  List<Lead> _openLeads = [];
  List<Lead> _closedLeads = [];
  List<String> _source = [];
  List<String> _status = [];

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
    "tags": List<String>()
  };

  Future fetchLeads() async {
    await CrmService().getLeads().then((response) {
      var res = json.decode(response.body);

      res['open_leads'].forEach((_lead) {
        Lead lead = Lead.fromJson(_lead);
        _openLeads.add(lead);
      });

      _openLeads.forEach((Lead lead) {
        _leadsTitles.add(lead.title);
      });

      res['close_leads'].forEach((_lead) {
        Lead lead = Lead.fromJson(_lead);
        _closedLeads.add(lead);
      });

      res['source'].forEach((_leadsource) {
        _source.add(_leadsource[1]);
      });

      res['status'].forEach((_leadstatus) {
        _status.add(_leadstatus[1]);
      });

      res['users'].forEach((_user) {
        Profile user = Profile.fromJson(_user);
        _users.add(user);
      });

      _users.forEach((_user) {
        Map user = {};
        user['id'] = _user.id;
        user['name'] = _user.firstName + ' ' + _user.lastName;
        _usersObjForDropdown.add(user);
      });

      _countriesList = res['countries'];

      res['countries'].forEach((country) {
        _countries.add(country[1]);
      });
    }).catchError((onError) {
      print('fetchLeads $onError');
    });
  }

  editLead() async {
    _currentEditLead['status'] = _currentEditLead['status'].toLowerCase();
    _currentEditLead['source'] = _currentEditLead['source'].toLowerCase();
    _currentEditLead['teams'] =
        [_currentEditLead['teams'].map((team) => team.toString())].toString();
    _currentEditLead['assigned_to'] = (_currentEditLead['assigned_to']
            .map((assignedTo) => assignedTo.toString())
            .toList())
        .toString();

    _currentEditLead['tags'] = _currentEditLead['tags'].toString();
    _countriesList.forEach((country) {
      if (country[1] == _currentEditLead['country']) {
        _currentEditLead['country'] = country[0];
      }
    });
    await CrmService()
        .editLead(_currentEditLead, _currentEditLeadId)
        .then((response) {
      var res = json.decode(response.body);
      print(res);
    }).catchError((onError) {
      print('fetchLeads $onError');
    });
  }

  createLead() async {
    print(_currentEditLead);
    _currentEditLead['status'] = _currentEditLead['status'].toLowerCase();
    _currentEditLead['source'] = _currentEditLead['source'].toLowerCase();
    _currentEditLead['teams'] = [
      ..._currentEditLead['teams'].map((team) => team.toString())
    ].toString();
    _currentEditLead['assigned_to'] = (_currentEditLead['assigned_to']
        .map((assignedTo) => assignedTo.toString())).toList();

    _currentEditLead['tags'] = _currentEditLead['tags'];

    _countriesList.forEach((country) {
      if (country[1] == _currentEditLead['country']) {
        _currentEditLead['country'] = country[0];
      }
    });
    print('Print before POST');
    print(_currentEditLead);
    await CrmService().createLead(_currentEditLead).then((response) {
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

  updateCurrentEditLead(Lead editLead) {
    _currentEditLeadId = editLead.id.toString();
    List teams = [];
    List assignedUsers = [];
    List<String> tags = [];

    // editLead.teams.forEach((team) {
    //   Map _team = {};
    //   _team['id'] = team.id;
    //   _team['name'] = team.name;
    //   teams.add(_team);
    // });

    editLead.assignedTo.forEach((user) {
      Map _user = {};
      _user['id'] = user.id;
      _user['name'] = user.firstName + ' ' + user.lastName;
      assignedUsers.add(_user);
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
    _currentEditLead['status'] = editLead.status;
    _currentEditLead['source'] = editLead.source;
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

  Map get currentEditLead {
    return _currentEditLead;
  }

  set currentEditLead(Map currentEditLead) {
    _currentEditLead = currentEditLead;
  }

  String get currentEditLeadId {
    return _currentEditLeadId;
  }

  set currentEditLeadId(String id) {
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

  set currentLead(Lead lead) {
    _currentLead = lead;
  }

  String get currentLeadType {
    return _currentLeadType;
  }

  set currentLeadType(String type) {
    _currentLeadType = type;
  }

  List<String> get countries {
    return _countries;
  }

  List get countriesList {
    return _countriesList;
  }

  set countriesList(List countriesList) {
    _countriesList = countriesList;
  }

  List get usersObjForDropdown {
    return _usersObjForDropdown;
  }
}

final leadBloc = LeadBloc();
