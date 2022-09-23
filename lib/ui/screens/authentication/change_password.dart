import 'package:bottle_crm/bloc/auth_bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:bottle_crm/utils/utils.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword();
  @override
  State createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isOldPasswordVisible = false;
  Map _formData = {
    "old_password": "",
    "new_password": "",
    "retype_password": ""
  };
  bool _isLoading = false;
  String _errorMessage = '';
  Map _errors = {};

  @override
  void initState() {
    super.initState();
  }

  OutlineInputBorder boxBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(width: 1, color: Colors.black12),
    );
  }

  _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
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
    if (result['error'] == false) {
      setState(() {
        _errorMessage = '';
      });
      showToaster('Password changed successfully.', context);
      await FirebaseAnalytics.instance.logEvent(name: "Password_Changes");
      Navigator.pop(context);
    } else if (result['error'] == true) {
      if (result['message'] != null) {
        setState(() {
          _errorMessage = result['message'];
        });
      }
      if (result['errors'] != null) {
        if (result['errors']['retype_password'] != null) {
          result['errors']['retype_password'] =
              "New Password and Confirm Password did not match.";
        }
        setState(() {
          _errors = result['errors'];
        });
      }
    } else {
      setState(() {
        _errorMessage = '';
      });
      showErrorMessage(context,result['message'].toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  showErrorMessage(BuildContext context,String message) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Alert'),
              content: Text(message),
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
                        IconButton(
                            icon: new Icon(Icons.arrow_back_ios,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context, true);
                            }),
                        SizedBox(width: 10.0),
                        Text(
                          'Change Password',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth / 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    ),
                child: buildPasswordScreen(),
              ))
            ],
          ),
        ),
      ),
    );
  }

  buildPasswordScreen() {
    return Container(
        height: screenHeight,
        alignment: Alignment.center,
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Old Password',
                                style: TextStyle(
                                    fontSize: screenWidth / 24,
                                    fontWeight: FontWeight.w500)),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              child: TextFormField(
                                obscureText:
                                    _isOldPasswordVisible ? false : true,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock_outline,
                                        color: Theme.of(context).primaryColor),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isOldPasswordVisible =
                                                !_isOldPasswordVisible;
                                          });
                                        },
                                        icon: Icon(
                                            _isOldPasswordVisible
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: Colors.grey)),
                                    contentPadding: EdgeInsets.all(12.0),
                                    enabledBorder: boxBorder(),
                                    focusedErrorBorder: boxBorder(),
                                    focusedBorder: boxBorder(),
                                    errorBorder: boxBorder(),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintStyle: TextStyle(fontSize: 14.0)),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      _errorMessage = '';
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
                            _errors['old_password'] != null
                                ? Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(
                                        bottom: 10.0, left: 10.0),
                                    child: Text(
                                      _errors['old_password'],
                                      style: TextStyle(
                                          color: Colors.red[700],
                                          fontSize: 12.0),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('New Password',
                                style: TextStyle(
                                    fontSize: screenWidth / 24,
                                    fontWeight: FontWeight.w500)),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              child: TextFormField(
                                obscureText: _isPasswordVisible ? false : true,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock_outline,
                                        color: Theme.of(context).primaryColor),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible =
                                                !_isPasswordVisible;
                                          });
                                        },
                                        icon: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: Colors.grey)),
                                    contentPadding: EdgeInsets.all(12.0),
                                    enabledBorder: boxBorder(),
                                    focusedErrorBorder: boxBorder(),
                                    focusedBorder: boxBorder(),
                                    errorBorder: boxBorder(),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintStyle: TextStyle(fontSize: 14.0)),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      _errorMessage = '';
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
                            _errors['new_password'] != null
                                ? Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(
                                        bottom: 10.0, left: 10.0),
                                    child: Text(
                                      _errors['new_password'],
                                      style: TextStyle(
                                          color: Colors.red[700],
                                          fontSize: 12.0),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Confirm Password',
                                style: TextStyle(
                                    fontSize: screenWidth / 24,
                                    fontWeight: FontWeight.w500)),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              child: TextFormField(
                                obscureText:
                                    _isConfirmPasswordVisible ? false : true,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock_outline,
                                        color: Theme.of(context).primaryColor),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isConfirmPasswordVisible =
                                                !_isConfirmPasswordVisible;
                                          });
                                        },
                                        icon: Icon(
                                            _isConfirmPasswordVisible
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: Colors.grey)),
                                    contentPadding: EdgeInsets.all(12.0),
                                    enabledBorder: boxBorder(),
                                    focusedErrorBorder: boxBorder(),
                                    focusedBorder: boxBorder(),
                                    errorBorder: boxBorder(),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintStyle: TextStyle(fontSize: 14.0)),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      _errorMessage = '';
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
                            _errors['retype_password'] != null
                                ? Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(
                                        bottom: 10.0, left: 10.0),
                                    child: Text(
                                      _errors['retype_password'],
                                      style: TextStyle(
                                          color: Colors.red[700],
                                          fontSize: 12.0),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      _errorMessage != ''
                          ? Container(
                              child: Text(
                                _errorMessage,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: screenWidth / 28),
                              ),
                            )
                          : Container(),
                      SizedBox(height: 10.0),
                      !_isLoading
                          ? Container(
                              width: screenWidth,
                              child: ElevatedButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    _errorMessage = '';
                                    _errors = {};
                                    _submitForm();
                                  },
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth / 22),
                                  )),
                            )
                          : Container(
                              child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Color.fromRGBO(62, 121, 247, 1))),
                            )
                    ],
                  )),
            ),
          ],
        ));
  }
}
