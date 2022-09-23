import 'package:bottle_crm/bloc/auth_bloc.dart';
import 'package:bottle_crm/bloc/contact_bloc.dart';
import 'package:bottle_crm/model/contact.dart';
import 'package:bottle_crm/ui/widgets/loader.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

class ContactDetails extends StatefulWidget {
  ContactDetails();
  @override
  State createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  var _currentTabIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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
          child: buildSocialBlock());
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

  buildSocialBlock() {
    return Container(
      alignment: Alignment.center,
      height: screenHeight,
      width: screenWidth,
      color: Colors.white,
      child: Text("No Socials Found..."),
    );
  }

  buildDescriptionBlock() {
    return Container(
      alignment: Alignment.center,
      height: screenHeight,
      width: screenWidth,
      color: Colors.white,
      child: Text(
          contactBloc.currentContact!.description != ""
              ? contactBloc.currentContact!.description!
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
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      SizedBox(width: 10.0),
                      Container(
                          width: screenWidth * 0.50,
                          child: Text(
                            contactBloc.currentContact!.firstName!
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          width: screenWidth * 0.29,
                          child: Text(
                            "Second Name :",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 10.0),
                      Container(
                          width: screenWidth * 0.50,
                          child: Text(
                            contactBloc.currentContact!.lastName!
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          width: screenWidth * 0.28,
                          child: Text(
                            "Title :",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 10.0),
                      Container(
                          width: screenWidth * 0.50,
                          child: Text(
                            contactBloc.currentContact!.title!
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          width: screenWidth * 0.28,
                          child: Text(
                            "Crated Date :",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 10.0),
                      Container(
                          width: screenWidth * 0.50,
                          child: Text(
                            contactBloc.currentContact!.createdOn!
                                .capitalizeFirstofEach(),
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
                          contactBloc.currentContact!.createdBy!.firstName!
                                  .capitalizeFirstofEach() +
                              " ${contactBloc.currentContact!.createdBy!.lastName!}",
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
                        child:
                            Icon(Icons.email_outlined, size: screenWidth / 20)),
                    SizedBox(width: 10.0),
                    Container(
                        width: screenWidth * 0.50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contactBloc.currentContact!.primaryEmail!,
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth / 24),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              contactBloc.currentContact!.secondaryEmail! != ""
                                  ? contactBloc.currentContact!.secondaryEmail!
                                  : "-----",
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
                              contactBloc.currentContact!.primaryMobile != ""
                                  ? contactBloc.currentContact!.primaryMobile!
                                  : "-----",
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
                          "Do not call :",
                          style: TextStyle(
                              color: Colors.blueGrey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth / 24),
                        )),
                    SizedBox(width: 10),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: screenWidth * 0.50,
                        child: Switch(
                          value: contactBloc.currentContact!.doNotCall!,
                          onChanged: (value) {},
                          activeColor: Colors.blue,
                          focusColor: Colors.blue,
                        ))
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
                          "${contactBloc.currentContact!.address!['address_line']}${contactBloc.currentContact!.address!['street']}${contactBloc.currentContact!.address!['city']}${contactBloc.currentContact!.address!['state']}${contactBloc.currentContact!.address!['postcode']}${contactBloc.currentContact!.address!['country']}",
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
                showDeleteContactAlertDialog(
                    context, contactBloc.currentContact!);
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

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _isLoading ? Loader() : new Container();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(fit: StackFit.expand, children: [
        SafeArea(
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(73, 128, 255, 1.0)),
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
                            'Contact Details',
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
                            Icon(Icons.edit_outlined,
                                size: screenWidth / 18,
                                color: Theme.of(context).primaryColor),
                            GestureDetector(
                              onTap: () async {
                                if (!_isLoading) {
                                  contactBloc.currentEditContactId =
                                      contactBloc.currentContact!.id.toString();
                                  await contactBloc.updateCurrentEditContact(
                                      contactBloc.currentContact!);
                                  Navigator.pushNamed(
                                      context, '/contact_create');
                                }
                              },
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
                                        'Contact Information',
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
                                        'Social',
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
                        : Container(color: Colors.white))
              ],
            ),
          ),
        ),
        new Align(
          child: loadingIndicator,
          alignment: FractionalOffset.center,
        )
      ]),
    );
  }

  void showDeleteContactAlertDialog(BuildContext context, Contact contact) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              contact.firstName != ""
                  ? contact.firstName!.capitalizeFirstofEach()
                  : "",
              style: TextStyle(color: Colors.black),
            ),
            content: Text(
              "Are you sure you want to delete this contact?",
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
                    deleteContact(contact);
                  },
                  child: Text("Delete")),
            ],
          );
        });
  }

  deleteContact(Contact contact) async {
    setState(() {
      _isLoading = true;
    });
    Map result = await contactBloc.deleteContact(contact);
    setState(() {
      _isLoading = false;
    });
    if (result['error'] == false) {
      showToaster(result['message'], context);
      contactBloc.contacts.clear();
      await contactBloc.fetchContacts();
      await FirebaseAnalytics.instance.logEvent(name: "Contact_Deleted");
      Navigator.pushReplacementNamed(context, '/contacts_list');
    } else if (result['error'] == true) {
      showToaster(result['message'], context);
    } else {
      showErrorMessage(context, 'Something went wrong', contact);
    }
  }

  showErrorMessage(BuildContext context, msg, Contact contact) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Alert'),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      deleteContact(contact);
                    },
                    child: Text('RETRY'))
              ],
            ));
  }
}
