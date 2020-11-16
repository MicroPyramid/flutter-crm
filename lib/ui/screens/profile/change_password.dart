import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/auth_bloc.dart';
import 'package:flutter_crm/utils/utils.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword();
  @override
  State createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  Map _formData = {
    "old_password": "",
    "new_password": "",
    "retype_password": ""
  };
  bool _isLoading = false;
  String _errorMessage;
  Map _errors = {};

  @override
  void initState() {
    super.initState();
  }

  _submitForm() async {
    if (!_passwordFormKey.currentState.validate()) {
      return;
    }
    _passwordFormKey.currentState.save();
    if (_formData['new_password'] != _formData['retype_password']) {
      setState(() {
        _errorMessage = "Confirm password do not match with new password";
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });
    Map result = await authBloc.changePassword(_formData);
    if (result['status'] == 'success') {
      setState(() {
        _errorMessage = null;
      });
      Navigator.pop(context);
    } else if (result['status'] == 'failure') {
      if (result['message'] != null) {
        setState(() {
          _errorMessage = result['message'];
        });
      }
      if (result['errors'] != null) {
        setState(() {
          _errors = result['errors'];
        });
      }
    } else {
      setState(() {
        _errorMessage = null;
      });
      showErrorMessage(context, 'Something went wrong');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void showErrorMessage(BuildContext context, String errorContent) {
    Flushbar(
      backgroundColor: Colors.white,
      messageText: Text(errorContent,
          style: TextStyle(fontWeight: FontWeight.w400, color: Colors.red)),
      isDismissible: false,
      mainButton: FlatButton(
        child: Text(
          'TRY AGAIN',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w500),
        ),
        onPressed: () {
          Navigator.of(context).pop(true);
          _submitForm();
        },
      ),
      duration: Duration(seconds: 10),
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Change Password"),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                  child: Form(
                      key: _passwordFormKey,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(top: 15.0),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Old Password ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                22),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '*',
                                          style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                )),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromRGBO(221, 221, 221, 1)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromRGBO(221, 221, 221, 1)),
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: 'Old Password'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    setState(() {
                                      _errorMessage = null;
                                      _errors = {};
                                    });
                                    return 'This field is required.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _formData['old_password'] = value;
                                },
                              ),
                            ),
                            _errors != null && _errors['old_password'] != null
                                ? Container(
                                    margin: EdgeInsets.symmetric(vertical: 5.0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                      _errors['old_password'],
                                      style: TextStyle(
                                          color: Colors.red[700],
                                          fontSize: 12.0),
                                    ),
                                  )
                                : Container(),
                            Container(
                                margin: EdgeInsets.only(bottom: 10.0),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'New Password ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                22),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '*',
                                          style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                )),
                            Container(
                              margin: EdgeInsets.only(bottom: 15.0),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromRGBO(221, 221, 221, 1)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromRGBO(221, 221, 221, 1)),
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: 'New Password'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    setState(() {
                                      _errorMessage = null;
                                      _errors = {};
                                    });
                                    return 'This field is required.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _formData['new_password'] = value;
                                },
                              ),
                            ),
                            _errors != null && _errors['new_password'] != null
                                ? Container(
                                    margin: EdgeInsets.symmetric(vertical: 5.0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                      _errors['new_password'],
                                      style: TextStyle(
                                          color: Colors.red[700],
                                          fontSize: 12.0),
                                    ),
                                  )
                                : Container(),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(
                                  "• Your password can't be too similar to your other personal information."),
                            ),
                            Container(
                              child: Text(
                                  "• Your password must contain at least 8 characters."),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(
                                  "• Your password can't be a commonly used password."),
                            ),
                            Container(
                              child: Text(
                                  "• Your password can't be entirely numeric."),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 15.0),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Confirm New Password ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                22),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '*',
                                          style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                )),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromRGBO(221, 221, 221, 1)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromRGBO(221, 221, 221, 1)),
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: 'Confirm Password'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    setState(() {
                                      _errorMessage = null;
                                      _errors = {};
                                    });
                                    return 'This field is required.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _formData['retype_password'] = value;
                                },
                              ),
                            ),
                            _errors != null &&
                                    _errors['retype_password'] != null
                                ? Container(
                                    margin: EdgeInsets.symmetric(vertical: 5.0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                      _errors['retype_password'],
                                      style: TextStyle(
                                          color: Colors.red[700],
                                          fontSize: 12.0),
                                    ),
                                  )
                                : Container(),
                            _errorMessage != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 10.0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                      _errorMessage,
                                      style: TextStyle(
                                          color: Colors.red[700],
                                          fontSize: 12.0),
                                    ),
                                  )
                                : Container(),
                            !_isLoading
                                ? Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    margin: EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 20.0),
                                          child: RaisedButton(
                                            color:
                                                Theme.of(context).buttonColor,
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();
                                              if (!_isLoading) {
                                                _submitForm();
                                              }
                                            },
                                            child: Text(
                                              'Change Password',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        RaisedButton(
                                          color: Colors.white,
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                            if (!_isLoading) {
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .buttonColor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 10.0),
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Theme.of(context).buttonColor)),
                                  )
                          ],
                        ),
                      )),
                ),
                Container(),
                Container()
              ],
            ),
          ),
        ));
  }
}
