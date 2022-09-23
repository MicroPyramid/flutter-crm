import 'package:bottle_crm/model/task.dart';
import 'package:bottle_crm/ui/widgets/loader.dart';
import 'package:bottle_crm/ui/widgets/profile_pic_widget.dart';
//import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottle_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bottle_crm/bloc/task_bloc.dart';
import 'package:random_color/random_color.dart';

class TasksList extends StatefulWidget {
  TasksList();
  @override
  State createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  final GlobalKey<FormState> _filtersFormKey = GlobalKey<FormState>();
  List<Task> _tasks = [];
  bool _isFilter = false;
  ScrollController? scrollController;
  bool _isNextPageLoading = false;
  Map _filtersFormData = {"title": "", "status": "", "priority": ""};
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _tasks = taskBloc.tasks;
    });
    scrollController = ScrollController();
    scrollController!.addListener(() async {
      if (scrollController!.offset >=
              scrollController!.position.maxScrollExtent &&
          !scrollController!.position.outOfRange &&
          taskBloc.offset != "" &&
          !_isNextPageLoading) {
        setState(() {
          _isNextPageLoading = true;
        });
        await taskBloc.fetchTasks(
            filtersData: _isFilter ? _filtersFormData : null);
        setState(() {
          _isNextPageLoading = false;
        });
      }
    });
    super.initState();
  }

  _submitForm() async {
    if (_isFilter) {
      _filtersFormKey.currentState!.save();
    }
    setState(() {
      _isLoading = true;
    });
    taskBloc.offset = "";
    taskBloc.tasks.clear();
    await taskBloc.fetchTasks(filtersData: _isFilter ? _filtersFormData : null);
    setState(() {
      _isLoading = false;
    });
  }

  OutlineInputBorder buildBorder(Color color) {
    return OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(3.0)));
  }

  EdgeInsets padding() {
    return EdgeInsets.symmetric(
        horizontal: screenWidth / 30, vertical: screenHeight / 80);
  }

  _buildFilterBlock() {
    return _isFilter
        ? Container(
            color: Colors.grey[100],
            child: Form(
              key: _filtersFormKey,
              child: Column(
                children: [
                  SizedBox(height: 10.0),
                  Container(
                    width: screenWidth * 0.92,
                    child: TextFormField(
                      initialValue: _filtersFormData['title'],
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Enter title",
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        enabledBorder: buildBorder(Colors.black54),
                        focusedErrorBorder: buildBorder(Colors.black54),
                        focusedBorder: buildBorder(Colors.black54),
                        errorBorder: buildBorder(Colors.black54),
                        border: buildBorder(Colors.black54),
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        _filtersFormData['title'] = value;
                      },
                    ),
                  ),
                  // Container(
                  //     padding: padding(),
                  //     child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "Status",
                  //             style: TextStyle(
                  //                 fontSize: 18, color: Colors.black54),
                  //           ),
                  //           SizedBox(height: screenHeight / 70),
                  //           Container(
                  //               width: screenWidth * 0.92,
                  //               height: screenHeight / 17,
                  //               child: Stack(children: [
                  //                 DropdownSearch<String?>(
                  //                   mode: Mode.BOTTOM_SHEET,
                  //                   items: taskBloc.status,
                  //                   onChanged: print,
                  //                   onSaved: (selection) {
                  //                     if (selection == null) {
                  //                       taskBloc.currentEditTask!["status"] =
                  //                           "";
                  //                     } else {
                  //                       taskBloc.currentEditTask!['status '] =
                  //                           selection;
                  //                     }
                  //                   },
                  //                   selectedItem:
                  //                       taskBloc.currentEditTask!['status '],
                  //                   showSearchBox: true,
                  //                   showSelectedItems: false,
                  //                   showClearButton: false,
                  //                   searchFieldProps: TextFieldProps(
                  //                       decoration: InputDecoration(
                  //                     border: boxBorder(),
                  //                     enabledBorder: boxBorder(),
                  //                     focusedErrorBorder: boxBorder(),
                  //                     focusedBorder: boxBorder(),
                  //                     errorBorder: boxBorder(),
                  //                     contentPadding: EdgeInsets.all(12),
                  //                     hintText: "Search a Status",
                  //                   )),
                  //                   popupTitle: Container(
                  //                     height: 50,
                  //                     decoration: BoxDecoration(
                  //                       color:
                  //                           Theme.of(context).primaryColorDark,
                  //                       borderRadius: BorderRadius.only(
                  //                         topLeft: Radius.circular(20),
                  //                         topRight: Radius.circular(20),
                  //                       ),
                  //                     ),
                  //                     child: Center(
                  //                       child: Text(
                  //                         'Status',
                  //                         style: TextStyle(
                  //                             fontSize: screenWidth / 20,
                  //                             color: Colors.white),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   popupItemBuilder:
                  //                       (context, item, isSelected) {
                  //                     return Container(
                  //                       padding: EdgeInsets.symmetric(
                  //                           horizontal: 15.0, vertical: 10.0),
                  //                       child: Text(item!,
                  //                           style: TextStyle(
                  //                               fontSize: screenWidth / 22)),
                  //                     );
                  //                   },
                  //                   popupShape: RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.only(
                  //                       topLeft: Radius.circular(24),
                  //                       topRight: Radius.circular(24),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ])),
                  //         ])),
                  // Container(
                  //     padding: padding(),
                  //     child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "Priority",
                  //             style: TextStyle(
                  //                 fontSize: 18, color: Colors.black54),
                  //           ),
                  //           SizedBox(height: screenHeight / 70),
                  //           Container(
                  //               width: screenWidth * 0.92,
                  //               height: screenHeight / 17,
                  //               child: Stack(children: [
                  //                 DropdownSearch<String?>(
                  //                   mode: Mode.BOTTOM_SHEET,
                  //                   items: taskBloc.priorities,
                  //                   onChanged: print,
                  //                   onSaved: (selection) {
                  //                     if (selection == null) {
                  //                       taskBloc.currentEditTask!["priority"] =
                  //                           "";
                  //                     } else {
                  //                       taskBloc.currentEditTask!["priority"] =
                  //                           selection;
                  //                     }
                  //                   },
                  //                   selectedItem:
                  //                       taskBloc.currentEditTask!['priority '],
                  //                   showSearchBox: true,
                  //                   showSelectedItems: false,
                  //                   showClearButton: false,
                  //                   searchFieldProps: TextFieldProps(
                  //                       decoration: InputDecoration(
                  //                     border: boxBorder(),
                  //                     enabledBorder: boxBorder(),
                  //                     focusedErrorBorder: boxBorder(),
                  //                     focusedBorder: boxBorder(),
                  //                     errorBorder: boxBorder(),
                  //                     contentPadding: EdgeInsets.all(12),
                  //                     hintText: "Search a Source",
                  //                   )),
                  //                   popupTitle: Container(
                  //                     height: 50,
                  //                     decoration: BoxDecoration(
                  //                       color:
                  //                           Theme.of(context).primaryColorDark,
                  //                       borderRadius: BorderRadius.only(
                  //                         topLeft: Radius.circular(20),
                  //                         topRight: Radius.circular(20),
                  //                       ),
                  //                     ),
                  //                     child: Center(
                  //                       child: Text(
                  //                         'Priority',
                  //                         style: TextStyle(
                  //                             fontSize: screenWidth / 20,
                  //                             color: Colors.white),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   popupItemBuilder:
                  //                       (context, item, isSelected) {
                  //                     return Container(
                  //                       padding: EdgeInsets.symmetric(
                  //                           horizontal: 15.0, vertical: 10.0),
                  //                       child: Text(item!,
                  //                           style: TextStyle(
                  //                               fontSize: screenWidth / 22)),
                  //                     );
                  //                   },
                  //                   popupShape: RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.only(
                  //                       topLeft: Radius.circular(24),
                  //                       topRight: Radius.circular(24),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ])),
                  //         ])),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isFilter = false;
                            });
                            FocusScope.of(context).unfocus();
                            setState(() {
                              _filtersFormData = {
                                "title": "",
                                "status": [],
                                "priority": []
                              };
                            });
                            _submitForm();
                          },
                          child: Text(
                            "Reset",
                            style: TextStyle(fontSize: screenWidth / 24),
                          )),
                      SizedBox(width: 20.0),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            onPrimary: Colors.white,
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _submitForm();
                          },
                          child: Text(
                            "Filter",
                            style: TextStyle(fontSize: screenWidth / 24),
                          )),
                    ],
                  )
                ],
              ),
            ))
        : Container();
  }

  Widget _buildTasksList() {
    return _tasks.length != 0
        ? Container(
            padding: EdgeInsets.all(10.0),
            child: ListView.builder(
                itemCount: _tasks.length,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        taskBloc.currentTask = _tasks[index];
                        Navigator.pushNamed(context, '/task_details');
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: screenWidth * 0.55,
                                    child: Text(
                                        _tasks[index]
                                            .title!
                                            .capitalizeFirstofEach(),
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.blueGrey[800],
                                            fontWeight: FontWeight.w600,
                                            fontSize: screenWidth / 24)),
                                  ),
                                  Text(_tasks[index].createdOn!,
                                      style: TextStyle(
                                          color: Colors.blueGrey[800],
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenWidth / 24))
                                ],
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                      child: ProfilePicViewWidget(
                                          _tasks[index]
                                              .assignedTo!
                                              .map((assignedUser) =>
                                                  assignedUser.profileUrl == ""
                                                      ? assignedUser
                                                          .firstName![0].inCaps
                                                      : assignedUser.profileUrl)
                                              .toList()),
                                    ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 3.0),
                                    color: randomColor.randomColor(
                                        colorBrightness: ColorBrightness.light),
                                    child: Text(
                                      _tasks[index].status!,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12.0),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ));
                }),
          )
        : Center(
            child: Text(_isLoading || _isNextPageLoading
                ? "Fetching data..."
                : 'No Accounts Found.'),
          );
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _isLoading ? Loader() : new Container();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(fit: StackFit.expand, children: [
          SafeArea(
            child: Container(
              decoration:
                  BoxDecoration(color: Color.fromRGBO(73, 128, 255, 1.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, "/dashboard");
                                  currentBottomNavigationIndex="0";     
                                },
                                child: Icon(Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: screenWidth / 18)),
                            SizedBox(width: 10.0),
                            Text(
                              'Tasks',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth / 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isFilter = !_isFilter;
                                    });
                                  },
                                  child: Container(
                                      child: SvgPicture.asset(
                                    !_isFilter
                                        ? 'assets/images/filter.svg'
                                        : 'assets/images/icon_close.svg',
                                    width: screenWidth / 20,
                                  )))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                          height: screenHeight * 0.06,
                          decoration: BoxDecoration(
                              color: bottomNavBarSelectedTextColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                  _buildFilterBlock(),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: _buildTasksList(),
                    ),
                  ),
                  _isNextPageLoading
                      ? Container(
                          color: Colors.white,
                          child: Container(
                              width: 20.0,
                              child: new Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: new Center(
                                      child: new CircularProgressIndicator()))))
                      : Container()
                ],
              ),
            ),
          ),
          new Align(
            child: loadingIndicator,
            alignment: FractionalOffset.center,
          )
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            taskBloc.currentEditTaskId = "";
            if (taskBloc.tasks.length == 0) {
              showAlertDialog(context);
            } else {
              Navigator.pushNamed(context, '/task_create');
            }
          },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        bottomNavigationBar: BottomNavigationBarWidget());
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              "Alert",
              style: TextStyle(color: Colors.black),
            ),
            content: Text(
              "You don't have any accounts, Please create account first.",
              style: TextStyle(fontSize: 15.0),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                  textStyle: TextStyle(color: Colors.red),
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    currentBottomNavigationIndex = "4";
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/task_create");
                  },
                  child: Text("Create")),
            ],
          );
        });
  }
}
