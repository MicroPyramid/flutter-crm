import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  @override
  State createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  String _currentBottomBarIndex = "0";
  @override
  void initState() {
    setState(() {
      _currentBottomBarIndex = currentBottomNavigationIndex;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.08,
      color: Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (_currentBottomBarIndex != '0') {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/dashboard', (route) => false);
                setState(() {
                  _currentBottomBarIndex = "0";
                });
                currentBottomNavigationIndex = _currentBottomBarIndex;
              }
            },
            child: Container(
              color: _currentBottomBarIndex == "0"
                  ? bottomNavBarSelectedBGColor
                  : Colors.white,
              width: screenWidth * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: SvgPicture.asset(
                      'assets/images/dashboard_icon.svg',
                      width: screenWidth / 15,
                      color: _currentBottomBarIndex == "0"
                          ? bottomNavBarSelectedTextColor
                          : bottomNavBarTextColor,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(
                      "Dashboard",
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: _currentBottomBarIndex == "0"
                                  ? bottomNavBarSelectedTextColor
                                  : bottomNavBarTextColor)),
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_currentBottomBarIndex != '1') {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/leads', (route) => false);
                setState(() {
                  _currentBottomBarIndex = "1";
                });
                currentBottomNavigationIndex = _currentBottomBarIndex;
              }
            },
            child: Container(
              color: _currentBottomBarIndex == "1"
                  ? bottomNavBarSelectedBGColor
                  : Colors.white,
              width: screenWidth * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: SvgPicture.asset(
                      'assets/images/leads_icon.svg',
                      width: screenWidth / 15,
                      color: _currentBottomBarIndex == "1"
                          ? bottomNavBarSelectedTextColor
                          : bottomNavBarTextColor,
                    ),
                  ),
                  Container(
                    child: Text(
                      "Leads",
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: _currentBottomBarIndex == "1"
                                  ? bottomNavBarSelectedTextColor
                                  : bottomNavBarTextColor)),
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_currentBottomBarIndex != '2') {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/account_list', (route) => false);
                setState(() {
                  _currentBottomBarIndex = "2";
                });
                currentBottomNavigationIndex = _currentBottomBarIndex;
              }
            },
            child: Container(
              color: _currentBottomBarIndex == "2"
                  ? bottomNavBarSelectedBGColor
                  : Colors.white,
              width: screenWidth * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: SvgPicture.asset(
                      'assets/images/accounts_icon.svg',
                      width: screenWidth / 15,
                      color: _currentBottomBarIndex == "2"
                          ? bottomNavBarSelectedTextColor
                          : bottomNavBarTextColor,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(
                      "Accounts",
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: _currentBottomBarIndex == "2"
                                  ? bottomNavBarSelectedTextColor
                                  : bottomNavBarTextColor)),
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_currentBottomBarIndex != '3') {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/more_options', (route) => false);
                setState(() {
                  _currentBottomBarIndex = "3";
                });
                currentBottomNavigationIndex = _currentBottomBarIndex;
              }
            },
            child: Container(
              color: _currentBottomBarIndex == "3"
                  ? bottomNavBarSelectedBGColor
                  : Colors.white,
              width: screenWidth * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: SvgPicture.asset(
                      'assets/images/menu.svg',
                      width: screenWidth / 15,
                      color: _currentBottomBarIndex == "3"
                          ? bottomNavBarSelectedTextColor
                          : bottomNavBarTextColor,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(
                      "More",
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: _currentBottomBarIndex == "3"
                                  ? bottomNavBarSelectedTextColor
                                  : bottomNavBarTextColor)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
