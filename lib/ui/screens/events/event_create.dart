import 'dart:io';
import 'package:bottle_crm/bloc/account_bloc.dart';
import 'package:bottle_crm/bloc/contact_bloc.dart';
import 'package:bottle_crm/bloc/dashboard_bloc.dart';
import 'package:bottle_crm/bloc/event_bloc.dart';
import 'package:bottle_crm/bloc/team_bloc.dart';
import 'package:bottle_crm/bloc/user_bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'package:bottle_crm/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import '../../../utils/utils.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class CreateEvent extends StatefulWidget {
  CreateEvent();
  @override
  State createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  quill.QuillController _controller = quill.QuillController.basic();
  final GlobalKey<FormState> _eventFormKey = GlobalKey<FormState>();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  TextEditingController fileNameController = new TextEditingController();
  String? selectedDate = "";
  DateTime? initialDate = DateTime.now();
  var _currentTabIndex = 0;
  Map _errors = {};
  bool _isLoading = false;
  File file = new File('');
  List _eventFormKeys = [
    "name",
    "event_type",
    "contacts",
    "start_date",
    "start_time",
    "end_date",
    "end_time",
    "description",
    "teams",
    "assigned_to",
    "recurring_day",
  ];

  TimeOfDay startSelectedTime = TimeOfDay.now();
  TimeOfDay endSelectedTime = TimeOfDay.now();

  @override
  void initState() {
    _startDateController.text = DateFormat("yyyy-MM-dd")
        .format(DateFormat("yyyy-MM-dd").parse(DateTime.now().toString()));
    _endDateController.text = DateFormat("yyyy-MM-dd")
        .format(DateFormat("yyyy-MM-dd").parse(DateTime.now().toString()));
    
    _startTimeController.text = "00:00:00";
    _endTimeController.text = "00:00:00";
    super.initState();
  }

  _StartSelectDate(BuildContext context) async {
    showTimePicker(context: context, initialTime: TimeOfDay.now());
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: initialDate!,
      firstDate: DateTime(1965),
      lastDate: DateTime.now().add(Duration(days: 730)),
    );
    if (selected != null && selected.toString() != selectedDate)
      setState(() {
        initialDate = selected;
        selectedDate = DateFormat("yyyy-MM-dd")
            .format(DateFormat("yyyy-MM-dd").parse(selected.toString()));
        _startDateController.text = DateFormat("yyyy-MM-dd")
            .format(DateFormat("yyyy-MM-dd").parse(selected.toString()));
      });
  }

  _endSelectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: initialDate!,
      firstDate: DateTime(1965),
      lastDate: DateTime.now().add(Duration(days: 730)),
    );
    if (selected != null && selected.toString() != selectedDate)
      setState(() {
        initialDate = selected;
        selectedDate = DateFormat("yyyy-MM-dd")
            .format(DateFormat("yyyy-MM-dd").parse(selected.toString()));
        _endDateController.text = DateFormat("yyyy-MM-dd")
            .format(DateFormat("yyyy-MM-dd").parse(selected.toString()));
      });
  }

  buildTopBar() {
    if (_currentTabIndex == 0) {
      return SwipeDetector(
          onSwipeLeft: (offset) {
            setState(() {
              if (_eventFormKey.currentState != null)
                _eventFormKey.currentState!.save();
              _currentTabIndex = 1;
            });
          },
          child: _buildEventBlock());
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

  OutlineInputBorder buildBorder(Color color) {
    return OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(3.0)));
  }

  OutlineInputBorder boxBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(width: 1, color: Colors.black45),
    );
  }

  EdgeInsets padding() {
    return EdgeInsets.symmetric(
        horizontal: screenWidth / 30, vertical: screenHeight / 80);
  }

  Widget _buildEventBlock() {
    return Container(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
                key: _eventFormKey,
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
                                    text: 'Event Name ',
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
                                    eventBloc.currentEditEvent['name'],
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
                                  eventBloc.currentEditEvent['name'] = value;
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
                                    text: 'Event Type ',
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
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                    border: boxBorder(),
                                    contentPadding: EdgeInsets.all(12.0)),
                                style: TextStyle(color: Colors.black),
                                hint: Text('select Event Type'),
                                value: eventBloc.currentEditEvent['event_type'],
                                onChanged: (value) {
                                  accountBloc.currentEditAccount['event_type'] =
                                      value;
                                },
                                items:
                                    ['Recurring', 'Non-Recurring'].map((item) {
                                  return DropdownMenuItem(
                                    child: new Text(item),
                                    value: item,
                                  );
                                }).toList(),
                              ),
                            ),
                            _errors['event_type'] != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _errors['event_type'][0],
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(bottom: 5.0),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Contacts ',
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
                                    eventBloc.currentEditEvent['contacts'],
                                onSaved: (value) {
                                  if (value == null) return;
                                  eventBloc.currentEditEvent['contacts'] =
                                      value;
                                },
                              ),
                            ),
                            _errors['event_type'] != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _errors['event_type'][0],
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
                              "Start Date ",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
                            SizedBox(height: screenHeight / 70),
                            Container(
                              width: screenWidth * 0.92,
                              child: TextFormField(
                                controller: _startDateController,
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
                                      _StartSelectDate(context);
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
                                  print(value);
                                  eventBloc.currentEditEvent['start_date'] =
                                      value;
                                },
                              ),
                            ),
                          ])),
                  Container(
                      padding: padding(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Start Time ",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
                            SizedBox(height: screenHeight / 70),
                            Container(
                              width: screenWidth * 0.92,
                              child: TextFormField(
                                controller: _startTimeController,
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
                                    onPressed: () async {
                                      final TimeOfDay? picked_s =
                                          await showTimePicker(
                                              context: context,
                                              initialTime: startSelectedTime,
                                              builder: (BuildContext? context,
                                                  Widget? child) {
                                                return MediaQuery(
                                                  data: MediaQuery.of(context!)
                                                      .copyWith(
                                                          alwaysUse24HourFormat:
                                                              true),
                                                  child: child!,
                                                );
                                              });

                                      if (picked_s != null &&
                                          picked_s != startSelectedTime)
                                        setState(() {
                                          startSelectedTime = picked_s;
                                          DateTime parsedTime = DateFormat.jm()
                                              .parse(picked_s
                                                  .format(context)
                                                  .toString());
                                          _startTimeController.text =
                                              DateFormat('HH:mm:ss')
                                                  .format(parsedTime);
                                        });
                                    },
                                    icon: Icon(Icons.punch_clock_outlined),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field is required.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  print(value);
                                  eventBloc.currentEditEvent['start_time'] =
                                      value;
                                },
                              ),
                            ),
                          ])),
                          Container(
                      padding: padding(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "End Date ",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
                            SizedBox(height: screenHeight / 70),
                            Container(
                              width: screenWidth * 0.92,
                              child: TextFormField(
                                controller: _endDateController,
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
                                      _endSelectDate(context);
                                    },
                                    icon: Icon(Icons.calendar_today_outlined),
                                  ),
                                ),
                                // keyboardType: TextInputType.text
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field is required.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  print(value);
                                  eventBloc.currentEditEvent['end_date'] =
                                      value;
                                },
                              ),
                            ),
                          ])),
                  Container(
                      padding: padding(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "End Time ",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
                            SizedBox(height: screenHeight / 70),
                            Container(
                              width: screenWidth * 0.92,
                              child: TextFormField(
                                controller: _endTimeController,
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
                                    onPressed: () async {
                                      final TimeOfDay? picked_s =
                                          await showTimePicker(
                                              context: context,
                                              initialTime: endSelectedTime,
                                              builder: (BuildContext? context,
                                                  Widget? child) {
                                                return MediaQuery(
                                                  data: MediaQuery.of(context!)
                                                      .copyWith(
                                                          alwaysUse24HourFormat:
                                                              true),
                                                  child: child!,
                                                );
                                              });

                                      if (picked_s != null &&
                                          picked_s != endSelectedTime)
                                        setState(() {
                                          endSelectedTime = picked_s;
                                          DateTime parsedTime = DateFormat.jm()
                                              .parse(picked_s
                                                  .format(context)
                                                  .toString());
                                          _endTimeController.text =
                                              DateFormat('HH:mm:ss')
                                                  .format(parsedTime);
                                        });
                                    },
                                    icon: Icon(Icons.punch_clock)
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field is required.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  eventBloc.currentEditEvent['end_time'] =
                                      value;
                                },
                              ),
                            ),
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
                                    // required: true,
                                    hintWidget: Text(
                                      "Please choose one or more",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    title: Text(
                                      "teams",
                                    ),
                                    initialValue:
                                        eventBloc.currentEditEvent['teams'],
                                    onSaved: (value) {
                                      if (value == null) return;
                                      eventBloc.currentEditEvent['teams'] =
                                          value;
                                    }))
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
                                    // required: true,
                                    hintWidget: Text(
                                      "Please choose one or more",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    title: Text(
                                      "Users",
                                    ),
                                    initialValue: eventBloc
                                        .currentEditEvent['assigned_to'],
                                    onSaved: (value) {
                                      if (value == null) return;
                                      eventBloc
                                              .currentEditEvent['assigned_to'] =
                                          value;
                                    }))
                          ])),
                  Container(
                      padding: padding(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Recurring Days",
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
                                    dataSource: eventBloc.recurringDays,
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
                                      "Recurring Days",
                                    ),
                                    initialValue: eventBloc
                                        .currentEditEvent['recurring_days'],
                                    onSaved: (value) {
                                      if (value == null) return;
                                      eventBloc.currentEditEvent[
                                          'recurring_days'] = value;
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
                              dashboardBloc.fetchDashboardDetails();
                              eventBloc.cancelCurrentEditEvent();
                              eventBloc.currentEditEventId = "";
                              Navigator.pop(context, true);
                            }),
                        SizedBox(width: 10.0),
                        Text(
                          eventBloc.currentEditEventId == ""
                              ? 'Add Event'
                              : "Edit Event",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth / 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_eventFormKey.currentState != null)
                          _eventFormKey.currentState!.save();
                        FocusScope.of(context).unfocus();
                        eventBloc.currentEditEvent['description'] =
                            _controller.document.toPlainText();
                        print(eventBloc.currentEditEvent['description']);
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
              !_isLoading
                  ? Container(
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
                              width: screenWidth * 0.22,
                              child: Text(
                                'Event',
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
                              if (_eventFormKey.currentState != null)
                                _eventFormKey.currentState!.save();
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
              Expanded(
                  child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: Colors.white, child: _buildEventBlock()),
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
    if (_eventFormKey.currentState != null) {
      if (!_eventFormKey.currentState!.validate()) {
        setState(() {
          _isLoading = false;
        });
        showToaster('⚠ Please enter required fields.', context);
        return;
      }
      _eventFormKey.currentState!.save();
      await Future.delayed(const Duration(seconds: 1), () async {});

      Map _result = {};
      if (eventBloc.currentEditEventId != null &&
          eventBloc.currentEditEventId != "") {
        _result = await eventBloc.editEvent();
      } else {
        _result = await eventBloc.createEvent();
      }
      setState(() {
        _isLoading = false;
      });
      if (_result['error'] == false) {
        setState(() {
          _errors = {};
        });
        eventBloc.cancelCurrentEditEvent();
        eventBloc.currentEditEventId = "";
        showToaster(_result['message'], context);
        eventBloc.events.clear();
        eventBloc.offset = "";
        await eventBloc.fetchEvents();
        eventBloc.events;
        await FirebaseAnalytics.instance.logEvent(name: "Event_Created");
        Navigator.pushReplacementNamed(context, '/events_list');
      } else if (_result['error'] == true) {
        setState(() {
          _errors = _result['errors'];
        });
        for (var key in _eventFormKeys) {
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
