import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/auth_bloc.dart';
import 'package:flutter_crm/utils/utils.dart';

class SideMenuDrawer extends StatefulWidget {
  @override
  State createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenuDrawer> {
  final List salesSideMenuList = [
    {'title': 'Dashboard', 'route': '/sales_dashboard'},
    {'title': 'Accounts', 'route': '/accounts'},
    {'title': 'Contacts', 'route': '/sales_contacts'},
    {'title': 'Leads', 'route': '/leads'},
    {'title': 'Opportunities', 'route': '/opportunities'},
    {'title': 'Cases', 'route': '/cases'},
    {'title': 'Documents', 'route': '/documents'},
    {'title': 'Tasks', 'route': '/tasks'},
    {'title': 'Invoices', 'route': '/invoices'},
    {'title': 'Events', 'route': '/events'},
    {'title': 'Teams', 'route': '/teams'},
  ];

  final List marketingSideMenuList = [
    {'title': 'Dashboard', 'route': '/marketing_dashboard'},
    {'title': 'Contacts', 'route': '/marketing_contacts'},
    {'title': 'Email templates', 'route': '/email_templates'},
    {'title': 'Campaigns', 'route': '/marketing_campaigns'},
  ];

  String _selectedSidebarItem = 'Dashboard';
  String _currentModule = 'Sales';
  String _profilePicUrl =
      "https://starsunfolded.com/wp-content/uploads/2017/09/Virat-Kohli-French-cut-with-trimmed-scruff-beard-style.jpg";
  // String _profilePicUrl = "";
  bool _isExpanded = false;

  @override
  void initState() {
    setState(() {
      _selectedSidebarItem = selectedSidebarName;
      _currentModule = currentSidebarModuleName;
    });
    super.initState();
  }

  Widget _buildMenuItems(BuildContext context) {
    List _sidebarList =
        _currentModule == 'Sales' ? salesSideMenuList : marketingSideMenuList;
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _sidebarList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  right: _selectedSidebarItem == _sidebarList[index]['title']
                      ? BorderSide(
                          color: Theme.of(context).primaryColor, width: 5.0)
                      : BorderSide(color: Colors.white),
                  bottom: BorderSide(
                      color: Theme.of(context).dividerColor, width: 2.0))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                // leading: sideMenuList[index]['leading'],
                trailing: _currentModule == "Marketing" &&
                        _sidebarList[index]['title'] == "Contacts"
                    ? !_isExpanded
                        ? Container(
                            child: Icon(Icons.arrow_drop_down,
                                color: Theme.of(context).primaryColor),
                          )
                        : Container(
                            child: Icon(Icons.arrow_drop_up,
                                color: Theme.of(context).primaryColor),
                          )
                    : Container(
                        child: Icon(Icons.arrow_drop_down, color: Colors.white),
                      ),
                title: Text(
                  _sidebarList[index]['title'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'Roboto',
                      fontSize: 15.0),
                ),
                onTap: () {
                  if (_currentModule == "Marketing" &&
                      _sidebarList[index]['title'] == "Contacts") {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  } else {
                    selectedSidebarName = _sidebarList[index]['title'];
                    setState(() {
                      _selectedSidebarItem = _sidebarList[index]['title'];
                    });
                    Navigator.pushNamedAndRemoveUntil(context,
                        _sidebarList[index]['route'], (route) => false);
                  }
                },
              ),
              _currentModule == "Marketing" &&
                      _sidebarList[index]['title'] == "Contacts" &&
                      _isExpanded
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                        width: 2.0))),
                            child: ListTile(
                              title: Text(
                                "Contacts List",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14.0),
                              ),
                              onTap: () {
                                selectedSidebarName =
                                    _sidebarList[index]['title'];
                                setState(() {
                                  _selectedSidebarItem =
                                      _sidebarList[index]['title'];
                                });
                                Navigator.pushNamedAndRemoveUntil(context,
                                    '/marketing_contacts', (route) => false);
                              },
                            ),
                          ),
                          ListTile(
                            title: Text(
                              "Contacts",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14.0),
                            ),
                            onTap: () {
                              selectedSidebarName =
                                  _sidebarList[index]['title'];
                              setState(() {
                                _selectedSidebarItem =
                                    _sidebarList[index]['title'];
                              });
                              Navigator.pushNamedAndRemoveUntil(context,
                                  '/marketing_contacts', (route) => false);
                            },
                          )
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.75,
      child: Drawer(
        child: ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  alignment: FractionalOffset(0.0, 0.0),
                  color: Theme.of(context).primaryColor,
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/profile", (route) => false);
                        },
                        child: Container(
                          child: authBloc.userProfile != null &&
                                  authBloc.userProfile.profileUrl != null &&
                                  authBloc.userProfile.profileUrl != ""
                              ? CircleAvatar(
                                  radius: MediaQuery.of(context).size.width / 9,
                                  backgroundImage: NetworkImage(
                                      authBloc.userProfile.profileUrl),
                                  backgroundColor: Colors.white,
                                )
                              : authBloc.userProfile != null &&
                                      authBloc.userProfile.firstName != ""
                                  ? CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width / 9,
                                      child: Text(
                                        authBloc.userProfile.firstName[0],
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: Colors.white,
                                    )
                                  : CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width / 9,
                                      child: Icon(
                                        Icons.person,
                                        size:
                                            MediaQuery.of(context).size.width /
                                                8,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // Container(
                            //   child: Text(
                            //     "bottlecrm",
                            //     style: TextStyle(
                            //         color: Colors.white,
                            //         fontSize:
                            //             MediaQuery.of(context).size.width / 15,
                            //         fontWeight: FontWeight.bold),
                            //   ),
                            // ),
                            // Container(
                            //   child: IconButton(
                            //     onPressed: () {
                            //       setState(() {
                            //         _showDropDown = true;
                            //       });
                            //     },
                            //     icon: Icon(Icons.arrow_drop_down_sharp,
                            //         color: Colors.white,
                            //         size:
                            //             MediaQuery.of(context).size.width / 15),
                            //   ),
                            // )
                            Container(
                                margin: EdgeInsets.only(top: 5.0),
                                child: Text(
                                  "bottlecrm",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              15,
                                      fontWeight: FontWeight.bold),
                                ))
                            // Container(
                            //   child: DropdownButtonHideUnderline(
                            //     child: new DropdownButton<String>(
                            //       icon: Icon(
                            //         Icons.arrow_drop_down_sharp,
                            //         color: Colors.white,
                            //       ),
                            //       hint: Text(
                            //         "bottlecrm",
                            //         style: TextStyle(
                            //             color: Colors.white,
                            //             fontSize:
                            //                 MediaQuery.of(context).size.width /
                            //                     15,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //       items: <String>['Sales', 'Marketing']
                            //           .map((String value) {
                            //         return new DropdownMenuItem<String>(
                            //           value: value,
                            //           child: new Text(
                            //             value,
                            //             style: TextStyle(
                            //                 fontWeight: FontWeight.w500),
                            //           ),
                            //         );
                            //       }).toList(),
                            //       onChanged: (String value) {
                            //         setState(() {
                            //           _currentModule = value;
                            //           _selectedSidebarItem = "Dashboard";
                            //         });
                            //         selectedSidebarName = "Dashboard";
                            //         currentSidebarModuleName = value;
                            //         if (_currentModule == "Sales") {
                            //           Navigator.pushReplacementNamed(
                            //               context, '/sales_dashboard');
                            //         } else {
                            //           Navigator.pushReplacementNamed(
                            //               context, '/marketing_dashboard');
                            //         }
                            //       },
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      )
                    ],
                  )),
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.72,
                child: _buildMenuItems(context))
          ],
        ),
      ),
    );
  }
}
