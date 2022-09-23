import 'package:bottle_crm/bloc/contact_bloc.dart';
import 'package:bottle_crm/bloc/lead_bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:bottle_crm/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

class CreateContact extends StatefulWidget {
  CreateContact();
  @override
  State createState() => _CreateContactState();
}

class _CreateContactState extends State<CreateContact> {
  var _currentTabIndex = 0;
  quill.QuillController _controller = quill.QuillController.basic();
  final GlobalKey<FormState> _contactFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _addressFormKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  TextEditingController fileNameController = new TextEditingController();
  DateTime initialDate = DateTime.now();
  Map _errors = {};
  bool _isLoading = false;
  String? selectedDate = "";
  File file = new File('');
  List _contactFormKeys = [
    "salutation",
    "first_name",
    "last_name",
    "date_of_birth",
    "organization",
    "title",
    "primary_email",
    "mobile_number",
    "secondary_number",
    "department",
    "language",
    "do_not_call"
  ];
  List _addressFormKeys = [
    "address_line ",
    "street",
    "city",
    "state",
    "pincode",
    "country"
  ];
  @override
  void initState() {
    _dateController.text = DateFormat("yyyy-MM-dd")
        .format(DateFormat("yyyy-MM-dd").parse(DateTime.now().toString()));
    super.initState();
  }

  OutlineInputBorder boxBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(width: 1, color: Colors.black45),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
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

