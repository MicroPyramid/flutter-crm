import 'dart:async';

import 'package:bottle_crm/responsive.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:flutter/material.dart';
//import 'package:connectivity/connectivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen();
  @override
  State createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () => checkInternet());
    super.initState();
  }

  checkInternet() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (preferences.getString('authToken') != null &&
          preferences.getString('authToken') != "") {
        await authBloc.fetchCompanies();
        Navigator.pushReplacementNamed(context, '/companies_List');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      showNoInternet(context);
    }
  }

  showNoInternet(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('No Internet'),
              content: Text('No internet connection!'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      checkInternet();
                    },
                    child: Text('RETRY'))
              ],
            ));
  }

  buildMobileScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: screenHeight * 0.4),
        Container(
            margin: EdgeInsets.only(bottom: 30.0),
            child: SvgPicture.asset('assets/images/logo.svg',
                width: screenWidth * 0.5)),
        CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)),
        SizedBox(height: screenHeight * 0.25),
        Container(
          child: Column(
            children: [
              Text('Free CRM for startups and enterprises.',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth / 25,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 3.0),
              Text('Released as Opensource under MIT License',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth / 25,
                      fontWeight: FontWeight.bold))
            ],
          ),
        )
      ],
    );
  }

  buildTabletScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: screenHeight * 0.4),
        Container(
            margin: EdgeInsets.only(bottom: 30.0),
            child: SvgPicture.asset(
              'assets/images/logo.svg',
              width: screenWidth * 0.3,
            )),
        CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)),
        SizedBox(height: screenHeight * 0.25),
        Container(
          child: Column(
            children: [
              Text('Free CRM for startups and enterprises.',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth / 40,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 3.0),
              Text('Released as Opensource under MIT License',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth / 40,
                      fontWeight: FontWeight.bold))
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg-image-blue.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Responsive(
            mobile: buildMobileScreen(),
            tablet: buildTabletScreen(),
            desktop: Container()),
      ),
    );
  }
}
