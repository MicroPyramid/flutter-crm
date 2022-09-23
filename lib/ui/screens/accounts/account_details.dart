import 'package:bottle_crm/bloc/auth_bloc.dart';
import 'package:bottle_crm/bloc/dashboard_bloc.dart';
import 'package:bottle_crm/model/account.dart';
import 'package:bottle_crm/ui/widgets/loader.dart';
import 'package:bottle_crm/ui/widgets/profile_pic_widget.dart';
import 'package:bottle_crm/ui/widgets/tags_widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottle_crm/bloc/account_bloc.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

class AccountDetails extends StatefulWidget {
  AccountDetails();
  @override
  State createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  var _currentTabIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _isLoading ? Loader() : new Container();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Container(
              decoration:
                  BoxDecoration(color: Color.fromRGBO(73, 128, 255, 1.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(children: [
                            GestureDetector(
                                child: new Icon(Icons.arrow_back_ios,
                                    color: Colors.white),
                                onTap: () {
                                  Navigator.pop(context, true);
                                }),
                            SizedBox(width: 10.0),
                            Text(
                              'Account Details',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth / 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (!_isLoading) {
                              accountBloc.currentEditAccountId =
                                  accountBloc.currentAccount!.id.toString();
                              await accountBloc.updateCurrentEditAccount(
                                  accountBloc.currentAccount!);
                              Navigator.pushNamed(context, '/account_create');
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0)),
                              color: Colors.white,
                            ),
                            width: screenWidth * 0.18,
                            height: screenHeight * 0.04,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/Icon_edit_color.svg',
                                  color: Theme.of(context).primaryColor,
                                  width: screenWidth / 25,
                                ),
                                Container(
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(
                                        fontSize: screenWidth / 25,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  !_isLoading
                      ? Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 23.0),
                                height: screenHeight * 0.06,
                                decoration: BoxDecoration(
                                  color: bottomNavBarSelectedTextColor,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _currentTabIndex = 0;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: screenHeight * 0.06,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                          color: Colors.white,
                                          width:
                                              _currentTabIndex == 0 ? 3.0 : 0.0,
                                        ))),
                                        width: screenWidth * 0.40,
                                        child: Text(
                                          'Account Information',
                                          style: TextStyle(
                                              color: _currentTabIndex == 0
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .secondaryHeaderColor,
                                              fontSize: screenWidth / 25,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _currentTabIndex = 1;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: screenHeight * 0.06,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                          color: Colors.white,
                                          width:
                                              _currentTabIndex == 1 ? 3.0 : 0.0,
                                        ))),
                                        width: screenWidth * 0.22,
                                        child: Text(
                                          'Attachment',
                                          style: TextStyle(
                                              color: _currentTabIndex == 1
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .secondaryHeaderColor,
                                              fontSize: screenWidth / 25,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _currentTabIndex = 2;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: screenHeight * 0.06,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                          color: Colors.white,
                                          width:
                                              _currentTabIndex == 2 ? 3.0 : 0.0,
                                        ))),
                                        width: screenWidth * 0.21,
                                        child: Text(
                                          'Description',
                                          style: TextStyle(
                                              color: _currentTabIndex == 2
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .secondaryHeaderColor,
                                              fontSize: screenWidth / 25,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Expanded(
                      child: !_isLoading
                          ? Container(
                              child: buildTopBar(),
                              color: Colors.white,
                            )
                          : Container(
                              height: screenHeight,
                              width: screenWidth,
                              color: Colors.white,
                            ))
                ],
              ),
            ),
          ),
          new Align(
            child: loadingIndicator,
            alignment: FractionalOffset.center,
          )
        ],
      ),
    );
  }

  buildTopBar() {
    if (_currentTabIndex == 0) {
      return buildAccountInfoBlock();
    } else if (_currentTabIndex == 1) {
      return buildAttachmentBlock();
    } else if (_currentTabIndex == 2) {
      return buildDescriptionBlock();
    }
  }

  buildAttachmentBlock() {
    return SwipeDetector(
      onSwipeLeft: (offset) {
        setState(() {
          _currentTabIndex = 2;
        });
      },
      onSwipeRight: (offset) {
        setState(() {
          _currentTabIndex = 0;
        });
      },
      child: Container(
        height: screenHeight,
        width: screenWidth,
        color: Colors.white,
        alignment: Alignment.center,
        child: Text("No Attachments Found."),
      ),
    );
  }

  buildDescriptionBlock() {
    return SwipeDetector(
      onSwipeRight: (offset) {
        setState(() {
          _currentTabIndex = 1;
        });
      },
      child: Container(
        height: screenHeight,
        width: screenWidth,
        alignment: Alignment.center,
        color: Colors.white,
        child: Text(
            accountBloc.currentAccount!.description != ""
                ? accountBloc.currentAccount!.description!
                : "No Description Found",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)),
      ),
    );
  }

  buildAccountInfoBlock() {
    return SwipeDetector(
      onSwipeLeft: (offset) {
        setState(() {
          _currentTabIndex = 1;
        });
      },
      child: Container(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
              child: Column(children: [
            Container(
              width: screenWidth,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black12),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      accountBloc.currentAccount!.name!.capitalizeFirstofEach(),
                      style: TextStyle(
                          color: Colors.blueGrey[800],
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth / 24),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TagViewWidget(accountBloc.currentAccount!.tags!),
                  SizedBox(height: 10.0),
                  ProfilePicViewWidget(accountBloc.currentAccount!.assignedTo!
                      .map((assignedUser) => assignedUser.profileUrl == ""
                          ? assignedUser.firstName![0].inCaps
                          : assignedUser.profileUrl)
                      .toList())
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black12),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Text(
                            "Create Date",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          child: Text(
                            accountBloc.currentAccount!.createdOn!,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black12),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          width: screenWidth * 0.28,
                          child: Text(
                            "Organization :",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 10.0),
                      Container(
                          width: screenWidth * 0.50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                authBloc.selectedOrganization!.name!
                                    .capitalizeFirstofEach(),
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w600,
                                    fontSize: screenWidth / 24),
                              ),
                            ],
                          )),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          width: screenWidth * 0.28,
                          child: Text(
                            "Contact :",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 10.0),
                      Container(
                          width: screenWidth * 0.50,
                          child: Text(
                            accountBloc.currentAccount!.createdBy!.firstName!
                                    .capitalizeFirstofEach() +
                                " ${accountBloc.currentAccount!.createdBy!.lastName!}",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          width: screenWidth * 0.28,
                          child: Icon(Icons.email_outlined,
                              size: screenWidth / 20)),
                      SizedBox(width: 10.0),
                      Container(
                          width: screenWidth * 0.50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                accountBloc.currentAccount!.email!,
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w600,
                                    fontSize: screenWidth / 24),
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Divider())
                            ],
                          )),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          width: screenWidth * 0.28,
                          child: Icon(Icons.phone, size: screenWidth / 20)),
                      SizedBox(width: 10.0),
                      Container(
                          width: screenWidth * 0.50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                accountBloc.currentAccount!.phone!,
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w600,
                                    fontSize: screenWidth / 24),
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Divider())
                            ],
                          )),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Container(
                  //         alignment: Alignment.centerRight,
                  //         width: screenWidth * 0.28,
                  //         child: Image.asset(
                  //           "assets/images/skype.png",
                  //           width: screenWidth / 22,
                  //         )),
                  //     SizedBox(width: 10.0),
                  //     Container(
                  //         width: screenWidth * 0.50,
                  //         child: Text(
                  //           " skype@Id",
                  //           style: TextStyle(
                  //               color: Colors.blue,
                  //               fontWeight: FontWeight.w600,
                  //               fontSize: screenWidth / 24),
                  //         )),
                  //   ],
                  // ),
                  // SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          width: screenWidth * 0.28,
                          child: Text(
                            "Website :",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 10.0),
                      Container(
                          width: screenWidth * 0.50,
                          child: Text(
                            accountBloc.currentAccount!.website == ""
                                ? "------"
                                : accountBloc.currentAccount!.website!,
                            style: TextStyle(
                                color: accountBloc.currentAccount!.website == ""
                                    ? Colors.black45
                                    : Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          width: screenWidth * 0.28,
                          child: Text(
                            "Lead :",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 10),
                      Container(
                          width: screenWidth * 0.50,
                          child: Text(
                            accountBloc.currentAccount!.lead != null &&
                                    accountBloc.currentAccount!.lead!.title !=
                                        null
                                ? accountBloc.currentAccount!.lead!.title!
                                : "------",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          width: screenWidth * 0.28,
                          child: Text(
                            "Industry :",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 10),
                      Container(
                          width: screenWidth * 0.50,
                          child: Text(
                            accountBloc.currentAccount!.industry == ""
                                ? "------"
                                : accountBloc.currentAccount!.industry!,
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          width: screenWidth * 0.28,
                          child: Text(
                            "Status :",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 10),
                      Container(
                          width: screenWidth * 0.50,
                          child: Text(
                            accountBloc.currentAccount!.status!,
                            style: TextStyle(
                                color: accountBloc.currentAccount!.status!
                                            .toLowerCase() ==
                                        "open"
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black12),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Column(children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          width: screenWidth * 0.28,
                          child: Text(
                            "Address :",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 10),
                      Container(
                          width: screenWidth * 0.50,
                          child: Text(
                            "${accountBloc.currentAccount!.billingAddressLine!}, ${accountBloc.currentAccount!.billingStreet!}, ${accountBloc.currentAccount!.billingCity!}, ${accountBloc.currentAccount!.billingState!}, ${accountBloc.currentAccount!.billingCountry!}, ${accountBloc.currentAccount!.billingPostcode!}.",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                    ],
                  ),
                ])),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                if (!_isLoading)
                  showDeleteAccountAlertDialog(
                      context, accountBloc.currentAccount!);
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.red.shade100),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                  color: Colors.white,
                ),
                width: screenWidth * 0.25,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/icon_delete_color.svg',
                      width: screenWidth / 25,
                    ),
                    SizedBox(width: 10.0),
                    Container(
                      child: Text(
                        "Delete",
                        style: TextStyle(
                            fontSize: screenWidth / 23,
                            color: Colors.red,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]))),
    );
  }

  void showDeleteAccountAlertDialog(BuildContext context, Account account) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              account.name != "" ? account.name!.capitalizeFirstofEach() : "",
              style: TextStyle(color: Colors.black),
            ),
            content: Text(
              "Are you sure you want to delete this account?",
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
                    deleteAccount(account);
                  },
                  child: Text("Delete")),
            ],
          );
        });
  }

  deleteAccount(Account account) async {
    setState(() {
      _isLoading = true;
    });
    Map result = await accountBloc.deleteAccount(account);
    setState(() {
      _isLoading = false;
    });
    if (result['error'] == false) {
      showToaster(result['message'], context);
      accountBloc.openAccounts.clear();
      accountBloc.closedAccounts.clear();
      await accountBloc.fetchAccounts();
      await dashboardBloc.fetchDashboardDetails();
      await FirebaseAnalytics.instance.logEvent(name: "Account_Deleted");
      Navigator.pushReplacementNamed(context, '/accounts_list');
    } else if (result['error'] == true) {
      showToaster(result['message'], context);
    } else {
      showErrorMessage(context, result['message'].toString(), account);
    }
  }

  showErrorMessage(BuildContext context, msg, Account account) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Alert'),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      deleteAccount(account);
                    },
                    child: Text('RETRY'))
              ],
            ));
  }
}
