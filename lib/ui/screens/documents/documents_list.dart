import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/contact_bloc.dart';
import 'package:flutter_crm/bloc/documents_bloc.dart';
import 'package:flutter_crm/model/contact.dart';
import 'package:flutter_crm/model/document.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/ui/widgets/profile_pic_widget.dart';
import 'package:flutter_crm/ui/widgets/squareFloatingActionBtn.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class DocumentsList extends StatefulWidget {
  DocumentsList();
  @override
  State createState() => _DocumentsListState();
}

class _DocumentsListState extends State<DocumentsList> {
  final GlobalKey<FormState> _documentsFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isSearch = false;
  List _documents = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _documents = documentBLoc.documents;
    });
  }

  _saveForm() async {
    setState(() {
      _isLoading = true;
    });
    await documentBLoc.fetchDocuments();
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildSearchBar(int length) {
    return Container(
      color: Colors.white,
      height: screenHeight * 0.060,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: screenWidth * 0.85,
            child: TextFormField(
              initialValue: "",
              onSaved: null,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12.0),
                  enabledBorder: boxBorder(),
                  focusedErrorBorder: boxBorder(),
                  focusedBorder: boxBorder(),
                  errorBorder: boxBorder(),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Search your Document here',
                  errorStyle: GoogleFonts.robotoSlab(),
                  hintStyle: GoogleFonts.robotoSlab(
                      textStyle: TextStyle(fontSize: screenWidth / 26))),
              keyboardType: TextInputType.text,
            ),
          ),
          Container(
              width: screenWidth * 0.1,
              child: IconButton(
                  icon: Icon(Icons.search, color: Colors.green),
                  onPressed: () {
                    setState(() {
                      _isSearch = !_isSearch;
                    });
                  }))
        ],
      ),
    );
  }

  Widget _buildDocumentList() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: ListView.builder(
          itemCount: _documents.length,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                // contactBloc.currentContact = _contacts[index];
                // contactBloc.currentContactIndex = index;
                // Navigator.pushNamed(context, '/contact_details');
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                color: Colors.white,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10, bottom: 10),
                          child: CircleAvatar(
                            radius: screenWidth / 17,
                            backgroundImage: NetworkImage(
                                _documents[index].createdBy.profileUrl),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: SvgPicture.asset(
                            'assets/images/pdf_icon.svg',
                            width: screenWidth / 12,
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Container(
                            width: screenWidth * 0.60,
                            child: Text(
                              "${_documents[index].title}",
                              style: GoogleFonts.robotoSlab(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: screenWidth / 23,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          width: screenWidth * 0.60,
                          child: Text(
                            _documents[index].createdOn != null
                                ? DateFormat.yMMMMd().add_jm().format(
                                    DateFormat("yyyy-MM-dd")
                                        .parse(_documents[index].createdOn))
                                : "",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.robotoSlab(
                              color: bottomNavBarTextColor,
                              fontSize: screenWidth / 27,
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 5.0, right: 10),
                                child: Icon(
                                  Icons.share,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5.0),
                                child: ProfilePicViewWidget(_documents[index]
                                    .sharedTo
                                    .map((e) => e.profileUrl)
                                    .toList()),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: screenWidth * 0.76,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: screenWidth * 0.15,
                                    child: Text(
                                      "Status :",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.robotoSlab(
                                        color: bottomNavBarTextColor,
                                        fontSize: screenWidth / 25,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: screenWidth * 0.20,
                                    child: Text(
                                      _documents[index]
                                          .status
                                          .toString()
                                          .toUpperCase(),
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.robotoSlab(
                                        color: Colors.green,
                                        fontSize: screenWidth / 25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      // await contactBloc.updateCurrentEditContact(
                                      //     _contacts[index]);
                                      // Navigator.pushNamed(
                                      //     context, '/create_contact');
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.0,
                                            color: Colors.grey[300]),
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
                                      // showDeleteContactAlertDialog(
                                      //     context, _contacts[index], index);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.0,
                                            color: Colors.grey[300]),
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
                                  GestureDetector(
                                    onTap: () async {
                                      // await contactBloc.updateCurrentEditContact(
                                      //     _contacts[index]);
                                      // Navigator.pushNamed(
                                      //     context, '/create_contact');

                                      // await documentBLoc.downloadFunc(
                                      //     "Document_ID_${_documents[index].id}}",
                                      //     _documents[index].documentFile);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.0,
                                            color: Colors.grey[300]),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3.0)),
                                      ),
                                      padding: EdgeInsets.all(4.0),
                                      child: SvgPicture.asset(
                                        'assets/images/download_icon.svg',
                                        width: screenWidth / 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  void showDeleteContactAlertDialog(
      BuildContext context, Contact contact, index) {
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
                    deleteContact(index, contact);
                  },
                  child: Text(
                    "Delete",
                    style: GoogleFonts.robotoSlab(),
                  )),
            ],
          );
        });
  }

  deleteContact(index, contact) async {
    // setState(() {
    //   _contacts.removeAt(index);
    // });
    setState(() {
      _isLoading = true;
    });
    Map _result = await contactBloc.deleteContact(contact);
    setState(() {
      _isLoading = false;
    });
    if (_result['error'] == false) {
      showToast(_result['message']);
      Navigator.pushReplacementNamed(context, "/sales_contacts");
    } else if (_result['error'] == true) {
      showToast(_result['message']);
    } else {
      showErrorMessage(context, 'Something went wrong', index, contact);
    }
  }

  void showErrorMessage(
      BuildContext context, String errorContent, int index, Contact contact) {
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
          deleteContact(index, contact);
        },
      ),
      duration: Duration(seconds: 10),
    )..show(context);
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          GestureDetector(
            child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child:
                    Icon((_isSearch == false) ? Icons.search : Icons.cancel)),
            onTap: () {
              setState(() {
                _isSearch = !_isSearch;
              });
            },
          )
        ],
        title: Text("Documents", style: GoogleFonts.robotoSlab()),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Column(
              children: [
                (_isSearch == false) ? Container() : _buildSearchBar(0),
                _documents.length > 0
                    ? Expanded(child: _buildDocumentList())
                    : Container(
                        margin: EdgeInsets.only(top: 30.0),
                        child: Text(
                          "No Documents Found",
                          style: GoogleFonts.robotoSlab(),
                        ),
                      )
              ],
            ),
          ),
          new Align(
            child: loadingIndicator,
            alignment: FractionalOffset.center,
          )
        ],
      ),
      floatingActionButton: SquareFloatingActionButton(
          '/create_contact', "Add Document", "Documents"),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}
