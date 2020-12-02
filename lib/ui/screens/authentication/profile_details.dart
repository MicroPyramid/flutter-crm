import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/auth_bloc.dart';

class ProfileDetails extends StatefulWidget {
  ProfileDetails();
  @override
  State createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  String _profilePicUrl =
      "https://starsunfolded.com/wp-content/uploads/2017/09/Virat-Kohli-French-cut-with-trimmed-scruff-beard-style.jpg";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                child: authBloc.userProfile != null &&
                        authBloc.userProfile.profileUrl != null &&
                        authBloc.userProfile.profileUrl != ""
                    ? CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.2,
                        backgroundImage:
                            NetworkImage(authBloc.userProfile.profileUrl),
                        backgroundColor: Colors.white,
                      )
                    : authBloc.userProfile != null &&
                            authBloc.userProfile.firstName != ""
                        ? CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.2,
                            child: Text(
                              authBloc.userProfile.firstName[0],
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.2,
                                  fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: Colors.white,
                          )
                        : CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.2,
                            child: Icon(
                              Icons.person,
                              size: MediaQuery.of(context).size.width * 0.3,
                              color: Theme.of(context).primaryColor,
                            ),
                            backgroundColor: Colors.white,
                          ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Name'),
                        subtitle: Text(authBloc.userProfile.firstName +
                            " " +
                            authBloc.userProfile.lastName),
                      ),
                      ListTile(
                        title: Text('UserName'),
                        subtitle: Text(authBloc.userProfile.userName),
                      ),
                      ListTile(
                        title: Text('Email'),
                        subtitle: Text(authBloc.userProfile.email),
                      ),
                      ListTile(
                        title: Text('Permissions'),
                        subtitle: Text(authBloc.userProfile.hasSalesAccess &&
                                authBloc.userProfile.hasMarketingAccess
                            ? "Sales and Marketing"
                            : authBloc.userProfile.hasSalesAccess
                                ? "Sales"
                                : authBloc.userProfile.hasMarketingAccess
                                    ? "Marketing"
                                    : "No Permissions"),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Icon(Icons.edit),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
