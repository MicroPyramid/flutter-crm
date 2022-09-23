import 'package:bottle_crm/bloc/setting_bloc.dart';
import 'package:bottle_crm/bloc/user_bloc.dart';
import 'package:bottle_crm/model/user.dart';
import 'package:bottle_crm/ui/widgets/loader.dart';
import 'package:bottle_crm/ui/widgets/tags_widget.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:bottle_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:bottle_crm/model/settings.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

class SettingsList extends StatefulWidget {
  SettingsList();
  @override
  State createState() => _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  var _currentTabIndex = 0;

  List<Settings> _settings = [];
  List<User> _users = [];

  bool _isLoading = false;
  bool _isNextPageLoading = false;
  ScrollController? scrollController;

  @override
  void initState() {
    setState(() {
      _settings = settingsBloc.apiSettings;
      _users = settingsBloc.usersList;
    });
    scrollController = ScrollController();
    scrollController!.addListener(() async {
      if (scrollController!.offset >=
              scrollController!.position.maxScrollExtent &&
          !scrollController!.position.outOfRange &&
          settingsBloc.offset != "" &&
          !_isNextPageLoading) {
        setState(() {
          _isNextPageLoading = true;
        });
        setState(() {
          _isNextPageLoading = false;
        });
      }
    });
    super.initState();
  }

  buildTopBar() {
    if (_currentTabIndex == 0) {
      return SwipeDetector(
          onSwipeLeft: (offset) {
            setState(() {
              _currentTabIndex = 1;
            });
          },
          child: _buildSettingsList());
    } else if (_currentTabIndex == 1) {
      return SwipeDetector(
          onSwipeRight: (offset) {
            setState(() {
              _currentTabIndex = 0;
            });
          },
          child: _buildUsersBlock());
    }
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
                        Row(children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back_ios,
                                  color: Colors.white, size: screenWidth / 18)),
                          Text(
                            'Settings',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth / 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ])
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
                                  width: screenWidth * 0.25,
                                  child: Text(
                                    'Api Settings',
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
                                    'Users',
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
                    child: Container(color: Colors.white, child: buildTopBar()),
                  ),
                  _isNextPageLoading
                      ? Container(
                          color: Colors.white,
                          child: Container(
                              width: 20.0,
                              child: new Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: new Center(
                                      child: new CircularProgressIndicator()))))
                      : Container()
                ],
              ),
            ),
          ),
          new Align(
            child: loadingIndicator,
            alignment: FractionalOffset.center,
          )
        ]),
        bottomNavigationBar: BottomNavigationBarWidget());
  }

  Widget _buildSettingsList() {
    return _settings.length != 0
        ? Container(
            padding: EdgeInsets.all(10.0),
            child: ListView.builder(
                itemCount: _settings.length,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        settingsBloc.currentSettings = _settings[index];
                        Navigator.pushNamed(context, '/settings_details');
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: screenWidth * 0.55,
                                    child: Text(
                                        _settings[index]
                                            .title!
                                            .capitalizeFirstofEach(),
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.blueGrey[800],
                                            fontWeight: FontWeight.w600,
                                            fontSize: screenWidth / 24)),
                                  ),
                                  Container(
                                    width: screenWidth * 0.3,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        _settings[index]
                                                    .createdBy!
                                                    .profileUrl !=
                                                ""
                                            ? CircleAvatar(
                                                radius: screenWidth / 28,
                                                backgroundImage: NetworkImage(
                                                    _settings[index]
                                                        .createdBy!
                                                        .profileUrl!),
                                              )
                                            : CircleAvatar(
                                                radius: screenWidth / 25,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                                child: Text(
                                                  _settings[index]
                                                      .createdBy!
                                                      .firstName![0]
                                                      .allInCaps,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                        SizedBox(width: 5.0),
                                        Text(
                                            _settings[index]
                                                .createdBy!
                                                .firstName!
                                                .capitalizeFirstofEach(),
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.blueGrey[800],
                                                fontWeight: FontWeight.w500,
                                                fontSize: screenWidth / 25))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: screenWidth * 0.5,
                                      child: TagViewWidget(
                                          _settings[index].tags!)),
                                  Text(_settings[index].createdOn!,
                                      style: TextStyle(
                                          color: Colors.blueGrey[800],
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenWidth / 24))
                                ],
                              ),
                            )
                          ],
                        ),
                      ));
                }),
          )
        : Center(
            child: Text(_isLoading || _isNextPageLoading
                ? "Fetching data..."
                : 'No Api Settings Found.'),
          );
  }

  Widget _buildUsersBlock() {
    return _users.length != 0
        ? Container(
            padding: EdgeInsets.all(10.0),
            child: ListView.builder(
                itemCount: _users.length,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        userBloc.currentUser = _users[index];
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
                                  _users[index].profilePic != ""
                                      ? CircleAvatar(
                                          radius: screenWidth / 28,
                                          backgroundImage: NetworkImage(
                                              _users[index].profilePic!),
                                        )
                                      : CircleAvatar(
                                          radius: screenWidth / 25,
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          child: Text(
                                            _users[index]
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
                                            _users[index]
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
                                        child: Text(_users[index].role!,
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
        : Center(
            child: Text(_isLoading || _isNextPageLoading
                ? "Fetching data..."
                : 'No Users Found.'),
          );
  }
}
