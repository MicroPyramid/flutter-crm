import 'dart:convert';
import 'package:flutter_crm/bloc/lead_bloc.dart';
import 'package:flutter_crm/model/account.dart';
import 'package:flutter_crm/model/profile.dart';
import 'package:flutter_crm/model/team.dart';
import 'package:flutter_crm/services/crm_services.dart';
import 'package:flutter_crm/utils/utils.dart';

class AccountBloc {
  List<Account> _openAccounts = [];
  List<Account> _closedAccounts = [];
  Account _currentAccount;
  String _currentAccountType = "Open";
  int _currentAccountIndex;
  String _currentEditAccountId;
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
    "tags": []
  };

  List<Map> _assignedToList = [];
  List countriesList;
  List _tags = [];

  Future fetchAccounts({filtersData}) async {
    await CrmService().getAccounts(queryParams: filtersData).then((response) {
      var res = (json.decode(response.body));

      _openAccounts.clear();
      _closedAccounts.clear();
      _assignedToList.clear();

      res['open_accounts'].forEach((_account) {
        Account account = Account.fromJson(_account);
        _openAccounts.add(account);
      });

      res['close_accounts'].forEach((_account) {
        Account account = Account.fromJson(_account);
        _closedAccounts.add(account);
      });

      res['users'].forEach((_user) {
        Profile user = Profile.fromJson(_user);
        _assignedToList.add({"name": user.userName, "id": user.id});
      });

      _tags = res['tags'];

      countriesList = leadBloc.countriesList;
    }).catchError((onError) {
      print("fetchAccounts Error>> $onError");
    });
  }

  Future createAccount() async {
    Map result;
    Map _copyCurrentEditAccount = new Map.from(_currentEditAccount);
    countriesList = leadBloc.countriesList;
    _copyCurrentEditAccount['contacts'] = (_copyCurrentEditAccount['contacts']
        .map((contact) => contact.toString())).toList().toString();
    _copyCurrentEditAccount['teams'] = (_copyCurrentEditAccount['teams']
        .map((team) => team.toString())).toList().toString();
    _copyCurrentEditAccount['assigned_to'] =
        (_copyCurrentEditAccount['assigned_to']
            .map((assignedTo) => assignedTo.toString())).toList().toString();
    _copyCurrentEditAccount['status'] =
        _copyCurrentEditAccount['status'].toLowerCase();
    countriesList.forEach((country) {
      if (country[1] == _copyCurrentEditAccount['billing_country']) {
        _copyCurrentEditAccount['billing_country'] = country[0];
      }
      leadBloc.openLeads.forEach((lead) {
        if (lead.title == _copyCurrentEditAccount['lead']) {
          _copyCurrentEditAccount['lead'] = lead.id.toString();
        }
      });
    });
    _copyCurrentEditAccount['tags'] =
        jsonEncode(_copyCurrentEditAccount['tags']);
    print(_copyCurrentEditAccount);
    await CrmService()
        .createAccount(_copyCurrentEditAccount)
        .then((response) async {
      var res = json.decode(response.body);
      if (res["errors"] != null) {
        // cancelCurrentEditAccount();
        res["error"] = true;
      } else {
        await fetchAccounts();
      }
      result = res;
      print("createAccount Response >> $res");
    }).catchError((onError) {
      print("createAccount Error >> $onError");
      result = {"status": "error", "message": "Something went wrong"};
    });
    return result;
  }

  Future editAccount() async {
    Map result;
    Map _copyCurrentEditAccount = new Map.from(_currentEditAccount);
    countriesList = leadBloc.countriesList;
    _copyCurrentEditAccount['contacts'] = (_copyCurrentEditAccount['contacts']
        .map((contact) => contact.toString())).toList().toString();
    _copyCurrentEditAccount['teams'] = (_copyCurrentEditAccount['teams']
        .map((team) => team.toString())).toList().toString();
    _copyCurrentEditAccount['assigned_to'] =
        (_copyCurrentEditAccount['assigned_to']
            .map((assignedTo) => assignedTo.toString())).toList().toString();
    _copyCurrentEditAccount['status'] =
        _copyCurrentEditAccount['status'].toLowerCase();
    countriesList.forEach((country) {
      if (country[1] == _copyCurrentEditAccount['billing_country']) {
        _copyCurrentEditAccount['billing_country'] = country[0];
      }
      leadBloc.openLeads.forEach((lead) {
        if (lead.title == _copyCurrentEditAccount['lead']) {
          _copyCurrentEditAccount['lead'] = lead.id.toString();
        }
      });
    });
    _copyCurrentEditAccount['tags'] =
        jsonEncode(_copyCurrentEditAccount['tags']);
    await CrmService()
        .editAccount(_copyCurrentEditAccount, _currentEditAccountId)
        .then((response) async {
      var res = json.decode(response.body);
      if (res["errors"] != null) {
        cancelCurrentEditAccount();
        res["error"] = true;
      } else {
        await fetchAccounts();
      }
      result = res;
      print("editAccount Response >> $res");
    }).catchError((onError) {
      print("editAccount Error >> $onError");
      result = {"status": "error", "message": "Something went wrong"};
    });
    return result;
  }

  Future deleteAccount(Account account) async {
    Map result;
    await CrmService().deleteAccount(account.id).then((response) async {
      var res = (json.decode(response.body));
      print('deleteAccount Response >> $res');
      await fetchAccounts();
      result = res;
    }).catchError((onError) {
      print("deleteAccount Error >> $onError");
      result = {"status": "error", "message": "Something went wrong."};
    });
    return result;
  }

  cancelCurrentEditAccount() {
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
      "tags": <String>[]
    };
  }

  updateCurrentEditAccount(Account editAccount) {
    _currentEditAccountId = editAccount.id.toString();
    print('Update Account Entries');
    print(_currentEditAccountId);
    List contacts = [];
    List teams = [];
    List assignedUsers = [];
    List<String> tags = [];

    editAccount.contacts.forEach((contact) {
      contacts.add(contact.id);
    });

    editAccount.assignedTo.forEach((assignedAccount) {
      assignedUsers.add(assignedAccount.id);
    });

    editAccount.teams.forEach((team) {
      teams.add(team.id);
    });

    editAccount.tags.forEach((tag) {
      tags.add(tag['name']);
    });

    _currentEditAccount['name'] = editAccount.name;
    _currentEditAccount['website'] = editAccount.website;
    _currentEditAccount['phone'] = editAccount.phone;
    _currentEditAccount['email'] = editAccount.email;
    _currentEditAccount['lead'] = editAccount.lead.title;
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
  }

  List<Account> get openAccounts {
    return _openAccounts;
  }

  List<Account> get closedAccounts {
    return _closedAccounts;
  }

  List<Map> get assignedToList {
    return _assignedToList;
  }

  Map get currentEditAccount {
    return _currentEditAccount;
  }

  set currentEditAccount(currentEditAccount) {
    _currentEditAccount = currentEditAccount;
  }

  List get tags {
    return _tags;
  }

  String get currentEditAccountId {
    return _currentEditAccountId;
  }

  set currentEditAccountId(id) {
    _currentEditAccountId = id;
  }

  Account get currentAccount {
    return _currentAccount;
  }

  set currentAccount(account) {
    _currentAccount = account;
  }

  int get currentAccountIndex {
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
}

final accountBloc = AccountBloc();
