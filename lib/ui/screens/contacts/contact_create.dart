import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crm/bloc/contact_bloc.dart';
import 'package:flutter_crm/bloc/contact_bloc.dart';
import 'package:flutter_crm/bloc/lead_bloc.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class CreateContact extends StatefulWidget {
  CreateContact();
  @override
  State createState() => _CreateContactState();
}

class _CreateContactState extends State<CreateContact> {
  final GlobalKey<FormState> _createContactFormKey = GlobalKey<FormState>();
  FilePickerResult result;
  PlatformFile file;
  List _myActivities;
  String _selectedStatus = 'Open';
  List countiresForDropDown = leadBloc.countries;

  FocusNode _focusErr;
  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _emailAddressFocusNode = FocusNode();
  Map _errors;

  @override
  void initState() {
    super.initState();
  }

  focusError() {
    setState(() {
      FocusManager.instance.primaryFocus.unfocus();
      Focus.of(context).requestFocus(_focusErr);
    });
  }

  void showErrorMessage(BuildContext context, String errorContent) {
    Flushbar(
      backgroundColor: Colors.white,
      messageText: Text(errorContent,
          style:
              GoogleFonts.robotoSlab(textStyle: TextStyle(color: Colors.red))),
      isDismissible: false,
      mainButton: FlatButton(
        child: Text('TRY AGAIN',
            style: GoogleFonts.robotoSlab(
                textStyle: TextStyle(color: Theme.of(context).accentColor))),
        onPressed: () {
          Navigator.of(context).pop(true);
          _saveForm();
        },
      ),
      duration: Duration(seconds: 10),
    )..show(context);
  }

  _saveForm() async {
    _focusErr = null;
    setState(() {
      _errors = null;
    });

    if (!_createContactFormKey.currentState.validate()) {
      focusError();
      return;
    }
    _createContactFormKey.currentState.save();
    Map _result;

    if (contactBloc.currentEditContactId == null) {
      _result = await contactBloc.createContact();
    } else {
      _result = await contactBloc.editContact();
    }

    if (_result['error'] == false) {
      setState(() {
        _errors = null;
      });
      showToast(_result['message']);
      Navigator.pushReplacementNamed(context, '/sales_contacts');
    } else if (_result['error'] == true) {
      setState(() {
        _errors = _result['contact_errors'];
      });

      if (_errors['first_name'] != null && _focusErr == null) {
        _focusErr = _firstNameFocusNode;
        focusError();
      }

      if (_errors['last_name'] != null && _focusErr == null) {
        _focusErr = _lastNameFocusNode;
        focusError();
      }

      if (_errors['phone'] != null && _focusErr == null) {
        _focusErr = _phoneFocusNode;
        focusError();
      }

      if (_errors['email_address'] != null && _focusErr == null) {
        _focusErr = _emailAddressFocusNode;
        focusError();
      }
    } else {
      setState(() {
        _errors = null;
      });

      showErrorMessage(context, "Something went wrong.");
    }
  }

