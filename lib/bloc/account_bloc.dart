import 'dart:convert';
import 'dart:io';
import 'package:bottle_crm/bloc/dashboard_bloc.dart';
import 'package:bottle_crm/bloc/lead_bloc.dart';
import 'package:bottle_crm/model/account.dart';
import 'package:bottle_crm/model/profile.dart';
import 'package:bottle_crm/services/crm_services.dart';

class AccountBloc {
  List<Account> _openAccounts = [];
  List<Account> _closedAccounts = [];
  Account? _currentAccount;
  String _currentAccountType = "Open";
  int? _currentAccountIndex;
  String? _currentEditAccountId = "";
  Map _currentEditAccount = {
    "name": "",
    "website": "",
    "phone": "",
    "email": "",
    "lead": null,
    "billing_address_line": "",
    "billing_street": "",
    "billing_postcode": "",
    "billing_city": "",
    "billing_state": "",
    "billing_country": null,
    "contacts": [],
    "teams": [],
    "assigned_to": [],
    "status": "open",
    "tags": [],
    "description":"",
  };
  String _offset = "";

  List _assignedToList = [];
  List<String?> countriesList = [];
  List<String>? _tags = [];
  List _filterTags = [];

  Future fetchAccounts({filtersData}) async {
    try {
      Map? _copyFiltersData =
          filtersData != null ? new Map.from(filtersData) : null;
      if (filtersData != null) {
        _copyFiltersData!['tags'] = _copyFiltersData['tags'].length > 0
            ? jsonEncode(_copyFiltersData['tags'])
            : "";
      }
      await CrmService()
          .getAccounts(queryParams: _copyFiltersData, offset: _offset)
          .then((response) {
        var res = (json.decode(response.body));
        _assignedToList.clear();

        res['active_accounts']['open_accounts'].forEach((_account) {
          leadBloc.countriesList!.forEach((country) {
            if (_account!["billing_country"] == country[0]) {
              _account!["billing_country"] = country[1];
            }
          });
          Account account = Account.fromJson(_account);
          _openAccounts.add(account);
        });
        res['closed_accounts']['close_accounts'].forEach((_account) {
          leadBloc.countriesList!.forEach((country) {
            if (_account!["billing_country"] == country[0]) {
              _account!["billing_country"] = country[1];
            }
          });
          Account account = Account.fromJson(_account);
          _closedAccounts.add(account);
        });
        if (res['users'] != null)
          res['users'].forEach((_user) {
            Profile user = Profile.fromJson(_user);
            _assignedToList.add({"name": user.firstName, "id": user.id});
          });
        _filterTags = res['tags'] != null ? res['tags'] : [];
        _offset = res['active_accounts']['offset'] != null &&
                res['active_accounts']['offset'].toString() != "0"
            ? res['active_accounts']['offset'].toString()
            : res['closed_accounts']['offset'] != null &&
                    res['closed_accounts']['offset'].toString() != "0"
                ? res['closed_accounts']['offset'].toString()
                : "";
      }).catchError((onError) {
        print("fetchAccounts Error>> $onError");
      });
    } catch (e) {}
  }

  Future createAccount({File? file}) async {
    print(_currentEditAccount);
    try {
      Map result = {};
      Map _copyCurrentEditAccount = new Map.from(_currentEditAccount);
      _copyCurrentEditAccount['contacts'] = (_copyCurrentEditAccount['contacts']
          .map((contact) => contact.toString())).toList().toString();
      _copyCurrentEditAccount['teams'] = (_copyCurrentEditAccount['teams']
          .map((team) => team.toString())).toList().toString();
      _copyCurrentEditAccount['assigned_to'] =
          (_copyCurrentEditAccount['assigned_to']
              .map((assignedTo) => assignedTo.toString())).toList().toString();
      _copyCurrentEditAccount['status'] =
          _copyCurrentEditAccount['status'].toLowerCase();
      leadBloc.countriesList!.forEach((country) {
        if (country![1] == _copyCurrentEditAccount['billing_country']) {
          _copyCurrentEditAccount['billing_country'] = country[0];
        }
      });
      leadBloc.openLeads.forEach((lead) {
        if (lead.title == _copyCurrentEditAccount['lead']) {
          _copyCurrentEditAccount['lead'] = lead.id.toString();
        }
      });
      _copyCurrentEditAccount['tags'] =
          jsonEncode(_copyCurrentEditAccount['tags']);
          print(_copyCurrentEditAccount);
      await CrmService()
          .createAccount(_copyCurrentEditAccount, file!)
          .then((response) async {
          print(_copyCurrentEditAccount);  
        var res = json.decode(response.body);
        if (res["error"] == false) {
          offset = "";
          await fetchAccounts();
          await dashboardBloc.fetchDashboardDetails();
        }
        result = res;
      })
      .catchError((onError) {
        print("createAccount Error >> $onError");
        result = {"status": "error", "message": onError};
      });
      return result;
    } catch (e) {}
  }

