import 'package:bottle_crm/responsive.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:bottle_crm/bloc/auth_bloc.dart';
import 'package:bottle_crm/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Clear all stored data when login page opens
    authBloc.clearAllStoredData();
  }


  _googleLogin() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      Map result = await authBloc.googleLogin();
      if (result['error'] == false) {
        setState(() {
          _errorMessage = '';
        });
        await FirebaseAnalytics.instance.logEvent(name: "google_login");
        Navigator.pushNamedAndRemoveUntil(
            context, '/organization_selection', (route) => false);
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Google login failed';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Google login failed. Please try again.';
      });
    }
    
    setState(() {
      _isLoading = false;
    });
  }


  Widget loginWidget() {
    return Responsive(
        mobile: buildMobileScreen(),
        tablet: buildTabletScreen(),
        desktop: Container());
  }

  buildMobileScreen() {
    return SingleChildScrollView(
      child: Container(
        height: screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.08),
            // Logo and Branding Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: screenWidth * 0.4,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'BottleCRM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth / 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Free CRM for startups and enterprises',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: screenWidth / 25,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.08),
            // Login Card
            Expanded(
              child: Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: screenWidth / 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Sign in to continue managing your business',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: screenWidth / 26,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      _errorMessage != ''
                          ? Container(
                              margin: EdgeInsets.only(bottom: 20.0),
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.red.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline, color: Colors.red, size: 20),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _errorMessage,
                                      style: TextStyle(
                                        color: Colors.red[700],
                                        fontSize: screenWidth / 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      !_isLoading
                          ? Container(
                              width: screenWidth,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _googleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black87,
                                  elevation: 2,
                                  shadowColor: Colors.black26,
                                  side: BorderSide(color: Colors.grey[300]!, width: 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/google-icon.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    SizedBox(width: 16),
                                    Text(
                                      'Continue with Google',
                                      style: TextStyle(
                                        fontSize: screenWidth / 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                      SizedBox(height: screenHeight * 0.04),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Secure sign-in powered by Google OAuth 2.0',
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: screenWidth / 32,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildTabletScreen() {
    return Container(
      height: screenHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor,
          ],
        ),
      ),
      child: Row(
        children: [
          // Left side - Branding
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: screenWidth * 0.15,
                    colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'BottleCRM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth / 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Free CRM for startups and enterprises',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth / 50,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Manage your customers, leads, and opportunities all in one place.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth / 60,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right side - Login Form
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Container(
                padding: EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: screenWidth / 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Sign in to continue managing your business',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: screenWidth / 55,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    _errorMessage != ''
                        ? Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.red, size: 18),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage,
                                    style: TextStyle(
                                      color: Colors.red[700],
                                      fontSize: screenWidth / 60,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    !_isLoading
                        ? Container(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _googleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                                elevation: 2,
                                shadowColor: Colors.black26,
                                side: BorderSide(color: Colors.grey[300]!, width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/google-icon.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  SizedBox(width: 16),
                                  Text(
                                    'Continue with Google',
                                    style: TextStyle(
                                      fontSize: screenWidth / 45,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue, size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Secure sign-in powered by Google OAuth 2.0',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontSize: screenWidth / 65,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: loginWidget(),
    );
  }
}
