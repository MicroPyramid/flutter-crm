import 'package:flutter/material.dart';
import 'package:flutter_crm/ui/widgets/side_menu.dart';
import 'package:flutter_crm/utils/utils.dart';

class DocumentsScreen extends StatefulWidget {
  DocumentsScreen();
  @override
  State createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
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
            title: Text("Documents"),
          ),
          drawer: SideMenuDrawer(),
          body: Center(
            child: Text("This page under Development..."),
          )),
    );
  }
}
