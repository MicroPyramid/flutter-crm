import 'package:dropdown_search/dropdown_search.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/account_bloc.dart';
import 'package:flutter_crm/bloc/lead_bloc.dart';
import 'package:flutter_crm/model/lead.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/ui/widgets/squareFloatingActionBtn.dart';
import 'package:flutter_crm/ui/widgets/tags_widget.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class LeadsList extends StatefulWidget {
  LeadsList();
  @override
  State createState() => _LeadsListState();
}

class _LeadsListState extends State<LeadsList> {
  var _currentTabIndex = 0;
  final GlobalKey<FormState> _filtersFormKey = GlobalKey<FormState>();

  bool _isFilter = false;

  List<Lead> _leads = [];
  Map _filtersFormData = {
    "title": "",
    "source": null,
    "assigned_to": [],
    "status": null,
    "tags": ""
  };
  bool _isLoading = false;

  @override
  void initState() {
    accountBloc.fetchAccounts();
    setState(() {
      _leads = leadBloc.openLeads;
    });
    super.initState();
  }

  _saveForm() async {
    if (_isFilter) {
      _filtersFormKey.currentState.save();
    }
    // if (_isFilter &&
    //     _filtersFormData['title'] == "" &&
    //     _filtersFormData['source'] == "" &&
    //     _filtersFormData['assigned_to'] == "" &&
    //     _filtersFormData['status'] == "" &&
    //     _filtersFormData['tags'] == "") {
    //   return;
    // }
    setState(() {
      _isLoading = true;
    });
    await leadBloc.fetchLeads(filtersData: _isFilter ? _filtersFormData : null);
    setState(() {
      _isLoading = false;
      _currentTabIndex = 0;
    });
    leadBloc.currentLeadType = "Open";
  }

  void showErrorMessage(
      BuildContext context, String errorContent, Lead lead, int index) {
    Flushbar(
      backgroundColor: Colors.white,
      messageText: Text(errorContent,
          style:
              GoogleFonts.robotoSlab(textStyle: TextStyle(color: Colors.red))),
      isDismissible: false,
      mainButton: FlatButton(
        child: Text('TRY AGAIN',
            style: GoogleFonts.robotoSlab(
                textStyle: TextStyle(color: Theme.of(context).accentColor))),
        onPressed: () {
          Navigator.of(context).pop(true);
          deleteLead(index, lead);
        },
      ),
      duration: Duration(seconds: 10),
    )..show(context);
  }

