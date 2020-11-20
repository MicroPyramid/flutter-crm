import 'dart:async';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/auth_bloc.dart';
import 'package:flutter_crm/ui/widgets/bottleCrm_headerText.dart';
import 'package:flutter_crm/ui/widgets/footer_button.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword();
  @override
  State createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _forgotPasswordFormKey = GlobalKey<FormState>();
  String _email;
  bool _isLoading = false;
  String _errorMessage;
  bool _isBtnEnabled = true;

  @override
  void initState() {
    super.initState();
  }

  _submitForm() async {
    if (!_forgotPasswordFormKey.currentState.validate()) {
      return;
    }
    _forgotPasswordFormKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    Map result = await authBloc.forgotPassword({'email': _email});
    if (result['error'] == false) {
      setState(() {
        _errorMessage = null;
      });
      // Navigator.pushReplacementNamed(context, '/forgot_password_text');
    } else if (result['error'] == true) {
      setState(() {
        _errorMessage = result['errors']['non_field_errors'][0];
      });
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

  Widget forgotPasswordWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 15.0),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text('Forgot Password',
              style: GoogleFonts.robotoSlab(
                  textStyle: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth / 20))),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text('Please enter your email address below following which a reset-password email will be sent to you.',
              style: GoogleFonts.robotoSlab(
                  textStyle: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    // fontWeight: FontWeight.w700,
                  ))),
        ),
        Container(
          child: Form(
              key: _forgotPasswordFormKey,

              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: TextFormField(
                        decoration: InputDecoration(
                            enabledBorder: boxBorder(),
                            focusedBorder: boxBorder(),
                            filled: true,
                            hintText: 'Enter Email Address'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              _errorMessage = null;
                              _isBtnEnabled= !_isBtnEnabled;
                            });
                            return 'This field is required.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value;
                        },
                      ),
                    ),
                    _errorMessage != null
                        ? Container(
                      margin: EdgeInsets.only(top: 10.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        _errorMessage,
                        style: TextStyle(
                            color: Colors.red[700], fontSize: 12.0),
                      ),
                    )
                        : Container(),
                    SizedBox(width: 10,),
                    !_isLoading
                        ? Container(
                      height: screenHeight * 0.06,
                      width: screenWidth * 0.15,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: RaisedButton(
                          color: Color.fromRGBO(73, 163, 69, 1),
                          disabledColor: Colors.green.shade200,
                          shape: boxBorder(),
                          onPressed: _isBtnEnabled?() {
                            FocusScope.of(context).unfocus();
                            if (!_isLoading) {
                              _submitForm();
                              setState(() {
                                _isBtnEnabled= !_isBtnEnabled;
                                Fluttertoast.showToast(
                                  toastLength: Toast.LENGTH_LONG,
                                    msg: 'Password-reset Email has been sent.',);
                                Timer(const Duration(seconds: 2), () {
                                  setState(() {
                                    Navigator.pushReplacementNamed(context, '/sub_domain');
                                  });
                                });
                              });
                            }
                          }:null,
                          child: Icon(
                            Icons.arrow_right_alt_outlined,
                            size: 30,
                            color: Colors.white,)
                      ),
                    )
                        : Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: CircularProgressIndicator(
                          valueColor:
                          new AlwaysStoppedAnimation<Color>(
                              Theme.of(context).buttonColor)),
                    ),

                  ],
                ),

              )),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            width: screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children : [
                HeaderTextWidget(),
                forgotPasswordWidget(),
                FooterBtnWidget(
                  labelText: "",
                  buttonLabelText: "Back to Login",
                  routeName: "/user_login",
                )]),
          )
          // FooterBtnWidget()
        ],
      ),
    );
  }
}
