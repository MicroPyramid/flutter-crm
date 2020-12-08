import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_crm/bloc/auth_bloc.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoreOptions extends StatefulWidget {
  @override
  State createState() => _MoreOptionsState();
}

class _MoreOptionsState extends State<MoreOptions> {
  final List _optionsList = [
    {
      'title': 'Contacts',
      'route': '/sales_contacts',
      'icon': 'assets/images/contacts_icon.svg'
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

  final List _bottomOptionsList = [
    {
      'title': 'Users',
      'route': '/sales_contacts',
      'icon': 'assets/images/users.svg'
    },
    {
      'title': 'Settings',
      'route': '/opportunities',
      'icon': 'assets/images/settings.svg'
    },
    {
      'title': 'Change Password',
      'route': '/change_password',
      'icon': 'assets/images/change_password.svg'
    },
    {'title': 'Logout', 'icon': 'assets/images/logout_icon.svg'},
  ];

  @override
  void initState() {
    super.initState();
  }

  void showLogoutAlertDialog(BuildContext context) {
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
                  currentBottomNavigationIndex = "0";
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
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
              return true;
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _optionsList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, _optionsList[index]['route']);
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.fromLTRB(screenWidth / 12, 8, 20, 8),
                          child: SvgPicture.asset(
                            _optionsList[index]['icon'],
                            width: screenWidth / 20,
                          ),
                        ),
                        Container(
                          child: Text(
                            _optionsList[index]['title'],
                            style: GoogleFonts.robotoSlab(
                                color: Color.fromRGBO(75, 75, 78, 1),
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
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Divider(color: Colors.grey[400]),
        ),
        Container(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
              return true;
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _bottomOptionsList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    if (_bottomOptionsList[index]['title'] == "Logout") {
                      showLogoutAlertDialog(context);
                    } else {
                      Navigator.pushNamed(
                          context, _bottomOptionsList[index]['route']);
                    }
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.fromLTRB(screenWidth / 12, 8, 20, 8),
                          child: SvgPicture.asset(
                            _bottomOptionsList[index]['icon'],
                            width: screenWidth / 20,
                          ),
                        ),
                        Container(
                          child: Text(
                            _bottomOptionsList[index]['title'],
                            style: GoogleFonts.robotoSlab(
                                color: _bottomOptionsList[index]['title'] ==
                                        "Logout"
                                    ? Color.fromRGBO(234, 67, 53, 1)
                                    : Color.fromRGBO(75, 75, 78, 1),
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
        ),
      ],
    );
  }

  Widget _buildProfileWidget() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: authBloc.userProfile.profileUrl != null &&
                    authBloc.userProfile.profileUrl != ""
                ? CircleAvatar(
                    radius: screenWidth / 15.5,
                    backgroundColor: Color.fromRGBO(75, 75, 78, 1),
                    child: CircleAvatar(
                      radius: screenWidth / 16,
                      backgroundImage:
                          NetworkImage(authBloc.userProfile.profileUrl),
                      backgroundColor: Colors.white,
                    ),
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
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: screenWidth * 0.7,
                  child: Text(authBloc.userProfile.userName,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth / 18))),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3.0),
                  width: screenWidth * 0.7,
                  child: Text(authBloc.userProfile.email,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: Color.fromRGBO(75, 75, 78, 1),
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth / 25))),
                ),
                Container(
                    width: screenWidth * 0.7,
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: 'Permissions: ',
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(
                                color: Color.fromRGBO(75, 75, 78, 1),
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth / 25)),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Sales And Marketing',
                              style: GoogleFonts.robotoSlab(
                                  textStyle: TextStyle(
                                      color: Color.fromRGBO(75, 153, 90, 1),
                                      fontWeight: FontWeight.w500,
                                      fontSize: screenWidth / 25))),
                        ],
                      ),
                    ))
              ],
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile_details');
              },
              child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(117, 174, 51, 1),
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  ),
                  alignment: Alignment.center,
                  width: screenWidth / 15,
                  height: screenHeight * 0.05,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: screenWidth / 20,
                  )))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'More Options',
            style: GoogleFonts.robotoSlab(),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: screenHeight * 0.8,
            child: Column(
              children: <Widget>[
                _buildProfileWidget(),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(color: Colors.grey[400])),
                Container(child: _buildMenuItems(context))
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBarWidget(),
      ),
    );
  }
}
