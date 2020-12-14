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
  List<String> _ledasTitles = [];
  List _usersObjForDropdown = [];

  Future fetchLeads() async {
    await CrmService().getLeads().then((response) {
      var res = json.decode(response.body);

      res['open_leads'].forEach((_lead) {
        Lead lead = Lead.fromJson(_lead);
        _openLeads.add(lead);
      });

      _openLeads.forEach((Lead lead) {
        _ledasTitles.add(lead.title);
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

      res['countries'].forEach((country) {
        _countries.add(country[1]);
      });
    }).catchError((onError) {
      print('fetchLeads $onError');
    });
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
    return _ledasTitles;
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

  List get usersObjForDropdown {
    return _usersObjForDropdown;
  }
}

final leadBloc = LeadBloc();
