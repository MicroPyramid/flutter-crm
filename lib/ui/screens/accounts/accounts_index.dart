import 'dart:convert';

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crm/ui/widgets/acc_overview_widget.dart';
import 'package:flutter_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_crm/ui/widgets/side_menu.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:json_table/json_table.dart';

// import 'package:flutter_tags/flutter_tags.dart';

class AccountsScreen extends StatefulWidget {
  AccountsScreen();
  @override
  State createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen>
    with SingleTickerProviderStateMixin {
  bool ascending;
  TabController _tabController;
  List _tabItems = const ['Open', 'Closed'];
  int counter = 0;

  List<dynamic> json1 = [];
  bool _isLoading = true;

  // List<TempData> _notes = List<TempData>();

  var _nameFilterController = TextEditingController();
  var _cityFilterController = TextEditingController();
  var _tagFilterController = TextEditingController();

  void _fetchData() async {
    await rootBundle
        .loadString('assets/data/tempdata.json')
        .then((String result) {
      setState(() {
        json1 = jsonDecode(result);
      });
    });
  }

  _showDetailsDialogPopup(data) {
    print('data $data');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.all(10.0),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['Name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          )
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.black38),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            alignment: Alignment.centerLeft,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Name",
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        Text(
                                          data['Name'],
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black45),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Email",
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        Text(
                                          data['Email'],
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black45),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Mobile",
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        Text(
                                          data['Mobile'],
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black45),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Contacts",
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        Text(
                                          data['Contacts'],
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black45),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Billing Address",
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        Text(
                                          data['Billing Address'],
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black45),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Tags",
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              18,
                                          child: new ListView.builder(
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: data['Tags'].length,
                                            itemBuilder:
                                                (BuildContext ctxt, int index) {
                                              return Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      52, 58, 64, 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5.0)),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.0),
                                                margin:
                                                    EdgeInsets.only(right: 1.0),
                                                child: Text(
                                                  data['Tags'][index],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              35,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Status",
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        Text(
                                          data['Status'],
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black45),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: Icon(Icons.send, color: Colors.white),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: Icon(Icons.remove_red_eye,
                                      color: Colors.white),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.cyan,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: Icon(Icons.edit, color: Colors.white),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).buttonColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child:
                                      Icon(Icons.delete, color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Created by ',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: data['Email'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0,
                                        )),
                                    TextSpan(
                                        text: ' created on ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.0,
                                        )),
                                    TextSpan(
                                        text: '12 days ago',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0,
                                        )),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        });
  }

  Widget dataTableWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 10.0,
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'ID',
              ),
            ),
            DataColumn(
              label: Text(
                'Name',
              ),
            ),
            DataColumn(
              label: Text(
                'City',
              ),
            ),
            DataColumn(
              label: Text(
                'Created On',
              ),
            ),
            DataColumn(
              label: Text(
                'Tags',
              ),
            ),
          ],
          rows:
              json1 // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                    ((element) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(element[
                                "ID"])), //Extracting from Map element the value
                            DataCell(
                              Text(
                                element["Name"],
                                style: TextStyle(color: Colors.blue),
                              ),
                              onTap: () {
                                _showDetailsDialogPopup(element);
                              },
                            ),
                            DataCell(Text(element["City"])),
                            DataCell(Text(element["Created On"])),
                            DataCell(
                                // ListView.builder(
                                //   shrinkWrap: true,
                                //   scrollDirection: Axis
                                //       .horizontal, // Axis.horizontal for horizontal list view.
                                //   itemCount: element['Tags'].length,
                                //   itemBuilder: (ctx, index) {
                                //     return Text(element['Tags'][index]);
                                //   },
                                // ),
                                Container(
                              height: MediaQuery.of(context).size.width / 18,
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: new ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: element['Tags'].length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(52, 58, 64, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    margin: EdgeInsets.only(right: 1.0),
                                    child: Text(
                                      element['Tags'][index],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              35,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  );
                                },
                              ),
                            ))
                            // DataCell(Text(element["Tags"])),
                          ],
                        )),
                  )
                  .toList(),
        ),
      ),
    );
  }

  Widget headerRowBuilder(screenSize) {
    Map a = json1[0];
    List tableHeaders = a.keys.toList();
    // List tableHeaders = ['a', 'b', 'c','d'];
    print(tableHeaders.runtimeType);
    print('Headers are ${tableHeaders}');
    // return Text('Hello all');
    print(screenSize.width);

    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tableHeaders.length,
        itemBuilder: (BuildContext context, int index) {
          print("Index at $index");
          // return Container();
          return DataTable(
            columnSpacing: screenSize.width * 0.015,
            columns: [
              DataColumn(
                  label: Text(
                tableHeaders[index],
                textAlign: TextAlign.center,
              ))
            ],
            rows: [],
          );
        });
  }

  Widget newDataTableRow(screenSize) {
    Map a = json1[0];
    final tableheaders = a.keys.toList();
    // print(tableheaders.runtimeType);
    // print(tableheaders);
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: Container(
          width: screenSize.width,
          child: DataTable(
            sortAscending: ascending,
            dividerThickness: 1,
            headingRowHeight: 0,
            columnSpacing: screenSize.width * 0.015,
            dataTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
            columns: tableheaders
                .map(
                  (header) => DataColumn(
                      label: Text(
                    header,
                    textAlign: TextAlign.center,
                    // style: TextStyle(color: Colors.brown[800],),
                  )),
                )
                .toList(),
            rows:
                json1 // Loops through dataColumnText, each iteration assigning the value to element
                    .map(
                      ((element) => //Extracting from Map element the value
                          DataRow(
                            cells:
                                // tableheaders.map((cellData) =>
                                //     DataCell(Container(child: Text(element[cellData]))),).toList()
                                <DataCell>[
                              DataCell(
                                Container(
                                    // width: screenSize.width * 0.08,
                                    child: Text(
                                  element[tableheaders[0]],
                                  textAlign: TextAlign.start,
                                )),
                              ),
                              DataCell(
                                  Container(
                                      // width: screenSize.width * 0.22,
                                      child: Text(
                                    element[tableheaders[1]],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(color: Colors.blue[500]),
                                  )), onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(element[tableheaders[1]]),
                                        content: AccountOverviewWidget(),
                                      );
                                    });
                                print('Pressed');
                              }),
                              DataCell(Container(
                                  // width: screenSize.width * 0.17,
                                  child: Text(
                                element[tableheaders[2]],
                                textAlign: TextAlign.start,
                              ))),
                              DataCell(Container(
                                  // width: screenSize.width * 0.175,
                                  child: Text(
                                element[tableheaders[3]],
                                textAlign: TextAlign.start,
                              ))),
                              DataCell(Container(
                                  // width: screenSize.width * 0.22,
                                  child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 2.0,
                                direction: Axis.horizontal,
                                children: element[tableheaders[4]]
                                    .map<Widget>((item) => Chip(
                                          label: Text(
                                            item,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8),
                                          ),
                                          backgroundColor:
                                              Color.fromRGBO(52, 58, 64, 1),
                                          elevation: 5.0,
                                        ))
                                    .toList(),
                              ))),
                            ],
                          )),
                    )
                    .toList(),
          ),
        ),
      ),
    );
  }

  Widget filterDrawer(BuildContext context, screenSize) {
    List filterList = ['Name', 'City', 'Tags'];
    var filterMap = {
      'Name': _nameFilterController,
      'City': _cityFilterController,
      'Tags': _tagFilterController
    };
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              // height: screenSize.height * 0.40,
              child: Column(
                children: [
                  Text('Filters',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenSize.width * .05,
                          fontWeight: FontWeight.bold)),
                  Divider(
                    height: screenSize.height * 0.025,
                    color: Colors.grey,
                  ),
                  Table(
                      // border: TableBorder.all(color: Colors.grey),
                      columnWidths: {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(4),
                      },
                      children: filterMap.entries
                          .map((entry) => TableRow(children: [
                                Container(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 30, 0, 20),
                                    child: Center(
                                        child: Text(
                                      '${entry.key} :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: entry.value,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 5.0,
                                                  color: Colors.black)),
                                          hintText: 'Enter ${entry.key} here'),
                                    ),
                                  ),
                                )
                              ]))
                          .toList()),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        screenSize.width * 0.20, 10, 25, 10),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 15.0),
                          child: RaisedButton(
                            color: Colors.blue,
                            child: Text(
                              "Search",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            onPressed: () {},
                          ),
                        ),
                        RaisedButton(
                          color: Colors.white,
                          child: Text(
                            "Clear",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _nameFilterController.clear();
                            _cityFilterController.clear();
                            _tagFilterController.clear();
                          },
                        )
                        // FlatButton.icon(
                        //     onPressed: () {},
                        //     color: Colors.green,
                        //     label: Text('Submit'),
                        //     icon: Icon(
                        //       Icons.arrow_forward_outlined,
                        //     )),
                        // SizedBox(width: 20),
                        // FlatButton.icon(
                        //     onPressed: () {
                        //       Navigator.pop(context);
                        //       _nameFilterController.clear();
                        //       _cityFilterController.clear();
                        //       _tagFilterController.clear();
                        //     },
                        //     color: Colors.redAccent,
                        //     label: Text('Clear'),
                        //     icon: Icon(
                        //       Icons.clear,
                        //     ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _fetchData();
    ascending = false;
    // _fetchData().then((value){
    //   setState(() {
    //     _notes.addAll(value);
    //   });
    // });
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(a);
    // print(a.runtimeType);

    // Map userMap = jsonDecode(a);
    // print(userMap);
    // var user = TempData.fromJson(userMap);
    // print(user.id);
    // print(userMap.values);

    var screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
            title: Text("Accounts"),
            bottom: PreferredSize(
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(_tabItems[0]),
                      ),
                      Text(_tabItems[1])
                    ],
                    controller: _tabController,
                  ),
                  // Theme(
                ],
              ),
              preferredSize: Size.fromHeight(screenSize.height * 0.05),
            )),
        body: json1.isEmpty
            ? Center(child: CircularProgressIndicator())
            : TabBarView(controller: _tabController, children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      color: Color.fromRGBO(229, 229, 229, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Open Accounts : ${json1.length}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenSize.width / 22),
                          ),
                          // ButtonTheme(
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius:
                          //           BorderRadius.all(Radius.circular(10))),
                          //   minWidth: screenSize.width * 0.01,
                          //   height: screenSize.height * 0.04,
                          //   child: RaisedButton(
                          //     color: Color.fromRGBO(220, 62, 69, 1),
                          //     child: Icon(
                          //       Icons.filter_alt,
                          //       color: Colors.white,
                          //       size: 25,
                          //     ),
                          //     onPressed: () {
                          //       showModalBottomSheet(
                          //           shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.vertical(
                          //                   top: Radius.circular(25.0))),
                          //           context: context,
                          //           isScrollControlled: true,
                          //           builder: (BuildContext context) {
                          //             return filterDrawer(context, screenSize);
                          //           });
                          //     },
                          //   ),
                          // )
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0))),
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return filterDrawer(context, screenSize);
                                  });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(220, 62, 69, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3.0)),
                              ),

                              width: screenSize.width / 10,
                              height: screenSize.width / 10,
                              // decoration: BoxDecoration(
                              //   border: Border.all(
                              //     width: 1,
                              //   ),
                              child: Icon(Icons.filter_alt,
                                  color: Colors.white,
                                  size: screenSize.width / 12),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: dataTableWidget(),
                    ),
                    // Expanded(
                    //     flex: 12,
                    //     child: SingleChildScrollView(
                    //         // scrollDirection: Axis.horizontal,
                    //         child: SingleChildScrollView(
                    //       scrollDirection: Axis.vertical,
                    //       child: newDataTableRow(screenSize),
                    //     ))),
                  ],
                ),
                JsonTable(
                  json1,
                  showColumnToggle: false,
                  allowRowHighlight: true,
                  rowHighlightColor: Colors.yellow[500].withOpacity(0.7),
                  paginationRowCount: 10,
                  onRowSelect: (index, map) {
                    print(index);
                    print(map);
                  },
                ),
              ]),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.person_add_rounded,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/create_account');
            }),
        bottomNavigationBar: BottomNavigationBarWidget(),
      ),
    );
  }

  String getPrettyJSONString(jsonObject) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String jsonString = encoder.convert(json.decode(jsonObject));
    return jsonString;
  } // to display json data as is
}
