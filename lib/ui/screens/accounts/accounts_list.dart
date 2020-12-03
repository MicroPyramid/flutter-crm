import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crm/bloc/account_bloc.dart';
import 'package:flutter_crm/model/account.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_color/random_color.dart';

class AccountsList extends StatefulWidget {
  AccountsList();
  @override
  State createState() => _AccountsListState();
}

class _AccountsListState extends State<AccountsList> {
  int _currentTabIndex = 0;
  List<Account> _accounts = [];
  bool _isFilter = false;

  @override
  void initState() {
    setState(() {
      _accounts = accountBloc.openAccounts;
    });
    super.initState();
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
                      _accounts = accountBloc.openAccounts;
                      _isFilter = false;
                    });
                    accountBloc.currentAccountType = "Open";
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
                          accountBloc.openAccounts.length.toString(),
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
                      _accounts = accountBloc.closedAccounts;
                      _isFilter = false;
                    });
                    accountBloc.currentAccountType = "Closed";
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
                          accountBloc.closedAccounts.length.toString(),
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
                if (_accounts.length > 0) {
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
              ))
        ],
      ),
    );
  }

  Widget _buildFilterWidget() {
    return _isFilter ? Container() : Container();
  }

  Widget _buildAccountList() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: ListView.builder(
          itemCount: _accounts.length,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                accountBloc.currentAccount = _accounts[index];
                Navigator.pushNamed(context, '/account_details');
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                color: Colors.white,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: _accounts[index].createdBy.profileUrl != null &&
                              _accounts[index].createdBy.profileUrl != ""
                          ? CircleAvatar(
                              radius: screenWidth / 15,
                              backgroundImage: NetworkImage(
                                  _accounts[index].createdBy.profileUrl),
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
                                    _accounts[index].name,
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
                                    _accounts[index].createdOn,
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
                          _accounts[index].tags.length != 0
                              ? Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  width: screenWidth * 0.54,
                                  height: screenHeight / 33,
                                  child: ListView.builder(
                                      // physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _accounts[index].tags.length,
                                      itemBuilder:
                                          (BuildContext context, int tagIndex) {
                                        return Container(
                                          margin: EdgeInsets.only(right: 5.0),
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          color: randomColor.randomColor(
                                              colorBrightness:
                                                  ColorBrightness.light),
                                          child: Text(
                                            _accounts[index].tags[tagIndex]
                                                ['name'],
                                            style: GoogleFonts.robotoSlab(
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0)),
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
        appBar: AppBar(title: Text("Accounts")),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              _buildTabs(),
              _buildFilterWidget(),
              _accounts.length > 0
                  ? Expanded(child: _buildAccountList())
                  : Container(
                      margin: EdgeInsets.only(top: 30.0),
                      child: Text(
                        "No Account Found",
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
