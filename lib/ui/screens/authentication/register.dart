import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/auth_bloc.dart';
import 'package:flutter_crm/ui/widgets/footer_button.dart';
import 'package:flutter_crm/ui/widgets/bottleCrm_logo.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class UserRegister extends StatefulWidget {
  UserRegister();
  @override
  State createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  Map _formData = {
    "sub_domain": "",
    "username": "",
    "email": "",
    "password": ""
  };
  Map _errors = {};
  bool _isLoading = false;
  String _errorMessage;

  @override
  void initState() {
    super.initState();
  }

  _submitForm() async {
    if (!_registerFormKey.currentState.validate()) {
      return;
    }
    _registerFormKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    Map result = await authBloc.register(_formData);
    if (result['error'] == false) {
      setState(() {
        _errorMessage = null;
      });
      Navigator.pushReplacementNamed(context, '/user_login');
    } else if (result['error'] == true) {
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

  Widget textFields() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 15.0),
            child: Text(
              'Register',
              style: GoogleFonts.robotoSlab(
                  textStyle: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.w500,
                      fontSize: screenWidth / 20)),
            ),
          ),
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
                  hintText: 'Enter Sub Domain',
                  errorStyle: GoogleFonts.robotoSlab(),
                  hintStyle: GoogleFonts.robotoSlab(
                      textStyle: TextStyle(fontSize: 14.0))),
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
                _formData['sub_domain'] = value;
              },
            ),
          ),
          _errors != null && _errors['sub_domain'] != null
              ? Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 10.0, left: 10.0),
                  child: Text(
                    _errors['sub_domain'],
                    style: GoogleFonts.robotoSlab(
                        textStyle:
                            TextStyle(color: Colors.red[700], fontSize: 12.0)),
                  ),
                )
              : Container(),
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
                  hintText: 'Enter User Name',
                  errorStyle: GoogleFonts.robotoSlab(),
                  hintStyle: GoogleFonts.robotoSlab(
                      textStyle: TextStyle(fontSize: 14.0))),
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
                _formData['username'] = value;
              },
            ),
          ),
          _errors != null && _errors['username'] != null
              ? Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 10.0, left: 10.0),
                  child: Text(
                    _errors['username'],
                    style: GoogleFonts.robotoSlab(
                        textStyle:
                            TextStyle(color: Colors.red[700], fontSize: 12.0)),
                  ),
                )
              : Container(),
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
                  hintText: 'Enter Email Address',
                  errorStyle: GoogleFonts.robotoSlab(),
                  hintStyle: GoogleFonts.robotoSlab(
                      textStyle: TextStyle(fontSize: 14.0))),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value.isEmpty) {
                  setState(() {
                    _errorMessage = null;
                    _errors = null;
                  });
                  return 'This field is required.';
                }
                if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
                  setState(() {
                    _errorMessage = null;
                    _errors = null;
                  });
                  return 'Enter valid email address.';
                }
                return null;
              },
              onSaved: (value) {
                _formData['email'] = value;
              },
            ),
          ),
          _errors != null && _errors['email'] != null
              ? Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 10.0, left: 10.0),
                  child: Text(
                    _errors['email'],
                    style: GoogleFonts.robotoSlab(
                        textStyle:
                            TextStyle(color: Colors.red[700], fontSize: 12.0)),
                  ),
                )
              : Container(),
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12.0),
                  enabledBorder: boxBorder(),
                  focusedErrorBorder: boxBorder(),
                  focusedBorder: boxBorder(),
                  errorBorder: boxBorder(),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Enter Password',
                  errorStyle: GoogleFonts.robotoSlab(),
                  hintStyle: GoogleFonts.robotoSlab(
                      textStyle: TextStyle(fontSize: 14.0))),
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
                _formData['password'] = value;
              },
            ),
          ),
          _errors != null && _errors['password'] != null
              ? Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 10.0, left: 10.0),
                  child: Text(
                    _errors['password'],
                    style: GoogleFonts.robotoSlab(
                        textStyle:
                            TextStyle(color: Colors.red[700], fontSize: 12.0)),
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
                        textStyle:
                            TextStyle(color: Colors.red[700], fontSize: 12.0)),
                  ),
                )
              : Container(),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: !_isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          _submitForm();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: screenHeight * 0.06,
                          width: screenWidth * 0.4,
                          decoration: BoxDecoration(
                            color: submitButtonColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(3.0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Register',
                                style: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenWidth / 22)),
                              ),
                              SvgPicture.asset(
                                  'assets/images/arrow_forward.svg')
                            ],
                          ),
                        ),
                      ),
                      // Container(
                      //   child: Text(
                      //     'OR',
                      //     style: GoogleFonts.robotoSlab(
                      //         textStyle: TextStyle(
                      //             color: Color.fromRGBO(5, 24, 62, 1),
                      //             fontWeight: FontWeight.w500,
                      //             fontSize: screenWidth / 24)),
                      //   ),
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      //     FocusScope.of(context).unfocus();
                      //     if (!_isLoading)
                      //       Navigator.pushNamed(context, '/user_register');
                      //   },
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     height: screenHeight * 0.06,
                      //     width: screenWidth * 0.4,
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(3.0)),
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //       children: [
                      //         SvgPicture.asset(
                      //           'assets/images/logo_google.svg',
                      //           width: screenWidth / 16,
                      //         ),
                      //         Text(
                      //           'Google SignUp',
                      //           style: GoogleFonts.robotoSlab(
                      //               textStyle: TextStyle(
                      //                   color: Colors.red,
                      //                   fontWeight: FontWeight.w600,
                      //                   fontSize: screenWidth / 24)),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // )
                    ],
                  )
                : Container(
                    alignment: Alignment.center,
                    height: 40.0,
                    width: 40.0,
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            submitButtonColor)),
                  ),
          )
        ],
      ),
    );
  }

  Widget footerButton() {
    return Container(
        margin: EdgeInsets.only(bottom: screenHeight * 0.04),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Existing User?",
                style: GoogleFonts.robotoSlab(
                    textStyle: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth / 25)),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!_isLoading)
                  Navigator.pushReplacementNamed(context, '/sub_domain');
              },
              child: Container(
                padding: EdgeInsets.only(right: 10.0),
                alignment: Alignment.center,
                height: screenHeight * 0.06,
                width: screenWidth * 0.9,
                decoration: BoxDecoration(
                  color: Theme.of(context).buttonColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Text(
                      'Login Here',
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth / 22)),
                    ),
                    Icon(Icons.arrow_forward, color: Colors.white)
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          child: Form(
            key: _registerFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderTextWidget(),
                textFields(),
                FooterBtnWidget(
                  labelText: "Existing User?",
                  buttonLabelText: "Login Here",
                  routeName: "/sub_domain",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
