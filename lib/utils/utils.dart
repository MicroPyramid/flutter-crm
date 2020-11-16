import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';

String selectedSidebarName = "Dashboard";
String currentSidebarModuleName = "Sales";

DateTime currentBackPressTime;
Future<bool> onWillPop() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime) > Duration(seconds: 2)) {
    currentBackPressTime = now;
    Fluttertoast.showToast(msg: 'Press again to close');
    return Future.value(false);
  }
  exit(0);
}
