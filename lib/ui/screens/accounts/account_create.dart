import 'dart:io';
import 'package:bottle_crm/bloc/contact_bloc.dart';
import 'package:bottle_crm/bloc/lead_bloc.dart';
import 'package:bottle_crm/bloc/team_bloc.dart';
import 'package:bottle_crm/bloc/user_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:bottle_crm/bloc/account_bloc.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:textfield_tags/textfield_tags.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount();
  @override
  State createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  int _currentTabIndex = 0;
  quill.QuillController _controller = quill.QuillController.basic();
  GlobalKey<FormState> _accountFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _addressFormKey = GlobalKey<FormState>();
  TextEditingController fileNameController = new TextEditingController();
  TextfieldTagsController _tagsController = TextfieldTagsController();

  List _accountFormKeys = [
    "name",
    "phone",
    "email",
    "contacts",
    "website",
    "lead",
    "assigned_to",
    "status",
    "account_attachment",
    "tags"
  ];
  List _addressFormKeys = [
    "billing_address_line",
    "billing_street",
    "billing_city",
    "billing_state",
    "billing_postcode",
    "billing_country"
  ];
  Map _errors = {};
  bool _isLoading = false;
  File? file = File('');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  OutlineInputBorder boxBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(width: 1, color: Colors.black45),
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

  _filePicker() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      file = File(result.files[0].path!);
      var _filename = file!.path.toString();
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
              if (_accountFormKey.currentState != null)
                _accountFormKey.currentState!.save();
              _currentTabIndex = 1;
            });
          },
          child: buildaccountBlock());
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
              _currentTabIndex = 1;
            });
          },
          child: buildDescriptionBlock());
    }
  }

  Widget buildaccountBlock() {
    return Container(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
                key: _accountFormKey,
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
                                    text: 'Name ',
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
                                    accountBloc.currentEditAccount['name'],
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
                                  accountBloc.currentEditAccount['name'] =
                                      value;
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
                                    text: 'Website ',
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
                                      accountBloc.currentEditAccount['website'],
                                  decoration: new InputDecoration(
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 10.0),
                                    hintText: 'https://www.bottlecrm.com',
                                    enabledBorder: buildBorder(Colors.black54),
                                    focusedErrorBorder:
                                        buildBorder(Colors.black54),
                                    focusedBorder: buildBorder(Colors.black54),
                                    errorBorder: buildBorder(Colors.black54),
                                    border: buildBorder(Colors.black54),
                                  ),
                                  keyboardType: TextInputType.url,
                                  onSaved: (value) {
                                    accountBloc.currentEditAccount['website'] =
                                        value;
                                  }),
                            ),
                            _errors['website'] != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _errors['website'][0],
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
                                    text: 'Phone Number ',
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
                                    accountBloc.currentEditAccount['phone'],
                                decoration: new InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 10.0),
                                  enabledBorder: buildBorder(Colors.black54),
                                  focusedErrorBorder:
                                      buildBorder(Colors.black54),
                                  focusedBorder: buildBorder(Colors.black54),
                                  errorBorder: buildBorder(Colors.black54),
                                  border: buildBorder(Colors.black54),
                                  hintText: '+91XXXXXXXXXX',
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field is required.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  accountBloc.currentEditAccount['phone'] =
                                      value;
                                },
                              ),
                            ),
                            _errors['phone'] != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _errors['phone'][0],
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
                                    text: 'Email Address ',
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
                                    accountBloc.currentEditAccount['email'],
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
                                keyboardType: TextInputType.emailAddress,
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
                                  accountBloc.currentEditAccount['email'] =
                                      value;
                                },
                              ),
                            ),
                            _errors['email'] != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _errors['email'][0],
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
                              "Leads ",
                              style: buildLableTextStyle(),
                            ),
                            SizedBox(height: screenHeight / 70),
                            Container(
                              height: 48.0,
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: DropdownSearch<String?>(
                                items: leadBloc.leadsTitles,
                                onChanged: print,
                                onSaved: (selection) {
                                  if (selection == null) {
                                    accountBloc.currentEditAccount['lead'] = "";
                                  } else {
                                    accountBloc.currentEditAccount['lead'] =
                                        selection;
                                  }
                                },
                                selectedItem:
                                    accountBloc.currentEditAccount['lead'],
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
                                    hintText: "Search a Lead",
                                  )),
                                  showSearchBox: true,
                                  showSelectedItems: false,
                                ),
                              ),
                            )
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
                              child: Text(
                                "Teams",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black54),
                              ),
                            ),
                            SizedBox(height: screenHeight / 70),
                            Container(
                              child: MultiSelectFormField(
                                border: boxBorder(),
                                fillColor: Colors.white,
                                dataSource: teamBloc.teamsObjForDropdown,
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
                                  "teams",
                                ),
                                initialValue:
                                    accountBloc.currentEditAccount['teams'],
                                // validator: (value) {
                                //   if (value.length == 0) {
                                //     return 'Please select one or more options';
                                //   }
                                //   return null;
                                // },
                                onSaved: (value) {
                                  if (value == null) return;
                                  accountBloc.currentEditAccount['teams'] =
                                      value;
                                },
                              ),
                            ),
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
                                    accountBloc.currentEditAccount['contacts'],
                                onSaved: (value) {
                                  if (value == null) return;
                                  accountBloc.currentEditAccount['contacts'] =
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
                              "Assigned To",
                              style: buildLableTextStyle(),
                            ),
                            SizedBox(height: screenHeight / 70),
                            Container(
                              child: MultiSelectFormField(
                                  border: boxBorder(),
                                  fillColor: Colors.white,
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
                                    "users",
                                  ),
                                  initialValue: accountBloc
                                      .currentEditAccount['assigned_to'],
                                  onSaved: (value) {
                                    if (value == null) return;
                                    accountBloc
                                            .currentEditAccount['assigned_to'] =
                                        value;
                                  }),
                            ),
                          ])),
                  Container(
                      padding: padding(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Status",
                              style: buildLableTextStyle(),
                            ),
                            SizedBox(height: screenHeight / 70),
                            Container(
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                    border: boxBorder(),
                                    contentPadding: EdgeInsets.all(12.0)),
                                style: TextStyle(color: Colors.black),
                                hint: Text('select Status'),
                                value: accountBloc.currentEditAccount['status'],
                                onChanged: (value) {
                                  accountBloc.currentEditAccount['status'] =
                                      value;
                                },
                                items: ['open', 'close'].map((item) {
                                  return DropdownMenuItem(
                                    child: new Text(item),
                                    value: item,
                                  );
                                }).toList(),
                              ),
                            ),
                          ])),
                  Container(
                      padding: padding(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Attachment",
                              style: buildLableTextStyle(),
                            ),
                            SizedBox(height: screenHeight / 70),
                            Container(
                              width: screenWidth * 0.92,
                              child: TextFormField(
                                controller: fileNameController,
                                readOnly: true,
                                decoration: new InputDecoration(
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 5.0),
                                    enabledBorder: buildBorder(Colors.black54),
                                    focusedErrorBorder:
                                        buildBorder(Colors.black54),
                                    focusedBorder: buildBorder(Colors.black54),
                                    errorBorder: buildBorder(Colors.black54),
                                    border: buildBorder(Colors.black54),
                                    suffixIcon: IconButton(
                                        onPressed: _filePicker,
                                        icon: Icon(Icons.upload))),
                              ),
                            ),
                          ])),
                  Container(
                      padding: padding(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tags",
                              style: buildLableTextStyle(),
                            ),
                            SizedBox(height: screenHeight / 70),
                            TextFieldTags(
                              textfieldTagsController: _tagsController,
                              initialTags: accountBloc.tags,
                              letterCase: LetterCase.normal,
                              textSeparators: [],
                              validator: (String tag) {
                                if (tag == 'php') {
                                  return 'No, please just no';
                                } else if (_tagsController.getTags!
                                    .contains(tag)) {
                                  return 'you already entered that';
                                }
                                return null;
                              },
                              inputfieldBuilder: (context, tec, fn, error,
                                  onChanged, onSubmitted) {
                                return ((context, sc, tags, onTagDelete) {
                                  return TextField(
                                    controller: tec,
                                    focusNode: fn,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      border: buildBorder(Colors.black54),
                                      focusedBorder:
                                          buildBorder(Colors.black54),
                                      errorBorder: buildBorder(Colors.black54),
                                      helperStyle: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      hintText: _tagsController.hasTags
                                          ? ''
                                          : "Enter tag...",
                                      prefixIconConstraints: BoxConstraints(
                                          maxWidth: screenWidth * 0.74),
                                      prefixIcon: tags.isNotEmpty
                                          ? SingleChildScrollView(
                                              controller: sc,
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                  children:
                                                      tags.map((String tag) {
                                                return Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(20.0),
                                                    ),
                                                    color: Color.fromARGB(
                                                        255, 74, 137, 92),
                                                  ),
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 5.0),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 5.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        child: Text(
                                                          tag,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        onTap: () {
                                                          //print("$tag selected");
                                                        },
                                                      ),
                                                      const SizedBox(
                                                          width: 4.0),
                                                      InkWell(
                                                        child: const Icon(
                                                          Icons.cancel,
                                                          size: 14.0,
                                                          color: Color.fromARGB(
                                                              255,
                                                              233,
                                                              233,
                                                              233),
                                                        ),
                                                        onTap: () {
                                                          onTagDelete(tag);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }).toList()),
                                            )
                                          : null,
                                    ),
                                    onChanged: onChanged,
                                    onSubmitted: onSubmitted,
                                  );
                                });
                              },
                            ),
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
                                text: 'Billing Address Line ',
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
                            initialValue: accountBloc
                                .currentEditAccount['billing_address_line'],
                            decoration: new InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
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
                              accountBloc.currentEditAccount[
                                  'billing_address_line'] = value;
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
                                text: 'Street ',
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
                            initialValue: accountBloc
                                .currentEditAccount['billing_street'],
                            decoration: new InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
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
                              accountBloc.currentEditAccount['billing_street'] =
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
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(bottom: 5.0),
                            child: RichText(
                              text: TextSpan(
                                text: 'Postal Code ',
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
                            initialValue: accountBloc
                                .currentEditAccount['billing_postcode'],
                            decoration: new InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This field is required.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              accountBloc
                                      .currentEditAccount['billing_postcode'] =
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
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(bottom: 5.0),
                            child: RichText(
                              text: TextSpan(
                                text: 'City ',
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
                                accountBloc.currentEditAccount['billing_city'],
                            decoration: new InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
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
                              accountBloc.currentEditAccount['billing_city'] =
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
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(bottom: 5.0),
                            child: RichText(
                              text: TextSpan(
                                text: 'State ',
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
                                accountBloc.currentEditAccount['billing_state'],
                            decoration: new InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
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
                              accountBloc.currentEditAccount['billing_state'] =
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
                                accountBloc
                                    .currentEditAccount['billing_country'] = "";
                              } else {
                                accountBloc
                                        .currentEditAccount['billing_country'] =
                                    selection;
                              }
                            },
                            selectedItem: accountBloc
                                .currentEditAccount['billing_country'],
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
                                hintText: "Search a Country",
                              )),
                              showSearchBox: true,
                              showSelectedItems: false,
                            ),
                          ),
                        )
                        // Container(
                        //     width: screenWidth * 0.92,
                        //     child: DropdownSearch<String?>(
                        //       mode: Mode.BOTTOM_SHEET,
                        //       items: leadBloc.countries,
                        //       onChanged: print,
                        //       selectedItem: accountBloc
                        //           .currentEditAccount['billing_country'],
                        //       showSearchBox: true,
                        //       showSelectedItems: false,
                        //       showClearButton: false,
                        //       searchFieldProps: TextFieldProps(
                        //           decoration: InputDecoration(
                        //         border: boxBorder(),
                        //         enabledBorder: boxBorder(),
                        //         focusedErrorBorder: boxBorder(),
                        //         focusedBorder: boxBorder(),
                        //         errorBorder: boxBorder(),
                        //         contentPadding: EdgeInsets.all(12),
                        //         hintText: "Search a Country",
                        //       )),
                        //       popupTitle: Container(
                        //         decoration: BoxDecoration(
                        //           color: Theme.of(context).primaryColorDark,
                        //           borderRadius: BorderRadius.only(
                        //             topLeft: Radius.circular(20),
                        //             topRight: Radius.circular(20),
                        //           ),
                        //         ),
                        //         child: Center(
                        //           child: Text(
                        //             'County',
                        //             style: TextStyle(
                        //                 fontSize: screenWidth / 20,
                        //                 color: Colors.white),
                        //           ),
                        //         ),
                        //       ),
                        //       popupItemBuilder: (context, item, isSelected) {
                        //         return Container(
                        //           padding: EdgeInsets.symmetric(
                        //               horizontal: 15.0, vertical: 10.0),
                        //           child: Text(item!,
                        //               style: TextStyle(
                        //                   fontSize: screenWidth / 22)),
                        //         );
                        //       },
                        //       popupShape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.only(
                        //           topLeft: Radius.circular(24),
                        //           topRight: Radius.circular(24),
                        //         ),
                        //       ),
                        //       validator: (value) {
                        //         if (value == null || value.isEmpty) {
                        //           return 'This field is required.';
                        //         }
                        //         return null;
                        //       },
                        //       onSaved: (newValue) {
                        //         accountBloc
                        //                 .currentEditAccount['billing_country'] =
                        //             newValue;
                        //       },
                        //     )),
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
              //showDividers: false,
              showColorButton: false,
              // showUndo: false,
              //showRedo: false,
              showQuote: false,
              showClearFormat: false,
              showIndent: false,
              showLink: false,
              showCodeBlock: false,
              showInlineCode: false,
              showListCheck: false,
              //showJustifyAlignment: false,
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
                              accountBloc.resetAccountFields();
                              accountBloc.currentEditAccountId = "";
                              FocusScope.of(context).unfocus();
                              Navigator.pop(context, true);
                            }),
                        SizedBox(width: 10.0),
                        Text(
                          accountBloc.currentEditAccountId == ""
                              ? 'Add account'
                              : 'Edit account',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth / 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_accountFormKey.currentState != null)
                          _accountFormKey.currentState!.save();
                        accountBloc.currentEditAccount['tags'] =
                            _tagsController.getTags;
                        if (_addressFormKey.currentState != null)
                          _addressFormKey.currentState!.save();
                        FocusScope.of(context).unfocus();
                        accountBloc.currentEditAccount['description'] =
                            _controller.document.toPlainText();
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
                      child: !_isLoading
                          ? Container(
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
                                'Account',
                                style: TextStyle(
                                    color: _currentTabIndex == 0
                                        ? Colors.white
                                        : Theme.of(context)
                                            .secondaryHeaderColor,
                                    fontSize: screenWidth / 25,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          : Container(),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_accountFormKey.currentState != null)
                          _accountFormKey.currentState!.save();
                        setState(() {
                          _currentTabIndex = 1;
                        });
                      },
                      child: !_isLoading
                          ? Container(
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
                            )
                          : Container(),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_accountFormKey.currentState != null)
                          _accountFormKey.currentState!.save();
                        if (_addressFormKey.currentState != null)
                          _addressFormKey.currentState!.save();
                        setState(() {
                          _currentTabIndex = 2;
                        });
                      },
                      child: !_isLoading
                          ? Container(
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
                            )
                          : Container(),
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
    if (_accountFormKey.currentState != null) {
      if (!_accountFormKey.currentState!.validate()) {
        setState(() {
          _isLoading = false;
        });
        showToaster('⚠ Please enter required fields.', context);
        return;
      }
      _accountFormKey.currentState!.save();
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
        if (accountBloc.currentEditAccountId != null &&
            accountBloc.currentEditAccountId != "") {
          _result = await accountBloc.editAccount();
        } else {
          _result = await accountBloc.createAccount(file: file);
        }
        setState(() {
          _isLoading = false;
        });
        if (_result['error'] == false) {
          setState(() {
            _errors = {};
          });
          accountBloc.resetAccountFields();
          accountBloc.currentEditAccountId = "";
          showToaster(_result['message'], context);
          accountBloc.openAccounts.clear();
          accountBloc.closedAccounts.clear();
          await accountBloc.fetchAccounts();
          await FirebaseAnalytics.instance.logEvent(name: "Account_Created");
          Navigator.pushReplacementNamed(context, '/accounts_list');
        } else if (_result['error'] == true) {
          setState(() {
            _errors = _result['errors'];
          });
          for (var key in _accountFormKeys) {
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
          showErrorMessage(context, _result['message'].toString());
        }
      }
    }
  }

  showErrorMessage(BuildContext context, String msg) {
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
