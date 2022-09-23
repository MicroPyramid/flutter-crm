import 'package:bottle_crm/bloc/auth_bloc.dart';
import 'package:bottle_crm/bloc/setting_bloc.dart';
import 'package:bottle_crm/ui/widgets/loader.dart';
import 'package:bottle_crm/ui/widgets/tags_widget.dart';
import 'package:flutter/material.dart';
import 'package:bottle_crm/utils/utils.dart';

class SettingsDeails extends StatefulWidget {
  SettingsDeails();
  @override
  State createState() => _SettingsDeailsState();
}

class _SettingsDeailsState extends State<SettingsDeails> {
  var _currentTabIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _isLoading ? Loader() : new Container();
    return Scaffold(
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(children: [
                            GestureDetector(
                                child: new Icon(Icons.arrow_back_ios,
                                    color: Colors.white),
                                onTap: () {
                                  Navigator.pop(context, true);
                                }),
                            SizedBox(width: 10.0),
                            Text(
                              'Settings Details',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth / 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                        // GestureDetector(
                        //   onTap: () async {

                        //   },
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(3.0)),
                        //       color: Colors.white,
                        //     ),
                        //     width: screenWidth * 0.18,
                        //     height: screenHeight * 0.04,
                        //     alignment: Alignment.center,
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //       children: [
                        //         SvgPicture.asset(
                        //           'assets/images/Icon_edit_color.svg',
                        //           color: Theme.of(context).primaryColor,
                        //           width: screenWidth / 25,
                        //         ),
                        //         Container(
                        //           child: Text(
                        //             "Edit",
                        //             style: TextStyle(
                        //                 fontSize: screenWidth / 25,
                        //                 color: Theme.of(context).primaryColor,
                        //                 fontWeight: FontWeight.w500),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 23.0),
                          height: screenHeight * 0.06,
                          decoration: BoxDecoration(
                              color: bottomNavBarSelectedTextColor,
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentTabIndex = 0;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: screenHeight * 0.06,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                    color: Colors.white,
                                    width: _currentTabIndex == 0 ? 3.0 : 0.0,
                                  ))),
                                  width: screenWidth * 0.40,
                                  child: Text(
                                    'Team Information',
                                    style: TextStyle(
                                        color: _currentTabIndex == 0
                                            ? Colors.white
                                            : Theme.of(context)
                                                .secondaryHeaderColor,
                                        fontSize: screenWidth / 25,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    child: buildteamInfoBlock(),
                    color: Colors.white,
                  ))
                ],
              ),
            ),
          ),
          new Align(
            child: loadingIndicator,
            alignment: FractionalOffset.center,
          )
        ],
      ),
    );
  }

  buildteamInfoBlock() {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
            child: Column(children: [
          Container(
            width: screenWidth,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.black12),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    settingsBloc.currentSettings!.title!,
                    style: TextStyle(
                        color: Colors.blueGrey[800],
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth / 24),
                  ),
                ),
                SizedBox(height: 5.0),
                SizedBox(height: 10.0),
                TagViewWidget(settingsBloc.currentSettings!.tags!),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black12),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          width: screenWidth * 0.28,
                          child: Text(
                            "Create Date :",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 10.0),
                      Container(
                          width: screenWidth * 0.50,
                          child: Text(
                            settingsBloc.currentSettings!.createdOn!,
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          width: screenWidth * 0.29,
                          child: Text(
                            "Closed on :",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 10.0),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          width: screenWidth * 0.28,
                          child: Text(
                            "Status :",
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth / 24),
                          )),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              )),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.black12),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        alignment: Alignment.centerRight,
                        width: screenWidth * 0.28,
                        child: Text(
                          "Organization :",
                          style: TextStyle(
                              color: Colors.blueGrey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth / 24),
                        )),
                    SizedBox(width: 10.0),
                    Container(
                        width: screenWidth * 0.50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authBloc.selectedOrganization!.name!
                                  .capitalizeFirstofEach(),
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth / 24),
                            ),
                          ],
                        )),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                        alignment: Alignment.centerRight,
                        width: screenWidth * 0.28,
                        child: Text(
                          "Contact :",
                          style: TextStyle(
                              color: Colors.blueGrey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth / 24),
                        )),
                    SizedBox(width: 10.0),
                    Container(
                        width: screenWidth * 0.50,
                        child: Text(
                          settingsBloc.currentSettings!.createdBy!.firstName!
                                  .capitalizeFirstofEach() +
                              " ${settingsBloc.currentSettings!.createdBy!.lastName!}",
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth / 24),
                        )),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        alignment: Alignment.centerRight,
                        width: screenWidth * 0.28,
                        child:
                            Icon(Icons.email_outlined, size: screenWidth / 20)),
                    SizedBox(width: 10.0),
                    Container(
                        width: screenWidth * 0.50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "settings@mp.com",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth / 24),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Divider())
                          ],
                        )),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        alignment: Alignment.centerRight,
                        width: screenWidth * 0.28,
                        child: Icon(Icons.phone, size: screenWidth / 20)),
                    SizedBox(width: 10.0),
                    Container(
                        width: screenWidth * 0.50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "------------",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth / 24),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Divider())
                          ],
                        )),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          // GestureDetector(
          //   onTap: () {
          //     if (!_isLoading)
          //       showDeleteteamAlertDialog(context, settingsBloc.currentTeam!);
          //   },
          //   child: Container(
          //     padding: EdgeInsets.all(8.0),
          //     decoration: BoxDecoration(
          //       border: Border.all(width: 1.0, color: Colors.red.shade100),
          //       borderRadius: BorderRadius.all(Radius.circular(3.0)),
          //       color: Colors.white,
          //     ),
          //     width: screenWidth * 0.25,
          //     alignment: Alignment.center,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         SvgPicture.asset(
          //           'assets/images/icon_delete_color.svg',
          //           width: screenWidth / 25,
          //         ),
          //         SizedBox(width: 10.0),
          //         Container(
          //           child: Text(
          //             "Delete",
          //             style: TextStyle(
          //                 fontSize: screenWidth / 23,
          //                 color: Colors.red,
          //                 fontWeight: FontWeight.w500),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ])));
  }

  // void showDeleteteamAlertDialog(BuildContext context, Settings settings) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return CupertinoAlertDialog(
  //           title: Text(
  //             settings.title!.capitalizeFirstofEach(),
  //             style: TextStyle(color: Colors.black),
  //           ),
  //           content: Text(
  //             "Are you sure you want to delete this team?",
  //             style: TextStyle(fontSize: 15.0),
  //           ),
  //           actions: <Widget>[
  //             CupertinoDialogAction(
  //                 isDefaultAction: true,
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text("Cancel")),
  //             CupertinoDialogAction(
  //                 textStyle: TextStyle(color: Colors.red),
  //                 isDefaultAction: true,
  //                 onPressed: () async {
  //                   Navigator.pop(context);
  //                   deleteSettings(settings);
  //                 },
  //                 child: Text("Delete")),
  //           ],
  //         );
  //       });
  // }

  // deleteSettings(Settings settings) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   Map result = await settingsBloc.deleteTeam(team);
  //   setState(() {
  //     _isLoading = false;
  //   });
  //   if (result['error'] == false) {
  //     showToaster(result['message'], context);
  //     teamBloc.teams.clear();
  //     await teamBloc.fetchTeams();
  //     await FirebaseAnalytics.instance.logEvent(name: "team_Deleted");
  //     Navigator.pushReplacementNamed(context, '/teams_list');
  //   } else if (result['error'] == true) {
  //     showToaster(result['message'], context);
  //   } else {
  //     showErrorMessage(context, result['message'].toString(), team);
  //   }
  // }

  // showErrorMessage(BuildContext context, msg, Team team) {
  //   return showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //             title: Text('Alert'),
  //             content: Text(msg),
  //             actions: [
  //               TextButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                     deleteTeam(team);
  //                   },
  //                   child: Text('RETRY'))
  //             ],
  //           ));
  // }
}
