import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:textfield_tags/textfield_tags.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount();
  @override
  State createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final GlobalKey<FormState> _createAccountFormKey = GlobalKey<FormState>();
  FilePickerResult result;
  PlatformFile file;
  List _myActivities;
  String _selectedStatus = 'Open';

  @override
  void initState() {
    super.initState();
  }

  Widget _buildForm() {
    return Container(
      child: Form(
        key: _createAccountFormKey,
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Name',
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth / 25)),
                          children: <TextSpan>[
                            TextSpan(
                                text: '* ',
                                style: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(color: Colors.red))),
                            TextSpan(
                                text: ': ', style: GoogleFonts.robotoSlab())
                          ],
                        ),
                      )),
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
                          hintText: 'Enter Name',
                          errorStyle: GoogleFonts.robotoSlab(),
                          hintStyle: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(fontSize: 14.0))),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This field is required.';
                        }
                        return null;
                      },
                      onSaved: (value) {},
                    ),
                  ),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'Website :',
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth / 25)),
                      )),
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
                          hintText: 'Enter Website',
                          errorStyle: GoogleFonts.robotoSlab(),
                          hintStyle: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(fontSize: 14.0))),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {},
                    ),
                  ),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Phone Number',
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth / 25)),
                          children: <TextSpan>[
                            TextSpan(
                                text: '* ',
                                style: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(color: Colors.red))),
                            TextSpan(
                                text: ': ', style: GoogleFonts.robotoSlab())
                          ],
                        ),
                      )),
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
                          hintText: '+919876543210',
                          errorStyle: GoogleFonts.robotoSlab(),
                          hintStyle: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(fontSize: 14.0))),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This field is required.';
                        }
                        return null;
                      },
                      onSaved: (value) {},
                    ),
                  ),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Email Address',
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth / 25)),
                          children: <TextSpan>[
                            TextSpan(
                                text: '* ',
                                style: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(color: Colors.red))),
                            TextSpan(
                                text: ': ', style: GoogleFonts.robotoSlab())
                          ],
                        ),
                      )),
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
                          hintText: 'Enter Email Address',
                          errorStyle: GoogleFonts.robotoSlab(),
                          hintStyle: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(fontSize: 14.0))),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This field is required.';
                        }
                        return null;
                      },
                      onSaved: (value) {},
                    ),
                  ),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'Leads :',
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth / 25)),
                      )),
                  Container(
                    height: 48.0,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: DropdownSearch<String>(
                      mode: Mode.BOTTOM_SHEET,
                      items: [
                        "none",
                        "Brazil",
                        "Italia",
                        "Tunisia",
                        'Canada',
                        "Brazil",
                        "Italia",
                        "Tunisia",
                        'Canada'
                      ],
                      onChanged: print,
                      // selectedItem: "",
                      hint: 'Select Lead',
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
                        hintText: "Search a Lead",
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
                            'Leads',
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
                    ),
                  ),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Billing Address',
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth / 25)),
                          children: <TextSpan>[
                            TextSpan(
                                text: '* ',
                                style: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(color: Colors.red))),
                            TextSpan(
                                text: ': ', style: GoogleFonts.robotoSlab())
                          ],
                        ),
                      )),
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
                          hintText: 'Address Line',
                          errorStyle: GoogleFonts.robotoSlab(),
                          hintStyle: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(fontSize: 14.0))),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This field is required.';
                        }
                        return null;
                      },
                      onSaved: (value) {},
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: screenWidth * 0.42,
                          child: TextFormField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12.0),
                                enabledBorder: boxBorder(),
                                focusedErrorBorder: boxBorder(),
                                focusedBorder: boxBorder(),
                                errorBorder: boxBorder(),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Street',
                                errorStyle: GoogleFonts.robotoSlab(),
                                hintStyle: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(fontSize: 14.0))),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'This field is required.';
                              }
                              return null;
                            },
                            onSaved: (value) {},
                          ),
                        ),
                        Container(
                          width: screenWidth * 0.42,
                          child: TextFormField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12.0),
                                enabledBorder: boxBorder(),
                                focusedErrorBorder: boxBorder(),
                                focusedBorder: boxBorder(),
                                errorBorder: boxBorder(),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Postal Code',
                                errorStyle: GoogleFonts.robotoSlab(),
                                hintStyle: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(fontSize: 14.0))),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'This field is required.';
                              }
                              return null;
                            },
                            onSaved: (value) {},
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: screenWidth * 0.42,
                          child: TextFormField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12.0),
                                enabledBorder: boxBorder(),
                                focusedErrorBorder: boxBorder(),
                                focusedBorder: boxBorder(),
                                errorBorder: boxBorder(),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'City',
                                errorStyle: GoogleFonts.robotoSlab(),
                                hintStyle: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(fontSize: 14.0))),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'This field is required.';
                              }
                              return null;
                            },
                            onSaved: (value) {},
                          ),
                        ),
                        Container(
                          width: screenWidth * 0.42,
                          child: TextFormField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12.0),
                                enabledBorder: boxBorder(),
                                focusedErrorBorder: boxBorder(),
                                focusedBorder: boxBorder(),
                                errorBorder: boxBorder(),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'State',
                                errorStyle: GoogleFonts.robotoSlab(),
                                hintStyle: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(fontSize: 14.0))),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'This field is required.';
                              }
                              return null;
                            },
                            onSaved: (value) {},
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 48.0,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: DropdownSearch<String>(
                      mode: Mode.BOTTOM_SHEET,
                      items: [
                        "none",
                        "Brazil",
                        "Italia",
                        "Tunisia",
                        'Canada',
                        "Brazil",
                        "Italia",
                        "Tunisia",
                        'Canada'
                      ],
                      onChanged: print,
                      // selectedItem: "",
                      hint: 'Select Country',
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
                        hintText: "Search a Country",
                        hintStyle: GoogleFonts.robotoSlab(),
                        errorStyle: GoogleFonts.robotoSlab(),
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
                            'Countries',
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
                    ),
                  ),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Contacts',
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth / 25)),
                          children: <TextSpan>[
                            TextSpan(
                                text: '* ',
                                style: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(color: Colors.red))),
                            TextSpan(
                                text: ': ', style: GoogleFonts.robotoSlab())
                          ],
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: MultiSelectFormField(
                      border: boxBorder(),
                      fillColor: Colors.white,
                      autovalidate: false,
                      validator: (value) {
                        if (value == null || value.length == 0) {
                          return 'Please select one or more options';
                        }
                      },
                      dataSource: [
                        {
                          "display": "Running",
                          "value": "Running",
                        },
                        {
                          "display": "Climbing",
                          "value": "Climbing",
                        },
                        {
                          "display": "Walking",
                          "value": "Walking",
                        },
                        {
                          "display": "Swimming",
                          "value": "Swimming",
                        },
                        {
                          "display": "Soccer Practice",
                          "value": "Soccer Practice",
                        },
                        {
                          "display": "Baseball Practice",
                          "value": "Baseball Practice",
                        },
                        {
                          "display": "Football Practice",
                          "value": "Football Practice",
                        },
                      ],
                      textField: 'display',
                      valueField: 'value',
                      okButtonLabel: 'OK',
                      chipLabelStyle: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(color: Colors.black)),
                      dialogTextStyle: GoogleFonts.robotoSlab(),
                      cancelButtonLabel: 'CANCEL',
                      // required: true,
                      hintWidget: Text(
                        "Please choose one or more",
                        style: GoogleFonts.robotoSlab(),
                      ),
                      title: Text(
                        "Contacts",
                        style: GoogleFonts.robotoSlab(),
                      ),
                      initialValue: _myActivities,

                      onSaved: (value) {
                        if (value == null) return;
                        setState(() {
                          _myActivities = value;
                        });
                      },
                    ),
                  ),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'Teams :',
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth / 25)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: MultiSelectFormField(
                      border: boxBorder(),
                      fillColor: Colors.white,
                      autovalidate: false,
                      validator: (value) {
                        if (value == null || value.length == 0) {
                          return 'Please select one or more options';
                        }
                      },
                      dataSource: [
                        {
                          "display": "Running",
                          "value": "Running",
                        },
                        {
                          "display": "Climbing",
                          "value": "Climbing",
                        },
                        {
                          "display": "Walking",
                          "value": "Walking",
                        },
                        {
                          "display": "Swimming",
                          "value": "Swimming",
                        },
                        {
                          "display": "Soccer Practice",
                          "value": "Soccer Practice",
                        },
                        {
                          "display": "Baseball Practice",
                          "value": "Baseball Practice",
                        },
                        {
                          "display": "Football Practice",
                          "value": "Football Practice",
                        },
                      ],
                      textField: 'display',
                      valueField: 'value',
                      okButtonLabel: 'OK',
                      chipLabelStyle: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(color: Colors.black)),
                      dialogTextStyle: GoogleFonts.robotoSlab(),
                      cancelButtonLabel: 'CANCEL',
                      // required: true,
                      hintWidget: Text(
                        "Please choose one or more",
                        style: GoogleFonts.robotoSlab(),
                      ),
                      title: Text(
                        "Teams",
                        style: GoogleFonts.robotoSlab(),
                      ),
                      initialValue: _myActivities,

                      onSaved: (value) {
                        if (value == null) return;
                        setState(() {
                          _myActivities = value;
                        });
                      },
                    ),
                  ),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'Users :',
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth / 25)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: MultiSelectFormField(
                      border: boxBorder(),
                      fillColor: Colors.white,
                      autovalidate: false,
                      validator: (value) {
                        if (value == null || value.length == 0) {
                          return 'Please select one or more options';
                        }
                      },
                      dataSource: [
                        {
                          "display": "Running",
                          "value": "Running",
                        },
                        {
                          "display": "Climbing",
                          "value": "Climbing",
                        },
                        {
                          "display": "Walking",
                          "value": "Walking",
                        },
                        {
                          "display": "Swimming",
                          "value": "Swimming",
                        },
                        {
                          "display": "Soccer Practice",
                          "value": "Soccer Practice",
                        },
                        {
                          "display": "Baseball Practice",
                          "value": "Baseball Practice",
                        },
                        {
                          "display": "Football Practice",
                          "value": "Football Practice",
                        },
                      ],
                      textField: 'display',
                      valueField: 'value',
                      okButtonLabel: 'OK',
                      chipLabelStyle: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(color: Colors.black)),
                      dialogTextStyle: GoogleFonts.robotoSlab(),
                      cancelButtonLabel: 'CANCEL',
                      // required: true,
                      hintWidget: Text(
                        "Please choose one or more",
                        style: GoogleFonts.robotoSlab(),
                      ),
                      title: Text(
                        "Users",
                        style: GoogleFonts.robotoSlab(),
                      ),
                      initialValue: _myActivities,

                      onSaved: (value) {
                        if (value == null) return;
                        setState(() {
                          _myActivities = value;
                        });
                      },
                    ),
                  ),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'Assign To :',
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth / 25)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: MultiSelectFormField(
                      border: boxBorder(),
                      fillColor: Colors.white,
                      autovalidate: false,
                      validator: (value) {
                        if (value == null || value.length == 0) {
                          return 'Please select one or more options';
                        }
                      },
                      dataSource: [
                        {
                          "display": "Running",
                          "value": "Running",
                        },
                        {
                          "display": "Climbing",
                          "value": "Climbing",
                        },
                        {
                          "display": "Walking",
                          "value": "Walking",
                        },
                        {
                          "display": "Swimming",
                          "value": "Swimming",
                        },
                        {
                          "display": "Soccer Practice",
                          "value": "Soccer Practice",
                        },
                        {
                          "display": "Baseball Practice",
                          "value": "Baseball Practice",
                        },
                        {
                          "display": "Football Practice",
                          "value": "Football Practice",
                        },
                      ],
                      textField: 'display',
                      valueField: 'value',
                      okButtonLabel: 'OK',
                      chipLabelStyle: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(color: Colors.black)),
                      dialogTextStyle: GoogleFonts.robotoSlab(),
                      cancelButtonLabel: 'CANCEL',
                      // required: true,
                      hintWidget: Text(
                        "Please choose one or more",
                        style: GoogleFonts.robotoSlab(),
                      ),
                      title: Text(
                        "Assigned To",
                        style: GoogleFonts.robotoSlab(),
                      ),
                      initialValue: _myActivities,

                      onSaved: (value) {
                        if (value == null) return;
                        setState(() {
                          _myActivities = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Select one or more",
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'Status :',
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth / 25)),
                    ),
                  ),
                  Container(
                    height: 48.0,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          border: boxBorder(),
                          contentPadding: EdgeInsets.all(12.0)),
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(color: Colors.black)),
                      hint: Text('select Status'),
                      value: _selectedStatus,
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value;
                        });
                      },
                      items: ['Open', 'Close'].map((location) {
                        return DropdownMenuItem(
                          child: new Text(location),
                          value: location,
                        );
                      }).toList(),
                    ),
                  ),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'Tags :',
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth / 25)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: TextFieldTags(
                      // initialTags: <String>['Wero', 'baby'],
                      textFieldStyler: TextFieldStyler(
                        contentPadding: EdgeInsets.all(12.0),
                        textFieldBorder: boxBorder(),
                        textFieldFocusedBorder: boxBorder(),
                        hintText: 'Enter Tags',
                        hintStyle: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(fontSize: 14.0)),
                        helperText: null,
                      ),
                      tagsStyler: TagsStyler(
                          tagTextPadding: EdgeInsets.symmetric(horizontal: 5.0),
                          tagTextStyle: GoogleFonts.robotoSlab(),
                          tagDecoration: BoxDecoration(
                            color: Colors.lightGreen[300],
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          tagCancelIcon: Icon(Icons.cancel,
                              size: 18.0, color: Colors.green[900]),
                          tagPadding: const EdgeInsets.all(6.0)),
                      onTag: (tag) {
                        print('onTag ' + tag);
                      },
                      onDelete: (tag) {
                        print('onDelete ' + tag);
                      },
                    ),
                  ),
                  Divider(color: Colors.grey)
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'Attachments :',
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth / 25)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      result = await FilePicker.platform.pickFiles();
                      setState(() {
                        file = result.files.first;
                        print(file.name);
                      });
                    },
                    child: Container(
                      color: bottomNavBarTextColor,
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        "Choose File",
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  file != null
                      ? Container(
                          child: Text(
                            file.name,
                            style: GoogleFonts.robotoSlab(),
                          ),
                        )
                      : Container(),
                  Divider(color: Colors.grey)
                ],
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
                      height: screenHeight * 0.06,
                      width: screenWidth * 0.5,
                      decoration: BoxDecoration(
                        color: submitButtonColor,
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Create Account',
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth / 24)),
                          ),
                          SvgPicture.asset('assets/images/arrow_forward.svg')
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Text(
                        "Cancel",
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Create Account",
          style: GoogleFonts.robotoSlab(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Container(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: _buildForm(),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}
