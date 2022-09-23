import 'dart:io';

import 'package:bottle_crm/bloc/team_bloc.dart';
import 'package:bottle_crm/bloc/user_bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import '../../../utils/utils.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

class CreateTeam extends StatefulWidget {
  CreateTeam();
  @override
  State createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  quill.QuillController _controller = quill.QuillController.basic();
  final GlobalKey<FormState> _teamFormKey = GlobalKey<FormState>();
  var _currentTabIndex = 0;
  Map _errors = {};
  bool _isLoading = false;
  File? file = File('');
  List _teamFormKeys = [
    'name',
    'assign_users',
  ];

  List _deskey = [
    'description',
  ];

  @override
  void initState() {
    super.initState();
  }

  buildTopBar() {
    if (_currentTabIndex == 0) {
      return SwipeDetector(
          onSwipeLeft: (offset) {
            if (_teamFormKey.currentState != null) {
              _teamFormKey.currentState!.save();
            }
            setState(() {
              _currentTabIndex = 1;
            });
          },
          child: buildTeamBlock());
    } else if (_currentTabIndex == 1) {
      return SwipeDetector(
          onSwipeRight: (offset) {
            setState(() {
              _currentTabIndex = 0;
            });
          },
          child: buildDescriptionBlock());
    }
  }