  void showDeleteLeadAlertDialog(BuildContext context, Lead lead, index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              lead.title,
              style: GoogleFonts.robotoSlab(
                  color: Theme.of(context).secondaryHeaderColor),
            ),
            content: Text(
              "Are you sure you want to delete this lead?",
              style: GoogleFonts.robotoSlab(fontSize: 15.0),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.robotoSlab(),
                  )),
              CupertinoDialogAction(
                  textStyle: TextStyle(color: Colors.red),
                  isDefaultAction: true,
                  onPressed: () async {
                    deleteLead(index, lead);
                  },
                  child: Text(
                    "Delete",
                    style: GoogleFonts.robotoSlab(),
                  )),
            ],
          );
        });
  }

  deleteLead(index, lead) async {
    Map result = await leadBloc.deleteLead(lead);
    if (result['error'] == false) {
      showToast(result['message']);
      Navigator.pop(context);
      setState(() {
        _leads.removeAt(index);
      });
    } else if (result['error'] == true) {
      Navigator.pop(context);
    } else {
      showErrorMessage(context, 'Something went wrong', lead, index);
    }
  }

  Widget _buildMultiSelectDropdown(data) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: MultiSelectFormField(
        border: boxBorder(),
        fillColor: Colors.white,
        autovalidate: false,
        dataSource: data,
        textField: 'name',
        valueField: 'id',
        okButtonLabel: 'OK',
        chipLabelStyle:
            GoogleFonts.robotoSlab(textStyle: TextStyle(color: Colors.black)),
        dialogTextStyle: GoogleFonts.robotoSlab(),
        cancelButtonLabel: 'CANCEL',
        hintWidget: Text(
          "Please choose one or more",
          style:
              GoogleFonts.robotoSlab(textStyle: TextStyle(color: Colors.grey)),
        ),
        title: Text(
          "Users",
          style: GoogleFonts.robotoSlab(
              textStyle: TextStyle(color: Colors.grey[700]),
              fontSize: screenWidth / 26),
        ),
        initialValue: _filtersFormData["assigned_to"],
        onSaved: (value) {
          if (value == null) {
            _filtersFormData["assigned_to"] = [];
          } else {
            _filtersFormData["assigned_to"] = value;
          }
        },
      ),
    );
  }

  Widget _buildFilterWidget() {
    return _isFilter
        ? Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(top: 10.0),
            color: Colors.white,
            child: Form(
              key: _filtersFormKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      initialValue: _filtersFormData["title"],
                      onSaved: (newValue) {
                        _filtersFormData['title'] = newValue;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          enabledBorder: boxBorder(),
                          focusedErrorBorder: boxBorder(),
                          focusedBorder: boxBorder(),
                          errorBorder: boxBorder(),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Enter Lead Title',
                          errorStyle: GoogleFonts.robotoSlab(),
                          hintStyle: GoogleFonts.robotoSlab(
                              textStyle:
                                  TextStyle(fontSize: screenWidth / 26))),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      height: 48.0,
                      child: DropdownSearch<String>(
                        mode: Mode.BOTTOM_SHEET,
                        items: leadBloc.source,
                        onChanged: print,
                        selectedItem: _filtersFormData['source'] == ""
                            ? null
                            : _filtersFormData['source'],
                        hint: "Select Source",
                        showSearchBox: true,
                        showSelectedItem: false,
                        showClearButton: true,
                        searchBoxDecoration: InputDecoration(
                          border: boxBorder(),
                          enabledBorder: boxBorder(),
                          focusedErrorBorder: boxBorder(),
                          focusedBorder: boxBorder(),
                          errorBorder: boxBorder(),
                          contentPadding: EdgeInsets.all(12),
                          hintText: "Search a Source here.",
                          hintStyle: GoogleFonts.robotoSlab(),
                        ),
                        popupTitle: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorDark,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Source',
                              style: GoogleFonts.robotoSlab(
                                  textStyle: TextStyle(
                                      fontSize: screenWidth / 20,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                        popupShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        onSaved: (newValue) {
                          _filtersFormData['source'] = newValue;
                        },
                      )),
                  _buildMultiSelectDropdown(leadBloc.usersObjForDropdown),
                  Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      height: 48.0,
                      child: DropdownSearch<String>(
                        mode: Mode.BOTTOM_SHEET,
                        items: leadBloc.source,
                        onChanged: print,
                        selectedItem: _filtersFormData['status'] == ""
                            ? null
                            : _filtersFormData['status'],
                        hint: "Select Status",
                        showSearchBox: true,
                        showSelectedItem: false,
                        showClearButton: true,
                        searchBoxDecoration: InputDecoration(
                          border: boxBorder(),
                          enabledBorder: boxBorder(),
                          focusedErrorBorder: boxBorder(),
                          focusedBorder: boxBorder(),
                          errorBorder: boxBorder(),
                          contentPadding: EdgeInsets.all(12),
                          hintText: "Search a Status here.",
                          hintStyle: GoogleFonts.robotoSlab(),
                        ),
                        popupTitle: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorDark,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Status',
                              style: GoogleFonts.robotoSlab(
                                  textStyle: TextStyle(
                                      fontSize: screenWidth / 20,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                        popupShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        onSaved: (newValue) {
                          _filtersFormData['status'] = newValue;
                        },
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: MultiSelectFormField(
                      border: boxBorder(),
                      fillColor: Colors.white,
                      autovalidate: false,
                      dataSource: leadBloc.tags,
                      textField: 'name',
                      valueField: 'id',
                      okButtonLabel: 'OK',
                      chipLabelStyle: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(color: Colors.black)),
                      dialogTextStyle: GoogleFonts.robotoSlab(),
                      cancelButtonLabel: 'CANCEL',
                      hintWidget: Text(
                        "Please choose one or more",
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(color: Colors.grey)),
                      ),
                      title: Text(
                        "Tags",
                        style: GoogleFonts.robotoSlab(),
                      ),
                      // initialValue:
                      //     accountBloc.currentEditAccount['assigned_to'],
                      onSaved: (value) {
                        if (value == null) return;
                        _filtersFormData['tags'] = value;
                      },
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            _saveForm();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: screenHeight * 0.05,
                            width: screenWidth * 0.3,
                            decoration: BoxDecoration(
                              color: submitButtonColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Filter',
                                  style: GoogleFonts.robotoSlab(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: screenWidth / 24)),
                                ),
                                SvgPicture.asset(
                                    'assets/images/arrow_forward.svg')
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
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
                            _saveForm();
                          },
                          child: Container(
                            child: Text(
                              "Reset",
                              style: GoogleFonts.robotoSlab(
                                  textStyle: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: bottomNavBarTextColor,
                                      fontSize: screenWidth / 24)),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  Widget _buildTabs() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (_currentTabIndex != 0) {
                    setState(() {
                      _currentTabIndex = 0;
                      _leads = leadBloc.openLeads;
                    });
                    leadBloc.currentLeadType = "Open";
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: _currentTabIndex == 0
                          ? Theme.of(context).secondaryHeaderColor
                          : Colors.white,
                      border: Border.all(
                          color: _currentTabIndex == 0
                              ? Theme.of(context).secondaryHeaderColor
                              : bottomNavBarTextColor)),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 8.0),
                        child: Text(
                          "Open",
                          style: GoogleFonts.robotoSlab(
                              fontSize: screenWidth / 25,
                              color: _currentTabIndex == 0
                                  ? Colors.white
                                  : bottomNavBarTextColor),
                        ),
                      ),
                      Container(
                        color:
                            _currentTabIndex == 0 ? Colors.white : Colors.grey,
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          leadBloc.openLeads.length.toString(),
                          style: GoogleFonts.robotoSlab(
                              fontSize: screenWidth / 25,
                              color: _currentTabIndex == 0
                                  ? Theme.of(context).secondaryHeaderColor
                                  : Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_currentTabIndex != 1) {
                    setState(() {
                      _currentTabIndex = 1;
                      _leads = leadBloc.closedLeads;
                    });
                    leadBloc.currentLeadType = "Closed";
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                      color: _currentTabIndex == 1
                          ? Theme.of(context).secondaryHeaderColor
                          : Colors.white,
                      border: Border.all(
                          color: _currentTabIndex == 1
                              ? Theme.of(context).secondaryHeaderColor
                              : bottomNavBarTextColor)),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 8.0),
                        child: Text(
                          "Closed",
                          style: GoogleFonts.robotoSlab(
                              fontSize: screenWidth / 25,
                              color: _currentTabIndex == 1
                                  ? Colors.white
                                  : bottomNavBarTextColor),
                        ),
                      ),
                      Container(
                        color:
                            _currentTabIndex == 1 ? Colors.white : Colors.grey,
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          leadBloc.closedLeads.length.toString(),
                          style: GoogleFonts.robotoSlab(
                              fontSize: screenWidth / 25,
                              color: _currentTabIndex == 1
                                  ? Theme.of(context).secondaryHeaderColor
                                  : Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
              onTap: () {
                setState(() {
                  _isFilter = !_isFilter;
                });
              },
              child: Container(
                  padding: EdgeInsets.all(5.0),
                  color:
                      _leads.length > 0 ? bottomNavBarTextColor : Colors.grey,
                  child: SvgPicture.asset(
                    !_isFilter
                        ? 'assets/images/filter.svg'
                        : 'assets/images/icon_close.svg',
                    width: screenWidth / 20,
                  )))
        ],
      ),
    );
  }

  Widget _buildLeadList() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: ListView.builder(
          itemCount: _leads.length,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                leadBloc.currentLead = _leads[index];
                Navigator.pushNamed(context, '/lead_details');
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                color: Colors.white,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: _leads[index].createdBy.profileUrl != null &&
                              _leads[index].createdBy.profileUrl != ""
                          ? CircleAvatar(
                              radius: screenWidth / 15,
                              backgroundImage: NetworkImage(
                                  _leads[index].createdBy.profileUrl),
                            )
                          : CircleAvatar(
                              radius: screenWidth / 15,
                              child: Icon(
                                Icons.person,
                                size: screenWidth / 10,
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.grey,
                            ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: screenWidth * 0.54,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: screenWidth * 0.34,
                                  child: Text(
                                    _leads[index].title,
                                    style: GoogleFonts.robotoSlab(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                        fontSize: screenWidth / 25,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Container(
                                  width: screenWidth * 0.20,
                                  child: Text(
                                    _leads[index].createdOn.substring(0, 10),
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.robotoSlab(
                                        color: bottomNavBarTextColor,
                                        fontSize: screenWidth / 26,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          ),
                          _leads[index].tags.length != 0
                              ? Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  width: screenWidth * 0.54,
                                  child: TagViewWidget(_leads[index].tags),
                                )
                              : Container()
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await leadBloc.updateCurrentEditLead(_leads[index]);
                        Navigator.pushNamed(context, '/create_lead');
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 5.0),
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 1.0, color: Colors.grey[300]),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        padding: EdgeInsets.all(4.0),
                        child: SvgPicture.asset(
                          'assets/images/Icon_edit_color.svg',
                          width: screenWidth / 23,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDeleteLeadAlertDialog(
                            context, _leads[index], index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 1.0, color: Colors.grey[300]),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        padding: EdgeInsets.all(4.0),
                        child: SvgPicture.asset(
                          'assets/images/icon_delete_color.svg',
                          width: screenWidth / 23,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _isLoading
        ? new Container(
            color: Colors.transparent,
            width: 300.0,
            height: 300.0,
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(child: new CircularProgressIndicator())),
          )
        : new Container();
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Leads", style: GoogleFonts.robotoSlab()),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Container(
                height: screenHeight,
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    _buildTabs(),
                    _buildFilterWidget(),
                    _leads.length > 0
                        ? Expanded(child: _buildLeadList())
                        : Container(
                            margin: EdgeInsets.only(top: 30.0),
                            child: Text(
                              "No Leads Found",
                              style: GoogleFonts.robotoSlab(),
                            ),
                          )
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
        floatingActionButton:
            SquareFloatingActionButton('/create_lead', "Add Lead", "Leads"),
        bottomNavigationBar: BottomNavigationBarWidget(),
      ),
    );
  }
}
