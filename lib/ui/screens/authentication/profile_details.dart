import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/auth_bloc.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileDetails extends StatefulWidget {
  ProfileDetails();
  @override
  State createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.robotoSlab(),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  child: authBloc.userProfile != null &&
                          authBloc.userProfile.profileUrl != null &&
                          authBloc.userProfile.profileUrl != ""
                      ? CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.13,
                          backgroundImage:
                              NetworkImage(authBloc.userProfile.profileUrl),
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
                      child: Text("Name :",
                          style: GoogleFonts.robotoSlab(
                              color: bottomNavBarSelectedTextColor,
                              fontSize: screenWidth / 24)),
                    ),
                    Container(
                      child: Text(
                          authBloc.userProfile.firstName +
                              " " +
                              authBloc.userProfile.lastName,
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
                      child: Text(authBloc.userProfile.userName,
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
                      child: Text(authBloc.userProfile.email,
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
                    Container(
                      child: Text('Sales And Marketing',
                          style: GoogleFonts.robotoSlab(
                              color: bottomNavBarTextColor,
                              fontSize: screenWidth / 24)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.edit_outlined),
        backgroundColor: Color.fromRGBO(117, 174, 51, 1),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}
