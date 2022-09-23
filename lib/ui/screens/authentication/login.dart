import 'package:bottle_crm/responsive.dart';
import 'package:bottle_crm/utils/validations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:bottle_crm/bloc/auth_bloc.dart';
import 'package:bottle_crm/utils/utils.dart';

import '../../../utils/utils.dart';

class Login extends StatefulWidget {
  Login();
  @override
  State createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  Map _loginFormData = {"email": "", "password": ""};
  bool _isLoading = false;
  String _errorMessage = '';

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
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }
    _loginFormKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    Map result = {};
    result = await authBloc.login(_loginFormData);
    if (result['error'] == false) {
      setState(() {
        _errorMessage = '';
      });
      await authBloc.fetchCompanies();
      await FirebaseAnalytics.instance.logEvent(name: "login");
      Navigator.pushNamedAndRemoveUntil(
          context, '/companies_List', (route) => false);
    } else if (result['error'] == true) {
      setState(() {
        _errorMessage = result['errors'];
      });
    } else {
      setState(() {
        _errorMessage = '';
      });
      showErrorMessage(context, result['message'].toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  showErrorMessage(BuildContext context, String message) {
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

  Widget loginWidget() {
    return Responsive(
        mobile: buildMobileScreen(),
        tablet: buildTabletScreen(),
        desktop: Container());
  }

  buildMobileScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.1),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            width: screenWidth,
            height: screenHeight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                              color: Color.fromARGB(255, 59, 59, 59),
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth / 15),
                        ),
                        SvgPicture.asset(
                          'assets/images/logo.svg',
                          width: screenWidth * 0.3,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Container(
                    child: Form(
                        key: _loginFormKey,
                        child: Column(
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(bottom: 5.0),
                                      child: RichText(
                                        text: TextSpan(
                                          text: '* ',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: screenWidth / 25,
                                              fontWeight: FontWeight.w500),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Email ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: screenWidth / 24,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                      )),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.email_outlined,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          contentPadding: EdgeInsets.all(12.0),
                                          enabledBorder: boxBorder(),
                                          focusedErrorBorder: boxBorder(),
                                          focusedBorder: boxBorder(),
                                          errorBorder: boxBorder(),
                                          fillColor: Colors.white,
                                          filled: true,
                                          hintStyle: TextStyle(fontSize: 14.0)),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) =>
                                          FieldValidators.emailFieldValidation(
                                              value!),
                                      onSaved: (value) {
                                        _loginFormData['email'] = value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(bottom: 5.0),
                                      child: RichText(
                                        text: TextSpan(
                                          text: '* ',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: screenWidth / 25,
                                              fontWeight: FontWeight.w500),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Password ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: screenWidth / 24,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                      )),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    child: TextFormField(
                                      obscureText:
                                          _isPasswordVisible ? false : true,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.lock_outline,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isPasswordVisible =
                                                      !_isPasswordVisible;
                                                });
                                              },
                                              icon: Icon(
                                                  _isPasswordVisible
                                                      ? Icons
                                                          .visibility_outlined
                                                      : Icons
                                                          .visibility_off_outlined,
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
                                      validator: (value) =>
                                          FieldValidators.passwordValidation(
                                              value!),
                                      onSaved: (value) {
                                        _loginFormData['password'] = value;
                                      },
                                    ),
                                  ),
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
                                : SizedBox(
                                    height: 0.0,
                                  ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/forgot_password');
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: screenWidth / 24,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            !_isLoading
                                ? Container(
                                    width: screenWidth,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          _submitForm();
                                        },
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth / 22),
                                        )),
                                  )
                                : Container(
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Color.fromRGBO(
                                                    62, 121, 247, 1))),
                                  )
                          ],
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      ' Or Connect With ',
                      style: TextStyle(
                          color: Colors.grey, fontSize: screenWidth / 24),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey[400]!),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/google-icon.png',
                                width: screenWidth / 18),
                            SizedBox(width: 8.0),
                            Text(
                              'Login With Google',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: screenWidth / 24,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        )),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account yet? ",
                        style: TextStyle(
                            color: Colors.grey, fontSize: screenWidth / 24),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: screenWidth / 24),
                        ),
                      )
                    ],
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildTabletScreen() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0))),
      height: screenHeight * 0.9,
      width: screenWidth,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.black54, fontSize: screenWidth / 24),
                  ),
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: screenWidth * 0.2,
                  )
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            Container(
              width: screenWidth * 0.5,
              child: Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email',
                                style: TextStyle(
                                    fontSize: screenWidth / 40,
                                    fontWeight: FontWeight.w500)),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email_outlined,
                                        color: Theme.of(context).primaryColor),
                                    contentPadding: EdgeInsets.all(12.0),
                                    enabledBorder: boxBorder(),
                                    focusedErrorBorder: boxBorder(),
                                    focusedBorder: boxBorder(),
                                    errorBorder: boxBorder(),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintStyle: TextStyle(fontSize: 14.0)),
                                keyboardType: TextInputType.emailAddress,
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
                                  _loginFormData['email'] = value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Password',
                                style: TextStyle(
                                    fontSize: screenWidth / 40,
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
                                  _loginFormData['password'] = value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      _errorMessage != ''
                          ? Container(
                              child: Text(
                                _errorMessage,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: screenWidth / 45),
                              ),
                            )
                          : Container(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/forgot_password');
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 20.0),
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: screenWidth / 40,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      !_isLoading
                          ? Container(
                              width: screenWidth,
                              child: ElevatedButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    _errorMessage = '';
                                    _submitForm();
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth / 35),
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
            Container(
              width: screenWidth * 0.5,
              margin: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                '-------------- Or Connect With --------------',
                style:
                    TextStyle(color: Colors.grey, fontSize: screenWidth / 45),
              ),
            ),
            Container(
              width: screenWidth * 0.5,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.grey[400]!),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/google-icon.png',
                          width: screenWidth / 25),
                      SizedBox(width: 8.0),
                      Text(
                        'Sign In With Google',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: screenWidth / 40,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  )),
            ),
            SizedBox(
              height: screenHeight * 0.2,
            ),
            Container(
                width: screenWidth * 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account yet? ",
                      style: TextStyle(
                          color: Colors.grey, fontSize: screenWidth / 40),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: screenWidth / 40),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(color: Color.fromARGB(226, 73, 128, 255)),
          child: loginWidget()),
    );
  }
}
