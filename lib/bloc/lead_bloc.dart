
import 'dart:convert';

import 'package:flutter_crm/model/lead.dart';
import 'package:flutter_crm/services/crm_services.dart';

class LeadBloc {
  List<Lead> _openLeads = [];
  List<Lead> _closedLeads = [];
  Lead _currentLead;
  String _currentLeadType = "Open";

  Future fetchLeads() async {
    await CrmService().getLeads().then((response) {
      var res = json.decode(response.body);
      print(res);

      res['open_leads'].forEach((_lead) {
        Lead lead = Lead.fromJson(_lead);
        _openLeads.add(lead);
      });

      res['close_leads'].forEach((_lead) {
        Lead lead = Lead.fromJson(_lead);
        _closedLeads.add(lead);
      });

    }).catchError((onError){
      print('fetchLeads $onError');
    }
      );

  }

  List<Lead> get openLeads {
    return _openLeads;
  }

  List<Lead> get closedLeads {
    return _closedLeads;
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