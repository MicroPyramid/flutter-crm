import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crm/bloc/account_bloc.dart';
import 'package:flutter_crm/bloc/contact_bloc.dart';
import 'package:flutter_crm/bloc/lead_bloc.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:textfield_tags/textfield_tags.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount();
  @override
  State createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final GlobalKey<FormState> _createAccountFormKey = GlobalKey<FormState>();
  FilePickerResult result;
  PlatformFile file;
  Map _errors;
  bool _isLoading = false;
  FocusNode _focuserr;
  FocusNode _nameFocusNode = new FocusNode();
  FocusNode _phoneFocusNode = new FocusNode();
  FocusNode _emailFocusNode = new FocusNode();
  FocusNode _websiteFocusNode = new FocusNode();
  FocusNode _addLineFocusNode = new FocusNode();
  FocusNode _addStreetFocusNode = new FocusNode();
  FocusNode _addPostalFocusNode = new FocusNode();
  FocusNode _addCityFocusNode = new FocusNode();
  FocusNode _addStateFocusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_focuserr != null) {
      _focuserr.dispose();
    }
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    _websiteFocusNode.dispose();
    _addLineFocusNode.dispose();
    _addStreetFocusNode.dispose();
    _addPostalFocusNode.dispose();
    _addCityFocusNode.dispose();
    _addStateFocusNode.dispose();
    super.dispose();
  }

  focusError() {
    setState(() {
      FocusManager.instance.primaryFocus.unfocus();
      FocusScope.of(context).requestFocus(_focuserr);
    });
  }

  _saveForm() async {
    _focuserr = null;
    setState(() {
      _errors = null;
    });
    if (!_createAccountFormKey.currentState.validate()) {
      focusError();
      return;
    }
    _createAccountFormKey.currentState.save();
    Map _result;
    setState(() {
      _isLoading = true;
    });
    if (accountBloc.currentEditAccountId != null) {
      _result = await accountBloc.editAccount();
    } else {
      _result = await accountBloc.createAccount();
    }
    setState(() {
      _isLoading = false;
    });
    if (_result['error'] == false) {
      setState(() {
        _errors = null;
      });
      showToast(_result['message']);
      Navigator.pushReplacementNamed(context, '/account_list');
    } else if (_result['error'] == true) {
      setState(() {
        _errors = _result['errors'];
      });
      if (_errors['name'] != null && _focuserr == null) {
        _focuserr = _nameFocusNode;
        focusError();
      }
      if (_errors['phone'] != null && _focuserr == null) {
        _focuserr = _phoneFocusNode;
        focusError();
      }
      if (_errors['email'] != null && _focuserr == null) {
        _focuserr = _emailFocusNode;
        focusError();
      }
      if (_errors['website'] != null && _focuserr == null) {
        _focuserr = _websiteFocusNode;
        focusError();
      }
    } else {
      setState(() {
        _errors = null;
      });
      showErrorMessage(context, 'Something went wrong');
    }
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

  Widget _buildForm() {
    return Container(
      child: Form(
        key: _createAccountFormKey,
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
                          text: 'Name',
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth / 25)),
                          children: <TextSpan>[
                            TextSpan(
                                text: '* ',
                                style: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(color: Colors.red))),
                            TextSpan(
                                text: ': ', style: GoogleFonts.robotoSlab())
                          ],
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      focusNode: _nameFocusNode,
                      initialValue: accountBloc.currentEditAccount['name'],
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          enabledBorder: boxBorder(),
                          focusedErrorBorder: boxBorder(),
                          focusedBorder: boxBorder(),
                          errorBorder: boxBorder(),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Enter Name',
                          errorStyle: GoogleFonts.robotoSlab(),
                          hintStyle: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(fontSize: 14.0))),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          if (_focuserr == null) {
                            _focuserr = _nameFocusNode;
                          }
                          return 'This field is required.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        accountBloc.currentEditAccount['name'] = value;
                      },
                    ),
                  ),
                  _errors != null && _errors['name'] != null
                      ? Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _errors['name'][0],
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color: Colors.red[700], fontSize: 12.0)),
                          ),
                        )
                      : Container(),
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
                        'Website :',
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth / 25)),
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      focusNode: _websiteFocusNode,
                      initialValue: accountBloc.currentEditAccount['website'],
                      controller: null,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          enabledBorder: boxBorder(),
                          focusedErrorBorder: boxBorder(),
                          focusedBorder: boxBorder(),
                          errorBorder: boxBorder(),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Enter Website',
                          errorStyle: GoogleFonts.robotoSlab(),
                          hintStyle: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(fontSize: 14.0))),
                      keyboardType: TextInputType.url,
                      onSaved: (value) {
                        accountBloc.currentEditAccount['website'] = value;
                      },
                    ),
                  ),
                  _errors != null && _errors['website'] != null
                      ? Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _errors['website'][0],
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color: Colors.red[700], fontSize: 12.0)),
                          ),
                        )
                      : Container(),
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
                          text: 'Phone Number',
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth / 25)),
                          children: <TextSpan>[
                            TextSpan(
                                text: '* ',
                                style: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(color: Colors.red))),
                            TextSpan(
                                text: ': ', style: GoogleFonts.robotoSlab())
                          ],
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      focusNode: _phoneFocusNode,
                      initialValue: accountBloc.currentEditAccount['phone'],
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          enabledBorder: boxBorder(),
                          focusedErrorBorder: boxBorder(),
                          focusedBorder: boxBorder(),
                          errorBorder: boxBorder(),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: '+91XXXXXXXXXX',
                          errorStyle: GoogleFonts.robotoSlab(),
                          hintStyle: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(fontSize: 14.0))),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value.isEmpty) {
                          if (_focuserr == null) {
                            _focuserr = _phoneFocusNode;
                          }
                          return 'This field is required.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        accountBloc.currentEditAccount['phone'] = value;
                      },
                    ),
                  ),
                  _errors != null && _errors['phone'] != null
                      ? Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _errors['phone'][0],
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color: Colors.red[700], fontSize: 12.0)),
                          ),
                        )
                      : Container(),
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
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth / 25)),
                          children: <TextSpan>[
                            TextSpan(
                                text: '* ',
                                style: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(color: Colors.red))),
                            TextSpan(
                                text: ': ', style: GoogleFonts.robotoSlab())
                          ],
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      focusNode: _emailFocusNode,
                      initialValue: accountBloc.currentEditAccount['email'],
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          enabledBorder: boxBorder(),
                          focusedErrorBorder: boxBorder(),
                          focusedBorder: boxBorder(),
                          errorBorder: boxBorder(),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Enter Email Address',
                          errorStyle: GoogleFonts.robotoSlab(),
                          hintStyle: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(fontSize: 14.0))),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty) {
                          if (_focuserr == null) {
                            _focuserr = _emailFocusNode;
                          }
                          return 'This field is required.';
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          if (_focuserr == null) {
                            _focuserr = _emailFocusNode;
                          }
                          return 'Enter valid email address.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        accountBloc.currentEditAccount['email'] = value;
                      },
                    ),
                  ),
                  _errors != null && _errors['email'] != null
                      ? Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _errors['email'][0],
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color: Colors.red[700], fontSize: 12.0)),
                          ),
                        )
                      : Container(),
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
                        'Lead :',
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth / 25)),
                      )),
                  Container(
                    height: 48.0,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: DropdownSearch<String>(
                      mode: Mode.BOTTOM_SHEET,
                      items: leadBloc.leadsTitles,
                      onChanged: print,
                      onSaved: (selection) {
                        if (selection == null) {
                          accountBloc.currentEditAccount['lead'] = "";
                        } else {
                          accountBloc.currentEditAccount['lead'] = selection;
                        }
                      },
                      selectedItem: accountBloc.currentEditAccount['lead'],
                      hint: 'Select Lead',
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
                        hintText: "Search a Lead",
                        hintStyle: GoogleFonts.robotoSlab(),
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
                            'Leads',
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    fontSize: screenWidth / 20,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                      popupItemBuilder: (context, item, isSelected) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10.0),
                          child: Text(
                            item,
                            style: GoogleFonts.robotoSlab(
                                textStyle:
                                    TextStyle(fontSize: screenWidth / 22)),
                          ),
                        );
                      },
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
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth / 25)),
                          children: <TextSpan>[
                            TextSpan(
                                text: '* ',
                                style: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(color: Colors.red))),
                            TextSpan(
                                text: ': ', style: GoogleFonts.robotoSlab())
                          ],
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      focusNode: _addLineFocusNode,
                      initialValue: accountBloc
                          .currentEditAccount['billing_address_line'],
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
                      validator: (value) {
                        if (value.isEmpty) {
                          if (_focuserr == null) {
                            _focuserr = _addLineFocusNode;
                          }
                          return 'This field is required.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        accountBloc.currentEditAccount['billing_address_line'] =
                            value;
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
                            focusNode: _addStreetFocusNode,
                            initialValue: accountBloc
                                .currentEditAccount['billing_street'],
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
                                    textStyle: TextStyle(fontSize: 14.0))),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty) {
                                if (_focuserr == null) {
                                  _focuserr = _addStreetFocusNode;
                                }
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
                        Container(
                          width: screenWidth * 0.42,
                          child: TextFormField(
                            focusNode: _addPostalFocusNode,
                            initialValue: accountBloc
                                .currentEditAccount['billing_postcode'],
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
                                    textStyle: TextStyle(fontSize: 14.0))),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value.isEmpty) {
                                if (_focuserr == null) {
                                  _focuserr = _addPostalFocusNode;
                                }
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
                            focusNode: _addCityFocusNode,
                            initialValue:
                                accountBloc.currentEditAccount['billing_city'],
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
                                    textStyle: TextStyle(fontSize: 14.0))),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty) {
                                if (_focuserr == null) {
                                  _focuserr = _addCityFocusNode;
                                }
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
                        Container(
                          width: screenWidth * 0.42,
                          child: TextFormField(
                            focusNode: _addStateFocusNode,
                            initialValue:
                                accountBloc.currentEditAccount['billing_state'],
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
                                    textStyle: TextStyle(fontSize: 14.0))),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty) {
                                if (_focuserr == null) {
                                  _focuserr = _addStateFocusNode;
                                }
                                return 'This field is required.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              accountBloc.currentEditAccount['billing_state'] =
                                  value;
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: DropdownSearch<String>(
                      mode: Mode.BOTTOM_SHEET,
                      items: leadBloc.countries,
                      onChanged: print,
                      selectedItem:
                          accountBloc.currentEditAccount['billing_country'],
                      hint: 'Select Country',
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
                          hintStyle: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(fontSize: 14.0)),
                          errorStyle: GoogleFonts.robotoSlab()),
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
                      popupItemBuilder: (context, item, isSelected) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10.0),
                          child: Text(
                            item,
                            style: GoogleFonts.robotoSlab(
                                textStyle:
                                    TextStyle(fontSize: screenWidth / 22)),
                          ),
                        );
                      },
                      popupShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        accountBloc.currentEditAccount['billing_country'] =
                            newValue;
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
                          text: 'Contacts',
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth / 25)),
                          children: <TextSpan>[
                            TextSpan(
                                text: '* ',
                                style: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(color: Colors.red))),
                            TextSpan(
                                text: ': ', style: GoogleFonts.robotoSlab())
                          ],
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: MultiSelectFormField(
                      border: boxBorder(),
                      fillColor: Colors.white,
                      autovalidate: false,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select one or more options';
                        }
                        return null;
                      },
                      dataSource: contactBloc.contactsObjForDropdown,
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
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(color: Colors.grey)),
                      ),
                      title: Text(
                        "Contacts",
                        style: GoogleFonts.robotoSlab(),
                      ),
                      initialValue: accountBloc.currentEditAccount['contacts'],
                      onSaved: (value) {
                        if (value == null) return;
                        accountBloc.currentEditAccount['contacts'] = value;
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
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(color: Colors.grey)),
                      ),
                      title: Text(
                        "Teams",
                        style: GoogleFonts.robotoSlab(),
                      ),
                      initialValue: accountBloc.currentEditAccount['teams'],
                      onSaved: (value) {
                        if (value == null) {
                          accountBloc.currentEditAccount['teams'] = [];
                        } else {
                          accountBloc.currentEditAccount['teams'] = value;
                        }
                      },
                    ),
                  ),
                  Divider(color: Colors.grey)
                ],
              ),
            ),

            // Users MultiSelectDropDown Field. <disabled> - needs data
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
                      fillColor: Colors.white,
                      autovalidate: false,
                      dataSource: [
                        {'name': '', 'id': ''}
                      ],
                      textField: 'name',
                      valueField: 'id',
                      okButtonLabel: 'OK',
                      chipLabelStyle: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(color: Colors.black)),
                      dialogTextStyle: GoogleFonts.robotoSlab(),
                      cancelButtonLabel: 'CANCEL',
                      hintWidget: Text(
                        "Please choose one or more",
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(color: Colors.grey)),
                      ),
                      title: Text(
                        "Users",
                        style: GoogleFonts.robotoSlab(),
                      ),
                      // initialValue: accountBloc.currentEditAccount['users'],
                      onSaved: (value) {
                        // accountBloc.currentEditAccount['users'] = value;
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
                      'Assign To :',
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
                      dataSource: accountBloc.assignedToList,
                      textField: 'name',
                      valueField: 'id',
                      okButtonLabel: 'OK',
                      chipLabelStyle: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(color: Colors.black)),
                      dialogTextStyle: GoogleFonts.robotoSlab(),
                      cancelButtonLabel: 'CANCEL',
                      hintWidget: Text(
                        "Please choose one or more",
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(color: Colors.grey)),
                      ),
                      title: Text(
                        "Assigned To",
                        style: GoogleFonts.robotoSlab(),
                      ),
                      initialValue:
                          accountBloc.currentEditAccount['assigned_to'],
                      onSaved: (value) {
                        if (value == null) {
                          accountBloc.currentEditAccount['assigned_to'] = [];
                        } else {
                          accountBloc.currentEditAccount['assigned_to'] = value;
                        }
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
                      'Status :',
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth / 25)),
                    ),
                  ),
                  Container(
                    height: 48.0,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          border: boxBorder(),
                          contentPadding: EdgeInsets.all(12.0)),
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(color: Colors.black)),
                      hint: Text('select Status'),
                      value: accountBloc.currentEditAccount['status'],
                      onChanged: (value) {
                        accountBloc.currentEditAccount['status'] = value;
                      },
                      items: ['open', 'close'].map((item) {
                        return DropdownMenuItem(
                          child: new Text(item),
                          value: item,
                        );
                      }).toList(),
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
                      'Tags :',
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth / 25)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: TextFieldTags(
                      initialTags: accountBloc.currentEditAccount['tags'],
                      textFieldStyler: TextFieldStyler(
                        contentPadding: EdgeInsets.all(12.0),
                        textFieldBorder: boxBorder(),
                        textFieldFocusedBorder: boxBorder(),
                        hintText: 'Enter Tags',
                        hintStyle: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(fontSize: 14.0)),
                        helperText: null,
                      ),
                      tagsStyler: TagsStyler(
                          tagTextPadding: EdgeInsets.symmetric(horizontal: 5.0),
                          tagTextStyle: GoogleFonts.robotoSlab(),
                          tagDecoration: BoxDecoration(
                            color: Colors.lightGreen[300],
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          tagCancelIcon: Icon(Icons.cancel,
                              size: 18.0, color: Colors.green[900]),
                          tagPadding: const EdgeInsets.all(6.0)),
                      onTag: (tag) {
                        setState(() {
                          accountBloc.currentEditAccount['tags'].add(tag);
                        });
                      },
                      onDelete: (tag) {
                        setState(() {
                          accountBloc.currentEditAccount['tags'].remove(tag);
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
            // Save Form
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
                            accountBloc.currentEditAccountId == null
                                ? 'Create Account'
                                : 'Edit Account',
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
                      Navigator.pop(context);
                      accountBloc.cancelCurrentEditAccount();
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _isLoading
        ? new Container(
            color: Colors.transparent,
            width: 300.0,
            height: 300.0,
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(child: new CircularProgressIndicator())),
          )
        : new Container();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Create Account",
            style: GoogleFonts.robotoSlab(),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Container(
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: _buildForm(),
                ),
              ),
            ),
            new Align(
              child: loadingIndicator,
              alignment: FractionalOffset.center,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBarWidget());
  }
}
