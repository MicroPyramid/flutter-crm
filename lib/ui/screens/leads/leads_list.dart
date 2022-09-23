import 'package:bottle_crm/bloc/user_bloc.dart';
import 'package:bottle_crm/ui/widgets/loader.dart';
import 'package:bottle_crm/ui/widgets/profile_pic_widget.dart';
//import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottle_crm/bloc/lead_bloc.dart';
import 'package:bottle_crm/model/lead.dart';
import 'package:bottle_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:random_color/random_color.dart';

class LeadsList extends StatefulWidget {
  LeadsList();
  @override
  State createState() => _LeadsListState();
}

class _LeadsListState extends State<LeadsList> {
  var _currentTabIndex = 0;
  final GlobalKey<FormState> _filtersFormKey = GlobalKey<FormState>();
  bool _isFilter = false;
  List<Lead> _openLeads = [];
  List<Lead> _closedLeads = [];
  Map _filtersFormData = {
    "title": "",
    "source": null,
    "assigned_to": [],
    "status": null,
    "tags": []
  };
  bool _isLoading = false;
  bool _isNextPageLoading = false;
  ScrollController? scrollController;

  @override
  void initState() {
    setState(() {
      _openLeads = leadBloc.openLeads;
      _closedLeads = leadBloc.closedLeads;
    });
    scrollController = ScrollController();
    scrollController!.addListener(() async {
      if (scrollController!.offset >=
              scrollController!.position.maxScrollExtent &&
          !scrollController!.position.outOfRange &&
          leadBloc.offset != "" &&
          !_isNextPageLoading) {
        setState(() {
          _isNextPageLoading = true;
        });
        await leadBloc.fetchLeads(
            filtersData: _isFilter ? _filtersFormData : null);
        setState(() {
          _isNextPageLoading = false;
        });
      }
    });
    super.initState();
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

  _submitForm() async {
    if (_isFilter) {
      _filtersFormKey.currentState!.save();
    }
    setState(() {
      _isLoading = true;
    });
    leadBloc.offset = "";
    leadBloc.openLeads.clear();
    leadBloc.closedLeads.clear();
    await leadBloc.fetchLeads(filtersData: _isFilter ? _filtersFormData : null);
    setState(() {
      _isLoading = false;
    });
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
                      initialValue: _filtersFormData['title'],
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Enter title",
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
                        _filtersFormData['title'] = value;
                      },
                    ),
                  ),
                  // Container(
                  //     padding: padding(),
                  //     child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "Status",
                  //             style: TextStyle(
                  //                 fontSize: 18, color: Colors.black54),
                  //           ),
                  //           SizedBox(height: screenHeight / 70),
                  //           Container(
                  //               width: screenWidth * 0.92,
                  //               height: screenHeight / 17,
                  //               child: Stack(children: [
                  //                 DropdownSearch<String?>(
                  //                   mode: Mode.BOTTOM_SHEET,
                  //                   items: leadBloc.status,
                  //                   onChanged: print,
                  //                   onSaved: (selection) {
                  //                     if (selection == null) {
                  //                       leadBloc.currentEditLead["status"] = "";
                  //                     } else {
                  //                       leadBloc.currentEditLead['status '] =
                  //                           selection;
                  //                     }
                  //                   },
                  //                   selectedItem:
                  //                       leadBloc.currentEditLead['status '],
                  //                   showSearchBox: true,
                  //                   showSelectedItems: false,
                  //                   showClearButton: false,
                  //                   searchFieldProps: TextFieldProps(
                  //                       decoration: InputDecoration(
                  //                     border: boxBorder(),
                  //                     enabledBorder: boxBorder(),
                  //                     focusedErrorBorder: boxBorder(),
                  //                     focusedBorder: boxBorder(),
                  //                     errorBorder: boxBorder(),
                  //                     contentPadding: EdgeInsets.all(12),
                  //                     hintText: "Search a Status",
                  //                   )),
                  //                   popupTitle: Container(
                  //                     height: 50,
                  //                     decoration: BoxDecoration(
                  //                       color:
                  //                           Theme.of(context).primaryColorDark,
                  //                       borderRadius: BorderRadius.only(
                  //                         topLeft: Radius.circular(20),
                  //                         topRight: Radius.circular(20),
                  //                       ),
                  //                     ),
                  //                     child: Center(
                  //                       child: Text(
                  //                         'Source',
                  //                         style: TextStyle(
                  //                             fontSize: screenWidth / 20,
                  //                             color: Colors.white),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   popupItemBuilder:
                  //                       (context, item, isSelected) {
                  //                     return Container(
                  //                       padding: EdgeInsets.symmetric(
                  //                           horizontal: 15.0, vertical: 10.0),
                  //                       child: Text(item!,
                  //                           style: TextStyle(
                  //                               fontSize: screenWidth / 22)),
                  //                     );
                  //                   },
                  //                   popupShape: RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.only(
                  //                       topLeft: Radius.circular(24),
                  //                       topRight: Radius.circular(24),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ])),
                  //         ])),
                  // Container(
                  //     padding: padding(),
                  //     child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "Source",
                  //             style: TextStyle(
                  //                 fontSize: 18, color: Colors.black54),
                  //           ),
                  //           SizedBox(height: screenHeight / 70),
                  //           Container(
                  //               width: screenWidth * 0.92,
                  //               height: screenHeight / 17,
                  //               child: Stack(children: [
                  //                 DropdownSearch<String?>(
                  //                   mode: Mode.BOTTOM_SHEET,
                  //                   items: leadBloc.source,
                  //                   onChanged: print,
                  //                   onSaved: (selection) {
                  //                     if (selection == null) {
                  //                       leadBloc.currentEditLead["source"] = "";
                  //                     } else {
                  //                       leadBloc.currentEditLead['source '] =
                  //                           selection;
                  //                     }
                  //                   },
                  //                   selectedItem:
                  //                       leadBloc.currentEditLead['source '],
                  //                   showSearchBox: true,
                  //                   showSelectedItems: false,
                  //                   showClearButton: false,
                  //                   searchFieldProps: TextFieldProps(
                  //                       decoration: InputDecoration(
                  //                     border: boxBorder(),
                  //                     enabledBorder: boxBorder(),
                  //                     focusedErrorBorder: boxBorder(),
                  //                     focusedBorder: boxBorder(),
                  //                     errorBorder: boxBorder(),
                  //                     contentPadding: EdgeInsets.all(12),
                  //                     hintText: "Search a Source",
                  //                   )),
                  //                   popupTitle: Container(
                  //                     height: 50,
                  //                     decoration: BoxDecoration(
                  //                       color:
                  //                           Theme.of(context).primaryColorDark,
                  //                       borderRadius: BorderRadius.only(
                  //                         topLeft: Radius.circular(20),
                  //                         topRight: Radius.circular(20),
                  //                       ),
                  //                     ),
                  //                     child: Center(
                  //                       child: Text(
                  //                         'Source',
                  //                         style: TextStyle(
                  //                             fontSize: screenWidth / 20,
                  //                             color: Colors.white),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   popupItemBuilder:
                  //                       (context, item, isSelected) {
                  //                     return Container(
                  //                       padding: EdgeInsets.symmetric(
                  //                           horizontal: 15.0, vertical: 10.0),
                  //                       child: Text(item!,
                  //                           style: TextStyle(
                  //                               fontSize: screenWidth / 22)),
                  //                     );
                  //                   },
                  //                   popupShape: RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.only(
                  //                       topLeft: Radius.circular(24),
                  //                       topRight: Radius.circular(24),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ])),
                  //         ])),
                  SizedBox(height: 10.0),
                  Container(
                    padding: padding(),
                    child: Container(
                      width: screenWidth * 0.92,
                      child: Container(
                        child: MultiSelectFormField(
                          border: boxBorder(),
                          fillColor: Colors.white,
                          dataSource: userBloc.usersObjForDropdown,
                          textField: 'name',
                          valueField: 'id',
                          okButtonLabel: 'OK',
                          chipLabelStyle: TextStyle(color: Colors.black),
                          cancelButtonLabel: 'CANCEL',
                          // required: true,
                          hintWidget: Text(
                            "Please choose one or more",
                            style: TextStyle(color: Colors.grey),
                          ),
                          title: Text(
                            "Users",
                          ),
                          initialValue: _filtersFormData['assigned_to'],
                          onSaved: (value) {
                            if (value == null) return;
                            _filtersFormData['assigned_to'] = value;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    width: screenWidth * 0.92,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: MultiSelectFormField(
                      border: boxBorder(),
                      fillColor: Colors.white,
                      dataSource: leadBloc.filterTags,
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
                                "title": "",
                                "source": null,
                                "assigned_to": [],
                                "status": null,
                                "tags": ""
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

  buildTopBar() {
    if (_currentTabIndex == 0) {
      return _buildOpenLeadList();
    } else if (_currentTabIndex == 1) {
      return _buildClosedLeadList();
    }
  }

  Widget _buildOpenLeadList() {
    return _openLeads.length != 0
        ? SwipeDetector(
            onSwipeLeft: (offset) {
              setState(() {
                _currentTabIndex = 1;
                _closedLeads = leadBloc.closedLeads;
              });
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                  itemCount: _openLeads.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  controller: scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          leadBloc.currentLead = _openLeads[index];
                          Navigator.pushNamed(context, '/lead_details');
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  _openLeads[index].title!,
                                  style: TextStyle(
                                      color: Colors.blueGrey[800],
                                      fontWeight: FontWeight.w600,
                                      fontSize: screenWidth / 24),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: ProfilePicViewWidget(
                                          _openLeads[index]
                                              .assignedTo!
                                              .map((assignedUser) =>
                                                  assignedUser.profileUrl == ""
                                                      ? assignedUser
                                                          .firstName![0].inCaps
                                                      : assignedUser.profileUrl)
                                              .toList()),
                                    ),
                                    Row(
                                      children: [
                                        _openLeads[index].status != ""
                                            ? Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.0,
                                                    vertical: 3.0),
                                                color: randomColor.randomColor(
                                                    colorBrightness:
                                                        ColorBrightness.light),
                                                child: Text(
                                                  _openLeads[index].status == ""
                                                      ? ""
                                                      : _openLeads[index]
                                                          .status!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.0),
                                                ),
                                              )
                                            : Container(),
                                        SizedBox(width: 10.0),
                                        Container(
                                          child: Text(
                                              _openLeads[index]
                                                          .opportunityAmount ==
                                                      ""
                                                  ? "₹0"
                                                  : "₹" +
                                                      _openLeads[index]
                                                          .opportunityAmount!,
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
                              )
                            ],
                          ),
                        ));
                  }),
            ),
          )
        : SwipeDetector(
            onSwipeLeft: (offset) {
              setState(() {
                _currentTabIndex = 1;
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: screenHeight,
              width: screenWidth,
              color: Colors.white,
              child: Text(_isLoading || _isNextPageLoading
                  ? "Fetching data..."
                  : 'No Open Leas Found.'),
            ),
          );
  }

  Widget _buildClosedLeadList() {
    return _closedLeads.length != 0
        ? SwipeDetector(
            onSwipeRight: (offset) {
              setState(() {
                _currentTabIndex = 0;
              });
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                  itemCount: _closedLeads.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  controller: scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          leadBloc.currentLead = _closedLeads[index];
                          Navigator.pushNamed(context, '/lead_details');
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  _closedLeads[index].title!,
                                  style: TextStyle(
                                      color: Colors.blueGrey[800],
                                      fontWeight: FontWeight.w600,
                                      fontSize: screenWidth / 24),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: ProfilePicViewWidget(
                                          _closedLeads[index]
                                              .assignedTo!
                                              .map((assignedUser) =>
                                                  assignedUser.profileUrl == ""
                                                      ? assignedUser
                                                          .firstName![0].inCaps
                                                      : assignedUser.profileUrl)
                                              .toList()),
                                    ),
                                    Row(
                                      children: [
                                        _closedLeads[index].status != ""
                                            ? Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.0,
                                                    vertical: 3.0),
                                                color: randomColor.randomColor(
                                                    colorBrightness:
                                                        ColorBrightness.light),
                                                child: Text(
                                                  _closedLeads[index].status ==
                                                          ""
                                                      ? ""
                                                      : _closedLeads[index]
                                                          .status!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.0),
                                                ),
                                              )
                                            : Container(),
                                        SizedBox(width: 10.0),
                                        Container(
                                          child: Text(
                                              _closedLeads[index]
                                                          .opportunityAmount ==
                                                      ""
                                                  ? "₹0"
                                                  : "₹" +
                                                      _closedLeads[index]
                                                          .opportunityAmount!,
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
                              )
                            ],
                          ),
                        ));
                  }),
            ),
          )
        : SwipeDetector(
            onSwipeRight: (offset) {
              setState(() {
                _currentTabIndex = 0;
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: screenHeight,
              width: screenWidth,
              color: Colors.white,
              child: Text(_isLoading || _isNextPageLoading
                  ? "Fetching data..."
                  : 'No Closed Leads Found.'),
            ),
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
                              'Leads',
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (_currentTabIndex != 0) {
                                    setState(() {
                                      _currentTabIndex = 0;
                                    });
                                  }
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
                                  width: screenWidth * 0.15,
                                  child: Text(
                                    'Open',
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
                              GestureDetector(
                                onTap: () {
                                  if (_currentTabIndex != 1) {
                                    setState(() {
                                      _currentTabIndex = 1;
                                      _closedLeads = leadBloc.closedLeads;
                                    });
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: screenHeight * 0.06,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                    color: Colors.white,
                                    width: _currentTabIndex == 1 ? 3.0 : 0.0,
                                  ))),
                                  width: screenWidth * 0.15,
                                  child: Text(
                                    'Closed',
                                    style: TextStyle(
                                        color: _currentTabIndex == 1
                                            ? Colors.white
                                            : Theme.of(context)
                                                .secondaryHeaderColor,
                                        fontSize: screenWidth / 25,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildFilterBlock(),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: GestureDetector(child: buildTopBar()),
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
            leadBloc.currentEditLeadId = "";
            if (leadBloc.openLeads.length == 0 &&
                leadBloc.closedLeads.length == 0) {
              showAlertDialog(context);
            } else {
              Navigator.pushNamed(context, '/leads_create');
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
              "You don't have any leads, Please create lead first.",
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
                    Navigator.pushNamed(context, "/leads_create");
                  },
                  child: Text("Create")),
            ],
          );
        });
  }
}
