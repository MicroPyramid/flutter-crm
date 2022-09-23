import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottle_crm/bloc/user_bloc.dart';
import 'package:bottle_crm/model/user.dart';
import 'package:bottle_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

class UsersList extends StatefulWidget {
  UsersList();
  @override
  State createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  var _currentTabIndex = 0;
  ScrollController? scrollController;

  bool _isFilter = false;

  List<User> _activeUsers = [];
  List<User> _inActiveUsers = [];
  @override
  void initState() {
    _activeUsers = userBloc.activeUsers;
    _inActiveUsers = userBloc.inActiveUsers;
    super.initState();
  }

  _buildTopBar() {
    if (_currentTabIndex == 0) {
      return SwipeDetector(
          onSwipeLeft: (offset) {
            setState(() {
              _currentTabIndex = 1;
              _inActiveUsers = userBloc.inActiveUsers;
            });
          },
          child: _buildActiveUsersList());
    } else if (_currentTabIndex == 1) {
      return SwipeDetector(
          onSwipeRight: (offset) {
            setState(() {
              _currentTabIndex = 0;
            });
          },
          child: _buildInActiveUsersList());
    }
  }

  Widget _buildActiveUsersList() {
    return _activeUsers.length != 0
        ? Container(
            padding: EdgeInsets.all(10.0),
            child: ListView.builder(
                itemCount: _activeUsers.length,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        userBloc.currentUser = _activeUsers[index];
                        Navigator.pushNamed(context, '/user_details');
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  _activeUsers[index].profilePic != ""
                                      ? CircleAvatar(
                                          radius: screenWidth / 28,
                                          backgroundImage: NetworkImage(
                                              _activeUsers[index].profilePic!),
                                        )
                                      : CircleAvatar(
                                          radius: screenWidth / 25,
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          child: Text(
                                            _activeUsers[index]
                                                .firstName![0]
                                                .allInCaps,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                  SizedBox(width: 10.0),
                                  Column(
                                    children: [
                                      Container(
                                        width: screenWidth * 0.55,
                                        child: Text(
                                            _activeUsers[index]
                                                .firstName!
                                                .capitalizeFirstofEach(),
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.blueGrey[800],
                                                fontWeight: FontWeight.w600,
                                                fontSize: screenWidth / 24)),
                                      ),
                                      Container(
                                        width: screenWidth * 0.55,
                                        child: Text(_activeUsers[index].role!,
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                                fontSize: screenWidth / 30)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5.0),
                          ],
                        ),
                      ));
                }),
          )
        : Container(
            alignment: Alignment.center,
            color: Colors.white,
            height: screenHeight,
            width: screenWidth,
            child: Text('No Users Found.'),
          );
  }

  Widget _buildInActiveUsersList() {
    return _inActiveUsers.length != 0
        ? Container(
            padding: EdgeInsets.all(10.0),
            child: ListView.builder(
                itemCount: _inActiveUsers.length,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        userBloc.currentUser = _inActiveUsers[index];
                        Navigator.pushNamed(context, '/user_details');
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  _inActiveUsers[index].profilePic != ""
                                      ? CircleAvatar(
                                          radius: screenWidth / 28,
                                          backgroundImage: NetworkImage(
                                              _inActiveUsers[index]
                                                  .profilePic!),
                                        )
                                      : CircleAvatar(
                                          radius: screenWidth / 25,
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          child: Text(
                                            _inActiveUsers[index]
                                                .firstName![0]
                                                .allInCaps,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                  SizedBox(width: 10.0),
                                  Column(
                                    children: [
                                      Container(
                                        width: screenWidth * 0.55,
                                        child: Text(
                                            _inActiveUsers[index]
                                                .firstName!
                                                .capitalizeFirstofEach(),
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.blueGrey[800],
                                                fontWeight: FontWeight.w600,
                                                fontSize: screenWidth / 24)),
                                      ),
                                      Container(
                                        width: screenWidth * 0.55,
                                        child: Text(_inActiveUsers[index].role!,
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                                fontSize: screenWidth / 30)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5.0),
                          ],
                        ),
                      ));
                }),
          )
        : Container(
            alignment: Alignment.center,
            color: Colors.white,
            height: screenHeight,
            width: screenWidth,
            child: Text('No Users Found.'));
  }

  @override
  Widget build(BuildContext context) {
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
                          child: Row(
                            children: [
                              GestureDetector(
                                  child: new Icon(Icons.arrow_back_ios,
                                      color: Colors.white),
                                  onTap: () {
                                    Navigator.pop(context, true);
                                  }),
                              SizedBox(width: 10.0),
                              Text(
                                'Users',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth / 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _isFilter = !_isFilter;
                              });
                            },
                            child: Container(
                                child: SvgPicture.asset(
                              !_isFilter
                                  ? 'assets/images/filter.svg'
                                  : 'assets/images/icon_close.svg',
                              width: screenWidth / 20,
                            )))
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                          height: screenHeight * 0.06,
                          decoration: BoxDecoration(
                            color: bottomNavBarSelectedTextColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  if (_currentTabIndex != 0) {
                                    setState(() {
                                      _currentTabIndex = 0;
                                      _activeUsers = userBloc.activeUsers;
                                    });
                                  }
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
                                  width: screenWidth * 0.15,
                                  child: Text(
                                    'Open',
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
                                  FocusScope.of(context).unfocus();
                                  if (_currentTabIndex != 1) {
                                    setState(() {
                                      _currentTabIndex = 1;
                                      _inActiveUsers = userBloc.inActiveUsers;
                                    });
                                  }
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
                                  width: screenWidth * 0.15,
                                  child: Text(
                                    'Closed',
                                    style: TextStyle(
                                        color: _currentTabIndex == 1
                                            ? Colors.white
                                            : Theme.of(context)
                                                .secondaryHeaderColor,
                                        fontSize: screenWidth / 25,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: _buildTopBar(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     if (userBloc.activeUsers.length == 0) {
        //     } else {
        //       Navigator.pushNamed(context, '/user_create');
        //     }
        //   },
        //   child: Icon(Icons.add, color: Colors.white),
        //   backgroundColor: Theme.of(context).primaryColor,
        // ),
        bottomNavigationBar: BottomNavigationBarWidget());
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              "Alert",
              style: TextStyle(color: Colors.black),
            ),
            content: Text(
              "You don't have any users, Please create user first.",
              style: TextStyle(fontSize: 15.0),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                  textStyle: TextStyle(color: Colors.red),
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    currentBottomNavigationIndex = "4";
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/user_create");
                  },
                  child: Text("Create")),
            ],
          );
        });
  }
}
