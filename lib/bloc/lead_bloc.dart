import 'dart:convert';
import 'package:flutter_crm/model/lead.dart';
import 'package:flutter_crm/services/crm_services.dart';

class LeadBloc {
  List<Lead> _openLeads = [];
  List<Lead> _closedLeads = [];

  Future fetchLeads() async {
    await CrmService().getLeads().then((response) {
      var res = (json.decode(response.body));

      res['open_leads'].forEach((_lead) {
        Lead lead = Lead.fromJson(_lead);
        _openLeads.add(lead);
      });

      res['close_leads'].forEach((_lead) {
        Lead lead = Lead.fromJson(_lead);
        _closedLeads.add(lead);
      });
    }).catchError((onError) {
      print("fetchLeads>> $onError");
    });
  }

  List<Lead> get openLeads {
    return _openLeads;
  }

  List<Lead> get closedLeads {
    return _closedLeads;
  }
}

final leadBloc = LeadBloc();
