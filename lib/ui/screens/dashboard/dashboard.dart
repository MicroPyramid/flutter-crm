import 'package:flutter/material.dart';
import 'package:flutter_crm/ui/widgets/side_menu.dart';
import 'package:flutter_crm/utils/utils.dart';

class Dashboard extends StatefulWidget {
  Dashboard();
  @override
  State createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
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
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Card(
                    color: Colors.teal,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Text(
                              'ACCOUNTS',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 33,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.bold),
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
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Card(
                    color: Color.fromRGBO(106, 229, 48, 1),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Text(
                              'CONTACTS',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 33,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.bold),
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
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Card(
                    color: Color.fromRGBO(196, 58, 80, 1),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Text(
                              'LEADS',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 33,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500),
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
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Card(
                    color: Color.fromRGBO(237, 138, 37, 1),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Text(
                              'OPPORTUNITIES',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 33,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500),
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
                  _buildRecentAccounts(context),
                  _buildRecentOpportunities(context)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
