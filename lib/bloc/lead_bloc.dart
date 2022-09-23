import 'dart:convert';
import 'dart:io';

import 'package:bottle_crm/model/lead.dart';
import 'package:bottle_crm/model/profile.dart';
import 'package:bottle_crm/services/crm_services.dart';
import 'package:bottle_crm/utils/utils.dart';

import 'dashboard_bloc.dart';

class LeadBloc {
  List<Lead> _openLeads = [];
  List<Lead> _closedLeads = [];
  List<String?> _source = [];
  List<String?> _indrustries = [];
  List<String?> _status = [];
  List? _tags = [];
  Lead? _currentLead;
  String _currentLeadType = "Open";
  List<Profile> _users = [];
  List<String?> _countries = [];
  List _countriesList = [];
  //List<Team> _teams = [];
  List _teamsObjForDropdown = [];
  List<String?> _leadsTitles = [];
  List _usersObjForDropdown = [];
  String? _currentEditLeadId;
  List _filterTags = [];

  Map _currentEditLead = {
    "first_name": "",
    "last_name": "",
    "phone": "",
    "account_name": "",
    "opportunity_amount": "",
    "title": "",
    "email": "",
    "website": "",
    "skype_ID": "",
    "description": "",
    "assigned_to": [],
    "address_line": "",
    "street": "",
    "postcode": "",
    "city": "",
    "state": "",
    "country": "",
    "status": "",
    "source": "",
    "tags": <String>[],
    "industry": "",
  };
  String _offset = "";

