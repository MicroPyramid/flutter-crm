import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/auth_bloc.dart';
import 'package:flutter_crm/utils/utils.dart';
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

  Widget headerTextWidget() {
    return Container(
      margin: EdgeInsets.only(top: screenHeight * 0.1),
      child: Text(
        'Bottle CRM',
        style: GoogleFonts.robotoSlab(
            textStyle: TextStyle(
                color: Color.fromRGBO(5, 24, 62, 1),
                fontWeight: FontWeight.w500,
                fontSize: screenWidth / 13)),
      ),
    );
  }

  OutlineInputBorder boxBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(width: 1, color: Colors.grey),
    );
  }

  Widget textFields() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text(
              'Register',
              style: GoogleFonts.robotoSlab(
                  textStyle: TextStyle(
                      color: Color.fromRGBO(5, 24, 62, 1),
                      fontWeight: FontWeight.w500,
                      fontSize: screenWidth / 22)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: TextFormField(
              decoration: InputDecoration(
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
                            color: Color.fromRGBO(73, 163, 69, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Register',
                                style: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: screenWidth / 24)),
                              ),
                              Icon(Icons.arrow_forward, color: Colors.white)
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
                      //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //       children: [
                      //         Image.asset(
                      //           'assets/images/google-logo.png',
                      //           color: Colors.red,
                      //           width: screenWidth / 15,
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
                            Color.fromRGBO(73, 163, 69, 1))),
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
                        color: Color.fromRGBO(5, 24, 62, 1),
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
              children: [headerTextWidget(), textFields(), footerButton()],
            ),
          ),
        ),
      ),
      // body: Stack(
      //   fit: StackFit.expand,
      //   children: <Widget>[
      //     SingleChildScrollView(
      //       child: Container(
      //         height: MediaQuery.of(context).size.height,
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Container(
      //               margin: EdgeInsets.symmetric(vertical: 15.0),
      //               child: Text('bottlecrm',
      //                   style: TextStyle(
      //                       color: Color.fromRGBO(51, 51, 51, 1),
      //                       fontWeight: FontWeight.w500,
      //                       fontSize: MediaQuery.of(context).size.width / 15)),
      //             ),
      //             Container(
      //               child: Form(
      //                   key: _registerFormKey,
      //                   child: Container(
      //                     child: Column(
      //                       children: [
      //                         Container(
      //                           width: MediaQuery.of(context).size.width * 0.8,
      //                           child: TextFormField(
      //                             decoration: InputDecoration(
      //                                 enabledBorder: OutlineInputBorder(
      //                                   borderRadius: BorderRadius.all(
      //                                       Radius.circular(4)),
      //                                   borderSide: BorderSide(
      //                                       width: 1,
      //                                       color: Color.fromRGBO(
      //                                           221, 221, 221, 1)),
      //                                 ),
      //                                 focusedBorder: OutlineInputBorder(
      //                                   borderRadius: BorderRadius.all(
      //                                       Radius.circular(4)),
      //                                   borderSide: BorderSide(
      //                                       width: 1,
      //                                       color: Color.fromRGBO(
      //                                           221, 221, 221, 1)),
      //                                 ),
      //                                 fillColor: Colors.white,
      //                                 filled: true,
      //                                 hintText: 'Sub-domain'),
      //                             keyboardType: TextInputType.text,
      //                             validator: (value) {
      //                               if (value.isEmpty) {
      //                                 setState(() {
      //                                   _errors = {};
      //                                   _errorMessage = null;
      //                                 });
      //                                 return 'This field is required.';
      //                               }
      //                               return null;
      //                             },
      //                             onSaved: (value) {
      //                               _formData['sub_domain'] = value;
      //                             },
      //                           ),
      //                         ),
      //                         _errors != null && _errors['sub_domain'] != null
      //                             ? Container(
      //                                 margin:
      //                                     EdgeInsets.symmetric(vertical: 5.0),
      //                                 width: MediaQuery.of(context).size.width *
      //                                     0.8,
      //                                 child: Text(
      //                                   _errors['sub_domain'],
      //                                   style: TextStyle(
      //                                       color: Colors.red[700],
      //                                       fontSize: 12.0),
      //                                 ),
      //                               )
      //                             : Container(),
      //                         Container(
      //                           margin: EdgeInsets.only(top: 10.0),
      //                           width: MediaQuery.of(context).size.width * 0.8,
      //                           child: TextFormField(
      //                             decoration: InputDecoration(
      //                                 enabledBorder: OutlineInputBorder(
      //                                   borderRadius: BorderRadius.all(
      //                                       Radius.circular(4)),
      //                                   borderSide: BorderSide(
      //                                       width: 1,
      //                                       color: Color.fromRGBO(
      //                                           221, 221, 221, 1)),
      //                                 ),
      //                                 focusedBorder: OutlineInputBorder(
      //                                   borderRadius: BorderRadius.all(
      //                                       Radius.circular(4)),
      //                                   borderSide: BorderSide(
      //                                       width: 1,
      //                                       color: Color.fromRGBO(
      //                                           221, 221, 221, 1)),
      //                                 ),
      //                                 fillColor: Colors.white,
      //                                 filled: true,
      //                                 hintText: 'username'),
      //                             keyboardType: TextInputType.text,
      //                             validator: (value) {
      //                               if (value.isEmpty) {
      //                                 setState(() {
      //                                   _errors = {};
      //                                   _errorMessage = null;
      //                                 });
      //                                 return 'This field is required.';
      //                               }
      //                               return null;
      //                             },
      //                             onSaved: (value) {
      //                               _formData['username'] = value;
      //                             },
      //                           ),
      //                         ),
      //                         _errors != null && _errors['username'] != null
      //                             ? Container(
      //                                 margin:
      //                                     EdgeInsets.symmetric(vertical: 5.0),
      //                                 width: MediaQuery.of(context).size.width *
      //                                     0.8,
      //                                 child: Text(
      //                                   _errors['username'],
      //                                   style: TextStyle(
      //                                       color: Colors.red[700],
      //                                       fontSize: 12.0),
      //                                 ),
      //                               )
      //                             : Container(),
      //                         Container(
      //                           margin: EdgeInsets.only(top: 10.0),
      //                           width: MediaQuery.of(context).size.width * 0.8,
      //                           child: TextFormField(
      //                             decoration: InputDecoration(
      //                                 enabledBorder: OutlineInputBorder(
      //                                   borderRadius: BorderRadius.all(
      //                                       Radius.circular(4)),
      //                                   borderSide: BorderSide(
      //                                       width: 1,
      //                                       color: Color.fromRGBO(
      //                                           221, 221, 221, 1)),
      //                                 ),
      //                                 focusedBorder: OutlineInputBorder(
      //                                   borderRadius: BorderRadius.all(
      //                                       Radius.circular(4)),
      //                                   borderSide: BorderSide(
      //                                       width: 1,
      //                                       color: Color.fromRGBO(
      //                                           221, 221, 221, 1)),
      //                                 ),
      //                                 fillColor: Colors.white,
      //                                 filled: true,
      //                                 hintText: 'email'),
      //                             keyboardType: TextInputType.emailAddress,
      //                             validator: (value) {
      //                               if (value.isEmpty) {
      //                                 setState(() {
      //                                   _errors = {};
      //                                   _errorMessage = null;
      //                                 });
      //                                 return 'This field is required.';
      //                               }
      //                               return null;
      //                             },
      //                             onSaved: (value) {
      //                               _formData['email'] = value;
      //                             },
      //                           ),
      //                         ),
      //                         _errors != null && _errors['email'] != null
      //                             ? Container(
      //                                 margin:
      //                                     EdgeInsets.symmetric(vertical: 5.0),
      //                                 width: MediaQuery.of(context).size.width *
      //                                     0.8,
      //                                 child: Text(
      //                                   _errors['email'],
      //                                   style: TextStyle(
      //                                       color: Colors.red[700],
      //                                       fontSize: 12.0),
      //                                 ),
      //                               )
      //                             : Container(),
      //                         Container(
      //                           margin: EdgeInsets.only(top: 10.0),
      //                           width: MediaQuery.of(context).size.width * 0.8,
      //                           child: TextFormField(
      //                             obscureText: true,
      //                             decoration: InputDecoration(
      //                                 enabledBorder: OutlineInputBorder(
      //                                   borderRadius: BorderRadius.all(
      //                                       Radius.circular(4)),
      //                                   borderSide: BorderSide(
      //                                       width: 1,
      //                                       color: Color.fromRGBO(
      //                                           221, 221, 221, 1)),
      //                                 ),
      //                                 focusedBorder: OutlineInputBorder(
      //                                   borderRadius: BorderRadius.all(
      //                                       Radius.circular(4)),
      //                                   borderSide: BorderSide(
      //                                       width: 1,
      //                                       color: Color.fromRGBO(
      //                                           221, 221, 221, 1)),
      //                                 ),
      //                                 fillColor: Colors.white,
      //                                 filled: true,
      //                                 hintText: 'password'),
      //                             keyboardType: TextInputType.emailAddress,
      //                             validator: (value) {
      //                               if (value.isEmpty) {
      //                                 setState(() {
      //                                   _errors = {};
      //                                   _errorMessage = null;
      //                                 });
      //                                 return 'This field is required.';
      //                               }
      //                               return null;
      //                             },
      //                             onSaved: (value) {
      //                               _formData['password'] = value;
      //                             },
      //                           ),
      //                         ),
      //                         _errors != null && _errors['password'] != null
      //                             ? Container(
      //                                 margin:
      //                                     EdgeInsets.symmetric(vertical: 5.0),
      //                                 width: MediaQuery.of(context).size.width *
      //                                     0.8,
      //                                 child: Text(
      //                                   _errors['password'],
      //                                   style: TextStyle(
      //                                       color: Colors.red[700],
      //                                       fontSize: 12.0),
      //                                 ),
      //                               )
      //                             : Container(),
      //                         _errorMessage != null
      //                             ? Container(
      //                                 margin: EdgeInsets.only(top: 10.0),
      //                                 width: MediaQuery.of(context).size.width *
      //                                     0.8,
      //                                 child: Text(
      //                                   _errorMessage,
      //                                   style: TextStyle(
      //                                       color: Colors.red[700],
      //                                       fontSize: 12.0),
      //                                 ),
      //                               )
      //                             : Container(),
      //                         Container(
      //                           margin: EdgeInsets.symmetric(vertical: 10.0),
      //                           width: MediaQuery.of(context).size.width * 0.8,
      //                           child: Row(
      //                             children: [
      //                               Container(
      //                                 child: Text('Have an account? '),
      //                               ),
      //                               GestureDetector(
      //                                 onTap: () {
      //                                   Navigator.pushReplacementNamed(
      //                                       context, '/sub_domain');
      //                                 },
      //                                 child: Text(
      //                                   'Login here',
      //                                   style: TextStyle(color: Colors.blue),
      //                                 ),
      //                               )
      //                             ],
      //                           ),
      //                         ),
      //                         !_isLoading
      //                             ? Container(
      //                                 width: MediaQuery.of(context).size.width *
      //                                     0.8,
      //                                 margin: EdgeInsets.only(top: 10.0),
      //                                 child: RaisedButton(
      //                                   color: Theme.of(context).buttonColor,
      //                                   onPressed: () {
      //                                     FocusScope.of(context).unfocus();
      //                                     if (!_isLoading) {
      //                                       _submitForm();
      //                                     }
      //                                   },
      //                                   child: Text(
      //                                     'Register',
      //                                     style: TextStyle(
      //                                         color: Colors.white,
      //                                         fontWeight: FontWeight.w500),
      //                                   ),
      //                                 ),
      //                               )
      //                             : Container(
      //                                 margin: EdgeInsets.only(top: 10.0),
      //                                 child: CircularProgressIndicator(
      //                                     valueColor:
      //                                         new AlwaysStoppedAnimation<Color>(
      //                                             Theme.of(context)
      //                                                 .buttonColor)),
      //                               )
      //                       ],
      //                     ),
      //                   )),
      //             ),
      //           ],
      //         ),
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