  _filePicker() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      file = File(result.files[0].path!);
      var _filename = file.path.toString();
      var split = _filename.split('/');
      Map<int, String> values = {
        for (int i = 0; i < split.length; i++) i: split[i]
      };
      setState(() {
        fileNameController.text = values[7].toString();
      });
    } else {}
  }

  buildTopBar() {
    if (_currentTabIndex == 0) {
      return SwipeDetector(
          onSwipeLeft: (offset) {
            setState(() {
              if (_contactFormKey.currentState != null)
                _contactFormKey.currentState!.save();
              _currentTabIndex = 1;
            });
          },
          child: buildContactBlock());
    } else if (_currentTabIndex == 1) {
      return SwipeDetector(
          onSwipeLeft: (offset) {
            setState(() {
              if (_addressFormKey.currentState != null)
                _addressFormKey.currentState!.save();
              _currentTabIndex = 2;
            });
          },
          onSwipeRight: (offset) {
            setState(() {
              if (_addressFormKey.currentState != null)
                _addressFormKey.currentState!.save();
              _currentTabIndex = 0;
            });
          },
          child: buildAddressBlock());
    } else if (_currentTabIndex == 2) {
      return SwipeDetector(
          onSwipeRight: (offset) {
            setState(() {
              if (_addressFormKey.currentState != null)
                _addressFormKey.currentState!.save();
              _currentTabIndex = 1;
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

  Widget buildContactBlock() {
    return Container(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
                key: _contactFormKey,
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
                                    text: 'Salutation ',
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
                                initialValue: contactBloc
                                    .currentEditContact['salutation'],
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
                                  contactBloc.currentEditContact['salutation'] =
                                      value;
                                },
                              ),
                            ),
                            _errors['salutation'] != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _errors['salutation'][0],
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
                                    text: 'First Name ',
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
                                initialValue: contactBloc
                                    .currentEditContact['first_name'],
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
                                  contactBloc.currentEditContact['first_name'] =
                                      value;
                                },
                              ),
                            ),
                            _errors['first_name'] != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _errors['first_name'][0],
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
                                    text: 'Last Name ',
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
                                    contactBloc.currentEditContact['last_name'],
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
                                  contactBloc.currentEditContact['last_name'] =
                                      value;
                                },
                              ),
                            ),
                            _errors['last_name'] != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _errors['last_name'][0],
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
                              "Phone Number",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
                            SizedBox(height: screenHeight / 70),
                            Container(
                              width: screenWidth * 0.92,
                              child: TextFormField(
                                initialValue: contactBloc
                                    .currentEditContact['mobile_number'],
                                decoration: new InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 10.0),
                                  enabledBorder: buildBorder(Colors.black54),
                                  focusedErrorBorder:
                                      buildBorder(Colors.black54),
                                  focusedBorder: buildBorder(Colors.black54),
                                  errorBorder: buildBorder(Colors.black54),
                                  border: buildBorder(Colors.black54),
                                  hintText: '+91 XXXXXXXXXX',
                                ),
                                keyboardType: TextInputType.phone,
                                onSaved: (value) {
                                  contactBloc
                                          .currentEditContact['mobile_number'] =
                                      value;
                                },
                              ),
                            ),
                            _errors['mobile_number'] != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _errors['mobile_number'][0],
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
                              "Email ",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
                            SizedBox(height: screenHeight / 70),
                            Container(
                              width: screenWidth * 0.92,
                              child: TextFormField(
                                initialValue: contactBloc
                                    .currentEditContact['primary_email'],
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
                                  if (value.isNotEmpty &&
                                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value)) {
                                    return 'Enter valid email address.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  contactBloc
                                          .currentEditContact['primary_email'] =
                                      value;
                                },
                              ),
                            ),
                            _errors['primary_email'] != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _errors['primary_email'][0],
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
                              "Date of birth",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
                            SizedBox(height: screenHeight / 70),
                            Container(
                              width: screenWidth * 0.92,
                              child: TextFormField(
                                  // initialValue: contactBloc
                                  //     .currentEditContact['date_of_birth'],
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
                                  keyboardType: TextInputType.text),
                            ),
                          ])),
                  Container(
                      padding: padding(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Organization",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
                            SizedBox(height: screenHeight / 70),
                            Container(
                              width: screenWidth * 0.92,
                              child: TextFormField(
                                initialValue: contactBloc
                                    .currentEditContact['organization'],
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
                                onSaved: (value) {
                                  contactBloc
                                          .currentEditContact['organization'] =
                                      value;
                                },
                              ),
                            ),
                            _errors['organization'] != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _errors['organization'][0],
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
                                    text: 'Title ',
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
                                    contactBloc.currentEditContact['title'],
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
                                  contactBloc.currentEditContact['title'] =
                                      value;
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
                            Text(
                              "Department",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
                            SizedBox(height: screenHeight / 70),
                            Container(
                              width: screenWidth * 0.92,
                              child: TextFormField(
                                  initialValue: contactBloc
                                      .currentEditContact['department'],
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
                                  onSaved: (value) {
                                    contactBloc
                                            .currentEditContact['department'] =
                                        value;
                                  }),
                            ),
                            _errors['department'] != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _errors['department'][0],
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
                              "Language",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
                            SizedBox(height: screenHeight / 70),
                            Container(
                              width: screenWidth * 0.92,
                              child: TextFormField(
                                  initialValue: contactBloc
                                      .currentEditContact['language'],
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
                                  onSaved: (value) {
                                    contactBloc.currentEditContact['language'] =
                                        value;
                                  }),
                            ),
                            _errors['language'] != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _errors['language'][0],
                                      style: TextStyle(
                                          color: Colors.red[700],
                                          fontSize: 12.0),
                                    ),
                                  )
                                : Container(),
                          ])),
                  Container(
                      padding: padding(),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Do not call",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black54),
                              ),
                            ),
                            Container(
                                alignment: Alignment.centerRight,
                                child: Switch(
                                  value: contactBloc
                                      .currentEditContact['do_not_call'],
                                  onChanged: (value) {
                                    setState(() {
                                      contactBloc.currentEditContact[
                                          'do_not_call'] = value;
                                    });
                                  },
                                  activeColor: Colors.blue,
                                  focusColor: Colors.blue,
                                )),
                          ])),
                ])))));
  }

  Widget buildAddressBlock() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
            key: _addressFormKey,
            child: Container(
                child: Column(children: [
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
                                text: 'Address Line ',
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
                            initialValue: contactBloc
                                .currentEditContact['address']['address_line'],
                            decoration: new InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 5.0),
                              enabledBorder: buildBorder(Colors.black54),
                              focusedErrorBorder: buildBorder(Colors.black54),
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
                              contactBloc.currentEditContact['address']
                                  ['address_line'] = value;
                            },
                          ),
                        ),
                        _errors['address_line'] != null
                            ? Container(
                                margin: EdgeInsets.only(top: 5.0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _errors['address']['address_line'][0],
                                  style: TextStyle(
                                      color: Colors.red[700], fontSize: 12.0),
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
                                text: 'Street ',
                                style: buildLableTextStyle(),
                              ),
                            )),
                        SizedBox(height: screenHeight / 70),
                        Container(
                          width: screenWidth * 0.92,
                          child: TextFormField(
                            initialValue: contactBloc
                                .currentEditContact['address']['street'],
                            decoration: new InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 5.0),
                              enabledBorder: buildBorder(Colors.black54),
                              focusedErrorBorder: buildBorder(Colors.black54),
                              focusedBorder: buildBorder(Colors.black54),
                              errorBorder: buildBorder(Colors.black54),
                              border: buildBorder(Colors.black54),
                            ),
                            keyboardType: TextInputType.text,
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'This field is required.';
                            //   }
                            //   return null;
                            // },
                            onSaved: (value) {
                              contactBloc.currentEditContact['address']
                                  ['street'] = value;
                            },
                          ),
                        ),
                        _errors['street'] != null
                            ? Container(
                                margin: EdgeInsets.only(top: 5.0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _errors['address']['street'][0],
                                  style: TextStyle(
                                      color: Colors.red[700], fontSize: 12.0),
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
                                text: 'City ',
                                style: buildLableTextStyle(),
                              ),
                            )),
                        SizedBox(height: screenHeight / 70),
                        Container(
                          width: screenWidth * 0.92,
                          child: TextFormField(
                            initialValue: contactBloc
                                .currentEditContact['address']['city'],
                            decoration: new InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 5.0),
                              enabledBorder: buildBorder(Colors.black54),
                              focusedErrorBorder: buildBorder(Colors.black54),
                              focusedBorder: buildBorder(Colors.black54),
                              errorBorder: buildBorder(Colors.black54),
                              border: buildBorder(Colors.black54),
                            ),
                            keyboardType: TextInputType.text,
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'This field is required.';
                            //   }
                            //   return null;
                            // },
                            onSaved: (value) {
                              contactBloc.currentEditContact['address']
                                  ['city'] = value;
                            },
                          ),
                        ),
                        _errors['city'] != null
                            ? Container(
                                margin: EdgeInsets.only(top: 5.0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _errors['address']['city'][0],
                                  style: TextStyle(
                                      color: Colors.red[700], fontSize: 12.0),
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
                                text: 'State ',
                                style: buildLableTextStyle(),
                              ),
                            )),
                        SizedBox(height: screenHeight / 70),
                        Container(
                          width: screenWidth * 0.92,
                          child: TextFormField(
                            initialValue: contactBloc
                                .currentEditContact['address']['state'],
                            decoration: new InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 5.0),
                              enabledBorder: buildBorder(Colors.black54),
                              focusedErrorBorder: buildBorder(Colors.black54),
                              focusedBorder: buildBorder(Colors.black54),
                              errorBorder: buildBorder(Colors.black54),
                              border: buildBorder(Colors.black54),
                            ),
                            keyboardType: TextInputType.text,
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'This field is required.';
                            //   }
                            //   return null;
                            // },
                            onSaved: (value) {
                              contactBloc.currentEditContact['address']
                                  ['state'] = value;
                            },
                          ),
                        ),
                        _errors['state'] != null
                            ? Container(
                                margin: EdgeInsets.only(top: 5.0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _errors['address']['state'][0],
                                  style: TextStyle(
                                      color: Colors.red[700], fontSize: 12.0),
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
                                text: 'Pincode ',
                                style: buildLableTextStyle(),
                              ),
                            )),
                        SizedBox(height: screenHeight / 70),
                        Container(
                          width: screenWidth * 0.92,
                          child: TextFormField(
                            initialValue: contactBloc
                                .currentEditContact['address']['pincode'],
                            decoration: new InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 5.0),
                              enabledBorder: buildBorder(Colors.black54),
                              focusedErrorBorder: buildBorder(Colors.black54),
                              focusedBorder: buildBorder(Colors.black54),
                              errorBorder: buildBorder(Colors.black54),
                              border: buildBorder(Colors.black54),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'This field is required.';
                            //   }
                            //   return null;
                            // },
                            onSaved: (value) {
                              contactBloc.currentEditContact['address']
                                  ['pincode'] = value;
                            },
                          ),
                        ),
                        _errors['pincode'] != null
                            ? Container(
                                margin: EdgeInsets.only(top: 5.0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _errors['address']['pincode'][0],
                                  style: TextStyle(
                                      color: Colors.red[700], fontSize: 12.0),
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
                                text: 'Country ',
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
                            items: leadBloc.countries,
                            onChanged: print,
                            onSaved: (selection) {
                              if (selection == null) {
                                contactBloc.currentEditContact['address']
                                    ['country'] = "";
                              } else {
                                contactBloc.currentEditContact['address']
                                    ['country'] = selection;
                              }
                            },
                            selectedItem: contactBloc
                                .currentEditContact['address']['country'],
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
                                hintText: "Search a Counry",
                              )),
                              showSearchBox: true,
                              showSelectedItems: false,
                            ),
                          ),
                        ),
                      ]))
            ]))));
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
                              contactBloc.cancelCurrentEditContact();
                              contactBloc.currentEditContactId = "";
                              FocusScope.of(context).unfocus();
                              Navigator.pop(context, true);
                            }),
                        SizedBox(width: 10.0),
                        Text(
                          contactBloc.currentEditContactId == ""
                              ? 'Add Contact'
                              : "Edit Contact",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth / 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_contactFormKey.currentState != null)
                          _contactFormKey.currentState!.save();
                        if (_addressFormKey.currentState != null)
                          _addressFormKey.currentState!.save();
                        FocusScope.of(context).unfocus();
                        // contactBloc.currentEditContact['description'] =
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
              !_isLoading
                  ? Container(
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
                              if (_addressFormKey.currentState != null)
                                _addressFormKey.currentState!.save();
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
                              width: screenWidth * 0.20,
                              child: Text(
                                'Contact',
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
                              if (_contactFormKey.currentState != null)
                                _contactFormKey.currentState!.save();
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
                              width: screenWidth * 0.20,
                              child: Text(
                                'Address',
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
                              if (_contactFormKey.currentState != null)
                                _contactFormKey.currentState!.save();
                              if (_addressFormKey.currentState != null)
                                _addressFormKey.currentState!.save();
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
                              width: screenWidth * 0.25,
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
                    )
                  : Container(),
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
    if (_contactFormKey.currentState != null) {
      if (!_contactFormKey.currentState!.validate()) {
        setState(() {
          _isLoading = false;
        });
        showToaster('⚠ Please enter required fields.', context);
        return;
      }
      _contactFormKey.currentState!.save();
      setState(() {
        _currentTabIndex = 1;
      });
      await Future.delayed(const Duration(seconds: 1), () async {});
      if (_addressFormKey.currentState != null) {
        if (!_addressFormKey.currentState!.validate()) {
          setState(() {
            _isLoading = false;
          });
          showToaster('⚠ Please enter required fields.', context);
          return;
        }
        _addressFormKey.currentState!.save();
        Map _result = {};
        if (contactBloc.currentEditContactId != null &&
            contactBloc.currentEditContactId != "") {
          _result = await contactBloc.editContact();
        } else {
          _result = await contactBloc.createContact(file: file);
        }
        setState(() {
          _isLoading = false;
        });
        if (_result['error'] == false) {
          setState(() {
            _errors = {};
          });
          contactBloc.cancelCurrentEditContact();
          contactBloc.currentEditContactId = "";
          showToaster(_result['message'], context);
          contactBloc.contacts.clear();
          contactBloc.offset = "";
          await contactBloc.fetchContacts();
          await FirebaseAnalytics.instance.logEvent(name: "Contact_Created");
          Navigator.pushReplacementNamed(context, '/contacts_list');
        } else if (_result['error'] == true) {
          setState(() {
            _errors = _result['errors']['contact_errors'];
          });
          for (var key in _contactFormKeys) {
            if (_errors.containsKey(key)) {
              setState(() {
                _currentTabIndex = 0;
              });
              showToaster(_errors[key][0], context);
              return;
            }
          }
          for (var key in _addressFormKeys) {
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
          // showErrorMessage(context, _result['message'].toString());
        }
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
