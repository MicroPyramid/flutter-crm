import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crm/bloc/account_bloc.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_color/random_color.dart';

class AccountDetails extends StatefulWidget {
  AccountDetails();
  @override
  State createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Account Details",
          style: GoogleFonts.robotoSlab(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: screenWidth * 0.7,
                              child: Text(
                                accountBloc.currentAccount.name,
                                style: GoogleFonts.robotoSlab(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: screenWidth / 20),
                              ),
                            ),
                            Container(
                              child: Text(
                                accountBloc.currentAccountType,
                                style: GoogleFonts.robotoSlab(
                                    color:
                                        accountBloc.currentAccountType == "Open"
                                            ? Color.fromRGBO(117, 174, 51, 1)
                                            : Color.fromRGBO(234, 67, 53, 1),
                                    fontSize: screenWidth / 22),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          child: Divider(color: bottomNavBarTextColor))
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "Email Address :",
                          style: GoogleFonts.robotoSlab(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: screenWidth / 24),
                        ),
                      ),
                      Container(
                        child: Text(
                          accountBloc.currentAccount.email,
                          style: GoogleFonts.robotoSlab(
                              color: bottomNavBarTextColor,
                              fontSize: screenWidth / 24),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          child: Divider(color: Colors.grey))
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "Mobile Number :",
                          style: GoogleFonts.robotoSlab(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: screenWidth / 24),
                        ),
                      ),
                      Container(
                        child: Text(
                          accountBloc.currentAccount.phone,
                          style: GoogleFonts.robotoSlab(
                              color: bottomNavBarTextColor,
                              fontSize: screenWidth / 24),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          child: Divider(color: Colors.grey))
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "Contacts :",
                          style: GoogleFonts.robotoSlab(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: screenWidth / 24),
                        ),
                      ),
                      Container(
                          child: NotificationListener<
                              OverscrollIndicatorNotification>(
                        onNotification: (overscroll) {
                          overscroll.disallowGlow();
                          return true;
                        },
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount:
                                accountBloc.currentAccount.contacts.length,
                            itemBuilder:
                                (BuildContext context, int contactIndex) {
                              return Container(
                                child: Row(
                                  children: [
                                    Container(
                                        width: screenWidth / 20,
                                        child: Text(
                                          "○",
                                          style: GoogleFonts.robotoSlab(
                                              textStyle: TextStyle(
                                                  fontSize: screenWidth / 20,
                                                  color: bottomNavBarTextColor,
                                                  fontWeight: FontWeight.w600)),
                                        )),
                                    Container(
                                      child: Text(
                                        accountBloc
                                                .currentAccount
                                                .contacts[contactIndex]
                                                .firstName +
                                            " " +
                                            accountBloc
                                                .currentAccount
                                                .contacts[contactIndex]
                                                .lastName,
                                        style: GoogleFonts.robotoSlab(
                                            textStyle: TextStyle(
                                                color: bottomNavBarTextColor)),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                      )),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          child: Divider(color: Colors.grey))
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "Billing Address :",
                          style: GoogleFonts.robotoSlab(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: screenWidth / 24),
                        ),
                      ),
                      Container(
                        child: Text(
                          accountBloc.currentAccount.billingAddressLine +
                              ', ' +
                              accountBloc.currentAccount.billingStreet +
                              ', ' +
                              accountBloc.currentAccount.billingCity +
                              ', ' +
                              accountBloc.currentAccount.billingState +
                              ', ' +
                              accountBloc.currentAccount.billingPostcode +
                              ', ' +
                              accountBloc.currentAccount.billingCountry +
                              '.',
                          style: GoogleFonts.robotoSlab(
                              color: bottomNavBarTextColor,
                              fontSize: screenWidth / 24),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          child: Divider(color: Colors.grey))
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "Created By :",
                          style: GoogleFonts.robotoSlab(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: screenWidth / 24),
                        ),
                      ),
                      Container(
                        child: Text(
                          accountBloc.currentAccount.createdBy.firstName +
                              ' ' +
                              accountBloc.currentAccount.createdBy.lastName,
                          style: GoogleFonts.robotoSlab(
                              color: bottomNavBarTextColor,
                              fontSize: screenWidth / 24),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          child: Divider(color: Colors.grey))
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "Created On :",
                          style: GoogleFonts.robotoSlab(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: screenWidth / 24),
                        ),
                      ),
                      Container(
                        child: Text(
                          accountBloc.currentAccount.createdOn,
                          style: GoogleFonts.robotoSlab(
                              color: bottomNavBarTextColor,
                              fontSize: screenWidth / 24),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          child: Divider(color: Colors.grey))
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "Tags :",
                          style: GoogleFonts.robotoSlab(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: screenWidth / 24),
                        ),
                      ),
                      Container(
                        height: screenHeight / 33,
                        child: ListView.builder(
                            // physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: accountBloc.currentAccount.tags.length,
                            itemBuilder: (BuildContext context, int tagIndex) {
                              return Container(
                                margin: EdgeInsets.only(right: 5.0),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                color: randomColor.randomColor(
                                    colorBrightness: ColorBrightness.light),
                                child: Text(
                                  accountBloc.currentAccount.tags[tagIndex]
                                      ['name'],
                                  style: GoogleFonts.robotoSlab(
                                      textStyle: TextStyle(
                                          color: Colors.white, fontSize: 12.0)),
                                ),
                              );
                            }),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          child: Divider(color: Colors.grey))
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300])),
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 15.0),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: Color.fromRGBO(117, 174, 51, 1),
                                  size: screenWidth / 18,
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Edit",
                                  style: GoogleFonts.robotoSlab(
                                      textStyle: TextStyle(
                                          color:
                                              Color.fromRGBO(117, 174, 51, 1),
                                          fontSize: screenWidth / 25)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300])),
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 15.0),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Icons.delete_outlined,
                                  color: Color.fromRGBO(234, 67, 53, 1),
                                  size: screenWidth / 18,
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Delete",
                                  style: GoogleFonts.robotoSlab(
                                      textStyle: TextStyle(
                                          color: Color.fromRGBO(234, 67, 53, 1),
                                          fontSize: screenWidth / 25)),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}
