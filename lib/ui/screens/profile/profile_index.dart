import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_crm/ui/widgets/side_menu.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen();
  @override
  State createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List _profileList = [
    {
      'title': 'Users',
      'route': '/dashboard',
      'icon': Icon(Icons.supervisor_account)
    },
    {'title': 'Settings', 'route': '/accounts', 'icon': Icon(Icons.settings)},
    {
      'title': 'Change Password',
      'route': '/change_password',
      'icon': Icon(Icons.vpn_key)
    },
    {
      'title': 'Profile',
      'route': '/profile_details',
      'icon': Icon(Icons.account_circle)
    },
    {'title': 'Logout', 'route': '/opportunities', 'icon': Icon(Icons.logout)},
  ];

  @override
  void initState() {
    super.initState();
  }

  Widget _buildMenuItems(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _profileList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).dividerColor, width: 2.0))),
          child: ListTile(
            leading: _profileList[index]['icon'],
            title: Text(
              _profileList[index]['title'],
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontSize: MediaQuery.of(context).size.width / 22),
            ),
            onTap: () {
              if (_profileList[index]['title'] == "Logout") {
                showAlertDialog(context);
              } else {
                Navigator.pushNamed(context, _profileList[index]['route']);
              }
            },
          ),
        );
      },
    );
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        child: CupertinoAlertDialog(
          title: Text("Log out?"),
          content: Text("Are you sure you want to log out?"),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
            CupertinoDialogAction(
                textStyle: TextStyle(color: Colors.red),
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.pop(context);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('authToken');
                  prefs.remove('subdomain');
                  Navigator.pushReplacementNamed(context, "/sub_domain");
                },
                child: Text("Log out")),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
            appBar: AppBar(
              title: Text("My Account"),
            ),
            drawer: SideMenuDrawer(),
            body: _buildMenuItems(context)));
  }
}
