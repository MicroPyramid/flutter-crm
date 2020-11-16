import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/auth_bloc.dart';

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
      Navigator.pushReplacementNamed(context, '/forgot_password_text');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 15.0),
                child: Text('Forgot Password',
                    style: TextStyle(
                        color: Color.fromRGBO(51, 51, 51, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: MediaQuery.of(context).size.width / 18)),
              ),
              Container(
                child: Form(
                    key: _forgotPasswordFormKey,
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(221, 221, 221, 1)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(221, 221, 221, 1)),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Email'),
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
                                _email = value;
                              },
                            ),
                          ),
                          _errorMessage != null
                              ? Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    _errorMessage,
                                    style: TextStyle(
                                        color: Colors.red[700], fontSize: 12.0),
                                  ),
                                )
                              : Container(),
                          !_isLoading
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  margin: EdgeInsets.symmetric(vertical: 10.0),
                                  child: RaisedButton(
                                    color: Theme.of(context).buttonColor,
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      if (!_isLoading) {
                                        _submitForm();
                                      }
                                    },
                                    child: Text(
                                      'Submit',
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
                                              Theme.of(context).buttonColor)),
                                ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              children: [
                                Container(
                                  child: Text('Already Have An Account? '),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/sub_domain');
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ForgotPasswordText extends StatefulWidget {
  ForgotPasswordText();
  @override
  State createState() => _ForgotPasswordTextState();
}

class _ForgotPasswordTextState extends State<ForgotPasswordText> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          Container(
            child: Text('Django CRM',
                style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontWeight: FontWeight.w500,
                    fontSize: MediaQuery.of(context).size.width / 15)),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "We've emailed you instructions for setting your password, if an account exists with the email you entered. You should receive them shortly.",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width / 22),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "If you don't receive an email, please make sure you've entered the address you registered with, and check your spam folder.",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width / 22),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/sub_domain');
              },
              child: Text(
                'Login',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: MediaQuery.of(context).size.width / 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
