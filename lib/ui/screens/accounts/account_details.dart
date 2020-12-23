import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crm/bloc/account_bloc.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/ui/widgets/tags_widget.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_color/random_color.dart';

class AccountDetails extends StatefulWidget {
  AccountDetails();
  @override
  State createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> buildTags() {
    List<Widget> tags = <Widget>[];
    for (int i = 0; i < accountBloc.currentAccount.tags.length; i++) {
      tags.add(createTag(i));
    }
    return tags;
  }

  Widget createTag(tagIndex) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
      color: randomColor.randomColor(colorBrightness: ColorBrightness.light),
      child: Text(
        accountBloc.currentAccount.tags[tagIndex]['name'],
        style: GoogleFonts.robotoSlab(
            textStyle: TextStyle(color: Colors.white, fontSize: 12.0)),
      ),
    );
  }

  void showDeleteAccountAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              accountBloc.currentAccount.name,
              style: GoogleFonts.robotoSlab(
                  color: Theme.of(context).secondaryHeaderColor),
            ),
            content: Text(
              "Are you sure you want to delete this account?",
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
                    deleteAccount();
                  },
                  child: Text(
                    "Delete",
                    style: GoogleFonts.robotoSlab(),
                  )),
            ],
          );
        });
  }

  deleteAccount() async {
    setState(() {
      _isLoading = true;
    });
    Map result = await accountBloc.deleteAccount(accountBloc.currentAccount);
    setState(() {
      _isLoading = false;
    });
    if (result['error'] == false) {
      showToast(result['message']);
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, "/account_list");
    } else if (result['error'] == true) {
      Navigator.pop(context);
    } else {
      showErrorMessage(context, 'Something went wrong');
    }
  }

  void showErrorMessage(BuildContext context, String errorContent) {
    Flushbar(
      backgroundColor: Colors.white,
      messageText: Text(errorContent,
          style:
              GoogleFonts.robotoSlab(textStyle: TextStyle(color: Colors.red))),
      isDismissible: false,
      mainButton: FlatButton(
        child: Text('TRY AGAIN',
            style: GoogleFonts.robotoSlab(
                textStyle: TextStyle(color: Theme.of(context).accentColor))),
        onPressed: () {
          Navigator.of(context).pop(true);
          deleteAccount();
        },
      ),
      duration: Duration(seconds: 10),
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _isLoading
        ? new Container(
            color: Colors.transparent,
            width: 300.0,
            height: 300.0,
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(child: new CircularProgressIndicator())),
          )
        : new Container();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Account Details",
          style: GoogleFonts.robotoSlab(),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
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
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                        fontSize: screenWidth / 20),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    accountBloc.currentAccountType,
                                    style: GoogleFonts.robotoSlab(
                                        color: accountBloc.currentAccountType ==
                                                "Open"
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
                                                      fontSize:
                                                          screenWidth / 20,
                                                      color:
                                                          bottomNavBarTextColor,
                                                      fontWeight:
                                                          FontWeight.w600)),
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
                                                    color:
                                                        bottomNavBarTextColor)),
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
                          accountBloc.currentAccount.tags.length > 0
                              ? TagViewWidget(accountBloc.currentAccount.tags)
                              : Container(),
                          Container(
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: Divider(color: Colors.grey))
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await accountBloc.updateCurrentEditAccount(
                                  accountBloc.currentAccount);
                              Navigator.pushNamed(context, '/create_account');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300])),
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 15.0),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10.0),
                                    child: SvgPicture.asset(
                                      'assets/images/Icon_edit_color.svg',
                                      width: screenWidth / 25,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "Edit",
                                      style: GoogleFonts.robotoSlab(
                                          textStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  117, 174, 51, 1),
                                              fontSize: screenWidth / 25)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDeleteAccountAlertDialog(context);
                            },
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
                                    child: SvgPicture.asset(
                                      'assets/images/icon_delete_color.svg',
                                      width: screenWidth / 25,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "Delete",
                                      style: GoogleFonts.robotoSlab(
                                          textStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  234, 67, 53, 1),
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
          new Align(
            child: loadingIndicator,
            alignment: FractionalOffset.center,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}
