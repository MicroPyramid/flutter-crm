import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_crm/bloc/auth_bloc.dart';
import 'package:flutter_crm/ui/widgets/bottleCrm_headerText.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_crm/ui/widgets/footer_button.dart';

class UserLogin extends StatefulWidget {
  UserLogin();
  @override
  State createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  Map _loginFormData = {"email": "", "password": ""};
  bool _isLoading = false;
  String _errorMessage;

  @override
  void initState() {
    super.initState();
  }

  _submitForm() async {
    if (!_loginFormKey.currentState.validate()) {
      return;
    }
    _loginFormKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    Map result = await authBloc.login(_loginFormData);
    if (result['error'] == false) {
      setState(() {
        _errorMessage = null;
      });
      await authBloc.getProfileDetails();
      Navigator.pushNamedAndRemoveUntil(
          context, '/sales_dashboard', (route) => false);
    } else if (result['error'] == true) {
      setState(() {
        _errorMessage = result['message'];
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

  OutlineInputBorder boxBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(width: 1, color: Colors.grey),
    );
  }

  Widget loginWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Form(
          key: _loginFormKey,
          child: Container(
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: Text(
                            'Login',
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth / 20)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  if (!_isLoading)
                                    Navigator.pushReplacementNamed(
                                        context, '/sub_domain');
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: screenHeight * 0.03,
                                  width: screenWidth * 0.1,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  child: Icon(
                                    Icons.keyboard_backspace_sharp,
                                    color: Colors.white,
                                    size: screenWidth / 20,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Your Subdomain',
                                style: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenWidth / 30)),
                              )
                            ],
                          ),
                        ),
                        Text(
                          "${authBloc.subDomainName}",
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth / 25)),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                        enabledBorder: boxBorder(),
                        focusedErrorBorder: boxBorder(),
                        focusedBorder: boxBorder(),
                        errorBorder: boxBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        errorStyle: GoogleFonts.robotoSlab(),
                        hintStyle: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(fontSize: 14.0)),
                        hintText: 'Enter Email Address'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          _errorMessage = null;
                        });
                        return 'This field is required.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _loginFormData['email'] = value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        enabledBorder: boxBorder(),
                        focusedErrorBorder: boxBorder(),
                        focusedBorder: boxBorder(),
                        errorBorder: boxBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        errorStyle: GoogleFonts.robotoSlab(),
                        hintStyle: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(fontSize: 14.0)),
                        hintText: 'Enter Password'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          _errorMessage = null;
                        });
                        return 'This field is required.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _loginFormData['password'] = value;
                    },
                  ),
                ),
                _errorMessage != null
                    ? Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text(
                          _errorMessage,
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                  color: Colors.red[700], fontSize: 12.0)),
                        ),
                      )
                    : Container(),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/forgot_password');
                    },
                    child: Text(
                      "Forgot Password?",
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth / 25)),
                    ),
                  ),
                ),
                !_isLoading
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.only(top: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Login',
                                      style: GoogleFonts.robotoSlab(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: screenWidth / 24)),
                                    ),
                                    Icon(Icons.arrow_forward,
                                        color: Colors.white)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Color.fromRGBO(73, 163, 69, 1))),
                      ),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeaderTextWidget(),
                  loginWidget(),
                  FooterBtnWidget(
                    labelText: "Don't have an Account?",
                    buttonLabelText: "Register Here",
                    routeName: "/user_register",
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
