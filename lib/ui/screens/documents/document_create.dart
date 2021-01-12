import 'package:file_picker/file_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crm/bloc/contact_bloc.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_crm/bloc/document_bloc.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class CreateDocument extends StatefulWidget {
  CreateDocument();
  @override
  State createState() => _CreateDocumentState();
}

class _CreateDocumentState extends State<CreateDocument> {
  final GlobalKey<FormState> _createDocumentFormKey = GlobalKey<FormState>();
  FilePickerResult result;
  PlatformFile file;
  Map _errors;
  bool _isLoading = false;
  FocusNode _focuserr;
  FocusNode _titleFocusNode = new FocusNode();
  FocusNode _documentFocusNode = new FocusNode();
  bool accessError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_focuserr != null) {
      _focuserr.dispose();
    }
    _titleFocusNode.dispose();
    _documentFocusNode.dispose();

    super.dispose();
  }

  focusError() {
    setState(() {
      FocusManager.instance.primaryFocus.unfocus();
      FocusScope.of(context).requestFocus(_focuserr);
    });
  }

  _saveForm() async {
    _focuserr = null;
    setState(() {
      _errors = null;
    });
    if (!_createDocumentFormKey.currentState.validate()) {
      focusError();
      return;
    }
    _createDocumentFormKey.currentState.save();
    Map _result;

    // setState(() {
    //   _isLoading = true;
    // });
    if (documentBLoc.currentEditDocumentId != null) {
      // _result = await userBloc.editUser();
    } else {
      _result = await documentBLoc.createDocument(file);
    }
    setState(() {
      _isLoading = false;
    });

    // if (_result['error'] == false) {
    //   setState(() {
    //     _errors = null;
    //   });
    //   showToast(_result['message']);
    //   Navigator.pushReplacementNamed(context, '/users_list');
    // } else if (_result['error'] == true) {
    //   setState(() {
    //     _errors = _result['errors'];
    //   });
    //   if (_errors['name'] != null && _focuserr == null) {
    //     _focuserr = _titleFocusNode;
    //     focusError();
    //   }
    // } else {
    //   setState(() {
    //     _errors = null;
    //   });
    //   showErrorMessage(context, 'Something went wrong');
    // }
  }

  void showErrorMessage(BuildContext context, String errorContent) {
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
          _saveForm();
        },
      ),
      duration: Duration(seconds: 10),
    )..show(context);
  }

  Widget _buildForm() {
    return Container(
        child: Form(
            key: _createDocumentFormKey,
            child: Column(children: [
              Container(
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Title',
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
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
                        focusNode: _titleFocusNode,
                        // initialValue: userBloc.currentEditUser['title'],
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12.0),
                            enabledBorder: boxBorder(),
                            focusedErrorBorder: boxBorder(),
                            focusedBorder: boxBorder(),
                            errorBorder: boxBorder(),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter Title',
                            errorStyle: GoogleFonts.robotoSlab(),
                            hintStyle: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(fontSize: 14.0))),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            if (_focuserr == null) {
                              _focuserr = _titleFocusNode;
                            }
                            return 'This field is required.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          documentBLoc.currentEditDocument['title'] = value;
                        },
                      ),
                    ),
                    _errors != null && _errors['title'] != null
                        ? Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _errors['title'][0],
                              style: GoogleFonts.robotoSlab(
                                  textStyle: TextStyle(
                                      color: Colors.red[700], fontSize: 12.0)),
                            ),
                          )
                        : Container(),
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
                        child: RichText(
                          text: TextSpan(
                            text: 'Upload Document',
                            style: GoogleFonts.robotoSlab(
                                textStyle: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
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
                    GestureDetector(
                      onTap: () async {
                        result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: [
                              'pdf',
                              'doc',
                              'docx',
                              'csv',
                              'txt',
                              'xlsx',
                              'ppt',
                              'pptx',
                              'gdoc'
                            ]);
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
                            margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Text(
                              file.name,
                              style: GoogleFonts.robotoSlab(),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Text(
                              "No file chosen.",
                              style: GoogleFonts.robotoSlab(),
                            ),
                          ),
                    Divider(color: Colors.grey),
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
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
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
                              initialValue:
                                  documentBLoc.currentEditDocument['teams'],
                              onSaved: (value) {
                                if (value == null) return;
                                documentBLoc.currentEditDocument['teams'] =
                                    value;
                              },
                            ),
                          ),
                          Divider(color: Colors.grey),
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(bottom: 5.0),
                                  child: Text(
                                    'Share To :',
                                    style: GoogleFonts.robotoSlab(
                                        textStyle: TextStyle(
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
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
                                    dataSource:
                                        documentBLoc.usersObjforMultiselect,
                                    textField: 'name',
                                    valueField: 'id',
                                    okButtonLabel: 'OK',
                                    chipLabelStyle: GoogleFonts.robotoSlab(
                                        textStyle:
                                            TextStyle(color: Colors.black)),
                                    dialogTextStyle: GoogleFonts.robotoSlab(),
                                    cancelButtonLabel: 'CANCEL',
                                    hintWidget: Text(
                                      "Please choose one or more",
                                      style: GoogleFonts.robotoSlab(),
                                    ),
                                    title: Text(
                                      "Share To",
                                      style: GoogleFonts.robotoSlab(),
                                    ),
                                    initialValue: documentBLoc
                                        .currentEditDocument['shared_to'],
                                    onSaved: (value) {
                                      if (value == null) return;
                                      documentBLoc.currentEditDocument[
                                          'shared_to'] = value;
                                    },
                                  ),
                                ),
                                Divider(color: Colors.grey),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Save Form
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
                              height: screenHeight * 0.06,
                              width: screenWidth * 0.5,
                              decoration: BoxDecoration(
                                color: submitButtonColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3.0)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    documentBLoc.currentEditDocumentId == null
                                        ? 'Create Document'
                                        : 'Edit Document',
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
                              Navigator.pop(context);
                              // documentBLoc.cancelCurrentEditDocument();
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
            ])));
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
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Create Document',
            style: GoogleFonts.robotoSlab(),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Container(
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: _buildForm(),
                ),
              ),
            ),
            new Align(
              child: loadingIndicator,
              alignment: FractionalOffset.center,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBarWidget());
  }
}