  Future fetchLeads({filtersData}) async {
    Map? _copyFiltersData =
        filtersData != null ? new Map.from(filtersData) : null;
    if (filtersData != null) {
      _copyFiltersData!['tags'] = _copyFiltersData['tags'].length > 0
          ? jsonEncode(
              (_copyFiltersData['tags'].map((id) => id.toString())).toList())
          : "";
      _copyFiltersData['assigned_to'] =
          _copyFiltersData['assigned_to'].length > 0
              ? jsonEncode((_copyFiltersData['assigned_to']
                  .map((id) => id.toString())).toList())
              : "";
      _copyFiltersData['source'] = _copyFiltersData['source'] != null
          ? _copyFiltersData['source'].toString().toLowerCase()
          : "";
      _copyFiltersData['status'] = _copyFiltersData['status'] != null
          ? _copyFiltersData['status'].toString().toLowerCase()
          : "";
    }
    await CrmService()
        .getLeads(queryParams: _copyFiltersData, offset: _offset)
        .then((response) {
      var res = json.decode(response.body);

      if (res['open_leads'] != null) {
        _leadsTitles.clear();
        // _teams.clear();
        res['open_leads']['open_leads'].forEach((_lead) {
          Lead lead = Lead.fromJson(_lead);
          _openLeads.add(lead);
        });

        _openLeads.forEach((Lead lead) {
          _leadsTitles.add(lead.title);
        });
      }

      if (res['close_leads'] != null) {
        res['close_leads']['close_leads'].forEach((_lead) {
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

      if (res['industries'] != null) {
        _indrustries.clear();
        res['industries'].forEach((_industries) {
          _indrustries.add(_industries[1]);
        });
      }

      if (res['status'] != null) {
        _status.clear();
        res['status'].forEach((_leadstatus) {
          _status.add(_leadstatus[1]);
        });
      }

      _filterTags = res['tags'] != null ? res['tags'] : [];
      _offset = res['open_leads']['offset'] != null &&
              res['open_leads']['offset'].toString() != "0"
          ? res['open_leads']['offset'].toString()
          : res['close_leads']['offset'] != null &&
                  res['close_leads']['offset'].toString() != "0"
              ? res['close_leads']['offset'].toString()
              : "";

      if (res['countries'] != null) {
        _countries.clear();
        _countriesList = res['countries'];
        res['countries'].forEach((country) {
          _countries.add(country[1]);
        });
      }
    }).catchError((onError) {
      print('fetchLeads error $onError');
    });
  }

  createLead({File? file}) async {
    Map? result;
    Map _copyCurrentEditLead = new Map.from(_currentEditLead);
    _copyCurrentEditLead['status'] =
        _copyCurrentEditLead['status'].toLowerCase();
    _copyCurrentEditLead['source'] =
        _copyCurrentEditLead['source'].toLowerCase();
    _copyCurrentEditLead['assigned_to'] = (_copyCurrentEditLead['assigned_to']
        .map((assignedTo) => assignedTo.toString())).toList().toString();
    _copyCurrentEditLead['tags'] = jsonEncode(_copyCurrentEditLead['tags']);
    _countriesList.forEach((country) {
      if (country![1] == _copyCurrentEditLead['country']) {
        _copyCurrentEditLead['country'] = country[0];
      }
    });

    await CrmService()
        .createLead(_copyCurrentEditLead, file!)
        .then((response) async {
      var res = json.decode(response.body);
      if (res['error'] == false) {
       // await fetchLeads();
        await dashboardBloc.fetchDashboardDetails();
      }
      result = res;
    }).catchError((onError) {
      print('createLead Error >> $onError');
      result = {"status": "error", "message": onError};
    });
    return result;
  }

  editLead() async {
    Map? result;
    Map _copyCurrentEditLead = new Map.from(_currentEditLead);
    _copyCurrentEditLead['status'] =
        _copyCurrentEditLead['status'].toLowerCase();
    _copyCurrentEditLead['industry'] =
        _copyCurrentEditLead['industry'].toLowerCase();
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
        .then((response) async {
      var res = json.decode(response.body);

      if (res["error"] == false) {
        await fetchLeads();
        await dashboardBloc.fetchDashboardDetails();
      }
      result = res;
    }).catchError((onError) {
      print('editLead Error >> $onError');
      result = {"status": "error", "message": onError};
    });
    return result;
  }

  Future deleteLead(Lead lead) async {
    Map? result;
    await CrmService().deleteLead(lead.id).then((response) async {
      var res = (json.decode(response.body));
      // openLeads.clear();
      // closedLeads.clear();
      await fetchLeads();
      await dashboardBloc.fetchDashboardDetails();
      result = res;
    }).catchError((onError) {
      print("deleteLead Error >> $onError");
      result = {"status": "error", "message": onError};
    });
    return result;
  }

  cancelCurrentEditLead() {
    _currentEditLead = {
      "first_name": "",
      "last_name": "",
      "phone": "",
      "account_name": "",
      "skype_ID": "",
      "title": "",
      "email": "",
      "website": "",
      "description": "",
      "opportunity_amount ": "",
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
  }

  updateCurrentEditLead(Lead editLead) async {
    _currentEditLeadId = editLead.id.toString();

    List teams = [];
    List assignedUsers = [];
    List<String>? tags = [];

    editLead.teams!.forEach((team) {
      teams.add(team.id);
    });

    editLead.assignedTo!.forEach((user) {
      assignedUsers.add(user.id);
    });

    for (var tag in editLead.tags!) {
      tags.add(tag['name']);
    }

    _countriesList.forEach((country) {
      if (country[0] == editLead.country) {
        editLead.country = country[1];
      }
    });

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
    _currentEditLead['status'] =
        editLead.status != null && editLead.status != ""
            ? editLead.status!.capitalizeFirstofEach()
            : editLead.status;
    _currentEditLead['source'] =
        editLead.source != null && editLead.source != ""
            ? editLead.source!.capitalizeFirstofEach()
            : editLead.source;
    _currentEditLead['tags'] = tags;
  }

  List? get tags {
    return _tags;
  }

  List get filterTags {
    return _filterTags;
  }

  Map get currentEditLead {
    return _currentEditLead;
  }

  set currentEditLead(currentEditLead) {
    _currentEditLead = currentEditLead;
  }

  String? get currentEditLeadId {
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

  List<String?> get source {
    return _source;
  }

  List<String?> get industry {
    return _indrustries;
  }

  List<String?> get status {
    return _status;
  }

  List<String?> get leadsTitles {
    return _leadsTitles;
  }

  List<Profile> get users {
    return _users;
  }

  Lead? get currentLead {
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

  List<String?> get countries {
    return _countries;
  }

  List? get countriesList {
    return _countriesList;
  }

  set countriesList(countriesList) {
    _countriesList = countriesList;
  }

  List get usersObjForDropdown {
    return _usersObjForDropdown;
  }

  // List<Team> get teams {
  //   return _teams;
  // }

  List get teamsObjForDropdown {
    return _teamsObjForDropdown;
  }

  String get offset {
    return _offset;
  }

  set offset(offset) {
    _offset = offset;
  }
}

final leadBloc = LeadBloc();
