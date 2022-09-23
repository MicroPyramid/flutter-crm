import 'dart:convert';
import 'dart:io';

import 'package:bottle_crm/model/account.dart';
import 'package:bottle_crm/model/opportunities.dart';
import 'package:bottle_crm/services/crm_services.dart';
import 'package:intl/intl.dart';

import 'dashboard_bloc.dart';

class OpportunityBloc {
  List<Opportunity> _opportunities = [];
  int? _currentOpportunityIndex;
  Opportunity? _currentOpportunity;
  String? _currentEditOpportunityId;

  Map _currentEditOpportunity = {
    'name': "",
    'account': "",
    'stage': "",
    'currency': "",
    'amount': "",
    'lead_source': "",
    'probability': 0,
    'contacts': [],
    'due_date': DateFormat("yyyy-MM-dd")
        .format(DateFormat("yyyy-MM-dd").parse(DateTime.now().toString())),
    'description': "",
    'assigned_to': [],
    'tags': <String>[],
    'teams': [],
  };

  List<String>? _tags = [];
  List<String?> _accountsObjforDropDown = [];
  List<String?> _stageObjforDropDown = [];
  List<String?> _leadSourceObjforDropDown = [];
  List<String?> _currencyObjforDropDown = [];
  List? _currencyList = [];
  List _accountsList = [];
  List _filterTags = [];
  String _offset = "";

  Future fetchOpportunities({filtersData}) async {
    Map? _copyFiltersData =
        filtersData != null ? new Map.from(filtersData) : null;
    if (filtersData != null) {
      _copyFiltersData!['tags'] = _copyFiltersData['tags'].length > 0
          ? jsonEncode(_copyFiltersData['tags'])
          : "";
      if (_copyFiltersData['account'] != null) {
        _accountsList.forEach((element) {
          if (element[1] == _copyFiltersData['account']) {
            _copyFiltersData['account'] = element[0].toString();
          }
        });
      }
    }

    await CrmService()
        .getOpportunities(queryParams: _copyFiltersData, offset: _offset)
        .then((response) {
      var res = jsonDecode(response.body);

      //_opportunities.clear();
      _accountsObjforDropDown.clear();
      _accountsList.clear();
      _currencyObjforDropDown.clear();

      res['opportunities'].forEach((_opportunity) {
        Opportunity oppor = Opportunity.fromJson(_opportunity);
        _opportunities.add(oppor);
      });

      _filterTags = res['tags'] != null ? res['tags'] : [];
      _filterTags = res['tags'];

      _offset = res['offset'] != null && res['offset'].toString() != "0"
          ? res['offset'].toString()
          : "";

      res['accounts_list'].forEach((_account) {
        Account acc = Account.fromJson(_account);
        _accountsObjforDropDown.add(acc.name);
        _accountsList.add([acc.id, acc.name]);
      });
      // _stageObjforDropDown = res['stage'];
      //_leadSourceObjforDropDown = res['lead_source'];
      if (res['stage'] != null) {
        _stageObjforDropDown.clear();
        res['stage'].forEach((_stage) {
          _stageObjforDropDown.add(_stage[1]);
        });
      }
      if (res['lead_source'] != null) {
        _leadSourceObjforDropDown.clear();
        res['lead_source'].forEach((_leadsource) {
          _leadSourceObjforDropDown.add(_leadsource[1]);
        });
      }
      res['currency'].forEach((curr) {
        _currencyObjforDropDown.add(curr[1]);
      });

      _currencyList = res['currency'];
    }).catchError((onError) {
      print("fetchOpportunities Error >> $onError");
    });
  }