  Positioned buildReqField() {
    return Positioned(
      child: Container(
        width: 3.0,
        color: Colors.red,
      ),
    );
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

  Widget buildTeamBlock() {
    return Container(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
                key: _teamFormKey,
                child: Container(
                    child: Column(children: [
                  Container(
                      padding: padding(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(bottom: 5.0),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Team Name ',
                                    style: buildLableTextStyle(),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '* ',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: screenWidth / 25,
                                              fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                )),
                            SizedBox(height: screenHeight / 70),
                            Container(
                              width: screenWidth * 0.92,
                              child: TextFormField(
                                initialValue: teamBloc.currentEditTeam!['name'],
                                cursorWidth: 3.0,
                                decoration: new InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 10.0),
                                  enabledBorder: buildBorder(Colors.black54),
                                  focusedErrorBorder:
                                      buildBorder(Colors.black54),
                                  focusedBorder: buildBorder(Colors.black54),
                                  errorBorder: buildBorder(Colors.black54),
                                  border: buildBorder(Colors.black54),
                                ),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field is required.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  teamBloc.currentEditTeam!['name'] = value;
                                },
                              ),
                            ),
                            _errors['name'] != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _errors['name'][0],
                                      style: TextStyle(
                                          color: Colors.red[700],
                                          fontSize: 12.0),
                                    ),
                                  )
                                : Container(),
                          ])),
                  Container(
                      padding: padding(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(bottom: 5.0),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Assign Users ',
                                    style: buildLableTextStyle(),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '* ',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: screenWidth / 25,
                                              fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                )),
                            SizedBox(height: screenHeight / 70),
                            Container(
                                child: MultiSelectFormField(
                                    border: boxBorder(),
                                    fillColor: Colors.white,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select one or more options';
                                      }
                                      return null;
                                    },
                                    dataSource: userBloc.usersObjForDropdown,
                                    textField: 'name',
                                    valueField: 'id',
                                    okButtonLabel: 'OK',
                                    chipLabelStyle:
                                        TextStyle(color: Colors.black),
                                    cancelButtonLabel: 'CANCEL',
                                    // required: true,
                                    hintWidget: Text(
                                      "Please choose one or more",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    title: Text(
                                      "Assigned to",
                                    ),
                                    initialValue: teamBloc
                                        .currentEditTeam!['assign_users'],
                                    onSaved: (value) {
                                      if (value == null) return;
                                      teamBloc.currentEditTeam![
                                          'assign_users'] = value;
                                    }))
                          ])),
                ])))));
  }

  Widget buildDescriptionBlock() {
    return Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Column(
          children: [
            quill.QuillToolbar.basic(
              controller: _controller,
              showAlignmentButtons: true,
              showBackgroundColorButton: false,
              showCameraButton: false,
              showImageButton: false,
              showVideoButton: false,
              showDividers: false,
              showColorButton: false,
              showUndo: false,
              showRedo: false,
              showQuote: false,
              showClearFormat: false,
              showIndent: false,
              showLink: false,
              showCodeBlock: false,
              showInlineCode: false,
              showListCheck: false,
              showJustifyAlignment: false,
              showHeaderStyle: false,
            ),
            Expanded(
              child: Container(
                child: quill.QuillEditor.basic(
                    controller: _controller,
                    readOnly: !_isLoading ? false : true),
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(73, 128, 255, 1.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(children: [
                        GestureDetector(
                            child: new Icon(Icons.arrow_back_ios,
                                size: screenWidth / 18, color: Colors.white),
                            onTap: () {
                              teamBloc.cancelCurrentEditTeam();
                              teamBloc.currentEditTeamId = "";
                              FocusScope.of(context).unfocus();
                              Navigator.pop(context, true);
                            }),
                        SizedBox(width: 10.0),
                        Text(
                          teamBloc.currentEditTeamId == ""
                              ? 'Add Team'
                              : "Edit Team",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth / 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_teamFormKey.currentState != null)
                          _teamFormKey.currentState!.save();
                        FocusScope.of(context).unfocus();
                        // teamBloc.currentEditTeam!['description'] =
                        //     _controller.document.toPlainText();
                        if (!_isLoading) _submitForm();
                      },
                      child: Container(
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
                            Icon(Icons.check,
                                color: Theme.of(context).primaryColor,
                                size: screenWidth / 18),
                            Container(
                              child: Text(
                                "Save",
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
                padding: EdgeInsets.symmetric(horizontal: 23.0),
                height: screenHeight * 0.06,
                decoration: BoxDecoration(
                  color: bottomNavBarSelectedTextColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        width: screenWidth * 0.15,
                        child: Text(
                          'Team',
                          style: TextStyle(
                              color: _currentTabIndex == 0
                                  ? Colors.white
                                  : Theme.of(context).secondaryHeaderColor,
                              fontSize: screenWidth / 25,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_teamFormKey.currentState != null)
                          _teamFormKey.currentState!.save();
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
                        width: screenWidth * 0.25,
                        child: Text(
                          'Description',
                          style: TextStyle(
                              color: _currentTabIndex == 1
                                  ? Colors.white
                                  : Theme.of(context).secondaryHeaderColor,
                              fontSize: screenWidth / 25,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.white,
                    child: buildTopBar(),
                  ),
                  new Align(
                    child: _isLoading
                        ? Container(
                            color: Colors.white,
                            width: screenWidth,
                            height: screenHeight * 0.9,
                            child: new Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: new Center(
                                    child: new CircularProgressIndicator())),
                          )
                        : Container(),
                    alignment: FractionalOffset.center,
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  _submitForm() async {
    setState(() {
      _errors = {};
      _isLoading = true;
    });
    _currentTabIndex = 0;
    await Future.delayed(const Duration(seconds: 1), () async {});
    if (_teamFormKey.currentState != null) {
      if (!_teamFormKey.currentState!.validate()) {
        setState(() {
          _isLoading = false;
        });
        showToaster('⚠ Please enter required fields.', context);
        return;
      }
      _teamFormKey.currentState!.save();
      setState(() {
        _currentTabIndex = 1;
      });
      await Future.delayed(const Duration(seconds: 1), () async {});
      // if (_controller.getPlainText().isEmpty) {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   showToaster('⚠ Please enter Description.', context);
      //   return;
      // }

      Map _result = {};
      if (teamBloc.currentEditTeamId != null &&
          teamBloc.currentEditTeamId != "") {
        _result = await teamBloc.editTeam();
      } else {
        _result = await teamBloc.createTeam();
      }
      setState(() {
        _isLoading = false;
      });
      if (_result['error'] == false) {
        setState(() {
          _errors = {};
        });
        teamBloc.cancelCurrentEditTeam();
        teamBloc.currentEditTeamId = "";
        showToaster(_result['message'], context);
        teamBloc.teams.clear();
        await teamBloc.fetchTeams();
        await FirebaseAnalytics.instance.logEvent(name: "team_Created");
        Navigator.pushReplacementNamed(context, '/teams_list');
      } else if (_result['error'] == true) {
        setState(() {
          _errors = _result['errors'];
        });
        for (var key in _teamFormKeys) {
          if (_errors.containsKey(key)) {
            setState(() {
              _currentTabIndex = 0;
            });
            showToaster(_errors[key][0], context);
            return;
          }
        }
        for (var key in _deskey) {
          if (_errors.containsKey(key)) {
            setState(() {
              _currentTabIndex = 1;
            });
            showToaster(_errors[key][0], context);
            return;
          }
        }
      } else {
        setState(() {
          _errors = {};
        });
        showErrorMessage(context, _result['message'].toString());
      }
    }
  }

  showErrorMessage(BuildContext context, msg) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Alert'),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _submitForm();
                    },
                    child: Text('RETRY'))
              ],
            ));
  }
}
