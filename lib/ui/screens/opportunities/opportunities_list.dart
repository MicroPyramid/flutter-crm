import 'package:bottle_crm/bloc/opportunity_bloc.dart';
import 'package:bottle_crm/model/opportunities.dart';
import 'package:bottle_crm/model/profile.dart';
import 'package:bottle_crm/ui/widgets/loader.dart';
import 'package:bottle_crm/ui/widgets/profile_pic_widget.dart';
//import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottle_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:random_color/random_color.dart';

class OpportunitiesList extends StatefulWidget {
  OpportunitiesList();
  @override
  State createState() => _OpportunitiesListState();
}

class _OpportunitiesListState extends State<OpportunitiesList> {
  final GlobalKey<FormState> _filtersFormKey = GlobalKey<FormState>();
  bool _isFilter = false;
  bool _isNextPageLoading = false;
  ScrollController? scrollController;
  List<Profile>? _assignedUsers = [];
  List<Opportunity> _opportunities = [];
  Map _filtersFormData = {
    "name": "",
    "account": "",
    "stage": "",
    "lead_source": "",
    "tags": []
  };
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _opportunities = opportunityBloc.opportunities;
    });
    scrollController = ScrollController();
    scrollController!.addListener(() async {
      if (scrollController!.offset >=
              scrollController!.position.maxScrollExtent &&
          !scrollController!.position.outOfRange &&
          opportunityBloc.offset != "" &&
          !_isNextPageLoading) {
        setState(() {
          _isNextPageLoading = true;
        });
        await opportunityBloc.fetchOpportunities(
            filtersData: _isFilter ? _filtersFormData : null);
        setState(() {
          _isNextPageLoading = false;
        });
      }
    });
    _getUsers();
    super.initState();
  }

  _getUsers() {
    _opportunities.forEach((element) {
      _assignedUsers!.addAll(element.assignedTo!);
    });
  }

  _submitForm() async {
    if (_isFilter) {
      _filtersFormKey.currentState!.save();
    }
    setState(() {
      _isLoading = true;
    });
    opportunityBloc.offset = "";
    opportunityBloc.opportunities.clear();
    await opportunityBloc.fetchOpportunities(
        filtersData: _isFilter ? _filtersFormData : null);
    setState(() {
      _isLoading = false;
    });
  }

  OutlineInputBorder buildBorder(Color color) {
    return OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(3.0)));
  }

  EdgeInsets padding() {
    return EdgeInsets.symmetric(
        horizontal: screenWidth / 30, vertical: screenHeight / 80);
  }

  _buildFilterBlock() {
    return _isFilter
        ? Container(
            color: Colors.grey[100],
            child: Form(
              key: _filtersFormKey,
              child: Column(
                children: [
                  SizedBox(height: 10.0),
                  Container(
                    width: screenWidth * 0.92,
                    child: TextFormField(
                      initialValue: _filtersFormData['name'],
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Enter Name",
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        enabledBorder: buildBorder(Colors.black54),
                        focusedErrorBorder: buildBorder(Colors.black54),
                        focusedBorder: buildBorder(Colors.black54),
                        errorBorder: buildBorder(Colors.black54),
                        border: buildBorder(Colors.black54),
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        _filtersFormData['name'] = value;
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Container(
                  //     padding: padding(),
                  //     child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "Stage",
                  //             style: buildLableTextStyle(),
                  //           ),
                  //           SizedBox(height: screenHeight / 70),
                  //           Container(
                  //             height: 48.0,
                  //             margin: EdgeInsets.only(bottom: 5.0),
                  //             child: DropdownSearch<String?>(
                  //               mode: Mode.BOTTOM_SHEET,
                  //               items: opportunityBloc.stageObjforDropDown,
                  //               onChanged: print,
                  //               onSaved: (selection) {
                  //                 if (selection == null) {
                  //                   opportunityBloc
                  //                       .currentEditOpportunity['stage'] = "";
                  //                 } else {
                  //                   opportunityBloc
                  //                           .currentEditOpportunity['stage'] =
                  //                       selection;
                  //                 }
                  //               },
                  //               selectedItem: opportunityBloc
                  //                   .currentEditOpportunity['stage'],
                  //               showSearchBox: true,
                  //               showSelectedItems: false,
                  //               showClearButton: false,
                  //               searchFieldProps: TextFieldProps(
                  //                   decoration: InputDecoration(
                  //                 border: boxBorder(),
                  //                 enabledBorder: boxBorder(),
                  //                 focusedErrorBorder: boxBorder(),
                  //                 focusedBorder: boxBorder(),
                  //                 errorBorder: boxBorder(),
                  //                 contentPadding: EdgeInsets.all(12),
                  //                 hintText: "Search a Stage",
                  //               )),
                  //               popupTitle: Container(
                  //                 height: 50,
                  //                 decoration: BoxDecoration(
                  //                   color: Theme.of(context).primaryColorDark,
                  //                   borderRadius: BorderRadius.only(
                  //                     topLeft: Radius.circular(20),
                  //                     topRight: Radius.circular(20),
                  //                   ),
                  //                 ),
                  //                 child: Center(
                  //                   child: Text(
                  //                     'Stage',
                  //                     style: TextStyle(
                  //                         fontSize: screenWidth / 20,
                  //                         color: Colors.white),
                  //                   ),
                  //                 ),
                  //               ),
                  //               popupItemBuilder: (context, item, isSelected) {
                  //                 return Container(
                  //                   padding: EdgeInsets.symmetric(
                  //                       horizontal: 15.0, vertical: 10.0),
                  //                   child: Text(item!,
                  //                       style: TextStyle(
                  //                           fontSize: screenWidth / 22)),
                  //                 );
                  //               },
                  //               popupShape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.only(
                  //                   topLeft: Radius.circular(24),
                  //                   topRight: Radius.circular(24),
                  //                 ),
                  //               ),
                  //             ),
                  //           )
                  //         ])),
                  // Container(
                  //     padding: padding(),
                  //     child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "Account",
                  //             style: buildLableTextStyle(),
                  //           ),
                  //           SizedBox(height: screenHeight / 70),
                  //           Container(
                  //             height: 48.0,
                  //             margin: EdgeInsets.only(bottom: 5.0),
                  //             child: DropdownSearch<String?>(
                  //               mode: Mode.BOTTOM_SHEET,
                  //               items: opportunityBloc.accountsObjforDropDown,
                  //               onChanged: print,
                  //               onSaved: (selection) {
                  //                 if (selection == null) {
                  //                   opportunityBloc
                  //                       .currentEditOpportunity['account'] = "";
                  //                 } else {
                  //                   opportunityBloc
                  //                           .currentEditOpportunity['account'] =
                  //                       selection;
                  //                 }
                  //               },
                  //               selectedItem: opportunityBloc
                  //                   .currentEditOpportunity['account'],
                  //               showSearchBox: true,
                  //               showSelectedItems: false,
                  //               showClearButton: false,
                  //               searchFieldProps: TextFieldProps(
                  //                   decoration: InputDecoration(
                  //                 border: boxBorder(),
                  //                 enabledBorder: boxBorder(),
                  //                 focusedErrorBorder: boxBorder(),
                  //                 focusedBorder: boxBorder(),
                  //                 errorBorder: boxBorder(),
                  //                 contentPadding: EdgeInsets.all(12),
                  //                 hintText: "Search a Account",
                  //               )),
                  //               popupTitle: Container(
                  //                 height: 50,
                  //                 decoration: BoxDecoration(
                  //                   color: Theme.of(context).primaryColorDark,
                  //                   borderRadius: BorderRadius.only(
                  //                     topLeft: Radius.circular(20),
                  //                     topRight: Radius.circular(20),
                  //                   ),
                  //                 ),
                  //                 child: Center(
                  //                   child: Text(
                  //                     'Account',
                  //                     style: TextStyle(
                  //                         fontSize: screenWidth / 20,
                  //                         color: Colors.white),
                  //                   ),
                  //                 ),
                  //               ),
                  //               popupItemBuilder: (context, item, isSelected) {
                  //                 return Container(
                  //                   padding: EdgeInsets.symmetric(
                  //                       horizontal: 15.0, vertical: 10.0),
                  //                   child: Text(item!,
                  //                       style: TextStyle(
                  //                           fontSize: screenWidth / 22)),
                  //                 );
                  //               },
                  //               popupShape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.only(
                  //                   topLeft: Radius.circular(24),
                  //                   topRight: Radius.circular(24),
                  //                 ),
                  //               ),
                  //             ),
                  //           )
                  //         ])),
                  // Container(
                  //     padding: padding(),
                  //     child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "Lead Source",
                  //             style: buildLableTextStyle(),
                  //           ),
                  //           SizedBox(height: screenHeight / 70),
                  //           Container(
                  //             height: 48.0,
                  //             margin: EdgeInsets.only(bottom: 5.0),
                  //             child: DropdownSearch<String?>(
                  //               mode: Mode.BOTTOM_SHEET,
                  //               items: opportunityBloc.leadSourceObjforDropDown,
                  //               onChanged: print,
                  //               onSaved: (selection) {
                  //                 if (selection == null) {
                  //                   opportunityBloc.currentEditOpportunity[
                  //                       'lead_source'] = "";
                  //                 } else {
                  //                   opportunityBloc.currentEditOpportunity[
                  //                       'lead_source'] = selection;
                  //                 }
                  //               },
                  //               selectedItem: opportunityBloc
                  //                   .currentEditOpportunity['lead_source'],
                  //               showSearchBox: true,
                  //               showSelectedItems: false,
                  //               showClearButton: false,
                  //               searchFieldProps: TextFieldProps(
                  //                   decoration: InputDecoration(
                  //                 border: boxBorder(),
                  //                 enabledBorder: boxBorder(),
                  //                 focusedErrorBorder: boxBorder(),
                  //                 focusedBorder: boxBorder(),
                  //                 errorBorder: boxBorder(),
                  //                 contentPadding: EdgeInsets.all(12),
                  //                 hintText: "Search a Lead Source",
                  //               )),
                  //               popupTitle: Container(
                  //                 height: 50,
                  //                 decoration: BoxDecoration(
                  //                   color: Theme.of(context).primaryColorDark,
                  //                   borderRadius: BorderRadius.only(
                  //                     topLeft: Radius.circular(20),
                  //                     topRight: Radius.circular(20),
                  //                   ),
                  //                 ),
                  //                 child: Center(
                  //                   child: Text(
                  //                     'Lead source',
                  //                     style: TextStyle(
                  //                         fontSize: screenWidth / 20,
                  //                         color: Colors.white),
                  //                   ),
                  //                 ),
                  //               ),
                  //               popupItemBuilder: (context, item, isSelected) {
                  //                 return Container(
                  //                   padding: EdgeInsets.symmetric(
                  //                       horizontal: 15.0, vertical: 10.0),
                  //                   child: Text(item!,
                  //                       style: TextStyle(
                  //                           fontSize: screenWidth / 22)),
                  //                 );
                  //               },
                  //               popupShape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.only(
                  //                   topLeft: Radius.circular(24),
                  //                   topRight: Radius.circular(24),
                  //                 ),
                  //               ),
                  //             ),
                  //           )
                  //         ])),
                  SizedBox(height: 10.0),
                  Container(
                    width: screenWidth * 0.92,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: MultiSelectFormField(
                      border: boxBorder(),
                      fillColor: Colors.white,
                      dataSource: opportunityBloc.filtertags,
                      textField: 'name',
                      valueField: 'id',
                      okButtonLabel: 'OK',
                      chipLabelStyle: TextStyle(color: Colors.black),
                      cancelButtonLabel: 'CANCEL',
                      hintWidget: Text(
                        "Please choose one or more",
                        style: TextStyle(color: Colors.grey),
                      ),
                      title: Text("Tags"),
                      initialValue: _filtersFormData['tags'],
                      onSaved: (value) {
                        if (value == null) return;
                        _filtersFormData['tags'] = value;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isFilter = false;
                            });
                            FocusScope.of(context).unfocus();
                            setState(() {
                              _filtersFormData = {
                                "name": "",
                                "account": "",
                                "stage": "",
                                "lead_source": "",
                                "tags": []
                              };
                            });
                            _submitForm();
                          },
                          child: Text(
                            "Reset",
                            style: TextStyle(fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 20.0),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            onPrimary: Colors.white,
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _submitForm();
                          },
                          child: Text(
                            "Filter",
                            style: TextStyle(fontSize: screenWidth / 24),
                          )),
                    ],
                  )
                ],
              ),
            ))
        : Container();
  }

  Widget _buildopportunitiesList() {
    return _opportunities.length != 0
        ? Container(
            padding: EdgeInsets.all(10.0),
            child: ListView.builder(
                itemCount: _opportunities.length,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        opportunityBloc.currentOpportunity =
                            _opportunities[index];
                        Navigator.pushNamed(context, '/opportunitie_details');
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: Text(
                                    _opportunities[index]
                                        .name!
                                        .capitalizeFirstofEach(),
                                    style: TextStyle(
                                        color: Colors.blueGrey[800],
                                        fontWeight: FontWeight.w600,
                                        fontSize: screenWidth / 22),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // _opportunities[index].assignedTo!.length != 0
                                  //     ? Container(
                                  //         child: Row(
                                  //           children: [
                                  //             _opportunities[index]
                                  //                         .assignedTo![0]
                                  //                         .profileUrl !=
                                  //                     ""
                                  //                 ? CircleAvatar(
                                  //                     radius: screenWidth / 25,
                                  //                     backgroundImage:
                                  //                         NetworkImage(
                                  //                             _opportunities[
                                  //                                     index]
                                  //                                 .assignedTo![
                                  //                                     0]
                                  //                                 .profileUrl!),
                                  //                   )
                                  //                 : CircleAvatar(
                                  //                     radius: screenWidth / 25,
                                  //                     backgroundColor:
                                  //                         randomColor.randomColor(
                                  //                             colorBrightness:
                                  //                                 ColorBrightness
                                  //                                     .light),
                                  //                     child: Text(
                                  //                       _opportunities[index]
                                  //                           .assignedTo![0]
                                  //                           .firstName![0]
                                  //                           .toUpperCase(),
                                  //                       style: TextStyle(
                                  //                           color: Colors.white,
                                  //                           fontWeight:
                                  //                               FontWeight
                                  //                                   .bold),
                                  //                     ),
                                  //                   ),
                                  //             SizedBox(width: 3.0),
                                  //             _opportunities[index]
                                  //                         .assignedTo![0]
                                  //                         .profileUrl !=
                                  //                     ""&&_opportunities[index].assignedTo!.length<=2
                                  //                 ? CircleAvatar(
                                  //                     radius: screenWidth / 25,
                                  //                     backgroundImage:
                                  //                         NetworkImage(
                                  //                             _opportunities[
                                  //                                     index]
                                  //                                 .assignedTo![
                                  //                                     1]
                                  //                                 .profileUrl!),
                                  //                   )
                                  //                 : CircleAvatar(
                                  //                     radius: screenWidth / 25,
                                  //                     backgroundColor:
                                  //                         randomColor.randomColor(
                                  //                             colorBrightness:
                                  //                                 ColorBrightness
                                  //                                     .light),
                                  //                     child: Text(
                                  //                       _opportunities[index]
                                  //                           .assignedTo![1]
                                  //                           .firstName![0]
                                  //                           .toUpperCase(),
                                  //                       style: TextStyle(
                                  //                           color: Colors.white,
                                  //                           fontWeight:
                                  //                               FontWeight
                                  //                                   .bold),
                                  //                     ),
                                  //                   ),
                                  //             SizedBox(width: 3.0),
                                  //             CircleAvatar(
                                  //               radius: screenWidth / 25,
                                  //               backgroundColor: Colors.grey,
                                  //               child: Text(
                                  //                 "JR",
                                  //                 style: TextStyle(
                                  //                     color: Colors.white,
                                  //                     fontWeight:
                                  //                         FontWeight.bold),
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       )
                                  //     : Container(),
                                  ProfilePicViewWidget(_opportunities[index]
                                      .assignedTo!
                                      .map((assignedUser) =>
                                          assignedUser.profileUrl == ""
                                              ? assignedUser
                                                  .firstName![0].inCaps
                                              : assignedUser.profileUrl)
                                      .toList()),
                                  Row(
                                    children: [
                                      _opportunities[index].stage != ""
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5.0,
                                                  vertical: 3.0),
                                              color: randomColor.randomColor(
                                                  colorBrightness:
                                                      ColorBrightness.light),
                                              child: Text(
                                                _opportunities[index].stage!,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0),
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(width: 10.0),
                                      Container(
                                        child: Text(
                                            _opportunities[index].amount == ""
                                                ? "₹0"
                                                : "₹" +
                                                    _opportunities[index]
                                                        .amount!,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: screenWidth / 25,
                                                fontWeight: FontWeight.w600)),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                }),
          )
        : Center(
            child: Text(_isLoading || _isNextPageLoading
                ? "Fetching data..."
                : 'No Opportunitis Found.'),
          );
  }

 

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _isLoading ? Loader() : new Container();
    return Scaffold(
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  currentBottomNavigationIndex == "4"
                                      ? Navigator.pushReplacementNamed(
                                          context, "/dashboard")
                                      : Navigator.pushReplacementNamed(
                                          context, "/more_options");
                                },
                                child: Icon(Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: screenWidth / 18)),
                            SizedBox(width: 10.0),
                            Text(
                              'Opportunities',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth / 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isFilter = !_isFilter;
                                    });
                                  },
                                  child: Container(
                                      child: SvgPicture.asset(
                                    !_isFilter
                                        ? 'assets/images/filter.svg'
                                        : 'assets/images/icon_close.svg',
                                    width: screenWidth / 20,
                                  )))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                          height: screenHeight * 0.06,
                          decoration: BoxDecoration(
                            color: bottomNavBarSelectedTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildFilterBlock(),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: _buildopportunitiesList(),
                    ),
                  ),
                  _isNextPageLoading
                      ? Container(
                          color: Colors.white,
                          child: Container(
                              width: 20.0,
                              child: new Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: new Center(
                                      child: new CircularProgressIndicator()))))
                      : Container()
                ],
              ),
            ),
          ),
          new Align(
            child: loadingIndicator,
            alignment: FractionalOffset.center,
          )
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            opportunityBloc.currentEditOpportunityId = "";
            if (opportunityBloc.opportunities.length == 0) {
              showAlertDialog(context);
            } else {
              Navigator.pushNamed(context, '/opportunitie_create');
            }
          },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        bottomNavigationBar: BottomNavigationBarWidget());
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              "Alert",
              style: TextStyle(color: Colors.black),
            ),
            content: Text(
              "You don't have any opportunity, Please create opportunity first.",
              style: TextStyle(fontSize: 15.0),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                  textStyle: TextStyle(color: Colors.red),
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    currentBottomNavigationIndex = "4";
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/opportunitie_create");
                  },
                  child: Text("Create")),
            ],
          );
        });
  }
}
