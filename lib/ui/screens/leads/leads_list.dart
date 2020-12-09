import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/lead_bloc.dart';
import 'package:flutter_crm/model/lead.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_color/random_color.dart';

class LeadsList extends StatefulWidget {
  LeadsList();
  @override
  State createState() => _LeadsListState();
}

class _LeadsListState extends State<LeadsList> {
  var _currentTabIndex = 0;

  bool _isFilter = false;
  bool _isEdit = false;
  List<Lead> _leads = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _leads = leadBloc.openLeads;
    });
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
                      _isFilter = false;
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
                      _isFilter = false;
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
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    if (_leads.length > 0) {
                      setState(() {
                        _isEdit = !_isEdit;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(3.0),
                    color: Colors.grey[700],
                    child: Icon(
                      !_isEdit ? Icons.edit : Icons.close,
                      color: Colors.white,
                      size: screenWidth / 15,
                    ),
                  )),
              SizedBox(width: 3,),
              GestureDetector(
                  onTap: () {
                    if (_leads.length > 0) {
                      setState(() {
                        _isFilter = !_isFilter;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(3.0),
                    color: Colors.grey[700],
                    child: Icon(
                      !_isFilter ? Icons.filter_alt_outlined : Icons.close,
                      color: Colors.white,
                      size: screenWidth / 15,
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAccountList() {
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
                            height: screenHeight / 33,
                            child: ListView.builder(
                              // physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: _leads[index].tags.length,
                                itemBuilder:
                                    (BuildContext context, int tagIndex) {
                                  return Container(
                                    margin: EdgeInsets.only(right: 5.0),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                                    color: randomColor.randomColor(
                                        colorBrightness: ColorBrightness.light),
                                    child: Text(
                                      _leads[index].tags[tagIndex]
                                      ['name'],
                                      style: GoogleFonts.robotoSlab(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth/35)),
                                    ),
                                  );
                                }),
                          )
                              : Container()
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(right: 5.0),
                        decoration: BoxDecoration(
                          border:
                          Border.all(width: 1.0, color: Colors.grey[300]),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        padding: EdgeInsets.all(3.0),
                        child: Icon(
                          Icons.edit_outlined,
                          size: screenWidth / 20,
                          color: Color.fromRGBO(117, 174, 51, 1),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                          Border.all(width: 1.0, color: Colors.grey[300]),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        padding: EdgeInsets.all(3.0),
                        child: Icon(
                          Icons.delete_outlined,
                          size: screenWidth / 20,
                          color: Color.fromRGBO(234, 67, 53, 1),
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
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Leads",
              style: GoogleFonts.robotoSlab()),
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              _buildTabs(),
              _leads.length > 0
                  ? Expanded(child: _buildAccountList())
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
        bottomNavigationBar: BottomNavigationBarWidget(),
      ),
    );
  }
}
