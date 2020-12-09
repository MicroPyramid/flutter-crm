import 'dart:convert';

import 'package:flutter_crm/model/lead.dart';
import 'package:flutter_crm/model/profile.dart';
import 'package:flutter_crm/services/crm_services.dart';

class LeadBloc {
  List<Lead> _openLeads = [];
  List<Lead> _closedLeads = [];
  List<String> _source = [];
  List<String> _status = [];

  List<Map> _users = [];
  Lead _currentLead;
  String _currentLeadType = "Open";

  Future fetchLeads() async {
    await CrmService().getLeads().then((response) {
      var res = json.decode(response.body);

      res['open_leads'].forEach((_lead) {
        Lead lead = Lead.fromJson(_lead);
        _openLeads.add(lead);
      });

      res['close_leads'].forEach((_lead) {
        Lead lead = Lead.fromJson(_lead);
        _closedLeads.add(lead);
      });

      res['source'].forEach((_leadsource) {
        _source.add(_leadsource[1]);
      });

      res['users'].forEach((_user) {
        Profile user = Profile.fromJson(_user);
        _users.add({
          'display': user.userName.toString(),
          'value': user.userName.toString()
        });
      });

      res['status'].forEach((_leadstatus) {
        _status.add(_leadstatus[1]);
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

  List<Map> get users {
    return _users;
  }

  List<String> get source {
    return _source;
  }

  List<String> get status {
    return _status;
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
}

final leadBloc = LeadBloc();
