import 'dart:convert';
import 'package:flutter_crm/model/account.dart';
import 'package:flutter_crm/model/contact.dart';
import 'package:flutter_crm/model/profile.dart';
import 'package:flutter_crm/model/team.dart';
import 'package:flutter_crm/services/crm_services.dart';

class AccountBloc {
  List<Account> _openAccounts = [];
  List<Account> _closedAccounts = [];
  Account _currentAccount;
  String _currentAccountType = "Open";
  int _currentAccountIndex;
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
    "users": [],
    "assigned_to": [],
    "status": "Open",
    "tags": List<String>()
  };

  Future fetchAccounts() async {
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
    }).catchError((onError) {
      print("fetchAccounts>> $onError");
    });
  }

  Future deleteAccount(Account account) async {
    await CrmService().deleteAccount(account.id).then((response) {
      var res = (json.decode(response.body));
      print('account delete>> $res');
    }).catchError((onError) {
      print("deleteAccount>> $onError");
    });
  }

  updateCurrentEditAccount(Account editAccount) {
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

    editAccount.teams.forEach((team) {
      Map _team = {};
      _team['id'] = team.id;
      _team['name'] = team.name;
      teams.add(_team);
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
    _currentEditAccount['teams'] = teams;
    _currentEditAccount['users'] = [];
    _currentEditAccount['assigned_to'] = assignedUsers;
    _currentEditAccount['status'] = editAccount.status;
    _currentEditAccount['tags'] = tags;
  }

  Map get currentEditAccount {
    return _currentEditAccount;
  }

  set currentEditAccount(Map currentEditAccount) {
    _currentEditAccount = currentEditAccount;
  }

  List<Account> get openAccounts {
    return _openAccounts;
  }

  List<Account> get closedAccounts {
    return _closedAccounts;
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
