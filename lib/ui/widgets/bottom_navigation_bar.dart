import 'dart:core';

import 'package:flutter/material.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      //color: Colors.white,
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
              decoration: BoxDecoration(
                  color: _currentBottomBarIndex == "0"
                      ? bottomNavBarSelectedBGColor
                      : Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(30))),
              width: screenWidth * 0.20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: SvgPicture.asset(
                      'assets/images/home.svg',
                      width: screenWidth / 15,
                      color: _currentBottomBarIndex == "0"
                          ? bottomNavBarSelectedTextColor
                          : bottomNavBarTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_currentBottomBarIndex != '1') {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/accounts_list', (route) => false);
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
              width: screenWidth * 0.20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: SvgPicture.asset(
                      'assets/images/accounts.svg',
                      width: screenWidth / 12,
                      color: _currentBottomBarIndex == "1"
                          ? bottomNavBarSelectedTextColor
                          : bottomNavBarTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // if (_currentBottomBarIndex != '') {
              //   setState(() {
              //     _currentBottomBarIndex = "";
              //   });
              //   currentBottomNavigationIndex = _currentBottomBarIndex;
              // }
            },
            child: Container(
              color: _currentBottomBarIndex == ""
                  ? bottomNavBarSelectedBGColor
                  : Colors.white,
              width: screenWidth * 0.20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: SvgPicture.asset(
                      'assets/images/search.svg',
                      width: screenWidth / 16,
                      color: _currentBottomBarIndex == ""
                          ? bottomNavBarSelectedTextColor
                          : bottomNavBarTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_currentBottomBarIndex != '2') {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/tasks_list', (route) => false);
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
              width: screenWidth * 0.20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: SvgPicture.asset(
                      'assets/images/tasks.svg',
                      width: screenWidth / 18,
                      color: _currentBottomBarIndex == "2"
                          ? bottomNavBarSelectedTextColor
                          : bottomNavBarTextColor,
                    ),
                  ),
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
              decoration: BoxDecoration(
                  color: _currentBottomBarIndex == "3"
                      ? bottomNavBarSelectedBGColor
                      : Colors.white,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(30))),
              width: screenWidth * 0.20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: SvgPicture.asset(
                      'assets/images/more.svg',
                      width: screenWidth / 16,
                      color: _currentBottomBarIndex == "3"
                          ? bottomNavBarSelectedTextColor
                          : bottomNavBarTextColor,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
