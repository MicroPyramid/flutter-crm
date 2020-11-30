import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

var screenWidth;
var screenHeight;
Color submitButtonColor = Color.fromRGBO(75, 153, 90, 1);
String currentBottomNavigationIndex = "0";

OutlineInputBorder boxBorder() {
  return OutlineInputBorder(
    // borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(width: 1, color: Colors.grey),
  );
}

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
