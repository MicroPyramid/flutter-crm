import 'dart:convert';
import 'package:flutter_crm/model/account.dart';
import 'package:flutter_crm/services/crm_services.dart';

class AccountBloc {
  List<Account> _openAccounts = [];
  List<Account> _closedAccounts = [];
  Account _currentAccount;
  String _currentAccountType = "Open";

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

  String get currentAccountType {
    return _currentAccountType;
  }

  set currentAccountType(String type) {
    _currentAccountType = type;
  }
}

final accountBloc = AccountBloc();