  Future createOpportunity({File? file}) async {
    Map? result;
    Map _copyOfCurrentEditOpportunity = new Map.from(_currentEditOpportunity);
    _accountsList.forEach((element) {
      if (element[1] == _copyOfCurrentEditOpportunity['account']) {
        _copyOfCurrentEditOpportunity['account'] = element[0].toString();
      }
    });
    if (_copyOfCurrentEditOpportunity['currency'] == "" ||
        _copyOfCurrentEditOpportunity['currency'] == null) {
      _copyOfCurrentEditOpportunity['currency'] = "";
    } else {
      _currencyList!.forEach((element) {
        if (element[1] == _copyOfCurrentEditOpportunity['currency']) {
          _copyOfCurrentEditOpportunity['currency'] = element[0];
        }
      });
    }
    _copyOfCurrentEditOpportunity['probability'] =
        _copyOfCurrentEditOpportunity['probability'].toString();

    _copyOfCurrentEditOpportunity['teams'] =
        (_copyOfCurrentEditOpportunity['teams'].map((e) => e.toString()))
            .toList()
            .toString();
    _copyOfCurrentEditOpportunity['assigned_to'] =
        (_copyOfCurrentEditOpportunity['assigned_to'].map((e) => e.toString()))
            .toList()
            .toString();
    _copyOfCurrentEditOpportunity['contacts'] =
        (_copyOfCurrentEditOpportunity['contacts'].map((e) => e.toString()))
            .toList()
            .toString();

    // if (_copyOfCurrentEditOpportunity['due_date'] != "")
    //   _copyOfCurrentEditOpportunity['due_date'] =
    //   DateFormat("yyyy-MM-dd")
    //       .format(DateFormat("dd-MM-yyyy")
    //           .parse(_copyOfCurrentEditOpportunity['due_date']));

    _copyOfCurrentEditOpportunity['tags'] =
        jsonEncode(_copyOfCurrentEditOpportunity['tags']);
    if (_copyOfCurrentEditOpportunity != null) {
      _copyOfCurrentEditOpportunity
          .removeWhere((key, value) => value.runtimeType != String);
      _copyOfCurrentEditOpportunity
          .removeWhere((key, value) => key == "closed_on");
    }
    await CrmService()
        .createOpportunity(_copyOfCurrentEditOpportunity, file!)
        .then((response) async {
      // var res = json.decode(response);  # for multipartrequest
      var res = json.decode(response.body);
      if (res["error"] == false) {
        await fetchOpportunities();
        await dashboardBloc.fetchDashboardDetails();
      }
      result = res;
    }).catchError((onError) {
      print("createOpportunity Error >> $onError");
      result = {"status": "error", "message": onError};
    });
    return result;
  }

  Future editOpportunity() async {
    Map? result;
    Map _copyOfCurrentEditOpportunity = new Map.from(_currentEditOpportunity);

    _accountsList.forEach((element) {
      if (element[1] == _copyOfCurrentEditOpportunity['account']) {
        _copyOfCurrentEditOpportunity['account'] = element[0].toString();
      }
    });

    if (_copyOfCurrentEditOpportunity['currency'] == "" ||
        _copyOfCurrentEditOpportunity['currency'] == null) {
      _copyOfCurrentEditOpportunity['currency'] = "";
    } else {
      _currencyList!.forEach((element) {
        if (element[1] == _copyOfCurrentEditOpportunity['currency']) {
          _copyOfCurrentEditOpportunity['currency'] = element[0];
        }
      });
    }
    _copyOfCurrentEditOpportunity['probability'] =
        _copyOfCurrentEditOpportunity['probability'].toString();

    _copyOfCurrentEditOpportunity['teams'] =
        (_copyOfCurrentEditOpportunity['teams'].map((e) => e.toString()))
            .toList()
            .toString();
    _copyOfCurrentEditOpportunity['assigned_to'] =
        (_copyOfCurrentEditOpportunity['assigned_to'].map((e) => e.toString()))
            .toList()
            .toString();
    _copyOfCurrentEditOpportunity['contacts'] =
        (_copyOfCurrentEditOpportunity['contacts'].map((e) => e.toString()))
            .toList()
            .toString();
    _copyOfCurrentEditOpportunity['tags'] =
        jsonEncode(_copyOfCurrentEditOpportunity['tags']);

    _copyOfCurrentEditOpportunity['opportunity_attachment'] = "";

    if (_copyOfCurrentEditOpportunity['closed_on'] != "")
      _copyOfCurrentEditOpportunity['due_date'] = DateFormat("yyyy-MM-dd")
          .format(DateFormat("dd-MM-yyyy")
              .parse(_copyOfCurrentEditOpportunity['closed_on']));

    if (_copyOfCurrentEditOpportunity != null) {
      _copyOfCurrentEditOpportunity
          .removeWhere((key, value) => value.runtimeType != String);
      _copyOfCurrentEditOpportunity
          .removeWhere((key, value) => key == "closed_on");
    }

    await CrmService()
        .editOpportunity(
            _copyOfCurrentEditOpportunity, _currentEditOpportunityId)
        .then((response) async {
      var res = json.decode(response.body);
      if (res["error"] == false) {
        await fetchOpportunities();
        await dashboardBloc.fetchDashboardDetails();
      }
      result = res;
    });
    // .catchError((onError) {
    //   print("editOpportunity Error >> $onError");
    //   result = {"status": "error", "message": onError};
    // });
    return result;
  }