  Future editAccount() async {
    Map? result;
    Map _copyCurrentEditAccount = new Map.from(_currentEditAccount);
    countriesList = leadBloc.countries;
    _copyCurrentEditAccount['contacts'] = (_copyCurrentEditAccount['contacts']
        .map((contact) => contact.toString())).toList().toString();
    _copyCurrentEditAccount['teams'] = (_copyCurrentEditAccount['teams']
        .map((team) => team.toString())).toList().toString();
    _copyCurrentEditAccount['assigned_to'] =
        (_copyCurrentEditAccount['assigned_to']
            .map((assignedTo) => assignedTo.toString())).toList().toString();
    _copyCurrentEditAccount['status'] =
        _copyCurrentEditAccount['status'].toLowerCase();
    leadBloc.countriesList!.forEach((country) {
      if (country![1] == _copyCurrentEditAccount['billing_country']) {
        _copyCurrentEditAccount['billing_country'] = country[0];
      }
    });
    leadBloc.openLeads.forEach((lead) {
      if (lead.title == _copyCurrentEditAccount['lead']) {
        _copyCurrentEditAccount['lead'] = lead.id.toString();
      }
    });
    _copyCurrentEditAccount['tags'] =
        jsonEncode(_copyCurrentEditAccount['tags']);
    await CrmService()
        .editAccount(_copyCurrentEditAccount, _currentEditAccountId)
        .then((response) async {
      var res = json.decode(response.body);
      if (res["error"] == false) {
        offset = "";
        await fetchAccounts();
        await dashboardBloc.fetchDashboardDetails();
      }
      result = res;
    }).catchError((onError) {
      print("editAccount Error >> $onError");
      result = {"status": "error", "message": onError};
    });
    return result;
  }

  Future deleteAccount(Account account) async {
    Map? result = {};
    await CrmService().deleteAccount(account.id).then((response) async {
      var res = (json.decode(response.body));
      await fetchAccounts();
      await dashboardBloc.fetchDashboardDetails();
      result = res;
    }).catchError((onError) {
      print("deleteAccount Error >> $onError");
      result = {"status": "error", "message": onError};
    });
    return result;
  }

  resetAccountFields() {
    _currentEditAccountId = null;
    _currentEditAccount = {
      "name": "",
      "website": "",
      "phone": "",
      "email": "",
      "lead": null,
      "billing_address_line": "",
      "billing_street": "",
      "billing_postcode": "",
      "billing_city": "",
      "billing_state": "",
      "billing_country": null,
      "contacts": [],
      "teams": [],
      "assigned_to": [],
      "status": "open",
      "tags": [],
    };
    _tags = [];
  }

  updateCurrentEditAccount(Account editAccount) {
    List contacts = [];
    List teams = [];
    List assignedUsers = [];
    List<String>? tags = [];
    _currentEditAccountId = editAccount.id.toString();
    editAccount.contacts!.forEach((contact) {
      contacts.add(contact.id);
    });

    editAccount.assignedTo!.forEach((assignedAccount) {
      assignedUsers.add(assignedAccount.id);
    });

    editAccount.teams!.forEach((team) {
      teams.add(team.id);
    });

    editAccount.tags!.forEach((tag) {
      tags.add(tag['name']!);
    });

    _currentEditAccount['name'] = editAccount.name;
    _currentEditAccount['website'] = editAccount.website;
    _currentEditAccount['phone'] = editAccount.phone;
    _currentEditAccount['email'] = editAccount.email;
    _currentEditAccount['lead'] = editAccount.lead!.title;
    _currentEditAccount['billing_address_line'] =
        editAccount.billingAddressLine;
    _currentEditAccount['billing_street'] = editAccount.billingStreet;
    _currentEditAccount['billing_postcode'] = editAccount.billingPostcode;
    _currentEditAccount['billing_city'] = editAccount.billingCity;
    _currentEditAccount['billing_state'] = editAccount.billingState;
    _currentEditAccount['billing_country'] = editAccount.billingCountry;
    _currentEditAccount['contacts'] = contacts;
    _currentEditAccount['teams'] = teams;
    _currentEditAccount['assigned_to'] = assignedUsers;
    _currentEditAccount['status'] = editAccount.status;
    _currentEditAccount['tags'] = tags;
    _tags = tags;
  }

  List<Account> get openAccounts {
    return _openAccounts;
  }

  List<Account> get closedAccounts {
    return _closedAccounts;
  }

  List get assignedToList {
    return _assignedToList;
  }

  Map get currentEditAccount {
    return _currentEditAccount;
  }

  set currentEditAccount(currentEditAccount) {
    _currentEditAccount = currentEditAccount;
  }

  List<String>? get tags {
    return _tags;
  }

  List get filterTags {
    return _filterTags;
  }

  String? get currentEditAccountId {
    return _currentEditAccountId;
  }

  set currentEditAccountId(id) {
    _currentEditAccountId = id;
  }

  Account? get currentAccount {
    return _currentAccount;
  }

  set currentAccount(account) {
    _currentAccount = account;
  }

  int? get currentAccountIndex {
    return _currentAccountIndex;
  }

  set currentAccountIndex(index) {
    _currentAccountIndex = index;
  }

  String get currentAccountType {
    return _currentAccountType;
  }

  set currentAccountType(type) {
    _currentAccountType = type;
  }

  String get offset {
    return _offset;
  }

  set offset(offset) {
    _offset = offset;
  }
}

final accountBloc = AccountBloc();
