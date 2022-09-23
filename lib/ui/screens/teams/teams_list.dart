import 'package:bottle_crm/model/team.dart';
import 'package:bottle_crm/ui/widgets/loader.dart';
import 'package:bottle_crm/ui/widgets/profile_pic_widget.dart';
//import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottle_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bottle_crm/bloc/team_bloc.dart';

class TeamsList extends StatefulWidget {
  TeamsList();
  @override
  State createState() => _TeamsListState();
}

class _TeamsListState extends State<TeamsList> {
  final GlobalKey<FormState> _filtersFormKey = GlobalKey<FormState>();
  List<Team> _teams = [];
  bool _isFilter = false;
  ScrollController? scrollController;
  bool _isNextPageLoading = false;
  Map _filtersFormData = {
    "team_name": "",
    "created_by": "",
    "assigned_users": ""
  };
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _teams = teamBloc.teams;
    });
    scrollController = ScrollController();
    scrollController!.addListener(() async {
      if (scrollController!.offset >=
              scrollController!.position.maxScrollExtent &&
          !scrollController!.position.outOfRange &&
          teamBloc.offset != "" &&
          !_isNextPageLoading) {
        setState(() {
          _isNextPageLoading = true;
        });
        await teamBloc.fetchTeams(
            filtersData: _isFilter ? _filtersFormData : null);
        setState(() {
          _isNextPageLoading = false;
        });
      }
    });
    super.initState();
  }

  _submitForm() async {
    if (_isFilter) {
      _filtersFormKey.currentState!.save();
    }
    setState(() {
      _isLoading = true;
    });
    teamBloc.offset = "";
    teamBloc.teams.clear();
    await teamBloc.fetchTeams(filtersData: _isFilter ? _filtersFormData : null);
    setState(() {
      _isLoading = false;
    });
  }

  OutlineInputBorder buildBorder(Color color) {
    return OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(3.0)));
  }

  EdgeInsets padding() {
    return EdgeInsets.symmetric(
        horizontal: screenWidth / 30, vertical: screenHeight / 80);
  }

  _buildFilterBlock() {
    return _isFilter
        ? Container(
            color: Colors.grey[100],
            child: Form(
              key: _filtersFormKey,
              child: Column(
                children: [
                  SizedBox(height: 10.0),
                  Container(
                    width: screenWidth * 0.92,
                    child: TextFormField(
                      initialValue: _filtersFormData['team_name'],
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Enter team name",
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        enabledBorder: buildBorder(Colors.black54),
                        focusedErrorBorder: buildBorder(Colors.black54),
                        focusedBorder: buildBorder(Colors.black54),
                        errorBorder: buildBorder(Colors.black54),
                        border: buildBorder(Colors.black54),
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        _filtersFormData['team name'] = value;
                      },
                    ),
                  ),
                  // Container(
                  //     padding: padding(),
                  //     child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "Created by",
                  //             style: TextStyle(
                  //                 fontSize: 18, color: Colors.black54),
                  //           ),
                  //           SizedBox(height: screenHeight / 70),
                  //           Container(
                  //               width: screenWidth * 0.92,
                  //               height: screenHeight / 17,
                  //               child: Stack(children: [
                  //                 DropdownSearch<String?>(
                  //                   mode: Mode.BOTTOM_SHEET,
                  //                   items: teamBloc.userObjForDropDown,
                  //                   onChanged: print,
                  //                   onSaved: (selection) {
                  //                     if (selection == null) {
                  //                       teamBloc.currentEditTeam![
                  //                           "created_by"] = "";
                  //                     } else {
                  //                       teamBloc.currentEditTeam![
                  //                           'created_by'] = selection;
                  //                     }
                  //                   },
                  //                   selectedItem:
                  //                       teamBloc.currentEditTeam!['created_by'],
                  //                   showSearchBox: true,
                  //                   showSelectedItems: false,
                  //                   showClearButton: false,
                  //                   searchFieldProps: TextFieldProps(
                  //                       decoration: InputDecoration(
                  //                     border: boxBorder(),
                  //                     enabledBorder: boxBorder(),
                  //                     focusedErrorBorder: boxBorder(),
                  //                     focusedBorder: boxBorder(),
                  //                     errorBorder: boxBorder(),
                  //                     contentPadding: EdgeInsets.all(12),
                  //                     hintText: "Search a user",
                  //                   )),
                  //                   popupTitle: Container(
                  //                     height: 50,
                  //                     decoration: BoxDecoration(
                  //                       color:
                  //                           Theme.of(context).primaryColorDark,
                  //                       borderRadius: BorderRadius.only(
                  //                         topLeft: Radius.circular(20),
                  //                         topRight: Radius.circular(20),
                  //                       ),
                  //                     ),
                  //                     child: Center(
                  //                       child: Text(
                  //                         'Created By',
                  //                         style: TextStyle(
                  //                             fontSize: screenWidth / 20,
                  //                             color: Colors.white),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   popupItemBuilder:
                  //                       (context, item, isSelected) {
                  //                     return Container(
                  //                       padding: EdgeInsets.symmetric(
                  //                           horizontal: 15.0, vertical: 10.0),
                  //                       child: Text(item!,
                  //                           style: TextStyle(
                  //                               fontSize: screenWidth / 22)),
                  //                     );
                  //                   },
                  //                   popupShape: RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.only(
                  //                       topLeft: Radius.circular(24),
                  //                       topRight: Radius.circular(24),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ])),
                  //         ])),
                  // Container(
                  //     padding: padding(),
                  //     child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "Users",
                  //             style: TextStyle(
                  //                 fontSize: 18, color: Colors.black54),
                  //           ),
                  //           SizedBox(height: screenHeight / 70),
                  //           Container(
                  //               width: screenWidth * 0.92,
                  //               height: screenHeight / 17,
                  //               child: Stack(children: [
                  //                 DropdownSearch<String?>(
                  //                   mode: Mode.BOTTOM_SHEET,
                  //                   items: teamBloc.userObjForDropDown,
                  //                   onChanged: print,
                  //                   onSaved: (selection) {
                  //                     if (selection == null) {
                  //                       teamBloc.currentEditTeam![
                  //                           "assigned_users"] = "";
                  //                     } else {
                  //                       teamBloc.currentEditTeam![
                  //                           "assigned_users"] = selection;
                  //                     }
                  //                   },
                  //                   selectedItem: teamBloc
                  //                       .currentEditTeam!['assigned_users '],
                  //                   showSearchBox: true,
                  //                   showSelectedItems: false,
                  //                   showClearButton: false,
                  //                   searchFieldProps: TextFieldProps(
                  //                       decoration: InputDecoration(
                  //                     border: boxBorder(),
                  //                     enabledBorder: boxBorder(),
                  //                     focusedErrorBorder: boxBorder(),
                  //                     focusedBorder: boxBorder(),
                  //                     errorBorder: boxBorder(),
                  //                     contentPadding: EdgeInsets.all(12),
                  //                     hintText: "Search a Source",
                  //                   )),
                  //                   popupTitle: Container(
                  //                     height: 50,
                  //                     decoration: BoxDecoration(
                  //                       color:
                  //                           Theme.of(context).primaryColorDark,
                  //                       borderRadius: BorderRadius.only(
                  //                         topLeft: Radius.circular(20),
                  //                         topRight: Radius.circular(20),
                  //                       ),
                  //                     ),
                  //                     child: Center(
                  //                       child: Text(
                  //                         'assigned users',
                  //                         style: TextStyle(
                  //                             fontSize: screenWidth / 20,
                  //                             color: Colors.white),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   popupItemBuilder:
                  //                       (context, item, isSelected) {
                  //                     return Container(
                  //                       padding: EdgeInsets.symmetric(
                  //                           horizontal: 15.0, vertical: 10.0),
                  //                       child: Text(item!,
                  //                           style: TextStyle(
                  //                               fontSize: screenWidth / 22)),
                  //                     );
                  //                   },
                  //                   popupShape: RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.only(
                  //                       topLeft: Radius.circular(24),
                  //                       topRight: Radius.circular(24),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ])),
                  //         ])),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isFilter = false;
                            });
                            FocusScope.of(context).unfocus();
                            setState(() {
                              _filtersFormData = {
                                "team_name": "",
                                "created_by": [],
                                "assigned_users": []
                              };
                            });
                            _submitForm();
                          },
                          child: Text(
                            "Reset",
                            style: TextStyle(fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 20.0),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            onPrimary: Colors.white,
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _submitForm();
                          },
                          child: Text(
                            "Filter",
                            style: TextStyle(fontSize: screenWidth / 24),
                          )),
                    ],
                  )
                ],
              ),
            ))
        : Container();
  }

  Widget _buildTeamsList() {
    return _teams.length != 0
        ? Container(
            padding: EdgeInsets.all(10.0),
            child: ListView.builder(
                itemCount: _teams.length,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        teamBloc.currentTeam = _teams[index];
                        Navigator.pushNamed(context, '/team_details');
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
                                        _teams[index]
                                            .name!
                                            .capitalizeFirstofEach(),
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.blueGrey[800],
                                            fontWeight: FontWeight.w600,
                                            fontSize: screenWidth / 24)),
                                  ),
                                  Text(_teams[index].createdOn!,
                                      style: TextStyle(
                                          color: Colors.blueGrey[800],
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenWidth / 24))
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
                                    child: Row(
                                      children: [
                                        Container(
                                          child: ProfilePicViewWidget(_teams[
                                                  index]
                                              .users!
                                              .map((assignedUser) =>
                                                  assignedUser.profileUrl == ""
                                                      ? assignedUser
                                                          .firstName![0].inCaps
                                                      : assignedUser.profileUrl)
                                              .toList()),
                                        ),
                                      ],
                                    ),
                                  ),
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
                : 'No Teams Found.'),
          );
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
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, "/more_options");
                                },
                                child: Icon(Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: screenWidth / 18)),
                            SizedBox(width: 10.0),
                            Text(
                              'Teams',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth / 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          child: Row(
                            children: [
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
                        )
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
                        ),
                      ],
                    ),
                  ),
                  _buildFilterBlock(),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: _buildTeamsList(),
                    ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            teamBloc.currentEditTeamId = "";
            if (teamBloc.teams.length == 0) {
              showAlertDialog(context);
            } else {
              Navigator.pushNamed(context, '/team_create');
            }
          },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
        ),
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
              "You don't have any team, Please create team first.",
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
                    Navigator.pushNamed(context, "/team_create");
                  },
                  child: Text("Create")),
            ],
          );
        });
  }
}
