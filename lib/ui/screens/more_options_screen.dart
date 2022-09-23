import 'dart:core';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottle_crm/bloc/auth_bloc.dart';
import 'package:bottle_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoreOptions extends StatefulWidget {
  @override
  State createState() => _MoreOptionsState();
}

class _MoreOptionsState extends State<MoreOptions> {
  final List _optionsList = [
    {
      'title': 'Contacts',
      'route': '/contacts_list',
      'icon': 'assets/images/contacts.svg'
    },
    {
      'title': 'Opportunities',
      'route': '/opportunities_list',
      'icon': 'assets/images/opportunities.svg'
    },
    {
      'title': 'Cases',
      'route': '/cases_list',
      'icon': 'assets/images/cases.svg'
    },
    {
      'title': 'Documents',
      'route': '/documents_list',
      'icon': 'assets/images/documents.svg'
    },
    {
      'title': 'Leads',
      'route': '/leads_list',
      'icon': 'assets/images/leads.svg'
    },
    {
      'title': 'Invoices',
      'route': '/invoices_list',
      'icon': 'assets/images/invoices.svg'
    },
    {
      'title': 'Events',
      'route': '/events_list',
      'icon': 'assets/images/events.svg'
    },
    {
      'title': 'Teams',
      'route': '/teams_list',
      'icon': 'assets/images/teams.svg'
    },
    {
      'title': 'Users',
      'route': '/users_list',
      'icon': 'assets/images/users.svg'
    },
    {
      'title': 'Settings',
      'route': '/settings_List',
      'icon': 'assets/images/settings.svg'
    },
    {
      'title': 'Change Password',
      'route': '/change_password',
      'icon': 'assets/images/change_password.svg'
    },
    {'title': 'Logout', 'icon': 'assets/images/logout.svg'},
  ];

  @override
  void initState() {
    super.initState();
  }

  void showLogoutAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              "Logout?",
              style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
            ),
            content: Text(
              "Are you sure you want to logout?",
              style: TextStyle(fontSize: 15.0),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              CupertinoDialogAction(
                  textStyle: TextStyle(color: Colors.red),
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('authToken');
                    prefs.remove('org');
                    currentBottomNavigationIndex = "0";
                    await FirebaseAnalytics.instance
                        .logEvent(name: "User_Logged_Out");
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                  child: Text("Logout")),
            ],
          );
        });
  }

  buildProfile() {
    return Container(
        padding: EdgeInsets.only(left: 20.0, right: 10.0),
        height: screenHeight * 0.15,
        decoration: BoxDecoration(
            color: bottomNavBarSelectedTextColor,
            ),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10.0),
                child: authBloc.userProfile!.profileUrl != null &&
                        authBloc.userProfile!.profileUrl != ""
                    ? CircleAvatar(
                        radius: screenWidth / 11.5,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: CircleAvatar(
                          radius: screenWidth / 12,
                          backgroundImage:
                              NetworkImage(authBloc.userProfile!.profileUrl!),
                          backgroundColor: Colors.white,
                        ),
                      )
                    : CircleAvatar(
                        radius: screenWidth / 12,
                        child: Text(
                          authBloc.userProfile!.firstName![0].allInCaps,
                          style: TextStyle(
                              fontSize: screenWidth / 11,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                        backgroundColor: Colors.grey[200],
                      ),
              ),
              Container(
                width: screenWidth * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      authBloc.userProfile!.firstName!.capitalizeFirstofEach(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth / 24,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 3.0),
                    Text(
                      authBloc.userProfile!.email!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth / 26,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 3.0),
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: "Permissions: ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth / 26,
                              fontWeight: FontWeight.w500)),
                      TextSpan(
                          text: authBloc.userProfile!.role!.toLowerCase() ==
                                  "admin"
                              ? 'Sales and Marketing'
                              : authBloc.userProfile!.hasSalesAccess! &&
                                      authBloc.userProfile!.hasMarketingAccess!
                                  ? "Sales and Marketing"
                                  : authBloc.userProfile!.hasSalesAccess! &&
                                          !authBloc
                                              .userProfile!.hasMarketingAccess!
                                      ? "Sales"
                                      : !authBloc.userProfile!
                                                  .hasSalesAccess! &&
                                              authBloc.userProfile!
                                                  .hasMarketingAccess!
                                          ? "Marketing"
                                          : "---",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: screenWidth / 26,
                              fontWeight: FontWeight.w500))
                    ]))
                  ],
                ),
              ),
              Container(
                child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    icon: Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: screenWidth / 15)),
              )
            ],
          ),
        ));
  }

  buildOptions() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _optionsList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              if (_optionsList[index]['title'] == "Logout") {
                showLogoutAlertDialog(context);
              } else {
                Navigator.pushNamed(context, _optionsList[index]['route']);
              }
            },
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.fromLTRB(screenWidth / 12, 8, 20, 8),
                        child: SvgPicture.asset(
                          _optionsList[index]['icon'],
                          width: screenWidth / 18,
                        ),
                      ),
                      Container(
                        child: Text(
                          _optionsList[index]['title'],
                          style: TextStyle(
                              color: _optionsList[index]['title'] == "Logout"
                                  ? Colors.red
                                  : Color.fromRGBO(75, 75, 78, 1),
                              fontSize: screenWidth / 24,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ),
                index == _optionsList.length - 1
                    ? Container()
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(color: Colors.grey[200]))
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(73, 128, 255, 1.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Text(
                    'More Options',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth / 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                buildProfile(),
                Expanded(
                    child: Container(
                  color: Colors.white,
                  child: buildOptions(),
                ))
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBarWidget(),
      ),
    );
  }
}
