import 'package:bottle_crm/bloc/auth_bloc.dart';
import 'package:bottle_crm/bloc/user_bloc.dart';
import 'package:bottle_crm/ui/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

class UserDetails extends StatefulWidget {
  UserDetails();
  @override
  State createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
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
                              'User Details',
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
                              userBloc.currentEditUserId =
                                  userBloc.currentUser!.id.toString();
                              await userBloc
                                  .updateCurrentEditUser(userBloc.currentUser!);
                              Navigator.pushNamed(context, '/user_create');
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
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 23.0),
                          height: screenHeight * 0.06,
                          decoration: BoxDecoration(
                            color: bottomNavBarSelectedTextColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    width: _currentTabIndex == 0 ? 3.0 : 0.0,
                                  ))),
                                  width: screenWidth * 0.40,
                                  child: Text(
                                    'User Information',
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
                                    width: _currentTabIndex == 1 ? 3.0 : 0.0,
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
                                    width: _currentTabIndex == 2 ? 3.0 : 0.0,
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
                  ),
                  Expanded(
                      child: Container(
                    child: buildTopBar(),
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
            setState(() {
              _currentTabIndex = 1;
            });
          },
          child: buildUserInfoBlock());
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
      color: Colors.white,
      height: screenHeight,
      width: screenWidth,
      child: Text("No Attachments Found."),
    );
  }

  buildDescriptionBlock() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      height: screenHeight,
      width: screenWidth,
      child: Text("No Notes Found."),
    );
  }

  buildUserInfoBlock() {
    return Container(
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userBloc.currentUser!.firstName!
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
                SizedBox(height: 10.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    SizedBox(width: 10.0),
                    Container(
                        width: screenWidth * 0.50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userBloc.currentUser!.lastName == ""
                                  ? "----"
                                  : userBloc.currentUser!.lastName!
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
                SizedBox(height: 10.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        alignment: Alignment.centerRight,
                        width: screenWidth * 0.28,
                        child: Text(
                          "Role :",
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
                              userBloc.currentUser!.role!,
                              //.capitalizeFirstofEach(),
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth / 24),
                            ),
                          ],
                        )),
                  ],
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
                            SizedBox(height: 5.0),
                            Text(
                              "https//:www.micropyramid.com",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth / 25),
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
                              userBloc.currentUser!.email!,
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
                              userBloc.currentUser!.phone!,
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
                  children: [
                    Container(
                        alignment: Alignment.centerRight,
                        width: screenWidth * 0.28,
                        child: Image.asset(
                          "assets/images/skype.png",
                          width: screenWidth / 22,
                        )),
                    // SizedBox(width: 10.0),
                    // Container(
                    //     width: screenWidth * 0.50,
                    //     child: Text(
                    //       " skype@Id",
                    //       style: TextStyle(
                    //           color: Colors.blue,
                    //           fontWeight: FontWeight.w600,
                    //           fontSize: screenWidth / 24),
                    //     )),
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
                          "${userBloc.currentUser!.adressLine} ${userBloc.currentUser!.street!}, ${userBloc.currentUser!.city!}, ${userBloc.currentUser!.state!}, ${userBloc.currentUser!.country!}, ${userBloc.currentUser!.pincode!}.",
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth / 24),
                        )),
                  ],
                ),
              ])),
          SizedBox(height: 10.0),
        ])));
  }
}
