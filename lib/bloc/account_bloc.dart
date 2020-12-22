import 'dart:convert';
import 'package:flutter_crm/bloc/lead_bloc.dart';
import 'package:flutter_crm/model/account.dart';
import 'package:flutter_crm/model/profile.dart';
import 'package:flutter_crm/services/crm_services.dart';

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
    // "users": [],
    "assigned_to": [],
    "status": "Open",
    "tags": []
  };

  List<Map> _assignedToList = [];
  List countriesList;

  Future fetchAccounts() async {
    _openAccounts.clear();
    _closedAccounts.clear();
    await CrmService().getAccounts().then((response) {
      var res = (json.decode(response.body));

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
        _assignedToList.add({"name": user.userName, "id": user.id.toString()});
      });

      countriesList = leadBloc.countriesList;
    }).catchError((onError) {
      print("fetchAccounts>> $onError");
    });
  }

  Future createAccount() async {
    Map result;
    countriesList = leadBloc.countriesList;
    _currentEditAccount['contacts'] = (_currentEditAccount['contacts']
        .map((contact) => contact.toString())).toList().toString();
    _currentEditAccount['teams'] = (_currentEditAccount['teams']
        .map((team) => team.toString())).toList().toString();
    _currentEditAccount['assigned_to'] = (_currentEditAccount['assigned_to']
        .map((assignedTo) => assignedTo.toString())).toList().toString();
    _currentEditAccount['tags'] = jsonEncode(_currentEditAccount['tags']);
    _currentEditAccount['status'] = _currentEditAccount['status'].toLowerCase();
    countriesList.forEach((country) {
      if (country[1] == _currentEditAccount['billing_country']) {
        _currentEditAccount['billing_country'] = country[0];
      }
      leadBloc.openLeads.forEach((lead) {
        if (lead.title == _currentEditAccount['lead']) {
          _currentEditAccount['lead'] = lead.id.toString();
        }
      });
    });
    await CrmService()
        .createAccount(_currentEditAccount)
        .then((response) async {
      var res = json.decode(response.body);
      if (res["errors"] != null) {
        cancelCurrentEditAccount();
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
    countriesList = leadBloc.countriesList;
    _currentEditAccount['contacts'] = (_currentEditAccount['contacts']
        .map((contact) => contact.toString())).toList().toString();
    _currentEditAccount['teams'] = (_currentEditAccount['teams']
        .map((team) => team.toString())).toList().toString();
    _currentEditAccount['assigned_to'] = (_currentEditAccount['assigned_to']
        .map((assignedTo) => assignedTo.toString())).toList().toString();
    _currentEditAccount['tags'] = jsonEncode(_currentEditAccount['tags']);
    _currentEditAccount['status'] = _currentEditAccount['status'].toLowerCase();
    countriesList.forEach((country) {
      if (country[1] == _currentEditAccount['billing_country']) {
        _currentEditAccount['billing_country'] = country[0];
      }
      leadBloc.openLeads.forEach((lead) {
        if (lead.title == _currentEditAccount['lead']) {
          _currentEditAccount['lead'] = lead.id.toString();
        }
      });
    });
    await CrmService()
        .editAccount(_currentEditAccount, _currentEditAccountId)
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
    await CrmService().deleteAccount(account.id).then((response) {
      var res = (json.decode(response.body));
      print('deleteAccount Response >> $res');
    }).catchError((onError) {
      print("deleteAccount Error >> $onError");
    });
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
      // "users": [],
      "assigned_to": [],
      "status": "Open",
      "tags": List<String>()
    };
  }

  updateCurrentEditAccount(Account editAccount) {
    _currentEditAccountId = editAccount.id.toString();
    List contacts = [];
    List teams = [];
    List assignedUsers = [];
    List<String> tags = [];

    editAccount.contacts.forEach((contact) {
      Map _contact = {};
      _contact['id'] = contact.id;
      _contact['name'] = contact.firstName + ' ' + contact.lastName;
      contacts.add(_contact);
    });

    editAccount.assignedTo.forEach((user) {
      Map _user = {};
      _user['id'] = user.id;
      _user['name'] = user.firstName + ' ' + user.lastName;
      assignedUsers.add(_user);
    });

    for (var tag in editAccount.tags) {
      tags.add(tag['name']);
    }

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
    _currentEditAccount['teams'] = [
      editAccount.teams.map((team) => team.toString())
    ];
    // _currentEditAccount['users'] = [];
    _currentEditAccount['assigned_to'] = [
      editAccount.assignedTo.map((assingedTo) => assingedTo.toString())
    ];
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

  set currentEditAccount(Map currentEditAccount) {
    _currentEditAccount = currentEditAccount;
  }

  String get currentEditAccountId {
    return _currentEditAccountId;
  }

  set currentEditAccountId(String id) {
    _currentEditAccountId = id;
  }

  Account get currentAccount {
    return _currentAccount;
  }

  set currentAccount(Account account) {
    _currentAccount = account;
  }

  int get currentAccountIndex {
    return _currentAccountIndex;
  }

  set currentAccountIndex(int index) {
    _currentAccountIndex = index;
  }

  String get currentAccountType {
    return _currentAccountType;
  }

  set currentAccountType(String type) {
    _currentAccountType = type;
  }
}

final accountBloc = AccountBloc();
