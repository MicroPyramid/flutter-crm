import 'dart:io';

import 'package:bottle_crm/bloc/case_bloc.dart';
import 'package:bottle_crm/bloc/contact_bloc.dart';
import 'package:bottle_crm/bloc/lead_bloc.dart';
import 'package:bottle_crm/bloc/task_bloc.dart';
import 'package:bottle_crm/bloc/team_bloc.dart';
import 'package:bottle_crm/bloc/user_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'package:bottle_crm/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

import '../../../utils/utils.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class CreateTask extends StatefulWidget {
  CreateTask();
  @override
  State createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  quill.QuillController _controller = quill.QuillController.basic();
  final GlobalKey<FormState> _taskFormKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  TextEditingController fileNameController = new TextEditingController();
  String? selectedDate = "";
  DateTime initialDate = DateTime.now();
  var _currentTabIndex = 0;
  Map _errors = {};
  bool _isLoading = false;
  File? file = File('');
  List _taskFormKeys = [
    'title',
    'status',
    'priority',
    'account',
    'contacts',
    'closed_on',
    'assigned_to',
    'teams',
  ];

  @override
  void initState() {
    _dateController.text = DateFormat("yyyy-MM-dd")
        .format(DateFormat("yyyy-MM-dd").parse(DateTime.now().toString()));
    super.initState();
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2023),
    );
    if (selected != null && selected.toString() != selectedDate)
      setState(() {
        initialDate = selected;
        selectedDate = DateFormat("yyyy-MM-dd")
            .format(DateFormat("yyyy-MM-dd").parse(selected.toString()));
        _dateController.text = DateFormat("yyyy-MM-dd")
            .format(DateFormat("yyyy-MM-dd").parse(selected.toString()));
      });
  }

  buildTopBar() {
    if (_currentTabIndex == 0) {
      return buildTaskBlock();
    } else if (_currentTabIndex == 1) {
      return buildDescriptionBlock();
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

  Widget buildTaskBlock() {
    return Container(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
                key: _taskFormKey,
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
                                    text: 'Task Title ',
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
                                initialValue:
                                    taskBloc.currentEditTask!['title'],
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
                                  taskBloc.currentEditTask!['title'] = value;
                                },
                              ),
                            ),
                            _errors['title'] != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _errors['title'][0],
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
                                    text: 'Account ',
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
                              height: 48.0,
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: DropdownSearch<String?>(
                                items: taskBloc.accountsObjforDropDown,
                                onChanged: print,
                                onSaved: (selection) {
                                  if (selection == null) {
                                    taskBloc.currentEditTask!['account'] = "";
                                  } else {
                                    taskBloc.currentEditTask!['account'] =
                                        selection;
                                  }
                                },
                                selectedItem:
                                    taskBloc.currentEditTask!['account'],
                                popupProps: PopupProps.bottomSheet(
                                  itemBuilder: (context, item, isSelected) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 10.0),
                                      child: Text(item!,
                                          style: TextStyle(
                                              fontSize: screenWidth / 22)),
                                    );
                                  },
                                  constraints: BoxConstraints(maxHeight: 400),
                                  searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                    border: boxBorder(),
                                    enabledBorder: boxBorder(),
                                    focusedErrorBorder: boxBorder(),
                                    focusedBorder: boxBorder(),
                                    errorBorder: boxBorder(),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: "Search a account",
                                  )),
                                  showSearchBox: true,
                                  showSelectedItems: false,
                                ),
                              ),
                            ),
                            _errors['account'] != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _errors['account'][0],
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
                            Text(
                              "Contacts",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
                            SizedBox(height: screenHeight / 70),
                            Container(
                              child: MultiSelectFormField(
                                border: boxBorder(),
                                fillColor: Colors.white,
                                dataSource: contactBloc.contactsObjForDropdown,
                                textField: 'name',
                                valueField: 'id',
                                okButtonLabel: 'OK',
                                chipLabelStyle: TextStyle(color: Colors.black),
                                cancelButtonLabel: 'CANCEL',
                                hintWidget: Text(
                                  "Please choose one or more",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                title: Text(
                                  "Contacts",
                                ),
                                initialValue:
                                    taskBloc.currentEditTask!['contacts'],
                                onSaved: (value) {
                                  if (value == null) return;
                                  taskBloc.currentEditTask!['contacts'] = value;
                                },
                              ),
                            ),
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
                                    text: 'Status ',
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
                              height: 48.0,
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: DropdownSearch<String?>(
                                items: taskBloc.status!,
                                onChanged: print,
                                onSaved: (selection) {
                                  if (selection == null) {
                                    taskBloc.currentEditTask!['status'] = "";
                                  } else {
                                    taskBloc.currentEditTask!['status'] =
                                        selection;
                                  }
                                },
                                selectedItem:
                                    taskBloc.currentEditTask!['status'],
                                popupProps: PopupProps.bottomSheet(
                                  itemBuilder: (context, item, isSelected) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 10.0),
                                      child: Text(item!,
                                          style: TextStyle(
                                              fontSize: screenWidth / 22)),
                                    );
                                  },
                                  constraints: BoxConstraints(maxHeight: 400),
                                  searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                    border: boxBorder(),
                                    enabledBorder: boxBorder(),
                                    focusedErrorBorder: boxBorder(),
                                    focusedBorder: boxBorder(),
                                    errorBorder: boxBorder(),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: "Search a Status",
                                  )),
                                  showSearchBox: true,
                                  showSelectedItems: false,
                                ),
                              ),
                            ),
                            _errors['status'] != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _errors['status'][0],
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
                                    text: 'Priority ',
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
                              height: 48.0,
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: DropdownSearch<String?>(
                                items: taskBloc.priorities!,
                                onChanged: print,
                                onSaved: (selection) {
                                  if (selection == null) {
                                    taskBloc.currentEditTask!['priority'] = "";
                                  } else {
                                    taskBloc.currentEditTask!['priority'] =
                                        selection;
                                  }
                                },
                                selectedItem:
                                    taskBloc.currentEditTask!['priority'],
                                popupProps: PopupProps.bottomSheet(
                                  itemBuilder: (context, item, isSelected) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 10.0),
                                      child: Text(item!,
                                          style: TextStyle(
                                              fontSize: screenWidth / 22)),
                                    );
                                  },
                                  constraints: BoxConstraints(maxHeight: 400),
                                  searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                    border: boxBorder(),
                                    enabledBorder: boxBorder(),
                                    focusedErrorBorder: boxBorder(),
                                    focusedBorder: boxBorder(),
                                    errorBorder: boxBorder(),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: "Search a Priority",
                                  )),
                                  showSearchBox: true,
                                  showSelectedItems: false,
                                ),
                              ),
                            ),
                            _errors['priority'] != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _errors['priority'][0],
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
                          verticalDirection: VerticalDirection.down,
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(bottom: 5.0),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Due Date ',
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
                                controller: _dateController,
                                readOnly: true,
                                decoration: new InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 10.0),
                                  enabledBorder: buildBorder(Colors.black54),
                                  focusedErrorBorder:
                                      buildBorder(Colors.black54),
                                  focusedBorder: buildBorder(Colors.black54),
                                  errorBorder: buildBorder(Colors.black54),
                                  border: buildBorder(Colors.black54),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      _selectDate(context);
                                    },
                                    icon: Icon(Icons.calendar_today_outlined),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field is required.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  taskBloc.currentEditTask!['due_date'] = value;
                                },
                              ),
                            ),
                            _errors['due_date'] != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _errors['due_date'][0],
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
                            Text(
                              "Assigned to",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
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
                                    hintWidget: Text(
                                      "Please choose one or more",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    title: Text(
                                      "Assigned to",
                                    ),
                                    initialValue: taskBloc
                                        .currentEditTask!['assigned_to'],
                                    onSaved: (value) {
                                      if (value == null) return;
                                      taskBloc.currentEditTask!['assigned_to'] =
                                          value;
                                    }))
                          ])),
                  Container(
                      padding: padding(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Teams",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
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
                                    dataSource: teamBloc.teamsObjForDropdown,
                                    textField: 'name',
                                    valueField: 'id',
                                    okButtonLabel: 'OK',
                                    chipLabelStyle:
                                        TextStyle(color: Colors.black),
                                    cancelButtonLabel: 'CANCEL',
                                    hintWidget: Text(
                                      "Please choose one or more",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    title: Text(
                                      "teams",
                                    ),
                                    initialValue:
                                        taskBloc.currentEditTask!['teams'],
                                    onSaved: (value) {
                                      if (value == null) return;
                                      taskBloc.currentEditTask!['teams'] =
                                          value;
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
        child: SizedBox()
        // Column(
        //   children: [
        //     quill.QuillToolbar.basic(
        //       controller: _controller,
        //       showAlignmentButtons: true,
        //       showBackgroundColorButton: false,
        //       showCameraButton: false,
        //       showImageButton: false,
        //       showVideoButton: false,
        //       showDividers: false,
        //       showColorButton: false,
        //       showUndo: false,
        //       showRedo: false,
        //       showQuote: false,
        //       showClearFormat: false,
        //       showIndent: false,
        //       showLink: false,
        //       showCodeBlock: false,
        //       showInlineCode: false,
        //       showListCheck: false,
        //     ),
        //     Expanded(
        //       child: Container(
        //         child: quill.QuillEditor.basic(
        //           controller: _controller,
        //           readOnly: true,
        //         ),
        //       ),
        //     )
        //   ],
        // )
        );
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
                              taskBloc.cancelCurrentEditTask();
                              taskBloc.currentEditTaskId = "";
                              FocusScope.of(context).unfocus();
                              Navigator.pop(context, true);
                            }),
                        SizedBox(width: 10.0),
                        Text(
                          taskBloc.currentEditTaskId == ""
                              ? 'Add Task'
                              : "Edit Task",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth / 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_taskFormKey.currentState != null)
                          _taskFormKey.currentState!.save();
                        FocusScope.of(context).unfocus();
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          'Task',
                          style: TextStyle(
                              color: _currentTabIndex == 0
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
    if (_taskFormKey.currentState != null) {
      if (!_taskFormKey.currentState!.validate()) {
        setState(() {
          _isLoading = false;
        });
        showToaster('⚠ Please enter required fields.', context);
        return;
      }
      _taskFormKey.currentState!.save();
      // setState(() {
      //   _currentTabIndex = 1;
      // });
      await Future.delayed(const Duration(seconds: 1), () async {});

      Map _result = {};
      if (taskBloc.currentEditTaskId != null &&
          taskBloc.currentEditTaskId != "") {
        _result = await taskBloc.editTask();
      } else {
        _result = await taskBloc.createTask();
      }
      setState(() {
        _isLoading = false;
      });
      if (_result['error'] == false) {
        setState(() {
          _errors = {};
        });
        taskBloc.cancelCurrentEditTask();
        taskBloc.currentEditTaskId = "";
        showToaster(_result['message'], context);
        taskBloc.tasks.clear();
        await taskBloc.fetchTasks();
        await FirebaseAnalytics.instance.logEvent(name: "task_Created");
        Navigator.pushReplacementNamed(context, '/tasks_list');
      } else if (_result['error'] == true) {
        setState(() {
          _errors = _result['errors'];
        });
        for (var key in _taskFormKeys) {
          if (_errors.containsKey(key)) {
            setState(() {
              _currentTabIndex = 0;
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
