import 'package:bottle_crm/responsive.dart';
import 'package:bottle_crm/utils/validations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:bottle_crm/bloc/auth_bloc.dart';
import 'package:bottle_crm/utils/utils.dart';

import '../../../utils/utils.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword();
  @override
  State createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _forgotPasswordFormKey = GlobalKey<FormState>();
  String? _email = '';
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
    if (!_forgotPasswordFormKey.currentState!.validate()) {
      return;
    }
    _forgotPasswordFormKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    Map result = await authBloc.forgotPassword({'email': _email});
    if (result['error'] == false) {
      setState(() {
        _errorMessage = '';
      });
      await authBloc.fetchCompanies();
      await FirebaseAnalytics.instance.logEvent(name: "Forget Password");
      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', (route) => false);
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
              content: Text('Something went wrong'),
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

  Widget forgotPasswordWidget() {
    return Responsive(
        mobile: buildMobileScreen(),
        tablet: buildTabletScreen(),
        desktop: Container());
  }

  buildMobileScreen() {
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.1),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            width: screenWidth,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Forgot Password',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth / 18),
                        ),
                        SvgPicture.asset(
                          'assets/images/logo.svg',
                          width: screenWidth * 0.3,
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Form(
                        key: _forgotPasswordFormKey,
                        child: Column(
                          children: [
                            Container(
                                child: Text(
                              'Please enter your email address below and we will send you information to change your password.',
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: screenWidth / 27,
                                  fontWeight: FontWeight.w600),
                            )),
                            SizedBox(height: 10.0),
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
                                      validator: (value) =>FieldValidators.emailFieldValidation(value!),
                                      onSaved: (value) {
                                        _email = value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            !_isLoading
                                ? Container(
                                    width: screenWidth,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
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
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Color.fromRGBO(
                                                    62, 121, 247, 1))),
                                  )
                          ],
                        )),
                  ),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Back to ",
                        style: TextStyle(
                            color: Colors.grey, fontSize: screenWidth / 24),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          'Login',
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
        ),
      ],
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Forgot Password',
                    style: TextStyle(
                        color: Colors.black54, fontSize: screenWidth / 26),
                  ),
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: screenWidth * 0.2,
                  )
                ],
              ),
            ),
            Container(
              width: screenWidth * 0.6,
              child: Form(
                  key: _forgotPasswordFormKey,
                  child: Column(
                    children: [
                      Container(
                          child: Text(
                        'Please enter your email address below and we will send you information to change your password.',
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: screenWidth / 42,
                            fontWeight: FontWeight.w600),
                      )),
                      SizedBox(height: 10.0),
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
                                  _email = value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      !_isLoading
                          ? Container(
                              width: screenWidth,
                              child: ElevatedButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    _submitForm();
                                  },
                                  child: Text(
                                    'Submit',
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
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Back to ",
                  style:
                      TextStyle(color: Colors.grey, fontSize: screenWidth / 40),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: screenWidth / 40),
                  ),
                )
              ],
            )),
            SizedBox(height: screenHeight * 0.05)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(73, 128, 255, 1.0)
          ),
          child: forgotPasswordWidget()),
    );
  }
}
