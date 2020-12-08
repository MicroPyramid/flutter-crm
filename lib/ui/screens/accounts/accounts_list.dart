import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crm/bloc/account_bloc.dart';
import 'package:flutter_crm/model/account.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/ui/widgets/tags_widget.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  padding: EdgeInsets.all(5.0),
                  color: _accounts.length > 0
                      ? bottomNavBarTextColor
                      : Colors.grey,
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

  Widget _buildFilterWidget() {
    return _isFilter
        ? Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(top: 10.0),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12.0),
                        enabledBorder: boxBorder(),
                        focusedErrorBorder: boxBorder(),
                        focusedBorder: boxBorder(),
                        errorBorder: boxBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Enter Account Name',
                        errorStyle: GoogleFonts.robotoSlab(),
                        hintStyle: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(fontSize: 14.0))),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12.0),
                        enabledBorder: boxBorder(),
                        focusedErrorBorder: boxBorder(),
                        focusedBorder: boxBorder(),
                        errorBorder: boxBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Enter City',
                        errorStyle: GoogleFonts.robotoSlab(),
                        hintStyle: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(fontSize: 14.0))),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12.0),
                        enabledBorder: boxBorder(),
                        focusedErrorBorder: boxBorder(),
                        focusedBorder: boxBorder(),
                        errorBorder: boxBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Tags',
                        errorStyle: GoogleFonts.robotoSlab(),
                        hintStyle: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(fontSize: 14.0))),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {},
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
          )
        : Container();
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
                accountBloc.currentAccountIndex = index;
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
                                  child: TagViewWidget(_accounts[index].tags),
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
                        padding: EdgeInsets.all(4.0),
                        child: SvgPicture.asset(
                          'assets/images/Icon_edit_color.svg',
                          width: screenWidth / 23,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDeleteAccountAlertDialog(
                            context, _accounts[index], index);
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

  void showDeleteAccountAlertDialog(
      BuildContext context, Account account, index) {
    showDialog(
        context: context,
        child: CupertinoAlertDialog(
          title: Text(
            account.name,
            style: GoogleFonts.robotoSlab(
                color: Theme.of(context).secondaryHeaderColor),
          ),
          content: Text(
            "Are you sure you want to delete this account?",
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
                  deleteAccount(index, account);
                },
                child: Text(
                  "Delete",
                  style: GoogleFonts.robotoSlab(),
                )),
          ],
        ));
  }

  deleteAccount(index, account) {
    setState(() {
      _accounts.removeAt(index);
    });
    // accountBloc.deleteAccount(account);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          "Accounts",
          style: GoogleFonts.robotoSlab(),
        )),
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
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/create_account');
          },
          child: Container(
            width: screenWidth * 0.35,
            padding: EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
                color: Colors.red[50],
                border: Border.all(color: Color.fromRGBO(234, 67, 53, 1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Icon(
                    Icons.add,
                    size: screenWidth / 18,
                    color: Color.fromRGBO(234, 67, 53, 1),
                  ),
                ),
                Container(
                  child: Text(
                    "Add Account",
                    style: GoogleFonts.robotoSlab(
                        textStyle: TextStyle(
                            color: Color.fromRGBO(234, 67, 53, 1),
                            fontSize: screenWidth / 25)),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBarWidget(),
      ),
    );
  }
}
