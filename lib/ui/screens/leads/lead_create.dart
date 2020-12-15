import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crm/bloc/contact_bloc.dart';
import 'package:flutter_crm/bloc/lead_bloc.dart';
import 'package:flutter_crm/model/lead.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:textfield_tags/textfield_tags.dart';

class CreateLead extends StatefulWidget {
  CreateLead();
  @override
  State createState() => _CreateLeadState();
}

class _CreateLeadState extends State<CreateLead> {
  final GlobalKey<FormState> _createLeadFormKey = GlobalKey<FormState>();
  FilePickerResult result;
  PlatformFile file;
  List _myActivities;

  @override
  void initState() {
    super.initState();
  }

  _saveForm() {
    if (!_createLeadFormKey.currentState.validate()) {
      return;
    }
    _createLeadFormKey.currentState.save();
  }

  Widget _buildTextField(String _lable, bool _required, dynamic _controller,
      TextInputType _keyboardType, _initialValue) {
    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 5.0),
            child: RichText(
              text: TextSpan(
                text: _lable,
                style: GoogleFonts.robotoSlab(
                    textStyle: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth / 25)),
                children: <TextSpan>[
                  _required
                      ? TextSpan(
                          text: '*',
                          style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(color: Colors.red)))
                      : TextSpan(text: ""),
                  TextSpan(text: ' :', style: GoogleFonts.robotoSlab())
                ],
              ),
            )),
        Container(
          margin: EdgeInsets.only(bottom: 10.0),
          child: TextFormField(
            maxLines: _lable == "Description" ? 5 : 1,
            controller: _controller,
            initialValue: _initialValue,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12.0),
                enabledBorder: boxBorder(),
                focusedErrorBorder: boxBorder(),
                focusedBorder: boxBorder(),
                errorBorder: boxBorder(),
                fillColor: Colors.white,
                filled: true,
                hintText: _lable == "Phone"
                    ? "Enter $_lable (+919876543210)"
                    : "Enter $_lable",
                errorStyle: GoogleFonts.robotoSlab(),
                hintStyle: GoogleFonts.robotoSlab(
                    textStyle: TextStyle(fontSize: 14.0))),
            keyboardType: _keyboardType,
            validator: (value) {
              if (_required && value.isEmpty) {
                return 'This field is required.';
              }
              return null;
            },
            onSaved: (value) {
              _initialValue = value;
            },
          ),
        ),
        Divider(color: Colors.grey)
      ],
    );
  }

  Widget _buildForm() {
    return Container(
      child: Form(
        key: _createLeadFormKey,
        child: Column(
          children: [
            _buildTextField('First Name', false, null, TextInputType.text,
                leadBloc.currentEditLead['first_name']),
            _buildTextField('Last Name', false, null, TextInputType.text,
                leadBloc.currentEditLead['last_name']),
            _buildTextField('Phone', false, null, TextInputType.phone,
                leadBloc.currentEditLead['phone']),
            _buildTextField('Account Name', false, null, TextInputType.text,
                leadBloc.currentEditLead['account_name']),
            _buildTextField('Title', true, null, TextInputType.text,
                leadBloc.currentEditLead['title']),
            _buildTextField('Email Address', false, null,
                TextInputType.emailAddress, leadBloc.currentEditLead['email']),
            _buildTextField('Website', false, null, TextInputType.url,
                leadBloc.currentEditLead['website']),
            _buildTextField('Description', false, null, TextInputType.multiline,
                leadBloc.currentEditLead['description']),
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
                      dataSource: contactBloc.teamsObjForDropdown,
                      textField: 'name',
                      valueField: 'id',
                      okButtonLabel: 'OK',
                      chipLabelStyle: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(color: Colors.black)),
                      dialogTextStyle: GoogleFonts.robotoSlab(),
                      cancelButtonLabel: 'CANCEL',
                      hintWidget: Text(
                        "Please choose one or more",
                        style: GoogleFonts.robotoSlab(),
                      ),
                      title: Text(
                        "Teams",
                        style: GoogleFonts.robotoSlab(),
                      ),
                      initialValue: [],
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
                      dataSource: leadBloc.usersObjForDropdown,
                      textField: 'name',
                      valueField: 'id',
                      okButtonLabel: 'OK',
                      chipLabelStyle: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(color: Colors.black)),
                      dialogTextStyle: GoogleFonts.robotoSlab(),
                      cancelButtonLabel: 'CANCEL',
                      hintWidget: Text(
                        "Please choose one or more",
                        style: GoogleFonts.robotoSlab(),
                      ),
                      title: Text(
                        "Users",
                        style: GoogleFonts.robotoSlab(),
                      ),
                      initialValue: [],
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
                      'Assign Users :',
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
                      dataSource: leadBloc.usersObjForDropdown,
                      textField: 'name',
                      valueField: 'id',
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
                      initialValue: [],

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
                      initialValue: leadBloc.currentEditLead['address_line'],
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
                      onSaved: (value) {
                        leadBloc.currentEditLead['address_line'] = value;
                      },
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
                            initialValue: leadBloc.currentEditLead['street'],
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
                            onSaved: (value) {
                              leadBloc.currentEditLead['street'] = value;
                            },
                          ),
                        ),
                        Container(
                          width: screenWidth * 0.42,
                          child: TextFormField(
                            initialValue: leadBloc.currentEditLead['postcode'],
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
                            onSaved: (value) {
                              leadBloc.currentEditLead['postcode'] = value;
                            },
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
                            initialValue: leadBloc.currentEditLead['city'],
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
                            onSaved: (value) {
                              leadBloc.currentEditLead['city'] = value;
                            },
                          ),
                        ),
                        Container(
                          width: screenWidth * 0.42,
                          child: TextFormField(
                            initialValue: leadBloc.currentEditLead['state'],
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
                            onSaved: (value) {
                              leadBloc.currentEditLead['state'] = value;
                            },
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
                      items: leadBloc.countries,
                      onChanged: (value) {
                        leadBloc.currentEditLead['country'] = value;
                      },
                      selectedItem: leadBloc.currentEditLead['country'],
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
                      hint: Text('Select Status'),
                      // value: _selectedStatus,
                      onChanged: (value) {
                        leadBloc.currentEditLead['status'] = value;
                      },
                      items: leadBloc.status.map((location) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'Source :',
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
                      hint: Text('Select Source'),
                      // value: _selectedStatus,
                      onChanged: (value) {
                        leadBloc.currentEditLead['source'] = value;
                      },
                      items: leadBloc.source.map((location) {
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
                      initialTags: leadBloc.currentEditLead['tags'],
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      _saveForm();
                    },
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
                            'Create Lead',
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
                    onTap: () async {
                      // await leadBloc.updateCurrentEditLead();
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
          "Create Lead",
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
