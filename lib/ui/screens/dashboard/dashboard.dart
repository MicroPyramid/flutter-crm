import 'package:flutter/material.dart';
import 'package:flutter_crm/ui/widgets/side_menu.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  Dashboard();
  @override
  State createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  TabController _tabController;
  List _tabItems = const ['    Recent Accounts    ', 'Recent Opportunities'];
  bool _tabValue = true;

  @override
  void initState() {
    super.initState();
    _tabValue = true;
  }

  OutlineInputBorder boxBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(width: 1, color: Colors.grey),
    );
  }

  Widget _buildCards(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Card(
                    shape: boxBorder(),
                    color: Color.fromRGBO(44, 113, 255, 1),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: CircleAvatar(
                              radius: MediaQuery.of(context).size.width / 15,
                              child: SvgPicture.asset(
                                  'assets/images/accounts_color.svg'),
                              backgroundColor: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            width: screenWidth*0.2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    'Accounts',
                                    style: GoogleFonts.robotoSlab(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12))
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '0',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width / 20,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Card(
                    shape: boxBorder(),
                    color: Color.fromRGBO(96,75,186, 1),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: CircleAvatar(
                              radius: MediaQuery.of(context).size.width / 15,
                              child: SvgPicture.asset(
                                  'assets/images/flag.svg'),
                              backgroundColor: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            width: screenWidth*0.2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                      'Leads',
                                      style: GoogleFonts.robotoSlab(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12))
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '0',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                        MediaQuery.of(context).size.width / 20,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Card(
                    shape: boxBorder(),
                    color: Color.fromRGBO(52,141,80, 1),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: CircleAvatar(
                              radius: MediaQuery.of(context).size.width / 15,
                              child: SvgPicture.asset(
                                  'assets/images/identification.svg',
                                color: Color.fromRGBO(52,141,80, 1),
                              ),
                              backgroundColor: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            width: screenWidth*0.2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                      'Contacts',
                                      style: GoogleFonts.robotoSlab(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12))
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '0',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                        MediaQuery.of(context).size.width / 20,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Card(
                    shape: boxBorder(),
                    color: Color.fromRGBO(255,86,45, 1),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: CircleAvatar(
                              radius: MediaQuery.of(context).size.width / 15,
                              child: SvgPicture.asset(
                                  'assets/images/opportunities_color.svg'),
                              backgroundColor: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            width: screenWidth*0.2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                      'Opportunities',
                                      style: GoogleFonts.robotoSlab(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12))
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '0',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                        MediaQuery.of(context).size.width / 20,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
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
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAccounts(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        color: Color.fromRGBO(229, 229, 229, 1),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  "Recent Accounts",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 25,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                  child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.keyboard_arrow_right),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentOpportunities(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        color: Color.fromRGBO(229, 229, 229, 1),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  "Recent Opportunities",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 25,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                  child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.keyboard_arrow_right),
              ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
        ),
        drawer: SideMenuDrawer(),
        body: Container(
          child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  _buildCards(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        minWidth: screenWidth*0.2,
                          height: screenHeight*0.05,
                          disabledColor: Colors.blueGrey[900],
                          disabledTextColor: Colors.grey,
                          shape: boxBorder(),
                          onPressed: !_tabValue?(){
                            setState(() {
                              _tabValue = true;
                            });
                          }:null,
                          child: Text(_tabItems[0])),
                      FlatButton(
                          minWidth: screenWidth*0.2,
                          height: screenHeight*0.05,
                          disabledColor: Colors.blueGrey[900],
                          disabledTextColor: Colors.grey,
                          shape: boxBorder(),
                          onPressed: _tabValue?(){
                            setState(() {
                              _tabValue = false;
                            });
                          }:null,
                          child: Text(_tabItems[1]))
                    ],
                  ),
                  _tabValue ? _buildRecentAccounts(context): _buildRecentOpportunities(context),
                  // TabBar(
                  //   tabs: [
                  //     Padding(
                  //       padding: const EdgeInsets.all(10),
                  //       child: Text(_tabItems[0]),
                  //     ),
                  //     Text(_tabItems[1])
                  //   ],
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
