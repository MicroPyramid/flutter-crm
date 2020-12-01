import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_crm/bloc/auth_bloc.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenuDrawer extends StatefulWidget {
  @override
  State createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenuDrawer> {
  final List _sideMenuList = [
    {
      'title': 'Dashboard',
      'route': '/dashboard',
      'icon': 'assets/images/dashboard_icon.svg'
    },
    {
      'title': 'Accounts',
      'route': '/accounts',
      'icon': 'assets/images/accounts_icon.svg'
    },
    {
      'title': 'Contacts',
      'route': '/sales_contacts',
      'icon': 'assets/images/contacts_icon.svg'
    },
    {
      'title': 'Leads',
      'route': '/leads',
      'icon': 'assets/images/leads_icon.svg'
    },
    {
      'title': 'Opportunities',
      'route': '/opportunities',
      'icon': 'assets/images/opportunities_icon.svg'
    },
    {
      'title': 'Cases',
      'route': '/cases',
      'icon': 'assets/images/cases_icon.svg'
    },
    {
      'title': 'Documents',
      'route': '/documents',
      'icon': 'assets/images/documents_icon.svg'
    },
    {
      'title': 'Tasks',
      'route': '/tasks',
      'icon': 'assets/images/tasks_icon.svg'
    },
    {
      'title': 'Invoices',
      'route': '/invoices',
      'icon': 'assets/images/invoices_icon.svg'
    },
    {
      'title': 'Events',
      'route': '/events',
      'icon': 'assets/images/events_icon.svg'
    },
    {
      'title': 'Teams',
      'route': '/teams',
      'icon': 'assets/images/teams_icon.svg'
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        child: CupertinoAlertDialog(
          title: Text(
            "Logout?",
            style: GoogleFonts.robotoSlab(
                color: Theme.of(context).secondaryHeaderColor),
          ),
          content: Text(
            "Are you sure you want to logout?",
            style: GoogleFonts.robotoSlab(fontSize: 15.0),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.robotoSlab(),
                )),
            CupertinoDialogAction(
                textStyle: TextStyle(color: Colors.red),
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.pop(context);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('authToken');
                  prefs.remove('subdomain');
                  Navigator.pushReplacementNamed(context, "/sub_domain");
                },
                child: Text(
                  "Logout",
                  style: GoogleFonts.robotoSlab(),
                )),
          ],
        ));
  }

  Widget _buildMenuItems(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: screenHeight * 0.70,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _sideMenuList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, _sideMenuList[index]['route'], (route) => false);
                },
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.fromLTRB(screenWidth / 12, 10, 20, 10),
                        child: SvgPicture.asset(
                          _sideMenuList[index]['icon'],
                          width: screenWidth / 20,
                        ),
                      ),
                      Container(
                        child: Text(
                          _sideMenuList[index]['title'],
                          style: GoogleFonts.robotoSlab(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: screenWidth / 25),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, "/profile", (route) => false);
          },
          child: Container(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(screenWidth / 12, 10, 20, 10),
                  child: SvgPicture.asset(
                    'assets/images/profile_settings_icon.svg',
                    width: screenWidth / 20,
                  ),
                ),
                Container(
                  child: Text(
                    'Profile Settings',
                    style: GoogleFonts.robotoSlab(
                        color: Color.fromRGBO(44, 113, 255, 1),
                        fontSize: screenWidth / 24),
                  ),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showAlertDialog(context);
          },
          child: Container(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(screenWidth / 12, 10, 20, 10),
                  child: SvgPicture.asset(
                    'assets/images/logout_icon.svg',
                    width: screenWidth / 20,
                  ),
                ),
                Container(
                  child: Text(
                    'Logout',
                    style: GoogleFonts.robotoSlab(
                        color: Colors.red, fontSize: screenWidth / 24),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: ListTile(
                leading: authBloc.userProfile.profileUrl != null &&
                        authBloc.userProfile.profileUrl != ""
                    ? CircleAvatar(
                        radius: screenWidth / 15,
                        backgroundImage:
                            NetworkImage(authBloc.userProfile.profileUrl),
                        backgroundColor: Colors.white,
                      )
                    : CircleAvatar(
                        radius: screenWidth / 15,
                        child: Icon(
                          Icons.person,
                          size: screenWidth / 10,
                          color: Colors.white,
                        ),
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                      ),
                title: Text(authBloc.userProfile.firstName,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.robotoSlab(
                        textStyle: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth / 18))),
                subtitle: Text(authBloc.userProfile.email,
                    style: GoogleFonts.robotoSlab(
                        textStyle: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth / 28))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Container(child: _buildMenuItems(context)),
            )
          ],
        ),
      ),
    );
  }
}
