import 'package:flutter/material.dart';
import 'package:flutter_crm/ui/widgets/side_menu.dart';
import 'package:flutter_crm/utils/utils.dart';

class ContactsScreen extends StatefulWidget {
  ContactsScreen();
  @override
  State createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
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
            title: Text('Contacts'),
          ),
          drawer: SideMenuDrawer(),
          body: Center(
            child: Text("This page under Development..."),
          )),
    );
  }
}