  Widget _buildForm() {
    return Container(
        child: Form(
            key: _createContactFormKey,
            child: Column(children: [
              Container(
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'First Name',
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth / 25)),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '*',
                                  style: GoogleFonts.robotoSlab(
                                      textStyle: TextStyle(color: Colors.red))),
                              TextSpan(
                                  text: ' :', style: GoogleFonts.robotoSlab())
                            ],
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: TextFormField(
                        focusNode: _firstNameFocusNode,
                        maxLines: 1,
                        initialValue:
                            contactBloc.currentEditContact['first_name'],
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12.0),
                            enabledBorder: boxBorder(),
                            focusedErrorBorder: boxBorder(),
                            focusedBorder: boxBorder(),
                            errorBorder: boxBorder(),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Enter First Name",
                            errorStyle: GoogleFonts.robotoSlab(),
                            hintStyle: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(fontSize: 14.0))),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is required.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          contactBloc.currentEditContact['first_name'] = value;
                        },
                      ),
                    ),
                    Divider(color: Colors.grey)
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Last Name',
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth / 25)),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '*',
                                  style: GoogleFonts.robotoSlab(
                                      textStyle: TextStyle(color: Colors.red))),
                              TextSpan(
                                  text: ' :', style: GoogleFonts.robotoSlab())
                            ],
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: TextFormField(
                        focusNode: _lastNameFocusNode,
                        maxLines: 1,
                        initialValue:
                            contactBloc.currentEditContact['last_name'],
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12.0),
                            enabledBorder: boxBorder(),
                            focusedErrorBorder: boxBorder(),
                            focusedBorder: boxBorder(),
                            errorBorder: boxBorder(),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter Last Name',
                            errorStyle: GoogleFonts.robotoSlab(),
                            hintStyle: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(fontSize: 14.0))),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is required.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          contactBloc.currentEditContact['last_name'] = value;
                        },
                      ),
                    ),
                    Divider(color: Colors.grey)
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Phone',
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth / 25)),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '*',
                                  style: GoogleFonts.robotoSlab(
                                      textStyle: TextStyle(color: Colors.red))),
                              TextSpan(
                                  text: ' :', style: GoogleFonts.robotoSlab())
                            ],
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: TextFormField(
                        focusNode: _phoneFocusNode,
                        maxLines: 1,
                        initialValue: contactBloc.currentEditContact['phone'],
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12.0),
                            enabledBorder: boxBorder(),
                            focusedErrorBorder: boxBorder(),
                            focusedBorder: boxBorder(),
                            errorBorder: boxBorder(),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Enter Phone Number",
                            errorStyle: GoogleFonts.robotoSlab(),
                            hintStyle: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(fontSize: 14.0))),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is required.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          contactBloc.currentEditContact['phone'] = value;
                        },
                      ),
                    ),
                    Divider(color: Colors.grey)
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Email Address',
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth / 25)),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '*',
                                  style: GoogleFonts.robotoSlab(
                                      textStyle: TextStyle(color: Colors.red))),
                              TextSpan(
                                  text: ' :', style: GoogleFonts.robotoSlab())
                            ],
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: TextFormField(
                        focusNode: _emailAddressFocusNode,
                        maxLines: 1,
                        initialValue: contactBloc.currentEditContact['email'],
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12.0),
                            enabledBorder: boxBorder(),
                            focusedErrorBorder: boxBorder(),
                            focusedBorder: boxBorder(),
                            errorBorder: boxBorder(),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Enter Email Address",
                            errorStyle: GoogleFonts.robotoSlab(),
                            hintStyle: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(fontSize: 14.0))),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is required.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          contactBloc.currentEditContact['email'] = value;
                        },
                      ),
                    ),
                    Divider(color: Colors.grey)
                  ],
                ),
              ),

              Container(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'Teams :',
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth / 25)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: MultiSelectFormField(
                        border: boxBorder(),
                        fillColor: Colors.white,
                        autovalidate: false,
                        dataSource: contactBloc.teamsObjForDropdown,
                        textField: 'name',
                        valueField: 'id',
                        okButtonLabel: 'OK',
                        chipLabelStyle: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(color: Colors.black)),
                        dialogTextStyle: GoogleFonts.robotoSlab(),
                        cancelButtonLabel: 'CANCEL',
                        hintWidget: Text(
                          "Please choose one or more",
                          style: GoogleFonts.robotoSlab(),
                        ),
                        title: Text(
                          "Teams",
                          style: GoogleFonts.robotoSlab(),
                        ),
                        initialValue: contactBloc.currentEditContact['teams'],
                        onSaved: (value) {
                          if (value == null) return;
                          contactBloc.currentEditContact['teams'] = value;
                        },
                      ),
                    ),
                    Divider(color: Colors.grey)
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'Users :',
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth / 25)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: MultiSelectFormField(
                        border: boxBorder(),
                        enabled: false,
                        fillColor: Colors.grey[300],
                        autovalidate: false,
                        dataSource: leadBloc.usersObjForDropdown,
                        textField: 'name',
                        valueField: 'id',
                        okButtonLabel: 'OK',
                        chipLabelStyle: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(color: Colors.black)),
                        dialogTextStyle: GoogleFonts.robotoSlab(),
                        cancelButtonLabel: 'CANCEL',
                        hintWidget: Text(
                          "Please choose one or more",
                          style: GoogleFonts.robotoSlab(),
                        ),
                        title: Text(
                          "Users",
                          style: GoogleFonts.robotoSlab(),
                        ),
                        initialValue: [],
                        onSaved: (value) {
                          if (value == null) return;
                          setState(() {
                            _myActivities = value;
                          });
                        },
                      ),
                    ),
                    Divider(color: Colors.grey)
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'Assign Users :',
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth / 25)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: MultiSelectFormField(
                        border: boxBorder(),
                        fillColor: Colors.white,
                        autovalidate: false,
                        dataSource: leadBloc.usersObjForDropdown,
                        textField: 'name',
                        valueField: 'id',
                        okButtonLabel: 'OK',
                        chipLabelStyle: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(color: Colors.black)),
                        dialogTextStyle: GoogleFonts.robotoSlab(),
                        cancelButtonLabel: 'CANCEL',
                        // required: true,
                        hintWidget: Text(
                          "Please choose one or more",
                          style: GoogleFonts.robotoSlab(),
                        ),
                        title: Text(
                          "Assigned To",
                          style: GoogleFonts.robotoSlab(),
                        ),
                        initialValue:
                            contactBloc.currentEditContact['assigned_to'],

                        onSaved: (value) {
                          if (value == null) return;
                          contactBloc.currentEditContact['assigned_to'] = value;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select one or more",
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    Divider(color: Colors.grey)
                  ],
                ),
              ),
              // Build Address Field - currentEditContact to be added after update from backend
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Billing Address',
                                  style: GoogleFonts.robotoSlab(
                                      textStyle: TextStyle(
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: screenWidth / 25)),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '* ',
                                        style: GoogleFonts.robotoSlab(
                                            textStyle:
                                                TextStyle(color: Colors.red))),
                                    TextSpan(
                                        text: ': ',
                                        style: GoogleFonts.robotoSlab())
                                  ],
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(12.0),
                                  enabledBorder: boxBorder(),
                                  focusedErrorBorder: boxBorder(),
                                  focusedBorder: boxBorder(),
                                  errorBorder: boxBorder(),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Address Line',
                                  errorStyle: GoogleFonts.robotoSlab(),
                                  hintStyle: GoogleFonts.robotoSlab(
                                      textStyle: TextStyle(fontSize: 14.0))),
                              keyboardType: TextInputType.text,
                              initialValue:
                                  contactBloc.currentEditContact['address']
                                      ['address_line'],
                              validator: (value) {
                                if (value.isEmpty) {
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
                          Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: screenWidth * 0.42,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(12.0),
                                        enabledBorder: boxBorder(),
                                        focusedErrorBorder: boxBorder(),
                                        focusedBorder: boxBorder(),
                                        errorBorder: boxBorder(),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: 'Street',
                                        errorStyle: GoogleFonts.robotoSlab(),
                                        hintStyle: GoogleFonts.robotoSlab(
                                            textStyle:
                                                TextStyle(fontSize: 14.0))),
                                    keyboardType: TextInputType.text,
                                    initialValue: contactBloc
                                            .currentEditContact['address']
                                        ['street'],
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'This field is required.';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      contactBloc.currentEditContact['address']
                                          ['street'] = value;
                                    },
                                  ),
                                ),
                                Container(
                                  width: screenWidth * 0.42,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(12.0),
                                        enabledBorder: boxBorder(),
                                        focusedErrorBorder: boxBorder(),
                                        focusedBorder: boxBorder(),
                                        errorBorder: boxBorder(),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: 'Postal Code',
                                        errorStyle: GoogleFonts.robotoSlab(),
                                        hintStyle: GoogleFonts.robotoSlab(
                                            textStyle:
                                                TextStyle(fontSize: 14.0))),
                                    keyboardType: TextInputType.phone,
                                    initialValue: contactBloc
                                            .currentEditContact['address']
                                        ['postcode'],
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'This field is required.';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      contactBloc.currentEditContact['address']
                                          ['postcode'] = value;
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: screenWidth * 0.42,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(12.0),
                                        enabledBorder: boxBorder(),
                                        focusedErrorBorder: boxBorder(),
                                        focusedBorder: boxBorder(),
                                        errorBorder: boxBorder(),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: 'City',
                                        errorStyle: GoogleFonts.robotoSlab(),
                                        hintStyle: GoogleFonts.robotoSlab(
                                            textStyle:
                                                TextStyle(fontSize: 14.0))),
                                    keyboardType: TextInputType.text,
                                    initialValue: contactBloc
                                        .currentEditContact['address']['city'],
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'This field is required.';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      contactBloc.currentEditContact['address']
                                          ['city'] = value;
                                    },
                                  ),
                                ),
                                Container(
                                  width: screenWidth * 0.42,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(12.0),
                                        enabledBorder: boxBorder(),
                                        focusedErrorBorder: boxBorder(),
                                        focusedBorder: boxBorder(),
                                        errorBorder: boxBorder(),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: 'State',
                                        errorStyle: GoogleFonts.robotoSlab(),
                                        hintStyle: GoogleFonts.robotoSlab(
                                            textStyle:
                                                TextStyle(fontSize: 14.0))),
                                    keyboardType: TextInputType.text,
                                    initialValue: contactBloc
                                        .currentEditContact['address']['state'],
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'This field is required.';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      contactBloc.currentEditContact['address']
                                          ['state'] = value;
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 48.0,
                            margin: EdgeInsets.only(bottom: 5.0),
                            child: DropdownSearch<String>(
                              mode: Mode.BOTTOM_SHEET,
                              items: countiresForDropDown,
                              onChanged: (value) {
                                contactBloc.currentEditContact['address']
                                    ['country'] = value;
                              },
                              selectedItem: contactBloc
                                              .currentEditContact['address']
                                          ['country'] ==
                                      ""
                                  ? null
                                  : contactBloc.currentEditContact['address']
                                      ['country'],
                              // hint: 'Country',
                              label: "Country",
                              showSearchBox: true,
                              showSelectedItem: false,
                              showClearButton: true,
                              searchBoxDecoration: InputDecoration(
                                border: boxBorder(),
                                enabledBorder: boxBorder(),
                                focusedErrorBorder: boxBorder(),
                                focusedBorder: boxBorder(),
                                errorBorder: boxBorder(),
                                contentPadding: EdgeInsets.all(12),
                                hintText: "Search a Country",
                                hintStyle: GoogleFonts.robotoSlab(),
                                errorStyle: GoogleFonts.robotoSlab(),
                              ),
                              popupTitle: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorDark,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Countries',
                                    style: GoogleFonts.robotoSlab(
                                        textStyle: TextStyle(
                                            fontSize: screenWidth / 20,
                                            color: Colors.white)),
                                  ),
                                ),
                              ),
                              popupShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                              ),
                            ),
                          ),
                          Divider(color: Colors.grey)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Description',
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth / 25)),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' :', style: GoogleFonts.robotoSlab())
                            ],
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: TextFormField(
                        maxLines: 5,
                        initialValue:
                            contactBloc.currentEditContact['description'],
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12.0),
                            enabledBorder: boxBorder(),
                            focusedErrorBorder: boxBorder(),
                            focusedBorder: boxBorder(),
                            errorBorder: boxBorder(),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Enter Description",
                            errorStyle: GoogleFonts.robotoSlab(),
                            hintStyle: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(fontSize: 14.0))),
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is required.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          contactBloc.currentEditContact['description'] = value;
                        },
                      ),
                    ),
                    Divider(color: Colors.grey)
                  ],
                ),
              ),

              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'Attachments :',
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth / 25)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        result = await FilePicker.platform.pickFiles();
                        setState(() {
                          file = result.files.first;
                          print(file.name);
                        });
                      },
                      child: Container(
                        color: bottomNavBarTextColor,
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          "Choose File",
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    file != null
                        ? Container(
                            child: Text(
                              file.name,
                              style: GoogleFonts.robotoSlab(),
                            ),
                          )
                        : Container(),
                    Divider(color: Colors.grey)
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _saveForm();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.5,
                        decoration: BoxDecoration(
                          color: submitButtonColor,
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              contactBloc.currentEditContactId != null
                                  ? 'Update Contact'
                                  : 'Create Contact',
                              style: GoogleFonts.robotoSlab(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: screenWidth / 24)),
                            ),
                            SvgPicture.asset('assets/images/arrow_forward.svg')
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        contactBloc.cancelCurrentEditContact();
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: bottomNavBarTextColor,
                                  fontSize: screenWidth / 24)),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Create Contact",
          style: GoogleFonts.robotoSlab(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Container(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: _buildForm(),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}
