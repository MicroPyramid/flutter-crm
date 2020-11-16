import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/auth_bloc.dart';

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
    if (result['status'] == 'success') {
      setState(() {
        _errorMessage = null;
      });
      Navigator.pushReplacementNamed(context, '/sub_domain');
    } else if (result['status'] == 'failure') {
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
                        key: _registerFormKey,
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
                                      hintText: 'Sub-domain'),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        _errors = {};
                                        _errorMessage = null;
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
                                      margin:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        _errors['sub_domain'],
                                        style: TextStyle(
                                            color: Colors.red[700],
                                            fontSize: 12.0),
                                      ),
                                    )
                                  : Container(),
                              Container(
                                margin: EdgeInsets.only(top: 10.0),
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
                                      hintText: 'username'),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        _errors = {};
                                        _errorMessage = null;
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
                                      margin:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        _errors['username'],
                                        style: TextStyle(
                                            color: Colors.red[700],
                                            fontSize: 12.0),
                                      ),
                                    )
                                  : Container(),
                              Container(
                                margin: EdgeInsets.only(top: 10.0),
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
                                      setState(() {
                                        _errors = {};
                                        _errorMessage = null;
                                      });
                                      return 'This field is required.';
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
                                      margin:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        _errors['email'],
                                        style: TextStyle(
                                            color: Colors.red[700],
                                            fontSize: 12.0),
                                      ),
                                    )
                                  : Container(),
                              Container(
                                margin: EdgeInsets.only(top: 10.0),
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
                                        _errors = {};
                                        _errorMessage = null;
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
                                      margin:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        _errors['password'],
                                        style: TextStyle(
                                            color: Colors.red[700],
                                            fontSize: 12.0),
                                      ),
                                    )
                                  : Container(),
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
                                      child: Text('Have an account? '),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacementNamed(
                                            context, '/sub_domain');
                                      },
                                      child: Text(
                                        'Login here',
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
                                          'Register',
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
