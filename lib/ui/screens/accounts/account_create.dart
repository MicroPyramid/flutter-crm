import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:smart_select/smart_select.dart';
import 'package:file_picker/file_picker.dart';
import 'package:textfield_tags/textfield_tags.dart';

class CreateAccountScreen extends StatefulWidget {
  CreateAccountScreen();
  @override
  State createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final GlobalKey<FormState> _createAccountFormKey = GlobalKey<FormState>();
  List<String> _fruit;
  List<S2Choice<String>> fruits = [
    S2Choice<String>(value: 'app', title: 'Apple'),
    S2Choice<String>(value: 'ore', title: 'Orange'),
    S2Choice<String>(value: 'mel', title: 'Melon'),
    S2Choice<String>(value: 'ban', title: 'Banana'),
    S2Choice<String>(value: 'gra', title: 'Grape'),
    S2Choice<String>(value: 'man', title: 'Mango'),
  ];
  FilePickerResult attachmentFile;
  List<String> _myListCustom = ['Jagadeesh', 'Jagadeesh'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create Account"),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(15.0),
            child: Form(
                key: _createAccountFormKey,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              margin: EdgeInsets.only(top: 15.0),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Name ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '*',
                                        style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(221, 221, 221, 1)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(221, 221, 221, 1)),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Name'),
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
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              margin: EdgeInsets.only(top: 15.0),
                              child: RichText(
                                text: TextSpan(
                                    text: 'Website ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                22)),
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(221, 221, 221, 1)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(221, 221, 221, 1)),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Website'),
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
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              margin: EdgeInsets.only(top: 15.0),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Phone ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '*',
                                        style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(221, 221, 221, 1)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(221, 221, 221, 1)),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: '+919999999999'),
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
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              margin: EdgeInsets.only(top: 15.0),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Email Address ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '*',
                                        style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(221, 221, 221, 1)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(221, 221, 221, 1)),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Email'),
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
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              margin: EdgeInsets.only(top: 15.0),
                              child: RichText(
                                text: TextSpan(
                                    text: 'Leads ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                22)),
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.only(top: 10.0),
                            child: DropdownSearch<String>(
                              mode: Mode.BOTTOM_SHEET,
                              maxHeight: 300,
                              items: ["Brazil", "Italia", "Tunisia", 'Canada'],
                              // label: "Custom BottomShet mode",
                              onChanged: print,
                              selectedItem: "----------",
                              showSearchBox: true,
                              showSelectedItem: true,
                              searchBoxDecoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 8, 0),
                                hintText: "Search a Lead",
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
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
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
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              margin: EdgeInsets.only(top: 15.0),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Billing Address ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '*',
                                        style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(221, 221, 221, 1)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(221, 221, 221, 1)),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Address Line'),
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
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.44,
                                    margin: EdgeInsets.only(top: 15.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Street ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: '*',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ],
                                      ),
                                    )),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.44,
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  221, 221, 221, 1)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  221, 221, 221, 1)),
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: 'Street'),
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
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.44,
                                    margin: EdgeInsets.only(top: 15.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'PostCode ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: '*',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ],
                                      ),
                                    )),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.44,
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  221, 221, 221, 1)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  221, 221, 221, 1)),
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: 'Postcode'),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'This field is required.';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.44,
                                    margin: EdgeInsets.only(top: 15.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'City ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: '*',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ],
                                      ),
                                    )),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.44,
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  221, 221, 221, 1)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  221, 221, 221, 1)),
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: 'City'),
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
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.44,
                                    margin: EdgeInsets.only(top: 15.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'State ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: '*',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ],
                                      ),
                                    )),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.44,
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  221, 221, 221, 1)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  221, 221, 221, 1)),
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: 'State'),
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              margin: EdgeInsets.only(top: 15.0),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Country ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '*',
                                        style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.only(top: 10.0),
                            child: DropdownSearch<String>(
                              mode: Mode.BOTTOM_SHEET,
                              maxHeight: 300,
                              items: ["Brazil", "Italia", "Tunisia", 'Canada'],
                              // label: "Custom BottomShet mode",
                              onChanged: print,
                              selectedItem: "----------",
                              showSearchBox: true,
                              showSelectedItem: true,
                              searchBoxDecoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 8, 0),
                                hintText: "Search a Lead",
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
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
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
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              margin: EdgeInsets.only(top: 15.0),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Contacts ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '*',
                                        style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: SmartSelect<String>.multiple(
                                title: 'Contacts',
                                value: _fruit,
                                onChange: (state) =>
                                    setState(() => _fruit = state.value),
                                choiceItems: fruits,
                                modalType: S2ModalType.popupDialog,
                                modalConfirm: true,
                                modalValidation: (value) => value.length > 0
                                    ? null
                                    : 'Select at least one',
                                tileBuilder: (context, state) {
                                  return S2Tile.fromState(
                                    state,
                                    isTwoLine: true,
                                    leading: Container(
                                      width: 40,
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.contacts),
                                    ),
                                  );
                                },
                                modalHeaderBuilder: (context, state) {
                                  return Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 15, 15, 15),
                                    height: kToolbarHeight,
                                    child: Row(
                                      children: <Widget>[
                                        state.modalTitle,
                                        const Spacer(),
                                        Visibility(
                                          visible: !state.changes.valid,
                                          child: Text(
                                            state.changes?.error ?? '',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                modalDividerBuilder: (context, state) {
                                  return const Divider(height: 1);
                                },
                                modalFooterBuilder: (context, state) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 7.0,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        const Spacer(),
                                        FlatButton(
                                          child: const Text('Cancel'),
                                          onPressed: () => state.closeModal(
                                              confirmed: false),
                                        ),
                                        const SizedBox(width: 5),
                                        FlatButton.icon(
                                          icon: Icon(Icons.check),
                                          label: Text(
                                              'OK (${state.changes.length})'),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          onPressed: state.changes.valid
                                              ? () => state.closeModal(
                                                  confirmed: true)
                                              : null,
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              margin: EdgeInsets.only(top: 15.0),
                              child: RichText(
                                text: TextSpan(
                                    text: 'Teams ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                22)),
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: SmartSelect<String>.multiple(
                                title: 'Teams',
                                value: _fruit,
                                onChange: (state) =>
                                    setState(() => _fruit = state.value),
                                choiceItems: fruits,
                                modalType: S2ModalType.bottomSheet,
                                modalConfirm: true,
                                modalValidation: (value) => value.length > 0
                                    ? null
                                    : 'Select at least one',
                                tileBuilder: (context, state) {
                                  return S2Tile.fromState(
                                    state,
                                    isTwoLine: true,
                                    leading: Container(
                                      width: 40,
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.people),
                                    ),
                                  );
                                },
                                modalHeaderBuilder: (context, state) {
                                  return Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 15, 15, 15),
                                    height: kToolbarHeight,
                                    child: Row(
                                      children: <Widget>[
                                        state.modalTitle,
                                        const Spacer(),
                                        Visibility(
                                          visible: !state.changes.valid,
                                          child: Text(
                                            state.changes?.error ?? '',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                modalDividerBuilder: (context, state) {
                                  return const Divider(height: 1);
                                },
                                modalFooterBuilder: (context, state) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 7.0,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        const Spacer(),
                                        FlatButton(
                                          child: const Text('Cancel'),
                                          onPressed: () => state.closeModal(
                                              confirmed: false),
                                        ),
                                        const SizedBox(width: 5),
                                        FlatButton.icon(
                                          icon: Icon(Icons.check),
                                          label: Text(
                                              'OK (${state.changes.length})'),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          onPressed: state.changes.valid
                                              ? () => state.closeModal(
                                                  confirmed: true)
                                              : null,
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              margin: EdgeInsets.only(top: 15.0),
                              child: RichText(
                                text: TextSpan(
                                    text: 'Users ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                22)),
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: SmartSelect<String>.multiple(
                                title: 'Users',
                                value: _fruit,
                                onChange: (state) =>
                                    setState(() => _fruit = state.value),
                                choiceItems: fruits,
                                modalType: S2ModalType.bottomSheet,
                                modalConfirm: true,
                                modalValidation: (value) => value.length > 0
                                    ? null
                                    : 'Select at least one',
                                tileBuilder: (context, state) {
                                  return S2Tile.fromState(
                                    state,
                                    isTwoLine: true,
                                    leading: Container(
                                      width: 40,
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.people),
                                    ),
                                  );
                                },
                                modalHeaderBuilder: (context, state) {
                                  return Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 15, 15, 15),
                                    height: kToolbarHeight,
                                    child: Row(
                                      children: <Widget>[
                                        state.modalTitle,
                                        const Spacer(),
                                        Visibility(
                                          visible: !state.changes.valid,
                                          child: Text(
                                            state.changes?.error ?? '',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                modalDividerBuilder: (context, state) {
                                  return const Divider(height: 1);
                                },
                                modalFooterBuilder: (context, state) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 7.0,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        const Spacer(),
                                        FlatButton(
                                          child: const Text('Cancel'),
                                          onPressed: () => state.closeModal(
                                              confirmed: false),
                                        ),
                                        const SizedBox(width: 5),
                                        FlatButton.icon(
                                          icon: Icon(Icons.check),
                                          label: Text(
                                              'OK (${state.changes.length})'),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          onPressed: state.changes.valid
                                              ? () => state.closeModal(
                                                  confirmed: true)
                                              : null,
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              margin: EdgeInsets.only(top: 15.0),
                              child: RichText(
                                text: TextSpan(
                                    text: 'Assign To ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                22)),
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: SmartSelect<String>.multiple(
                                title: 'Assign To',
                                value: _fruit,
                                onChange: (state) =>
                                    setState(() => _fruit = state.value),
                                choiceItems: fruits,
                                modalType: S2ModalType.bottomSheet,
                                modalConfirm: true,
                                modalValidation: (value) => value.length > 0
                                    ? null
                                    : 'Select at least one',
                                tileBuilder: (context, state) {
                                  return S2Tile.fromState(
                                    state,
                                    isTwoLine: true,
                                    leading: Container(
                                      width: 40,
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.people),
                                    ),
                                  );
                                },
                                modalHeaderBuilder: (context, state) {
                                  return Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 15, 15, 15),
                                    height: kToolbarHeight,
                                    child: Row(
                                      children: <Widget>[
                                        state.modalTitle,
                                        const Spacer(),
                                        Visibility(
                                          visible: !state.changes.valid,
                                          child: Text(
                                            state.changes?.error ?? '',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                modalDividerBuilder: (context, state) {
                                  return const Divider(height: 1);
                                },
                                modalFooterBuilder: (context, state) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 7.0,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        const Spacer(),
                                        FlatButton(
                                          child: const Text('Cancel'),
                                          onPressed: () => state.closeModal(
                                              confirmed: false),
                                        ),
                                        const SizedBox(width: 5),
                                        FlatButton.icon(
                                          icon: Icon(Icons.check),
                                          label: Text(
                                              'OK (${state.changes.length})'),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          onPressed: state.changes.valid
                                              ? () => state.closeModal(
                                                  confirmed: true)
                                              : null,
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              margin: EdgeInsets.only(top: 15.0),
                              child: RichText(
                                text: TextSpan(
                                    text: 'Status ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                22)),
                              )),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              margin: EdgeInsets.symmetric(horizontal: 15.0),
                              child: DropdownButtonHideUnderline(
                                child: new DropdownButton<String>(
                                  // value: 'open',
                                  icon: Icon(
                                    Icons.arrow_drop_down_sharp,
                                  ),
                                  hint: Text(
                                    "Open",
                                  ),
                                  items: <String>['Open', 'Close']
                                      .map((String value) {
                                    return new DropdownMenuItem<String>(
                                      value: value,
                                      child: new Text(
                                        value,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String value) {},
                                ),
                              )),
                        ],
                      ),
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                margin: EdgeInsets.only(top: 15.0),
                                child: RichText(
                                  text: TextSpan(
                                      text: 'Tags ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              22)),
                                )),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              margin: EdgeInsets.only(top: 10.0),
                              child: TextFieldTags(
                                textFieldStyler: TextFieldStyler(
                                    hintText: 'Add tags',
                                    helperText: 'Enter space to add tag'),
                                tagsStyler: TagsStyler(
                                    tagTextStyle:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    tagDecoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    tagCancelIcon: Icon(Icons.cancel,
                                        size: 18.0, color: Colors.green[900]),
                                    tagPadding: const EdgeInsets.all(6.0)),
                                onTag: (tag) {
                                  print(tag);
                                },
                                onDelete: (tag) {},
                              ),
                            ),
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Attachment',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22)),
                              Container(
                                margin: EdgeInsets.only(left: 10.0),
                                child: RaisedButton(
                                  color: Color.fromRGBO(239, 239, 239, 1),
                                  child: Text('Choose file'),
                                  onPressed: () async {
                                    attachmentFile =
                                        await FilePicker.platform.pickFiles();
                                    setState(() {
                                      attachmentFile = attachmentFile;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          attachmentFile != null
                              ? Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Text(
                                            attachmentFile.files.single.name),
                                      ),
                                      Container(
                                        child: IconButton(
                                          icon: Icon(Icons.close,
                                              color: Colors.grey),
                                          onPressed: () {
                                            setState(() {
                                              attachmentFile = null;
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 20.0),
                            child: RaisedButton(
                              color: Colors.blue,
                              child: Text(
                                'Save',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {},
                            ),
                          ),
                          Container(
                            child: RaisedButton(
                              color: Colors.white,
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.blue),
                              ),
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}
