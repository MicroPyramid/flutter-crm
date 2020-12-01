import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/auth_bloc.dart';
import 'package:flutter_crm/bloc/dashboard_bloc.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/ui/widgets/recent_card_widget.dart';
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
    dashboardBloc.fetchDashboardDetails();
    super.initState();
    _tabValue = true;
  }


  OutlineInputBorder boxBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(0)),
      borderSide: BorderSide(width: 0, color: Colors.grey),
    );
  }

  Widget _buildCards(BuildContext context, AsyncSnapshot<Map> snapshot) {
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
                                    snapshot.data['accountsCount'].toString(),
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
                                    snapshot.data['leadsCount'].toString(),
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
                                    snapshot.data['contactsCount'].toString(),
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
                                    snapshot.data['opportunitiesCount'].toString(),
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

  Widget _buildRecentAccounts(BuildContext context, AsyncSnapshot<Map> snapshot) {
    return ListView.builder(
      itemCount: 10,
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
      return GestureDetector(
        onTap: (){},
        child: RecentCardWidget(
          position00: snapshot.data['accounts'][index].name,
          position01: snapshot.data['accounts'][index].createdOn.substring(0,10),
          position10:  snapshot.data['accounts'][index].billingCity,
          position11: snapshot.data['accounts'][index].email,
        ),
      );}
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
                  "Under Development... Coming Soon",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 25,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                  child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.info),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _recentTabWidget(context) {
    return Container(
      width: screenWidth*0.95,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlatButton(
              minWidth: screenWidth*0.2,
              height: screenHeight*0.05,
              color: Colors.white,
              disabledColor: Color.fromRGBO(0, 0, 128, 1),
              disabledTextColor: Colors.white,
              shape: boxBorder(),
              onPressed: !_tabValue?(){
                setState(() {
                  _tabValue = true;
                });
              }:null,
              child: Text(_tabItems[0],
              style: GoogleFonts.robotoSlab(
                  textStyle: TextStyle()),
              )),
          FlatButton(
              minWidth: screenWidth*0.2,
              height: screenHeight*0.05,
              color: Colors.white,
              disabledColor: Color.fromRGBO(0, 0, 128, 1),
              disabledTextColor: Colors.white,
              shape: boxBorder(),
              onPressed: _tabValue?(){
                setState(() {
                  _tabValue = false;
                });
              }:null,
              child: Text(_tabItems[1],
              style: GoogleFonts.robotoSlab(
                  textStyle: TextStyle()),))
        ],
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
        // drawer: SideMenuDrawer(),
        body: StreamBuilder(
          stream: dashboardBloc.dashboardDetails,
          builder: (context, AsyncSnapshot<Map> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  _buildCards(context, snapshot),
                  _recentTabWidget(context),
                  Expanded(child: _tabValue ? _buildRecentAccounts(context, snapshot): _buildRecentOpportunities(context)),
                ],
              );
            }
            else if (snapshot.hasError) {
              return Container();
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),

        bottomNavigationBar: BottomNavigationBarWidget(),
      ),
    );
  }
}
