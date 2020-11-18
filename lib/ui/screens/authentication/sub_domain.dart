import 'package:flushbar/flushbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/auth_bloc.dart';
import 'package:flutter_crm/utils/utils.dart';

class SubDomain extends StatefulWidget {
  SubDomain();
  @override
  State createState() => _SubDomainState();
}

class _SubDomainState extends State<SubDomain> {
  final GlobalKey<FormState> _subDomainFormKey = GlobalKey<FormState>();
  String _subDomainName;
  bool _isLoading = false;
  String _errorMessage;

  @override
  void initState() {
    super.initState();
  }

  _submitForm() async {
    if (!_subDomainFormKey.currentState.validate()) {
      return;
    }
    _subDomainFormKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    Map result = await authBloc.validateDomain({'sub_domain': _subDomainName});
    if (result['error'] == false) {
      setState(() {
        _errorMessage = null;
      });
      Navigator.pushNamed(context, '/user_login');
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

  Widget subDomainWidget() {
    return Container(
      child: Column(
        children: [
          Container(
            child: Text(
              'Welcome!',
              style: GoogleFonts.robotoSlab(
                  textStyle: TextStyle(
                      color: Color.fromRGBO(5, 24, 62, 1),
                      fontWeight: FontWeight.w500,
                      fontSize: screenWidth / 22)),
            ),
          ),
          Container(
              child: Column(
            children: [
              Text('Enter Sub-Domain Here to',
                  style: GoogleFonts.robotoSlab(
                      textStyle: TextStyle(
                          color: Color.fromRGBO(5, 24, 62, 1),
                          fontWeight: FontWeight.w500,
                          fontSize: screenWidth / 20))),
              Text('Login Your Account',
                  style: GoogleFonts.robotoSlab(
                      textStyle: TextStyle(
                          color: Color.fromRGBO(5, 24, 62, 1),
                          fontWeight: FontWeight.w500,
                          fontSize: screenWidth / 20)))
            ],
          )),
          Container(
            margin: EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.75,
                  child: TextFormField(
                    decoration: InputDecoration(
                        enabledBorder: boxBorder(),
                        focusedErrorBorder: boxBorder(),
                        focusedBorder: boxBorder(),
                        errorBorder: boxBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Enter Subdomain',
                        hintStyle: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(fontSize: 14.0))),
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
                      _subDomainName = value;
                    },
                  ),
                ),
                !_isLoading
                    ? GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          _submitForm();
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(73, 163, 69, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          width: screenWidth * 0.15,
                          height: 55.0,
                          child: Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(left: 10.0),
                        width: screenWidth * 0.12,
                        height: 40.0,
                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Color.fromRGBO(73, 163, 69, 1))),
                      )
              ],
            ),
          ),
          _errorMessage != null
              ? Container(
                  margin: EdgeInsets.only(top: 10.0, left: screenWidth * 0.06),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red[700], fontSize: 12.0),
                  ),
                )
              : Container(),
          Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                "Forgot Sub-Domain",
                style: GoogleFonts.robotoSlab(
                    textStyle: TextStyle(
                        color: Color.fromRGBO(5, 24, 62, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth / 23)),
              ))
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
              "Don't Have An Account?",
              style: GoogleFonts.robotoSlab(
                  textStyle: TextStyle(
                      color: Color.fromRGBO(5, 24, 62, 1),
                      fontWeight: FontWeight.w500,
                      fontSize: screenWidth / 25)),
            ),
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.pushNamed(context, '/user_register');
            },
            child: Container(
              alignment: Alignment.center,
              height: screenHeight * 0.06,
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Text(
                'Register Here',
                style: GoogleFonts.robotoSlab(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth / 22)),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          child: Form(
            key: _subDomainFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [headerTextWidget(), subDomainWidget(), footerButton()],
            ),
          ),
        ),
      )),
    );
  }
}
