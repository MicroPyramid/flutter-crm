import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crm/bloc/user_bloc.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:textfield_tags/textfield_tags.dart';

class CreateUser extends StatefulWidget {
  CreateUser();
  @override
  State createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final GlobalKey<FormState> _createUserFormKey = GlobalKey<FormState>();
  FilePickerResult result;
  PlatformFile file;
  Map _errors;
  bool _isLoading = false;
  FocusNode _focuserr;
  FocusNode _usernameFocusNode = new FocusNode();
  FocusNode _passwordFocusNode = new FocusNode();
  FocusNode _emailFocusNode = new FocusNode();
  bool accessError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_focuserr != null) {
      _focuserr.dispose();
    }
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();

    super.dispose();
  }

  focusError() {
    setState(() {
      FocusManager.instance.primaryFocus.unfocus();
      FocusScope.of(context).requestFocus(_focuserr);
    });
  }

  _saveForm() async {
    _focuserr = null;
    setState(() {
      _errors = null;
    });
    if (!_createUserFormKey.currentState.validate()) {
      focusError();
      return;
    }
    _createUserFormKey.currentState.save();
    Map _result;

    setState(() {
      _isLoading = true;
    });
    if (userBloc.currentEditUserId != null) {
      _result = await userBloc.editUser();
      // _result = await userBloc.createUser();
    } else {
      _result = await userBloc.createUser();
    }
    setState(() {
      _isLoading = false;
    });

    if (_result['error'] == false) {
      setState(() {
        _errors = null;
      });
      showToast(_result['message']);
      Navigator.pushReplacementNamed(context, '/users_list');
    } else if (_result['error'] == true) {
      setState(() {
        _errors = _result['errors'];
      });
      if (_errors['name'] != null && _focuserr == null) {
        _focuserr = _usernameFocusNode;
        focusError();
      }
      if (_errors['password'] != null && _focuserr == null) {
        _focuserr = _passwordFocusNode;
        focusError();
      }
    } else {
      setState(() {
        _errors = null;
      });
      showErrorMessage(context, 'Something went wrong');
    }
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
          _saveForm();
        },
      ),
      duration: Duration(seconds: 10),
    )..show(context);
  }

  Widget _buildForm() {
    return Container(
      child: Form(
        key: _createUserFormKey,
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'First Name :',
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth / 25)),
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      initialValue: userBloc.currentEditUser['first_name'],
                      controller: null,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          enabledBorder: boxBorder(),
                          focusedErrorBorder: boxBorder(),
                          focusedBorder: boxBorder(),
                          errorBorder: boxBorder(),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Enter First Name',
                          errorStyle: GoogleFonts.robotoSlab(),
                          hintStyle: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(fontSize: 14.0))),
                      keyboardType: TextInputType.url,
                      onSaved: (value) {
                        userBloc.currentEditUser['first_name'] = value;
                      },
                    ),
                  ),
                  _errors != null && _errors['first_name'] != null
                      ? Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _errors['first_name'][0],
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color: Colors.red[700], fontSize: 12.0)),
                          ),
                        )
                      : Container(),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'Last Name :',
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth / 25)),
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      initialValue: userBloc.currentEditUser['last_name'],
                      controller: null,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          enabledBorder: boxBorder(),
                          focusedErrorBorder: boxBorder(),
                          focusedBorder: boxBorder(),
                          errorBorder: boxBorder(),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Enter Last Name',
                          errorStyle: GoogleFonts.robotoSlab(),
                          hintStyle: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(fontSize: 14.0))),
                      keyboardType: TextInputType.url,
                      onSaved: (value) {
                        userBloc.currentEditUser['last_name'] = value;
                      },
                    ),
                  ),
                  _errors != null && _errors['last_name'] != null
                      ? Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _errors['last_name'][0],
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color: Colors.red[700], fontSize: 12.0)),
                          ),
                        )
                      : Container(),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Username',
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth / 25)),
                          children: <TextSpan>[
                            TextSpan(
                                text: '* ',
                                style: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(color: Colors.red))),
                            TextSpan(
                                text: ': ', style: GoogleFonts.robotoSlab())
                          ],
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      focusNode: _usernameFocusNode,
                      initialValue: userBloc.currentEditUser['username'],
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          enabledBorder: boxBorder(),
                          focusedErrorBorder: boxBorder(),
                          focusedBorder: boxBorder(),
                          errorBorder: boxBorder(),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Enter Username',
                          errorStyle: GoogleFonts.robotoSlab(),
                          hintStyle: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(fontSize: 14.0))),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          if (_focuserr == null) {
                            _focuserr = _usernameFocusNode;
                          }
                          return 'This field is required.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userBloc.currentEditUser['username'] = value;
                      },
                    ),
                  ),
                  _errors != null && _errors['username'] != null
                      ? Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _errors['username'][0],
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color: Colors.red[700], fontSize: 12.0)),
                          ),
                        )
                      : Container(),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Password',
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth / 25)),
                          children: <TextSpan>[
                            TextSpan(
                                text: '* ',
                                style: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(color: Colors.red))),
                            TextSpan(
                                text: ': ', style: GoogleFonts.robotoSlab())
                          ],
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      obscureText: true,
                      focusNode: _passwordFocusNode,
                      initialValue: userBloc.currentEditUser['password'],
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          enabledBorder: boxBorder(),
                          focusedErrorBorder: boxBorder(),
                          focusedBorder: boxBorder(),
                          errorBorder: boxBorder(),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Enter Password',
                          errorStyle: GoogleFonts.robotoSlab(),
                          hintStyle: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(fontSize: 14.0))),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          if (_focuserr == null) {
                            _focuserr = _usernameFocusNode;
                          }
                          return 'This field is required.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userBloc.currentEditUser['password'] = value;
                      },
                    ),
                  ),
                  _errors != null && _errors['password'] != null
                      ? Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _errors['password'][0],
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color: Colors.red[700], fontSize: 12.0)),
                          ),
                        )
                      : Container(),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Email Address',
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth / 25)),
                          children: <TextSpan>[
                            TextSpan(
                                text: '* ',
                                style: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(color: Colors.red))),
                            TextSpan(
                                text: ': ', style: GoogleFonts.robotoSlab())
                          ],
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      focusNode: _emailFocusNode,
                      initialValue: userBloc.currentEditUser['email'],
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          enabledBorder: boxBorder(),
                          focusedErrorBorder: boxBorder(),
                          focusedBorder: boxBorder(),
                          errorBorder: boxBorder(),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Enter Email Address',
                          errorStyle: GoogleFonts.robotoSlab(),
                          hintStyle: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(fontSize: 14.0))),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty) {
                          if (_focuserr == null) {
                            _focuserr = _emailFocusNode;
                          }
                          return 'This field is required.';
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          if (_focuserr == null) {
                            _focuserr = _emailFocusNode;
                          }
                          return 'Enter valid email address.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userBloc.currentEditUser['email'] = value;
                      },
                    ),
                  ),
                  _errors != null && _errors['email'] != null
                      ? Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _errors['email'][0],
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color: Colors.red[700], fontSize: 12.0)),
                          ),
                        )
                      : Container(),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'Role :',
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth / 25)),
                    ),
                  ),
                  Container(
                    height: 48.0,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          border: boxBorder(),
                          contentPadding: EdgeInsets.all(12.0)),
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(color: Colors.black)),
                      hint: Text('Select Role'),
                      value: (userBloc.currentEditUser['is_admin'] != "")
                          ? userBloc.currentEditUser['is_admin']
                          : null,
                      // onSaved: (value) {
                      //   leadBloc.currentEditLead['status'] = value;
                      // },
                      onChanged: (value) {
                        setState(() {
                          userBloc.currentEditUser['is_admin'] = value;
                          if (value == "ADMIN") {
                            userBloc.currentEditUser['has_marketing_access'] =
                                true;
                            userBloc.currentEditUser['has_sales_access'] = true;
                          } else {
                            userBloc.currentEditUser['has_marketing_access'] =
                                false;
                            userBloc.currentEditUser['has_sales_access'] =
                                false;
                          }
                        });
                      },
                      items: userBloc.rolesObjForDropdown.map((location) {
                        return DropdownMenuItem(
                          child: new Text(location[1]),
                          value: location[0],
                        );
                      }).toList(),
                    ),
                  ),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          'Marketing  :',
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth / 25)),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Checkbox(
                            value: (userBloc.currentEditUser['is_admin'] !=
                                    "ADMIN")
                                ? userBloc
                                    .currentEditUser['has_marketing_access']
                                : true,
                            onChanged: (userBloc.currentEditUser['is_admin'] !=
                                    "ADMIN")
                                ? (bool value) {
                                    setState(() {
                                      userBloc.currentEditUser[
                                          'has_marketing_access'] = value;
                                    });
                                  }
                                : null,
                          )),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          'Sales  :',
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth / 25)),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Checkbox(
                            value: (userBloc.currentEditUser['is_admin'] !=
                                    "ADMIN")
                                ? userBloc.currentEditUser['has_sales_access']
                                : true,
                            onChanged: (userBloc.currentEditUser['is_admin'] !=
                                    "ADMIN")
                                ? (bool value) {
                                    setState(() {
                                      userBloc.currentEditUser[
                                          'has_sales_access'] = value;
                                    });
                                  }
                                : null,
                          )),
                    ],
                  ),
                  (accessError == true)
                      ? Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Please choose one or more.",
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color: Colors.red[700], fontSize: 12.0)),
                          ),
                        )
                      : Container(),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'Status :',
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth / 25)),
                    ),
                  ),
                  Container(
                    height: 48.0,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          border: boxBorder(),
                          contentPadding: EdgeInsets.all(12.0)),
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(color: Colors.black)),
                      hint: Text('Select status'),
                      value: (userBloc.currentEditUser['is_active'] != "")
                          ? userBloc.currentEditUser['is_active']
                          : null,
                      // onSaved: (value) {
                      //   leadBloc.currentEditLead['status'] = value;
                      // },
                      onChanged: (value) {
                        userBloc.currentEditUser['is_active'] = value;
                      },
                      items: userBloc.statusObjForDropdown.map((location) {
                        return DropdownMenuItem(
                          child: new Text(location[1]),
                          value: location[0],
                        );
                      }).toList(),
                    ),
                  ),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'Upload Profile Picture :',
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth / 25)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      result = await FilePicker.platform
                          .pickFiles(type: FileType.image);
                      setState(() {
                        file = result.files.first;
                        print(file.name);
                      });
                    },
                    child: Container(
                      color: bottomNavBarTextColor,
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        "Choose Profile Picture",
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  file != null
                      ? Container(
                          margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Text(
                            file.name,
                            style: GoogleFonts.robotoSlab(),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Text(
                            "No file chosen.",
                            style: GoogleFonts.robotoSlab(),
                          ),
                        ),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            // Save Form
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      if (userBloc.currentEditUser['has_marketing_access'] ==
                              false &&
                          userBloc.currentEditUser['has_sales_access'] ==
                              false) {
                        setState(() {
                          accessError = true;
                        });
                      } else {
                        setState(() {
                          accessError = false;
                          _saveForm();
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: screenHeight * 0.06,
                      width: screenWidth * 0.5,
                      decoration: BoxDecoration(
                        color: submitButtonColor,
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            userBloc.currentEditUserId == null
                                ? 'Create User'
                                : 'Edit User',
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth / 24)),
                          ),
                          SvgPicture.asset('assets/images/arrow_forward.svg')
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      userBloc.cancelCurrentEditUser();
                    },
                    child: Container(
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(
                                decoration: TextDecoration.underline,
                                color: bottomNavBarTextColor,
                                fontSize: screenWidth / 24)),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _isLoading
        ? new Container(
            color: Colors.transparent,
            width: 300.0,
            height: 300.0,
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(child: new CircularProgressIndicator())),
          )
        : new Container();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            userBloc.currentEditUserId == null ? 'Create User' : 'Edit User',
            style: GoogleFonts.robotoSlab(),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Container(
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: _buildForm(),
                ),
              ),
            ),
            new Align(
              child: loadingIndicator,
              alignment: FractionalOffset.center,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBarWidget());
  }
}
