import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:bottle_crm/bloc/auth_bloc.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:bottle_crm/model/organization.dart';
import 'package:bottle_crm/ui/widgets/loader.dart';
import '../../../utils/utils.dart';

class CompaniesList extends StatefulWidget {
  CompaniesList();
  @override
  State createState() => _CompaniesListState();
}

class _CompaniesListState extends State<CompaniesList> {
  List<Organization> companies = [];
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      companies = authBloc.companies;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _isLoading ? Loader() : new Container();
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            fit: StackFit.expand,
            children: [
              SafeArea(
                child: Container(
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(73, 128, 255, 1.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 15.0),
                        child: Text(
                          'Companies List',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth / 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: companies.length != 0
                            ? Container(
                                child: ListView.builder(
                                    itemCount: companies.length,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                          onTap: () async {
                                            if (!_isLoading) {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              final SharedPreferences
                                                  preferences =
                                                  await SharedPreferences
                                                      .getInstance();
                                              preferences.setString(
                                                  'org',
                                                  (companies[index].id!)
                                                      .toString());
                                              authBloc.selectedOrganization =
                                                  companies[index];
                                              await fetchRequiredData();
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              await FirebaseAnalytics.instance
                                                  .logEvent(
                                                      name:
                                                          "${companies[index].name!}_Selected");
                                              Navigator.pushNamed(
                                                  context, '/dashboard');
                                            }
                                          },
                                          child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 8.0),
                                              padding: EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: Colors.grey),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: screenWidth * 0.7,
                                                    child: Text(
                                                      companies[index].name!,
                                                      style: TextStyle(
                                                          color:
                                                              bottomNavBarSelectedTextColor,
                                                          fontSize:
                                                              screenWidth / 24,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                      child: Icon(
                                                    Icons.arrow_forward_ios,
                                                    color:
                                                        bottomNavBarSelectedTextColor,
                                                    size: screenWidth / 20,
                                                  ))
                                                ],
                                              )));
                                    }),
                              )
                            : Center(
                                child: Text('No data found.'),
                              ),
                      ))
                    ],
                  ),
                ),
              ),
              new Align(
                child: loadingIndicator,
                alignment: FractionalOffset.center,
              ),
            ],
          )),
    );
  }
}
