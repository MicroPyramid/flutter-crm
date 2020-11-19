import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/auth_bloc.dart';
import 'package:flutter_crm/ui/widgets/login_headerTextWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_crm/ui/widgets/login_footerBtnWidget.dart';
import 'dart:math' as math;

class UserLogin extends StatefulWidget {
  var subDomainName;

  UserLogin(this.subDomainName);
  @override
  State createState() => _UserLoginState(subDomainName);
}

class _UserLoginState extends State<UserLogin> {
  _UserLoginState(this._subDomainName);
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  Map _loginFormData = {"email": "", "password": ""};
  bool _isLoading = false;
  String _errorMessage;
  String _subDomainName;

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
      borderSide: BorderSide(width: 0, color: Color.fromRGBO(221, 221, 221, 1)),
    );
  }

  Widget loginWidget(){
    return Container(
      child: Form(
          key: _loginFormKey,
          child: Container(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: Text('Login',
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              fontSize: screenWidth / 20)),),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            children: [
                              SizedBox(
                                width: screenWidth*0.13,
                                height: screenHeight*0.03,
                                child: FlatButton(
                                    child: Transform.rotate(
                                        angle: 180*math.pi/180,
                                        child: Icon(Icons.arrow_right_alt, color: Colors.white)),
                                    shape: boxBorder(),
                                    color: Colors.black,
                                    onPressed: (){
                                      Navigator.popAndPushNamed(context, '/sub_domain');
                                      print('PRESSED!, going to subDomain Page.');
                                    }),
                              ),
                              SizedBox(width: 10,),
                              Text('Your Sub-domain :',
                              style: GoogleFonts.robotoSlab(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: screenWidth / 35)),)
                            ],
                          ),
                        ),
                        Text("$_subDomainName.bottlecrm.com",
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth / 27)),)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    decoration: InputDecoration(
                        enabledBorder: boxBorder(),
                        focusedBorder: boxBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Enter Email Address'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
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
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        enabledBorder: boxBorder(),
                        focusedBorder: boxBorder(),
                        fillColor: Colors.white,
                        filled: true,
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
                  margin: EdgeInsets.only(top: 10.0),
                  width: MediaQuery.of(context).size.width *
                      0.8,
                  child: Text(
                    _errorMessage,
                    style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 12.0),
                  ),
                )
                    : Container(),
                // Container(
                //   margin: EdgeInsets.symmetric(vertical: 10.0),
                //   width: MediaQuery.of(context).size.width * 0.8,
                //   child: Row(
                //     children: [
                //       Container(
                //         child: Text('New Here? '),
                //       ),
                //       GestureDetector(
                //         onTap: () {
                //           Navigator.pushNamed(
                //               context, '/user_register');
                //         },
                //         child: Text(
                //           'Register',
                //           style: TextStyle(color: Colors.blue),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/forgot_password');
                        },
                        child: Text(
                          "Forgot Password?",
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                  color: Color.fromRGBO(5, 24, 62, 1),
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth / 30)),
                        ),
                      )
                    ],
                  ),
                ),
                !_isLoading
                    ? Container(
                  width: MediaQuery.of(context).size.width *
                      0.8,
                  height: MediaQuery.of(context).size.height *
                      0.06,
                  margin: EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RaisedButton.icon(
                        shape: boxBorder(),
                        color: Colors.green[500],
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (!_isLoading) {
                            _submitForm();
                          }
                        },
                        label: Text(
                          '  Login  ',
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800)),
                        ),
                        icon: Icon(Icons.arrow_forward, color: Colors.white,),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text('OR'),
                      // ),
                      // RaisedButton.icon(
                      //     color: Colors.white,
                      //     shape: boxBorder(),
                      //     onPressed: (){},
                      //     icon: ImageIcon(
                      //       AssetImage('assets/images/google_logo.png'),
                      //       color: Colors.red,
                      //     ),
                      //     label: Text(
                      //         'Google Login',
                      //         style: GoogleFonts.robotoSlab(
                      //             textStyle: TextStyle(
                      //                 color: Colors.red,
                      //                 fontWeight: FontWeight.w800,))
                      //     )
                      // ),
                    ],
                  ),
                )
                    : Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: CircularProgressIndicator(
                      valueColor:
                      new AlwaysStoppedAnimation<Color>(
                          Theme.of(context)
                              .buttonColor)),
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
                  FooterBtnWidget("Don't have an Account ?", "Register Here", '/user_register'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

