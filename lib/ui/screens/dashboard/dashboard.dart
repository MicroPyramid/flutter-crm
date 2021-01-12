import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/dashboard_bloc.dart';
import 'package:flutter_crm/bloc/document_bloc.dart';
import 'package:flutter_crm/bloc/user_bloc.dart';
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
    loadAdditonalData();
    // dashboardBloc.fetchDashboardDetails();
    super.initState();
  }

  loadAdditonalData() async {
    await userBloc.fetchUsers();
    await documentBLoc.fetchDocuments();
  }

  OutlineInputBorder boxBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(0)),
      borderSide: BorderSide(width: 0, color: color),
    );
  }

  Widget _buildCards(BuildContext context) {
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
                    count:
                        dashboardBloc.dashboardData['accountsCount'].toString(),
                    icon: 'assets/images/accounts_color.svg',
                    routeName: "/account_list",
                    index: 2),
                CountCard(
                    color: Color.fromRGBO(96, 75, 186, 1),
                    lable: "Leads",
                    count: dashboardBloc.dashboardData['leadsCount'].toString(),
                    icon: 'assets/images/flag.svg',
                    routeName: "/leads_list",
                    index: 1)
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
                    count:
                        dashboardBloc.dashboardData['contactsCount'].toString(),
                    icon: 'assets/images/identification.svg',
                    routeName: "/contacts",
                    index: 3),
                CountCard(
                    color: Color.fromRGBO(255, 86, 45, 1),
                    lable: "Opportunities",
                    count: dashboardBloc.dashboardData['opportunitiesCount']
                        .toString(),
                    icon: 'assets/images/opportunities_color.svg',
                    routeName: "/opportunities",
                    index: 3)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAccounts(BuildContext context) {
    return dashboardBloc.dashboardData['accounts'].length > 0
        ? ListView.builder(
            itemCount: dashboardBloc.dashboardData['accounts'].length,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {},
                child: RecentCardWidget(
                  source: 'accounts',
                  name: dashboardBloc.dashboardData['accounts'][index].name,
                  date:
                      dashboardBloc.dashboardData['accounts'][index].createdOn,
                  city: dashboardBloc
                      .dashboardData['accounts'][index].billingCity,
                  email: dashboardBloc.dashboardData['accounts'][index].email,
                ),
              );
            })
        : Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Text("No Data Found",
                style: GoogleFonts.robotoSlab(
                    textStyle: TextStyle(
                        fontSize: screenWidth / 25,
                        color: Theme.of(context).secondaryHeaderColor))),
          );
  }

  Widget _buildRecentOpportunities(BuildContext context) {
    return dashboardBloc.dashboardData['opportunities'].length > 0
        ? ListView.builder(
            itemCount: dashboardBloc.dashboardData['opportunities'].length,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {},
                child: RecentCardWidget(
                  source: 'opportunities',
                  name:
                      dashboardBloc.dashboardData['opportunities'][index].name,
                  date: dashboardBloc
                      .dashboardData['opportunities'][index].createdOn,
                  city: dashboardBloc
                      .dashboardData['opportunities'][index].leadSource,
                  email: dashboardBloc
                      .dashboardData['opportunities'][index].amount,
                ),
              );
            })
        : Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Text("No Data Found",
                style: GoogleFonts.robotoSlab(
                    textStyle: TextStyle(
                        fontSize: screenWidth / 25,
                        color: Theme.of(context).secondaryHeaderColor))),
          );
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
        body: Column(
          children: [
            _buildCards(context),
            _recentTabWidget(context),
            Expanded(
                child: _selectedTabIndex == 0
                    ? _buildRecentAccounts(context)
                    : _buildRecentOpportunities(context)),
          ],
        ),
        bottomNavigationBar: BottomNavigationBarWidget(),
      ),
    );
  }
}
