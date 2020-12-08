import 'dart:convert';
import 'package:flutter_crm/model/account.dart';
import 'package:flutter_crm/services/crm_services.dart';

class AccountBloc {
  List<Account> _openAccounts = [];
  List<Account> _closedAccounts = [];
  Account _currentAccount;
  String _currentAccountType = "Open";
  int _currentAccountIndex;

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
