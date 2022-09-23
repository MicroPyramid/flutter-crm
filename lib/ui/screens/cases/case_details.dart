import 'package:bottle_crm/bloc/case_bloc.dart';
import 'package:bottle_crm/model/case.dart';
import 'package:bottle_crm/ui/widgets/loader.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bottle_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/utils.dart';

class CaseDetails extends StatefulWidget {
  CaseDetails();
  @override
  State createState() => _CaseDetailsState();
}

class _CaseDetailsState extends State<CaseDetails> {
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
      resizeToAvoidBottomInset: false,
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
                              'Case Details',
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
                              caseBloc.currentEditCaseId =
                                  caseBloc.currentCase!.id.toString();
                              await caseBloc
                                  .updateCurrentEditCase(caseBloc.currentCase!);
                              Navigator.pushNamed(context, '/case_create');
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
                                          'Case Information',
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
                                        width: screenWidth * 0.24,
                                        child: Text(
                                          'Attachments',
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
      return SwipeDetector(
          onSwipeLeft: (offset) {
            if (_currentTabIndex == 0) {
              setState(() {
                _currentTabIndex = 1;
              });
            }
          },
          child: buildContactInfoBlock());
    } else if (_currentTabIndex == 1) {
      return SwipeDetector(
          onSwipeRight: (offset) {
            setState(() {
              _currentTabIndex = 0;
            });
          },
          onSwipeLeft: (offset) {
            setState(() {
              _currentTabIndex = 2;
            });
          },
          child: buildAttachmentBlock());
    } else if (_currentTabIndex == 2) {
      return SwipeDetector(
          onSwipeRight: (offset) {
            setState(() {
              _currentTabIndex = 1;
            });
          },
          child: buildDescriptionBlock());
    }
  }

  buildAttachmentBlock() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      height: screenHeight,
      width: screenWidth,
      child: Text("No Attachment Found..."),
    );
  }

  buildDescriptionBlock() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      height: screenHeight,
      width: screenWidth,
      child: Text(
          caseBloc.currentCase!.description != ""
              ? caseBloc.currentCase!.description!
              : "No Description Found",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)),
    );
  }

  buildContactInfoBlock() {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
            child: Column(children: [
          Container(
            padding: EdgeInsets.all(20.0),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          caseBloc.currentCase!.name!,
                          style: TextStyle(
                              color: Colors.blueGrey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth / 24),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        child: Container(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: screenWidth / 25,
                                backgroundImage: NetworkImage(
                                    "https://www.thefamouspeople.com/profiles/images/virat-kohli-3.jpg"),
                              ),
                              SizedBox(width: 3.0),
                              CircleAvatar(
                                radius: screenWidth / 25,
                                backgroundImage: NetworkImage(
                                    "https://upload.wikimedia.org/wikipedia/commons/2/29/Ms._Smriti_Mandhana%2C_Arjun_Awardee_%28Cricket%29%2C_in_New_Delhi_on_July_16%2C_2019_%28cropped%29.jpg"),
                              ),
                              SizedBox(width: 3.0),
                              CircleAvatar(
                                radius: screenWidth / 25,
                                backgroundColor: Colors.grey,
                                child: Text(
                                  "JR",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
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
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black12),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          width: screenWidth * 0.28,
                          child: Text(
                            "Name :",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 10.0),
                      Container(
                          width: screenWidth * 0.50,
                          child: Text(
                            caseBloc.currentCase!.name!.capitalizeFirstofEach(),
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
                          width: screenWidth * 0.29,
                          child: Text(
                            "Account :",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 10.0),
                      Container(
                          width: screenWidth * 0.50,
                          child: Text(
                            caseBloc.currentCase!.account!.name != null
                                ? caseBloc.currentCase!.account!.name!
                                : "-----",
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
                      SizedBox(width: 10.0),
                      Container(
                          width: screenWidth * 0.50,
                          child: Text(
                            caseBloc.currentCase!.status!,
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
                            "Closed Date :",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 10.0),
                      Container(
                          width: screenWidth * 0.50,
                          child: Text(
                            caseBloc.currentCase!.closedOn!,
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                    ],
                  ),
                ],
              )),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.all(20.0),
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
                          "Priority :",
                          style: TextStyle(
                              color: Colors.blueGrey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth / 24),
                        )),
                    SizedBox(width: 10.0),
                    Container(
                        width: screenWidth * 0.50,
                        child: Text(
                          caseBloc.currentCase!.priority!,
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
                        child: Text(
                          "Type of Case :",
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
                              caseBloc.currentCase!.caseType == ""
                                  ? "----"
                                  : caseBloc.currentCase!.caseType!,
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth / 24),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Divider())
                          ],
                        )),
                  ],
                ),
                SizedBox(width: 10.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          caseBloc.currentCase!.createdBy!.firstName!,
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth / 24),
                        )),
                  ],
                ),
                SizedBox(width: 10.0),
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
                              " +91 0000 000 000",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth / 24),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              " +91 0000 000 000",
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
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                        alignment: Alignment.centerRight,
                        width: screenWidth * 0.28,
                        child: Text(
                          "Teams :",
                          style: TextStyle(
                              color: Colors.blueGrey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth / 24),
                        )),
                    SizedBox(width: 10),
                    Container(
                        width: screenWidth * 0.50,
                        child: Text(
                          caseBloc.currentCase!.teams!.length == 0
                              ? "----"
                              : _getteams(),
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
                          "Users :",
                          style: TextStyle(
                              color: Colors.blueGrey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth / 24),
                        )),
                    SizedBox(width: 10),
                    Container(
                        width: screenWidth * 0.50,
                        child: Text(
                          caseBloc.currentCase!.assignedTo!.length == 0
                              ? "----"
                              : _getUsers(),
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth / 24),
                        )),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          GestureDetector(
            onTap: () {
              if (!_isLoading)
                showDeleteAccountAlertDialog(context, caseBloc.currentCase!);
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
        ])));
  }

  _getteams() {
    List teams = [];

    caseBloc.currentCase!.teams!.forEach((_teams) {
      String _teamsList;
      _teamsList = _teams.name!;
      teams.add(_teamsList);
    });

    return teams.toString().replaceAll("[", "").replaceAll("]", "");
  }

  _getUsers() {
    List users = [];

    caseBloc.currentCase!.assignedTo!.forEach((_teams) {
      String _teamsList;
      _teamsList = _teams.firstName!;
      users.add(_teamsList);
    });

    return users.toString().replaceAll("[", "").replaceAll("]", "");
  }

  void showDeleteAccountAlertDialog(BuildContext context, Case casee) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              casee.name != "" ? casee.name!.capitalizeFirstofEach() : "",
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
                    deleteCase(casee);
                  },
                  child: Text("Delete")),
            ],
          );
        });
  }

  deleteCase(Case casee) async {
    setState(() {
      _isLoading = true;
    });
    Map result = await caseBloc.deleteCase(casee);
    setState(() {
      _isLoading = false;
    });
    if (result['error'] == false) {
      showToaster(result['message'], context);
      caseBloc.cases.clear();
      await caseBloc.fetchCases();
      await FirebaseAnalytics.instance.logEvent(name: "Case_deleted");
      Navigator.pushReplacementNamed(context, '/cases_list');
    } else if (result['error'] == true) {
      showToaster(result['message'], context);
    } else {
      showErrorMessage(context, 'Something went wrong', casee);
    }
  }

  showErrorMessage(BuildContext context, msg, Case casee) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Alert'),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      deleteCase(casee);
                    },
                    child: Text('RETRY'))
              ],
            ));
  }
}
