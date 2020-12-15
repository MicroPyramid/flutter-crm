import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/auth_bloc.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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
    if (result['error'] == false) {
      setState(() {
        _errorMessage = null;
      });
      showToast(result['message']);
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
          style:
              GoogleFonts.robotoSlab(textStyle: TextStyle(color: Colors.red))),
      isDismissible: false,
      mainButton: FlatButton(
        child: Text('TRY AGAIN',
            style: GoogleFonts.robotoSlab(
                textStyle: TextStyle(color: Theme.of(context).accentColor))),
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
          title: Text(
            "Change Password",
            style: GoogleFonts.robotoSlab(),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  child: Form(
                    key: _passwordFormKey,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.white,
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
                                        text: 'Old Password ',
                                        style: GoogleFonts.robotoSlab(
                                            textStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: screenWidth / 25)),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: '*',
                                              style: GoogleFonts.robotoSlab(
                                                  textStyle: TextStyle(
                                                      color: Colors.red))),
                                        ],
                                      ),
                                    )),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  child: TextFormField(
                                    obscureText: !_isOldPasswordVisible,
                                    decoration: InputDecoration(
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isOldPasswordVisible =
                                                  !_isOldPasswordVisible;
                                            });
                                          },
                                          child: Icon(
                                            !_isOldPasswordVisible
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: bottomNavBarTextColor,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.all(12.0),
                                        enabledBorder: boxBorder(),
                                        focusedErrorBorder: boxBorder(),
                                        focusedBorder: boxBorder(),
                                        errorBorder: boxBorder(),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: 'Enter Old Password',
                                        errorStyle: GoogleFonts.robotoSlab(),
                                        hintStyle: GoogleFonts.robotoSlab(
                                            textStyle:
                                                TextStyle(fontSize: 14.0))),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        setState(() {
                                          _errorMessage = null;
                                          _errors = null;
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
                                _errors != null &&
                                        _errors['old_password'] != null
                                    ? Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(
                                            bottom: 10.0, left: 10.0),
                                        child: Text(
                                          _errors['old_password'],
                                          style: GoogleFonts.robotoSlab(
                                              textStyle: TextStyle(
                                                  color: Colors.red[700],
                                                  fontSize: 12.0)),
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
                                        text: 'New Password ',
                                        style: GoogleFonts.robotoSlab(
                                            textStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: screenWidth / 25)),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: '*',
                                              style: GoogleFonts.robotoSlab(
                                                  textStyle: TextStyle(
                                                      color: Colors.red))),
                                        ],
                                      ),
                                    )),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  child: TextFormField(
                                    obscureText: !_isNewPasswordVisible,
                                    decoration: InputDecoration(
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isNewPasswordVisible =
                                                  !_isNewPasswordVisible;
                                            });
                                          },
                                          child: Icon(
                                            !_isNewPasswordVisible
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: bottomNavBarTextColor,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.all(12.0),
                                        enabledBorder: boxBorder(),
                                        focusedErrorBorder: boxBorder(),
                                        focusedBorder: boxBorder(),
                                        errorBorder: boxBorder(),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: 'Enter New Password',
                                        errorStyle: GoogleFonts.robotoSlab(),
                                        hintStyle: GoogleFonts.robotoSlab(
                                            textStyle:
                                                TextStyle(fontSize: 14.0))),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        setState(() {
                                          _errorMessage = null;
                                          _errors = null;
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
                                _errors != null &&
                                        _errors['new_password'] != null
                                    ? Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(
                                            bottom: 10.0, left: 10.0),
                                        child: Text(
                                          _errors['new_password'],
                                          style: GoogleFonts.robotoSlab(
                                              textStyle: TextStyle(
                                                  color: Colors.red[700],
                                                  fontSize: 12.0)),
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
                                  margin: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: screenWidth / 20,
                                          child: Text(
                                            "○",
                                            style: GoogleFonts.robotoSlab(
                                                textStyle: TextStyle(
                                                    fontSize: screenWidth / 20,
                                                    color:
                                                        bottomNavBarTextColor,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          )),
                                      Container(
                                        width: screenWidth * 0.83,
                                        child: Text(
                                          "Your Password can't be too similar to your other Personal Information.",
                                          style: GoogleFonts.robotoSlab(
                                              textStyle: TextStyle(
                                                  color:
                                                      bottomNavBarTextColor)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: screenWidth / 20,
                                          child: Text(
                                            "○",
                                            style: GoogleFonts.robotoSlab(
                                                textStyle: TextStyle(
                                                    fontSize: screenWidth / 20,
                                                    color:
                                                        bottomNavBarTextColor,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          )),
                                      Container(
                                        width: screenWidth * 0.83,
                                        child: Text(
                                          "Your Password must contain at least 8 characters.",
                                          style: GoogleFonts.robotoSlab(
                                              textStyle: TextStyle(
                                                  color:
                                                      bottomNavBarTextColor)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: screenWidth / 20,
                                          child: Text(
                                            "○",
                                            style: GoogleFonts.robotoSlab(
                                                textStyle: TextStyle(
                                                    fontSize: screenWidth / 20,
                                                    color:
                                                        bottomNavBarTextColor,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          )),
                                      Container(
                                        width: screenWidth * 0.83,
                                        child: Text(
                                          "Your Password can't be entirely numeric.",
                                          style: GoogleFonts.robotoSlab(
                                              textStyle: TextStyle(
                                                  color:
                                                      bottomNavBarTextColor)),
                                        ),
                                      )
                                    ],
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
                                        text: 'Confirm Password ',
                                        style: GoogleFonts.robotoSlab(
                                            textStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: screenWidth / 25)),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: '*',
                                              style: GoogleFonts.robotoSlab(
                                                  textStyle: TextStyle(
                                                      color: Colors.red))),
                                        ],
                                      ),
                                    )),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  child: TextFormField(
                                    obscureText: !_isConfirmPasswordVisible,
                                    decoration: InputDecoration(
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isConfirmPasswordVisible =
                                                  !_isConfirmPasswordVisible;
                                            });
                                          },
                                          child: Icon(
                                            !_isConfirmPasswordVisible
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: bottomNavBarTextColor,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.all(12.0),
                                        enabledBorder: boxBorder(),
                                        focusedErrorBorder: boxBorder(),
                                        focusedBorder: boxBorder(),
                                        errorBorder: boxBorder(),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: 'Enter Confirm Password',
                                        errorStyle: GoogleFonts.robotoSlab(),
                                        hintStyle: GoogleFonts.robotoSlab(
                                            textStyle:
                                                TextStyle(fontSize: 14.0))),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        setState(() {
                                          _errorMessage = null;
                                          _errors = null;
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
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(
                                            bottom: 10.0, left: 10.0),
                                        child: Text(
                                          _errors['retype_password'],
                                          style: GoogleFonts.robotoSlab(
                                              textStyle: TextStyle(
                                                  color: Colors.red[700],
                                                  fontSize: 12.0)),
                                        ),
                                      )
                                    : Container(),
                                _errorMessage != null
                                    ? Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          _errorMessage,
                                          style: GoogleFonts.robotoSlab(
                                              textStyle: TextStyle(
                                                  color: Colors.red[700],
                                                  fontSize: 12.0)),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                !_isLoading
                    ? Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  _errorMessage = null;
                                  _errors = null;
                                });
                                _submitForm();
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 10.0),
                                alignment: Alignment.center,
                                height: screenHeight * 0.06,
                                width: screenWidth * 0.5,
                                decoration:
                                    BoxDecoration(color: submitButtonColor),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Change Password',
                                      style: GoogleFonts.robotoSlab(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: screenWidth / 25)),
                                    ),
                                    SvgPicture.asset(
                                        'assets/images/arrow_forward.svg')
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.robotoSlab(
                                      decoration: TextDecoration.underline,
                                      color: bottomNavBarTextColor),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                submitButtonColor)),
                      )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBarWidget());
  }
}
