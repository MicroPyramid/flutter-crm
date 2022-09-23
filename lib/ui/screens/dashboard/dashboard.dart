import 'package:bottle_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:bottle_crm/ui/widgets/recent_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:bottle_crm/bloc/dashboard_bloc.dart';
import 'package:bottle_crm/ui/widgets/dashboard_count_card.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

class Dashboard extends StatefulWidget {
  Dashboard();
  @override
  State createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
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
                    //color: Color.fromRGBO(44, 113, 255, 1),
                    color: Colors.white,
                    lable: "Accounts",
                    count: dashboardBloc.dashboardData['accountsCount'],
                    icon: 'assets/images/accounts_color.svg',
                    routeName: "/accounts_list",
                    index: 1),
                CountCard(
                    //color: Color.fromRGBO(96, 75, 186, 1),
                    color: Colors.white,
                    lable: "Leads",
                    count: dashboardBloc.dashboardData['leadsCount'],
                    icon: 'assets/images/flag.svg',
                    routeName: "/leads_list",
                    index: 4)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CountCard(
                    //color: Color.fromRGBO(52, 141, 80, 1),
                    color: Colors.white,
                    lable: "Contacts",
                    count: dashboardBloc.dashboardData['contactsCount'],
                    icon: 'assets/images/identification.svg',
                    routeName: "/contacts_list",
                    index: 4),
                CountCard(
                    //color: Color.fromRGBO(255, 86, 45, 1),
                    color: Colors.white,
                    lable: "Opportunities",
                    count: dashboardBloc.dashboardData['opportunitiesCount'],
                    icon: 'assets/images/opportunities_color.svg',
                    routeName: "/opportunities_list",
                    index: 4)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAccounts(BuildContext context) {
    return dashboardBloc.dashboardData['accounts'] != null &&
            dashboardBloc.dashboardData['accounts'].length > 0
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
                  photoUrl: dashboardBloc.dashboardData['accounts'][index]
                              .createdBy!.profileUrl ==
                          null
                      ? dashboardBloc.dashboardData['accounts'][index]
                          .createdBy!.firstName[0].allInCaps
                      : dashboardBloc.dashboardData['accounts'][index]
                          .createdBy!.profileUrl,
                  createdBy: dashboardBloc
                      .dashboardData['accounts'][index].createdBy!.firstName,
                  tags: dashboardBloc.dashboardData['accounts'][index].tags!,
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
                style: TextStyle(
                    fontSize: screenWidth / 25,
                    color: Theme.of(context).secondaryHeaderColor)),
          );
  }

  Widget _buildRecentContacts(BuildContext context) {
    return dashboardBloc.dashboardData['contacts'] != null &&
            dashboardBloc.dashboardData['contacts'].length > 0
        ? ListView.builder(
            itemCount: dashboardBloc.dashboardData['contacts'].length,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {},
                child: RecentCardWidget(
                  source: 'contacts',
                  name: dashboardBloc
                          .dashboardData['contacts'][index].firstName +
                      "" +
                      dashboardBloc.dashboardData['contacts'][index].lastName,
                  date:
                      dashboardBloc.dashboardData['contacts'][index].createdOn,
                  tags: [],
                  photoUrl: dashboardBloc
                      .dashboardData['contacts'][index].createdBy!.profileUrl,
                  createdBy: dashboardBloc
                      .dashboardData['contacts'][index].createdBy!.firstName,
                  email: dashboardBloc
                      .dashboardData['contacts'][index].primaryEmail,
                ),
              );
            })
        : Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Text("No Data Found",
                style: TextStyle(
                    fontSize: screenWidth / 25,
                    color: Theme.of(context).secondaryHeaderColor)),
          );
  }

  Widget _buildRecentOpportunities(BuildContext context) {
    return dashboardBloc.dashboardData['opportunities'] != null &&
            dashboardBloc.dashboardData['opportunities'].length > 0
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
                  photoUrl: dashboardBloc.dashboardData['opportunities'][index]
                      .createdBy!.profileUrl,
                  createdBy: dashboardBloc.dashboardData['opportunities'][index]
                      .createdBy!.firstName,
                  tags:
                      dashboardBloc.dashboardData['opportunities'][index].tags!,
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
                style: TextStyle(
                    fontSize: screenWidth / 25,
                    color: Theme.of(context).secondaryHeaderColor)),
          );
  }

  Widget _recentTabWidget() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10.0, left: 10.0),
          alignment: Alignment.centerLeft,
          child: Text(
            "Recently added",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth / 25,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 23.0),
          height: screenHeight * 0.06,
          decoration: BoxDecoration(
            color: Color.fromARGB(5, 250, 250, 251),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
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
                  alignment: Alignment.center,
                  height: screenHeight * 0.06,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: bottomNavBarSelectedTextColor,
                    width: _selectedTabIndex == 0 ? 3.0 : 0.0,
                  ))),
                  width: screenWidth * 0.20,
                  child: Text(
                    'Accounts ',
                    style: TextStyle(
                        color: _selectedTabIndex == 0
                            ? bottomNavBarSelectedTextColor
                            : Colors.grey,
                        fontSize: screenWidth / 25,
                        fontWeight: FontWeight.w500),
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
                  alignment: Alignment.center,
                  height: screenHeight * 0.06,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: bottomNavBarSelectedTextColor,
                    width: _selectedTabIndex == 1 ? 3.0 : 0.0,
                  ))),
                  width: screenWidth * 0.22,
                  child: Text(
                    'Contacts ',
                    style: TextStyle(
                        color: _selectedTabIndex == 1
                            ? bottomNavBarSelectedTextColor
                            : Colors.grey,
                        fontSize: screenWidth / 25,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTabIndex = 2;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: screenHeight * 0.06,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: bottomNavBarSelectedTextColor,
                    width: _selectedTabIndex == 2 ? 3.0 : 0.0,
                  ))),
                  width: screenWidth * 0.30,
                  child: Text(
                    'Opportunities ',
                    style: TextStyle(
                        color: _selectedTabIndex == 2
                            ? bottomNavBarSelectedTextColor
                            : Colors.grey,
                        fontSize: screenWidth / 25,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildtabSelectTab() {
    if (_selectedTabIndex == 0) {
      return SwipeDetector(
          onSwipeLeft: (offset) {
            setState(() {
              _selectedTabIndex = 1;
            });
          },
          child: _buildRecentAccounts(context));
    } else if (_selectedTabIndex == 1) {
      return SwipeDetector(
          onSwipeLeft: (offset) {
            setState(() {
              _selectedTabIndex = 2;
            });
          },
          onSwipeRight: (offset) {
            setState(() {
              _selectedTabIndex = 0;
            });
          },
          child: _buildRecentContacts(context));
    } else if (_selectedTabIndex == 2) {
      return SwipeDetector(
          onSwipeRight: (offset) {
            setState(() {
              _selectedTabIndex = 1;
            });
          },
          child: _buildRecentOpportunities(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return WillPopScope(
        onWillPop: () {
          Navigator.pushNamedAndRemoveUntil(
              context, '/companies_List', (route) => false);
          return new Future(() => false);
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(fit: StackFit.expand, children: [
              SafeArea(
                child: Container(
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(73, 128, 255, 1.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          'Dashboard',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth / 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              _buildCards(context),
                              _recentTabWidget(),
                              Expanded(
                                child: _buildtabSelectTab(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            bottomNavigationBar: BottomNavigationBarWidget()));
  }
}
