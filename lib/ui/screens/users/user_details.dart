import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/user_bloc.dart';
import 'package:flutter_crm/model/profile.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UserDetails extends StatefulWidget {
  UserDetails();
  @override
  State createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void showDeleteUserAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              userBloc.currentUser.firstName,
              style: GoogleFonts.robotoSlab(
                  color: Theme.of(context).secondaryHeaderColor),
            ),
            content: Text(
              "Are you sure you want to delete this user?",
              style: GoogleFonts.robotoSlab(fontSize: 15.0),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.robotoSlab(),
                  )),
              CupertinoDialogAction(
                  textStyle: TextStyle(color: Colors.red),
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                    deleteUser();
                  },
                  child: Text(
                    "Delete",
                    style: GoogleFonts.robotoSlab(),
                  )),
            ],
          );
        });
  }

  deleteUser() async {
    setState(() {
      _isLoading = true;
    });
    Map result = await userBloc.deleteUser(userBloc.currentUser);
    setState(() {
      _isLoading = false;
    });
    if (result['status'] == 'success') {
      showToast((result['message'] != null)
          ? result['message']
          : "Successfully Deleted.");
      Navigator.pushReplacementNamed(context, "/sales_contacts");
    } else if (result['error'] == true) {
      showToast(result);
    } else {
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
          deleteUser();
        },
      ),
      duration: Duration(seconds: 10),
    )..show(context);
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
        title: Text(
          "User",
          style: GoogleFonts.robotoSlab(),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(15.0),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: userBloc.currentUser != null &&
                              userBloc.currentUser.profileUrl != null &&
                              userBloc.currentUser.profileUrl != ""
                          ? CircleAvatar(
                              radius: MediaQuery.of(context).size.width * 0.13,
                              backgroundImage:
                                  NetworkImage(userBloc.currentUser.profileUrl),
                              backgroundColor: Colors.white,
                            )
                          : CircleAvatar(
                              radius: MediaQuery.of(context).size.width * 0.13,
                              child: Icon(
                                Icons.person,
                                size: MediaQuery.of(context).size.width * 0.18,
                                color: bottomNavBarSelectedTextColor,
                              ),
                              backgroundColor: Theme.of(context).splashColor,
                            )),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: Divider(color: Colors.grey)),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 3.0),
                          child: Text("First Name :",
                              style: GoogleFonts.robotoSlab(
                                  color: bottomNavBarSelectedTextColor,
                                  fontSize: screenWidth / 24)),
                        ),
                        Container(
                          child: Text(userBloc.currentUser.firstName,
                              style: GoogleFonts.robotoSlab(
                                  color: bottomNavBarTextColor,
                                  fontSize: screenWidth / 24)),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            child: Divider(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 3.0),
                          child: Text("Last Name :",
                              style: GoogleFonts.robotoSlab(
                                  color: bottomNavBarSelectedTextColor,
                                  fontSize: screenWidth / 24)),
                        ),
                        Container(
                          child: Text(userBloc.currentUser.lastName,
                              style: GoogleFonts.robotoSlab(
                                  color: bottomNavBarTextColor,
                                  fontSize: screenWidth / 24)),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            child: Divider(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 3.0),
                          child: Text("User Name :",
                              style: GoogleFonts.robotoSlab(
                                  color: bottomNavBarSelectedTextColor,
                                  fontSize: screenWidth / 24)),
                        ),
                        Container(
                          child: Text(userBloc.currentUser.userName,
                              style: GoogleFonts.robotoSlab(
                                  color: bottomNavBarTextColor,
                                  fontSize: screenWidth / 24)),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            child: Divider(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 3.0),
                          child: Text("Email Address :",
                              style: GoogleFonts.robotoSlab(
                                  color: bottomNavBarSelectedTextColor,
                                  fontSize: screenWidth / 24)),
                        ),
                        Container(
                          child: Text(userBloc.currentUser.email,
                              style: GoogleFonts.robotoSlab(
                                  color: bottomNavBarTextColor,
                                  fontSize: screenWidth / 24)),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            child: Divider(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 3.0),
                          child: Text("Role :",
                              style: GoogleFonts.robotoSlab(
                                  color: bottomNavBarSelectedTextColor,
                                  fontSize: screenWidth / 24)),
                        ),
                        Container(
                          child: Text(userBloc.currentUser.role,
                              style: GoogleFonts.robotoSlab(
                                  color: bottomNavBarTextColor,
                                  fontSize: screenWidth / 24)),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            child: Divider(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 3.0),
                          child: Text("Permissions :",
                              style: GoogleFonts.robotoSlab(
                                  color: bottomNavBarSelectedTextColor,
                                  fontSize: screenWidth / 24)),
                        ),
                        (userBloc.currentUser.hasSalesAccess == true ||
                                userBloc.currentUser.isAdmin == true)
                            ? Container(
                                child: Text(' o Sales',
                                    style: GoogleFonts.robotoSlab(
                                        color: bottomNavBarTextColor,
                                        fontSize: screenWidth / 24)),
                              )
                            : Container(),
                        (userBloc.currentUser.hasMarketingAccess == true ||
                                userBloc.currentUser.isAdmin == true)
                            ? Container(
                                child: Text(' o Marketing',
                                    style: GoogleFonts.robotoSlab(
                                        color: bottomNavBarTextColor,
                                        fontSize: screenWidth / 24)),
                              )
                            : Container(),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            child: Divider(color: Colors.grey)),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 5.0),
                                child: Text(
                                  "Created On :",
                                  style: GoogleFonts.robotoSlab(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontSize: screenWidth / 24),
                                ),
                              ),
                              Container(
                                child: Text(
                                  DateFormat("dd-MM-yyyy").format(
                                      DateFormat("yyyy-MM-dd").parse(
                                          userBloc.currentUser.dateOfJoin)),
                                  style: GoogleFonts.robotoSlab(
                                      color: bottomNavBarTextColor,
                                      fontSize: screenWidth / 24),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Divider(color: Colors.grey))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await userBloc
                                .updateCurrentEditUser(userBloc.currentUser);
                            Navigator.pushNamed(context, '/create_user');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300])),
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 15.0),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10.0),
                                  child: SvgPicture.asset(
                                    'assets/images/Icon_edit_color.svg',
                                    width: screenWidth / 25,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    "Edit",
                                    style: GoogleFonts.robotoSlab(
                                        textStyle: TextStyle(
                                            color:
                                                Color.fromRGBO(117, 174, 51, 1),
                                            fontSize: screenWidth / 25)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDeleteUserAlertDialog(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300])),
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 15.0),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10.0),
                                  child: SvgPicture.asset(
                                    'assets/images/icon_delete_color.svg',
                                    width: screenWidth / 25,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    "Delete",
                                    style: GoogleFonts.robotoSlab(
                                        textStyle: TextStyle(
                                            color:
                                                Color.fromRGBO(234, 67, 53, 1),
                                            fontSize: screenWidth / 25)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Align(
            child: loadingIndicator,
            alignment: FractionalOffset.center,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}
