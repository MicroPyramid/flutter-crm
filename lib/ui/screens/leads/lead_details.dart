import 'package:bottle_crm/bloc/auth_bloc.dart';
import 'package:bottle_crm/model/lead.dart';
import 'package:bottle_crm/ui/widgets/loader.dart';
import 'package:bottle_crm/ui/widgets/profile_pic_widget.dart';
import 'package:bottle_crm/ui/widgets/tags_widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottle_crm/bloc/lead_bloc.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:random_color/random_color.dart';

class LeadDetails extends StatefulWidget {
  LeadDetails();
  @override
  State createState() => _LeadDetailsState();
}

class _LeadDetailsState extends State<LeadDetails> {
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
                              'Lead Details',
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
                              leadBloc.currentEditLeadId =
                                  leadBloc.currentLead!.id.toString();
                              await leadBloc
                                  .updateCurrentEditLead(leadBloc.currentLead!);
                              Navigator.pushNamed(context, '/leads_create');
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
                  Container(
                    child: Column(
                      children: [
                        !_isLoading
                            ? Container(
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
                                          'Lead Information',
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
                                        width: screenWidth * 0.20,
                                        child: Text(
                                          'Notes',
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
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Expanded(
                      child: !_isLoading
                          ? Container(
                              child: buildTopBar(),
                              color: Colors.white,
                            )
                          : Container(
                              height: screenHeight,
                              width: screenWidth,
                              color: Colors.white))
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
      return buildLeadInfoBlock();
    } else if (_currentTabIndex == 1) {
      return buildAttachmentBlock();
    } else if (_currentTabIndex == 2) {
      return buildDescriptionBlock();
    }
  }

  buildAttachmentBlock() {
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
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        height: screenHeight,
        width: screenWidth,
        child: Text("No Attachments Found."),
      ),
    );
  }

  buildDescriptionBlock() {
    return SwipeDetector(
      onSwipeRight: (offset) {
        if (_currentTabIndex == 2) {
          setState(() {
            _currentTabIndex = 1;
          });
        }
      },
      child: Container(
        height: screenHeight,
        width: screenWidth,
        color: Colors.white,
        alignment: Alignment.center,
        child: Text(
            leadBloc.currentLead!.description != ""
                ? leadBloc.currentLead!.description!
                : "No Description Found",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)),
      ),
    );
  }

