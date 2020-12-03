import 'package:flutter/material.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/utils/utils.dart';

class LeadsScreen extends StatefulWidget {
  LeadsScreen();
  @override
  State createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
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
          title: Text("Leads"),
        ),
        body: Center(
          child: Text("This page under Development..."),
        ),
        bottomNavigationBar: BottomNavigationBarWidget(),
      ),
    );
  }
}
