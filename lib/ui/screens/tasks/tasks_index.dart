import 'package:flutter/material.dart';
import 'package:flutter_crm/ui/widgets/side_menu.dart';
import 'package:flutter_crm/utils/utils.dart';

class TasksScreen extends StatefulWidget {
  TasksScreen();
  @override
  State createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
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
            title: Text("Tasks"),
          ),
          drawer: SideMenuDrawer(),
          body: Center(
            child: Text("This page under Development..."),
          )),
    );
  }
}
