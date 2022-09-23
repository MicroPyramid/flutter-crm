import 'dart:io';

import 'package:bottle_crm/bloc/account_bloc.dart';
import 'package:bottle_crm/bloc/auth_bloc.dart';
import 'package:bottle_crm/bloc/case_bloc.dart';
import 'package:bottle_crm/bloc/contact_bloc.dart';
import 'package:bottle_crm/bloc/dashboard_bloc.dart';
import 'package:bottle_crm/bloc/event_bloc.dart';
import 'package:bottle_crm/bloc/lead_bloc.dart';
import 'package:bottle_crm/bloc/opportunity_bloc.dart';
import 'package:bottle_crm/bloc/setting_bloc.dart';
import 'package:bottle_crm/bloc/task_bloc.dart';
import 'package:bottle_crm/bloc/team_bloc.dart';
import 'package:bottle_crm/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_color/random_color.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

var screenWidth;
var screenHeight;
// Color submitButtonColor = Color.fromRGBO(75, 153, 90, 1);
// Color bottomNavBarSelectedBGColor = Color.fromRGBO(219, 232, 249, 1);
// Color bottomNavBarSelectedTextColor = Color.fromRGBO(15, 36, 62, 1);
// Color bottomNavBarTextColor = Color.fromRGBO(75, 75, 78, 1);
String currentBottomNavigationIndex = "0";
String currentTopBarModuleName = "Dashboard";
Color bottomNavBarTextColor = Color.fromRGBO(75, 75, 78, 1);
Color submitButtonColor = Color.fromRGBO(75, 153, 90, 1);
Color bottomNavBarSelectedBGColor = Color.fromRGBO(219, 232, 249, 1);
Color bottomNavBarSelectedTextColor = Color.fromRGBO(15, 36, 62, 1);

RandomColor randomColor = RandomColor();

fetchRequiredData() async {
  print("fetching data ▁ ▂ ▃ ▄ ▅ ▆");
  await authBloc.getProfileDetails();
  await dashboardBloc.fetchDashboardDetails();
  await leadBloc.fetchLeads();
  await accountBloc.fetchAccounts();
  await contactBloc.fetchContacts();
  await opportunityBloc.fetchOpportunities();
  await caseBloc.fetchCases();
  await userBloc.fetchUsers();
  await taskBloc.fetchTasks();
  await teamBloc.fetchTeams();
  await eventBloc.fetchEvents();
  await settingsBloc.fetchApiSettings();
  print("✓ data fetched successfully");
}

OutlineInputBorder boxBorder() {
  return OutlineInputBorder(
    // borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(width: 0, color: Colors.white),
  );
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String capitalizeFirstofEach() =>
      this.split(" ").map((str) => str.inCaps).join(" ");
}

DateTime? currentBackPressTime;
Future<bool> onWillPop() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
    currentBackPressTime = now;
    Fluttertoast.showToast(msg: 'Press again to close Bottle CRM');
    return Future.value(false);
  }
  exit(0);
}

// showToast(message) {
//   Fluttertoast.showToast(
//     msg: message,
//     toastLength: Toast.LENGTH_LONG,
//     gravity: ToastGravity.CENTER,
//     timeInSecForIosWeb: 1,
//     backgroundColor: Colors.blue,
//     textColor: Colors.white,
//     fontSize: screenWidth / 26,
//   );
// }

showToaster(message, context) {
  showToast(
    message,
    context: context,
    animation: StyledToastAnimation.scale,
    reverseAnimation: StyledToastAnimation.fade,
    position: StyledToastPosition.bottom,
    animDuration: Duration(seconds: 1),
    duration: Duration(seconds: 4),
    curve: Curves.elasticOut,
    reverseCurve: Curves.linear,
  );
}

TextStyle buildLableTextStyle() {
  return TextStyle(
      fontSize: screenWidth / 25,
      fontWeight: FontWeight.w500,
      color: Colors.blueGrey);
}