  Future deleteOpportunity(Opportunity opportunity) async {
    Map? result;
    await CrmService()
        .deletefromModule('opportunities', opportunity.id)
        .then((response) async {
      var res = (json.decode(response.body));
      opportunities.clear();
      await fetchOpportunities();
      await dashboardBloc.fetchDashboardDetails();
      result = res;
    }).catchError((onError) {
      print("deleteOpportunity Error >> $onError");
      result = {"status": "error", "message": onError};
    });
    return result;
  }

  cancelCurrentEditOpportunity() {
    _currentEditOpportunityId = null;
    _currentEditOpportunity = {
      'name': "",
      'account': "",
      'stage': "",
      'currency': "",
      'amount': "",
      'lead_source': "",
      'probability': 0,
      'contacts': [],
      'due_date': DateFormat("yyyy-MM-dd")
          .format(DateFormat("yyyy-MM-dd").parse(DateTime.now().toString())),
      'closed_on': "",
      'description': "",
      'assigned_to': [],
      'tags': <String>[],
      'teams': [],
      "opportunity_attachment": []
    };
  }

  updateCurrentEditOpportunity(Opportunity editOpportunity) {
    List _contacts = [];
    List _teams = [];
    List _assignedUsers = [];
    List<String?> _tags = [];

    _currentEditOpportunityId = editOpportunity.id.toString();
    editOpportunity.contacts!.forEach((contact) {
      _contacts.add(contact.id);
    });
    editOpportunity.assignedTo!.forEach((assignedAccount) {
      _assignedUsers.add(assignedAccount.id);
    });
    editOpportunity.teams!.forEach((team) {
      _teams.add(team.id);
    });
    editOpportunity.tags!.forEach((tag) {
      _tags.add(tag['name']);
    });

    _currentEditOpportunity = {
      'name': editOpportunity.name,
      'account': editOpportunity.account!.name,
      'stage': editOpportunity.stage,
      'currency': editOpportunity.currency,
      'amount': editOpportunity.amount,
      'lead_source': editOpportunity.leadSource,
      'probability': editOpportunity.probability,
      'contacts': _contacts,
      'closed_on': editOpportunity.closedOn,
      'description': editOpportunity.description,
      'assigned_to': _assignedUsers,
      'tags': _tags,
      'teams': _teams,
      'opportunity_attachment': (editOpportunity.opportunityAttachment!.isEmpty)
          ? []
          : editOpportunity.opportunityAttachment![0]['file_path']
    };
  }

  List<Opportunity> get opportunities {
    return _opportunities;
  }

  int? get currentOpportunityIndex {
    return _currentOpportunityIndex;
  }

  set currentOpportunityIndex(index) {
    _currentOpportunityIndex = index;
  }

  Opportunity? get currentOpportunity {
    return _currentOpportunity;
  }

  set currentOpportunity(currOpp) {
    _currentOpportunity = currOpp;
  }

  String? get currentEditOpportunityId {
    return _currentEditOpportunityId;
  }

  set currentEditOpportunityId(id) {
    _currentEditOpportunityId = id;
  }

  Map get currentEditOpportunity {
    return _currentEditOpportunity;
  }

  set currentEditOpportunity(currEditOpp) {
    _currentEditOpportunity = currEditOpp;
  }

  List<String>? get tags {
    return _tags;
  }

  List get filtertags {
    return _filterTags;
  }

  List<String?> get accountsObjforDropDown {
    return _accountsObjforDropDown;
  }

  List get accountsList {
    return _accountsList;
  }

  List<String?> get stageObjforDropDown {
    return _stageObjforDropDown;
  }

  List<String?> get leadSourceObjforDropDown {
    return _leadSourceObjforDropDown;
  }

  List<String?> get currencyObjforDropDown {
    return _currencyObjforDropDown;
  }

  String get offset {
    return _offset;
  }

  set offset(offset) {
    _offset = offset;
  }
}

final opportunityBloc = OpportunityBloc();
