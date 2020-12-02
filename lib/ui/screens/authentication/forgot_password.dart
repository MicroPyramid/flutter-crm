import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/auth_bloc.dart';
import 'package:flutter_crm/ui/widgets/bottleCrm_logo.dart';
import 'package:flutter_crm/ui/widgets/footer_button.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
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
  String _successMessage = "";

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
        _successMessage = result['message'];
      });
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
          style:
              GoogleFonts.robotoSlab(textStyle: TextStyle(color: Colors.red))),
      isDismissible: false,
      mainButton: FlatButton(
        child: Text('TRY AGAIN',
            style: GoogleFonts.robotoSlab(
                textStyle: TextStyle(color: Theme.of(context).accentColor))),
        onPressed: () {
          Navigator.of(context).pop(true);
          _submitForm();
        },
      ),
      duration: Duration(seconds: 10),
    )..show(context);
  }

  Widget forgotPasswordWidget() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                vertical: 10.0, horizontal: screenWidth * 0.05),
            child: Text('Forgot Password',
                style: GoogleFonts.robotoSlab(
                    textStyle: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth / 20))),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: 15.0),
            child: Text(
                'Please enter your email address below and we will send you information to change your password.',
                style: GoogleFonts.robotoSlab(
                    textStyle: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: screenWidth / 27))),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Form(
                key: _forgotPasswordFormKey,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextFormField(
                          enabled: _successMessage == "" ? true : false,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(12.0),
                              enabledBorder: boxBorder(),
                              disabledBorder: boxBorder(),
                              focusedErrorBorder: boxBorder(),
                              focusedBorder: boxBorder(),
                              errorBorder: boxBorder(),
                              fillColor: _successMessage == ""
                                  ? Colors.white
                                  : Colors.grey[300],
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
                            _email = value;
                          },
                        ),
                      ),
                      !_isLoading && _successMessage == ""
                          ? GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                _submitForm();
                              },
                              child: Container(
                                padding: EdgeInsets.all(17.0),
                                margin: EdgeInsets.only(left: 10.0),
                                decoration: BoxDecoration(
                                  color: submitButtonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.0)),
                                ),
                                width: screenWidth * 0.15,
                                height: 48.0,
                                child: SvgPicture.asset(
                                    'assets/images/arrow_forward.svg'),
                              ),
                            )
                          : _isLoading
                              ? Container(
                                  margin: EdgeInsets.only(left: 10.0),
                                  width: screenWidth * 0.12,
                                  height: 40.0,
                                  child: CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              submitButtonColor)),
                                )
                              : Container()
                    ],
                  ),
                )),
          ),
          _successMessage != ""
              ? Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: screenWidth * 0.1),
                  child: Text(_successMessage,
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth / 24))),
                )
              : Container(),
          _errorMessage != null
              ? Container(
                  margin: EdgeInsets.only(top: 10.0, left: screenWidth * 0.06),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _errorMessage,
                    style: GoogleFonts.robotoSlab(
                        textStyle:
                            TextStyle(color: Colors.red[700], fontSize: 12.0)),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderTextWidget(),
                forgotPasswordWidget(),
                FooterBtnWidget(
                  labelText: "",
                  buttonLabelText: "Back To Login",
                  routeName: "/user_login",
                )
              ]),
        ),
      ),
    );
  }
}
