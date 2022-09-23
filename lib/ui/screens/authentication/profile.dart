import 'dart:core';

import 'package:flutter/material.dart';
import 'package:bottle_crm/bloc/auth_bloc.dart';
import 'package:bottle_crm/utils/utils.dart';

class Profile extends StatefulWidget {
  @override
  State createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(73, 128, 255, 1.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(children: [
                        GestureDetector(
                            child: new Icon(Icons.arrow_back_ios,
                                size: screenWidth / 18, color: Colors.white),
                            onTap: () {
                              Navigator.pop(context, true);
                            }),
                        SizedBox(width: 10.0),
                        Text(
                          'Profile',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth / 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.white,
                      ),
                      width: screenWidth * 0.18,
                      height: screenHeight * 0.04,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.edit,
                              size: screenWidth / 20,
                              color: Theme.of(context).primaryColor),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                    fontSize: screenWidth / 25,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  height: screenHeight * 0.2,
                  width: screenWidth,
                  decoration: BoxDecoration(
                      color: bottomNavBarSelectedTextColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.0))),
                  child: Container(
                    child: authBloc.userProfile!.profileUrl != null &&
                            authBloc.userProfile!.profileUrl != ""
                        ? CircleAvatar(
                            radius: screenWidth / 11.5,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: CircleAvatar(
                              radius: screenWidth / 12,
                              backgroundImage: NetworkImage(
                                  authBloc.userProfile!.profileUrl!),
                              backgroundColor: Colors.white,
                            ),
                          )
                        : CircleAvatar(
                            radius: screenWidth / 20,
                            child: Text(
                              authBloc.userProfile!.firstName![0].allInCaps,
                              style: TextStyle(
                                  fontSize: screenWidth / 11,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                            backgroundColor: Colors.grey[200],
                          ),
                  )),
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(20.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name',
                            style: TextStyle(
                                fontSize: screenWidth / 24,
                                fontWeight: FontWeight.w600,
                                color: bottomNavBarSelectedTextColor),
                          ),
                          SizedBox(height: 5.0),
                          authBloc.userProfile!.firstName! == "" &&
                                  authBloc.userProfile!.lastName! == ""
                              ? Text('------',
                                  style: TextStyle(
                                      fontSize: screenWidth / 22,
                                      fontWeight: FontWeight.w500,
                                      color: bottomNavBarTextColor))
                              : Text(
                                  authBloc.userProfile!.firstName! +
                                      ' ' +
                                      authBloc.userProfile!.lastName!,
                                  style: TextStyle(
                                      fontSize: screenWidth / 22,
                                      fontWeight: FontWeight.w500,
                                      color: bottomNavBarTextColor),
                                )
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Divider(color: Colors.grey)),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date of Joining',
                            style: TextStyle(
                                fontSize: screenWidth / 24,
                                fontWeight: FontWeight.w600,
                                color: bottomNavBarSelectedTextColor),
                          ),
                          SizedBox(height: 5.0),
                          authBloc.userProfile!.dateOfJoin! == ''
                              ? Text('------')
                              : Text(
                                  authBloc.userProfile!.dateOfJoin!
                                      .capitalizeFirstofEach(),
                                  style: TextStyle(
                                      fontSize: screenWidth / 22,
                                      fontWeight: FontWeight.w500,
                                      color: bottomNavBarTextColor),
                                )
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Divider(color: Colors.grey[200])),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email Address',
                            style: TextStyle(
                                fontSize: screenWidth / 24,
                                fontWeight: FontWeight.w600,
                                color: bottomNavBarSelectedTextColor),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            authBloc.userProfile!.email!,
                            style: TextStyle(
                                fontSize: screenWidth / 22,
                                fontWeight: FontWeight.w500,
                                color: bottomNavBarTextColor),
                          )
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Divider(color: Colors.grey[200])),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Permissions',
                            style: TextStyle(
                                fontSize: screenWidth / 24,
                                fontWeight: FontWeight.w600,
                                color: bottomNavBarSelectedTextColor),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            authBloc.userProfile!.role!.toLowerCase() == "admin"
                                ? 'Sales and Marketing'
                                : authBloc.userProfile!.hasSalesAccess! &&
                                        authBloc
                                            .userProfile!.hasMarketingAccess!
                                    ? "Sales and Marketing"
                                    : authBloc.userProfile!.hasSalesAccess! &&
                                            !authBloc.userProfile!
                                                .hasMarketingAccess!
                                        ? "Sales"
                                        : !authBloc.userProfile!
                                                    .hasSalesAccess! &&
                                                authBloc.userProfile!
                                                    .hasMarketingAccess!
                                            ? "Marketing"
                                            : "------",
                            style: TextStyle(
                                fontSize: screenWidth / 22,
                                fontWeight: FontWeight.w500,
                                color: bottomNavBarTextColor),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
