import 'package:flutter/material.dart';
import 'package:flutter_crm/ui/widgets/side_menu.dart';
import 'package:flutter_crm/utils/utils.dart';

class AccountsScreen extends StatefulWidget {
  AccountsScreen();
  @override
  State createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Accounts"),
          ),
          drawer: SideMenuDrawer(),
          body: Center(
            child: Text("This page under Development..."),
          )),
    );
  }
}
