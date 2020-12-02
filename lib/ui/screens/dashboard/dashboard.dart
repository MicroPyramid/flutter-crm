import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/dashboard_bloc.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/ui/widgets/dashboard_count_card.dart';
import 'package:flutter_crm/ui/widgets/recent_card_widget.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  Dashboard();
  @override
  State createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    dashboardBloc.fetchDashboardDetails();
    super.initState();
  }

  OutlineInputBorder boxBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(0)),
      borderSide: BorderSide(width: 0, color: color),
    );
  }

  Widget _buildCards(BuildContext context, AsyncSnapshot<Map> snapshot) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CountCard(
                  color: Color.fromRGBO(44, 113, 255, 1),
                  lable: "Accounts",
                  count: snapshot.data['accountsCount'].toString(),
                  icon: 'assets/images/accounts_color.svg',
                  routeName: "",
                ),
                CountCard(
                  color: Color.fromRGBO(96, 75, 186, 1),
                  lable: "Leads",
                  count: snapshot.data['leadsCount'].toString(),
                  icon: 'assets/images/flag.svg',
                  routeName: "",
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CountCard(
                  color: Color.fromRGBO(52, 141, 80, 1),
                  lable: "Contacts",
                  count: snapshot.data['contactsCount'].toString(),
                  icon: 'assets/images/identification.svg',
                  routeName: "",
                ),
                CountCard(
                  color: Color.fromRGBO(255, 86, 45, 1),
                  lable: "Opportunities",
                  count: snapshot.data['opportunitiesCount'].toString(),
                  icon: 'assets/images/opportunities_color.svg',
                  routeName: "",
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAccounts(
      BuildContext context, AsyncSnapshot<Map> snapshot) {
    return ListView.builder(
        itemCount: 10,
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {},
            child: RecentCardWidget(
              source: 'accounts',
              name: snapshot.data['accounts'][index].name,
              date: snapshot.data['accounts'][index].createdOn,
              city: snapshot.data['accounts'][index].billingCity,
              email: snapshot.data['accounts'][index].email,
            ),
          );
        });
  }

  Widget _buildRecentOpportunities(
      BuildContext context, AsyncSnapshot<Map> snapshot) {
    return ListView.builder(
        itemCount: 10,
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {},
            child: RecentCardWidget(
              source: 'opportunities',
              name: snapshot.data['opportunities'][index].name,
              date: snapshot.data['opportunities'][index].createdOn,
              city: snapshot.data['opportunities'][index].leadSource,
              email: snapshot.data['opportunities'][index].amount,
            ),
          );
        });
  }

  Widget _recentTabWidget(context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = 0;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color: _selectedTabIndex == 0
                      ? Theme.of(context).secondaryHeaderColor
                      : Colors.white,
                  border: Border.all(
                      width: 1.0,
                      color: Theme.of(context).secondaryHeaderColor)),
              alignment: Alignment.center,
              width: screenWidth * 0.46,
              height: screenHeight * 0.05,
              child: Text(
                "Recent Accounts",
                style: GoogleFonts.robotoSlab(
                    textStyle: TextStyle(
                        fontSize: screenWidth / 25,
                        color: _selectedTabIndex == 0
                            ? Colors.white
                            : Theme.of(context).secondaryHeaderColor)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = 1;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color: _selectedTabIndex == 1
                      ? Theme.of(context).secondaryHeaderColor
                      : Colors.white,
                  border: Border.all(
                      width: 1.0,
                      color: Theme.of(context).secondaryHeaderColor)),
              alignment: Alignment.center,
              width: screenWidth * 0.46,
              height: screenHeight * 0.05,
              child: Text(
                "Recent Opportunities",
                style: GoogleFonts.robotoSlab(
                    textStyle: TextStyle(
                        fontSize: screenWidth / 25,
                        color: _selectedTabIndex == 1
                            ? Colors.white
                            : Theme.of(context).secondaryHeaderColor)),
              ),
            ),
          )
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
          title: Text(
            'Dashboard',
            style: GoogleFonts.robotoSlab(),
          ),
        ),
        body: StreamBuilder(
          stream: dashboardBloc.dashboardDetails,
          builder: (context, AsyncSnapshot<Map> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  _buildCards(context, snapshot),
                  _recentTabWidget(context),
                  Expanded(
                      child: _selectedTabIndex == 0
                          ? _buildRecentAccounts(context, snapshot)
                          : _buildRecentOpportunities(context, snapshot)),
                ],
              );
            } else if (snapshot.hasError) {
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
