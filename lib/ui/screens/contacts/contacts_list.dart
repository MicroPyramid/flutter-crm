import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/contact_bloc.dart';
import 'package:flutter_crm/model/contact.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/ui/widgets/profile_pic_widget.dart';
import 'package:flutter_crm/ui/widgets/squareFloatingActionBtn.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class ContactsScreen extends StatefulWidget {
  ContactsScreen();
  @override
  State createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  bool _isFilter = false;

  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _contacts = contactBloc.contacts;
    });
  }

  Widget _buildTabBar(int length) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              child: RichText(
            text: TextSpan(
                text: 'You have ',
                style: GoogleFonts.robotoSlab(
                    textStyle: TextStyle(
                        color: Colors.grey[600], fontSize: screenWidth / 20)),
                children: <TextSpan>[
                  TextSpan(
                      text: _contacts.length.toString(),
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: submitButtonColor,
                              fontSize: screenWidth / 20))),
                  TextSpan(text: ' contacts')
                ]),
          )),
          GestureDetector(
              onTap: () {
                if (_contacts.length > 0) {
                  setState(() {
                    _isFilter = !_isFilter;
                  });
                }
              },
              child: Container(
                  padding: EdgeInsets.all(5.0),
                  color: _contacts.length > 0
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

  Widget _buildMultiSelectDropdown(data) {
    List _myActivities;
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
          "Assigned Profiles",
          style: GoogleFonts.robotoSlab(
              textStyle: TextStyle(color: Colors.grey[700]),
              fontSize: screenWidth / 26),
        ),
        initialValue: _myActivities,
        onSaved: (value) {
          if (value == null) return;
          setState(() {
            _myActivities = value;
          });
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
                        hintText: 'Enter First Name',
                        errorStyle: GoogleFonts.robotoSlab(),
                        hintStyle: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(fontSize: screenWidth / 26))),
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
                            textStyle: TextStyle(fontSize: screenWidth / 26))),
                    keyboardType: TextInputType.text,
                  ),
                ),
                _buildMultiSelectDropdown(contactBloc.contactsObjForDropdown),
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

  Widget _buildContactList() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: ListView.builder(
          itemCount: _contacts.length,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                contactBloc.currentContact = _contacts[index];
                Navigator.pushNamed(context, '');
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                color: Colors.white,
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: screenWidth * 0.43,
                            child: Text(
                              "${_contacts[index].firstName} ${_contacts[index].lastName}",
                              style: GoogleFonts.robotoSlab(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: screenWidth / 25,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: screenWidth * 0.20,
                            child: Text(
                              _contacts[index].address["city"] != null
                                  ? "${_contacts[index].address["city"]}"
                                  : "",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.robotoSlab(
                                color: bottomNavBarTextColor,
                                fontSize: screenWidth / 27,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            width: screenWidth * 0.25,
                            child: Text(
                              _contacts[index].createdOnText == ""
                                  ? _contacts[index].createdOn
                                  : _contacts[index].createdOnText,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.robotoSlab(
                                  color: bottomNavBarTextColor,
                                  fontSize: screenWidth / 27),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: ProfilePicViewWidget([
                              // _contacts[index].assignedTo
                              _contacts[index].createdBy.profileUrl,
                              _contacts[index].createdBy.profileUrl,
                              _contacts[index].createdBy.profileUrl,
                              _contacts[index].createdBy.profileUrl,
                            ]),
                          ),
                          Container(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await contactBloc.updateCurrentEditContact(
                                        _contacts[index]);
                                    Navigator.pushNamed(
                                        context, '/create_contact');
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0, color: Colors.grey[300]),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.0)),
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
                                        context, _contacts[index], index);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0, color: Colors.grey[300]),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.0)),
                                    ),
                                    padding: EdgeInsets.all(4.0),
                                    child: SvgPicture.asset(
                                      'assets/images/icon_delete_color.svg',
                                      width: screenWidth / 23,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  void showDeleteLeadAlertDialog(BuildContext context, Contact contact, index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              contact.firstName + ' ' + contact.lastName,
              style: GoogleFonts.robotoSlab(
                  color: Theme.of(context).secondaryHeaderColor),
            ),
            content: Text(
              "Are you sure you want to delete this Contact?",
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
                    deleteAccount(index, contact);
                  },
                  child: Text(
                    "Delete",
                    style: GoogleFonts.robotoSlab(),
                  )),
            ],
          );
        });
  }

  deleteAccount(index, contact) {
    setState(() {
      _contacts.removeAt(index);
    });
    // contactBloc.deleteAccount(contact);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts", style: GoogleFonts.robotoSlab()),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            _buildTabBar(_contacts.length),
            _buildFilterWidget(),
            _contacts.length > 0
                ? Expanded(child: _buildContactList())
                : Container(
                    margin: EdgeInsets.only(top: 30.0),
                    child: Text(
                      "No Contacts Found",
                      style: GoogleFonts.robotoSlab(),
                    ),
                  )
          ],
        ),
      ),
      floatingActionButton: SquareFloatingActionButton(
          '/create_contact', "Add Contact", "Contacts"),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}
