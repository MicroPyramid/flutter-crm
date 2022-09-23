import 'package:bottle_crm/bloc/opportunity_bloc.dart';
import 'package:bottle_crm/model/opportunities.dart';
import 'package:bottle_crm/ui/widgets/loader.dart';
import 'package:bottle_crm/ui/widgets/profile_pic_widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:bottle_crm/ui/widgets/tags_widget.dart';
import 'package:random_color/random_color.dart';
import '../../../utils/utils.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

class OpportunitiesDetails extends StatefulWidget {
  OpportunitiesDetails();
  @override
  State createState() => _OpportunitiesDetailsState();
}

class _OpportunitiesDetailsState extends State<OpportunitiesDetails> {
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
        body: Stack(fit: StackFit.expand, children: [
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
                              'Opportunity Details',
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
                              opportunityBloc.currentEditOpportunityId =
                                  opportunityBloc.currentOpportunity!.id
                                      .toString();
                              await opportunityBloc
                                  .updateCurrentEditOpportunity(
                                      opportunityBloc.currentOpportunity!);
                              Navigator.pushNamed(
                                  context, '/opportunitie_create');
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 23.0),
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
                                            width: _currentTabIndex == 0
                                                ? 3.0
                                                : 0.0,
                                          ))),
                                          width: screenWidth * 0.40,
                                          child: Text(
                                            'Opportunity Information',
                                            style: TextStyle(
                                                color: _currentTabIndex == 0
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                        .secondaryHeaderColor,
                                                fontSize: screenWidth / 28,
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
                                            width: _currentTabIndex == 1
                                                ? 3.0
                                                : 0.0,
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
                                            width: _currentTabIndex == 2
                                                ? 3.0
                                                : 0.0,
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
                                  )),
                            ],
                          ),
                        )
                      : Container(),
                  Expanded(
                      child: Container(
                    child: !_isLoading
                        ? buildTopBar()
                        : Container(color: Colors.white),
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
        ]));
  }

  buildTopBar() {
    if (_currentTabIndex == 0) {
      return SwipeDetector(
          onSwipeLeft: (offset) {
            setState(() {
              _currentTabIndex = 1;
            });
          },
          child: buildOpportunityInfoBlock());
    } else if (_currentTabIndex == 1) {
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
      height: screenHeight,
      width: screenWidth,
      color: Colors.white,
      child: Text("No Attachment Found..."),
    );
  }

  buildDescriptionBlock() {
    return Container(
      alignment: Alignment.center,
      height: screenHeight,
      width: screenWidth,
      color: Colors.white,
      child: Text(
          opportunityBloc.currentOpportunity!.description != ""
              ? opportunityBloc.currentOpportunity!.description!
              : "No Description Found",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)),
    );
  }

  buildOpportunityInfoBlock() {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
            child: Column(children: [
          Container(
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
                    opportunityBloc.currentOpportunity!.name!.allInCaps,
                    style: TextStyle(
                        color: Colors.blueGrey[800],
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth / 24),
                  ),
                ),
                opportunityBloc.currentOpportunity!.amount != ""
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 3.0),
                        color: randomColor.randomColor(
                            colorBrightness: ColorBrightness.dark),
                        child: Text(
                          opportunityBloc.currentOpportunity!.amount!,
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                      )
                    : Container(),
                SizedBox(height: 10.0),
                TagViewWidget(opportunityBloc.currentOpportunity!.tags!),
                SizedBox(height: 10.0),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child: ProfilePicViewWidget(opportunityBloc
                              .currentOpportunity!.assignedTo!
                              .map((assignedUser) =>
                                  assignedUser.profileUrl == ""
                                      ? assignedUser.firstName![0].inCaps
                                      : assignedUser.profileUrl)
                              .toList())
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
                            opportunityBloc.currentOpportunity!.name!
                                .capitalizeFirstofEach(),
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
                            opportunityBloc.currentOpportunity!.account!.name ==
                                    null
                                ? "-----"
                                : opportunityBloc
                                    .currentOpportunity!.account!.name!,
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
                            opportunityBloc.currentOpportunity!.stage!,
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
                            opportunityBloc.currentOpportunity!.dueDate == null
                                ? "-----"
                                : opportunityBloc.currentOpportunity!.closedOn
                                    .toString(),
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
                          "Lead Souece :",
                          style: TextStyle(
                              color: Colors.blueGrey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth / 24),
                        )),
                    SizedBox(width: 10.0),
                    Container(
                        width: screenWidth * 0.50,
                        child: Text(
                          opportunityBloc.currentOpportunity!.leadSource!,
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
                          "Amount :",
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
                              opportunityBloc.currentOpportunity!.amount!,
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
                          opportunityBloc
                                  .currentOpportunity!.createdBy!.firstName!
                                  .capitalizeFirstofEach() +
                              " ${opportunityBloc.currentOpportunity!.createdBy!.lastName!}",
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
                          opportunityBloc.currentOpportunity!.teams!.length == 0
                              ? "-----"
                              : _getTeams(),
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
                          "User :",
                          style: TextStyle(
                              color: Colors.blueGrey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth / 24),
                        )),
                    SizedBox(width: 10),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: screenWidth * 0.50,
                        child: Text(
                          opportunityBloc
                                      .currentOpportunity!.assignedTo!.length ==
                                  0
                              ? "-----"
                              : _getUsers(),
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth / 24),
                        ))
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                        alignment: Alignment.centerRight,
                        width: screenWidth * 0.28,
                        child: Text(
                          "Probability :",
                          style: TextStyle(
                              color: Colors.blueGrey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth / 24),
                        )),
                    SizedBox(width: 10),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: screenWidth * 0.50,
                        child: Text(
                          opportunityBloc.currentOpportunity!.probability!
                                      .toString() ==
                                  ""
                              ? "-----"
                              : opportunityBloc.currentOpportunity!.probability!
                                  .toString(),
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth / 24),
                        ))
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          GestureDetector(
            onTap: () {
              if (!_isLoading)
                showDeleteOpportunityAlertDialog(
                    context, opportunityBloc.currentOpportunity!);
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

  _getTeams() {
    List teams = [];

    opportunityBloc.currentOpportunity!.teams!.forEach((_teams) {
      String _teamsList;
      _teamsList = _teams.name!;
      teams.add(_teamsList);
    });

    return teams.toString().replaceAll("[", "").replaceAll("]", "");
  }

  _getUsers() {
    List users = [];

    opportunityBloc.currentOpportunity!.assignedTo!.forEach((_teams) {
      String _teamsList;
      _teamsList = _teams.firstName!;
      users.add(_teamsList);
    });

    return users.toString().replaceAll("[", "").replaceAll("]", "");
  }

  void showDeleteOpportunityAlertDialog(
      BuildContext context, Opportunity opportunity) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              opportunity.name != ""
                  ? opportunity.name!.capitalizeFirstofEach()
                  : "",
              style: TextStyle(color: Colors.black),
            ),
            content: Text(
              "Are you sure you want to delete this Opportunity?",
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
                    deleteOpportunity(opportunity);
                  },
                  child: Text("Delete")),
            ],
          );
        });
  }

  deleteOpportunity(Opportunity opportunity) async {
    setState(() {
      _isLoading = true;
    });
    Map result = await opportunityBloc.deleteOpportunity(opportunity);
    setState(() {
      _isLoading = false;
    });
    if (result['error'] == false) {
      showToaster(result['message'], context);
      opportunityBloc.opportunities.clear();
      opportunityBloc.fetchOpportunities();
      await FirebaseAnalytics.instance.logEvent(name: "Opportunity_Deleted");
      Navigator.pushNamedAndRemoveUntil(
          context, '/opportunities_list', ((route) => false));
    } else if (result['error'] == true) {
      showToaster(result['message'], context);
    } else {
      showErrorMessage(context, result['message'].toString(), opportunity);
    }
  }

  showErrorMessage(BuildContext context, msg, Opportunity opportunity) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Alert'),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      deleteOpportunity(opportunity);
                    },
                    child: Text('RETRY'))
              ],
            ));
  }
}