  buildLeadInfoBlock() {
    return SwipeDetector(
      onSwipeLeft: (offset) {
        if (_currentTabIndex == 0) {
          setState(() {
            _currentTabIndex = 1;
          });
        }
      },
      child: Container(
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
                      leadBloc.currentLead!.title!.allInCaps,
                      style: TextStyle(
                          color: Colors.blueGrey[800],
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth / 24),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(children: [
                    leadBloc.currentLead!.opportunityAmount != ""
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 3.0),
                            color: randomColor.randomColor(
                                colorBrightness: ColorBrightness.dark),
                            child: Text(
                              leadBloc.currentLead!.opportunityAmount!,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                            ),
                          )
                        : Container(),
                    leadBloc.currentLead!.status != ""
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 3.0),
                            color: randomColor.randomColor(
                                colorBrightness: ColorBrightness.dark),
                            child: Text(
                              leadBloc.currentLead!.status!,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                            ),
                          )
                        : Container(),
                  ]),
                  SizedBox(height: 10.0),
                  TagViewWidget(leadBloc.currentLead!.tags!),
                  SizedBox(height: 10.0),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            child: ProfilePicViewWidget(leadBloc
                                .currentLead!.assignedTo!
                                .map((assignedUser) =>
                                    assignedUser.profileUrl == ""
                                        ? assignedUser.firstName![0].inCaps
                                        : assignedUser.profileUrl)
                                .toList())),
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
                            leadBloc.currentLead!.createdOn!,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "Expected Close Date",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          child: Text(
                            leadBloc.currentLead!.createdOn!,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          ),
                        ),
                      ],
                    ),
                  )
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
                              Text(
                                "http://www.micropyramid.com",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: screenWidth / 30),
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
                            leadBloc.currentLead!.createdBy!.firstName!
                                    .capitalizeFirstofEach() +
                                " ${leadBloc.currentLead!.createdBy!.lastName!}",
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
                                leadBloc.currentLead!.email! == ""
                                    ? "-----"
                                    : leadBloc.currentLead!.email!,
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
                                leadBloc.currentLead!.phone! == ""
                                    ? "------"
                                    : leadBloc.currentLead!.phone!,
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
                  Row(
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          width: screenWidth * 0.28,
                          child: Image.asset(
                            "assets/images/skype.png",
                            width: screenWidth / 22,
                          )),
                      Text(
                        leadBloc.currentLead!.skypeID == ""
                            ? "   ---------"
                            : "   " + leadBloc.currentLead!.skypeID!,
                        style: TextStyle(
                            color: leadBloc.currentLead!.skypeID != ""
                                ? Colors.blue
                                : Colors.black45,
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth / 24),
                      ),
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
                            "product & services",
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
                            "Pipeline :",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 10),
                      Container(
                          width: screenWidth * 0.50,
                          child: Text(
                            "----------",
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
                            "Probability :",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 10),
                      Container(
                          width: screenWidth * 0.50,
                          child: Text(
                            "----------",
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
                              "First Name :",
                              style: TextStyle(
                                  color: Colors.blueGrey[800],
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth / 24),
                            )),
                        SizedBox(width: 10),
                        Container(
                            width: screenWidth * 0.50,
                            child: Text(
                              leadBloc.currentLead!.firstName != ""
                                  ? leadBloc.currentLead!.firstName!
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
                              "Last Name :",
                              style: TextStyle(
                                  color: Colors.blueGrey[800],
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth / 24),
                            )),
                        SizedBox(width: 10),
                        Container(
                            width: screenWidth * 0.50,
                            child: Text(
                              leadBloc.currentLead!.lastName! == ""
                                  ? "-----"
                                  : leadBloc.currentLead!.lastName!,
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
                              "Job Title :",
                              style: TextStyle(
                                  color: Colors.blueGrey[800],
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth / 24),
                            )),
                        SizedBox(width: 10),
                        Container(
                            width: screenWidth * 0.50,
                            child: Text(
                              leadBloc.currentLead!.title! == ""
                                  ? "-----"
                                  : leadBloc.currentLead!.title!,
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth / 24),
                            )),
                      ],
                    ),
                  ],
                )),
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
                            "${leadBloc.currentLead!.addressLine}, ${leadBloc.currentLead!.street}, ${leadBloc.currentLead!.city}, ${leadBloc.currentLead!.state}, ${leadBloc.currentLead!.postcode}, ${leadBloc.currentLead!.country}.",
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
                  showDeleteLeadAlertDialog(context, leadBloc.currentLead!);
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

  void showDeleteLeadAlertDialog(BuildContext context, Lead lead) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              lead.firstName != ""
                  ? lead.firstName!.capitalizeFirstofEach()
                  : "",
              style: TextStyle(color: Colors.black),
            ),
            content: Text(
              "Are you sure you want to delete this lead?",
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
                    deleteLead(lead);
                  },
                  child: Text("Delete")),
            ],
          );
        });
  }

  deleteLead(Lead lead) async {
    setState(() {
      _isLoading = true;
    });
    Map result = await leadBloc.deleteLead(lead);
    setState(() {
      _isLoading = false;
    });
    if (result['error'] == false) {
      showToaster(result['message'], context);
      leadBloc.openLeads.clear();
      await leadBloc.fetchLeads();
      await FirebaseAnalytics.instance.logEvent(name: "Lead_Deleted");
      Navigator.pushReplacementNamed(context, '/leads_list');
    } else if (result['error'] == true) {
      showToaster(result['message'], context);
    } else {
      showErrorMessage(context, 'Something went wrong', lead);
    }
  }

  showErrorMessage(BuildContext context, msg, Lead lead) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Alert'),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      deleteLead(lead);
                    },
                    child: Text('RETRY'))
              ],
            ));
  }
}
