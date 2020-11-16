import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/auth_bloc.dart';

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
    if (result['status'] == 'success') {
      setState(() {
        _errorMessage = null;
      });
      await authBloc.getProfileDetails();
      Navigator.pushNamedAndRemoveUntil(
          context, '/sales_dashboard', (route) => false);
    } else if (result['status'] == 'failure') {
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text('bottlecrm',
                        style: TextStyle(
                            color: Color.fromRGBO(51, 51, 51, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: MediaQuery.of(context).size.width / 15)),
                  ),
                  Container(
                    child: Form(
                        key: _loginFormKey,
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color.fromRGBO(
                                                221, 221, 221, 1)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color.fromRGBO(
                                                221, 221, 221, 1)),
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: 'email'),
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
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color.fromRGBO(
                                                221, 221, 221, 1)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color.fromRGBO(
                                                221, 221, 221, 1)),
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: 'password'),
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
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Row(
                                  children: [
                                    Container(
                                      child: Text('New Here? '),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/user_register');
                                      },
                                      child: Text(
                                        'Register',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Row(
                                  children: [
                                    Container(
                                      child: Text('Forgot Password '),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/forgot_password');
                                      },
                                      child: Text(
                                        'Click Here?',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              !_isLoading
                                  ? Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      margin: EdgeInsets.only(top: 10.0),
                                      child: RaisedButton(
                                        color: Theme.of(context).buttonColor,
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          if (!_isLoading) {
                                            _submitForm();
                                          }
                                        },
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(top: 10.0),
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Theme.of(context)
                                                      .buttonColor)),
                                    )
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _subDomainName {}
