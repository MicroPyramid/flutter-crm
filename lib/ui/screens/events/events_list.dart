import 'package:bottle_crm/bloc/event_bloc.dart';
import 'package:bottle_crm/model/events.dart';
import 'package:bottle_crm/ui/widgets/loader.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:bottle_crm/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class EventsList extends StatefulWidget {
  EventsList();
  @override
  State createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  List<Event> _events = [];
  bool _isLoading = false;
  bool _isFilter = false;
  bool _isNextPageLoading = false;
  ScrollController? scrollController;

  @override
  void initState() {
    setState(() {
      _events = eventBloc.events;
    });
    super.initState();
  }

  Widget _buildTasksList() {
    return _events.length != 0
        ? Container(
            padding: EdgeInsets.all(10.0),
            child: ListView.builder(
                itemCount: _events.length,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        eventBloc.currentEvent = _events[index];
                        Navigator.pushNamed(context, '/event_details');
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
                                        _events[index]
                                            .name!
                                            .capitalizeFirstofEach(),
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.blueGrey[800],
                                            fontWeight: FontWeight.w600,
                                            fontSize: screenWidth / 24)),
                                  ),
                                  Text(DateFormat("dd-MM-yyyy").format(DateTime.parse(_events[index].dateOfMeeting!)),
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
                               //crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      _events[index].startDate!+" "+_events[index].startTime! ,
                                      style: TextStyle(
                                          color: Colors.blueGrey[800],
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenWidth / 24)),
                                          Text(
                                      "To" ,
                                      style: TextStyle(
                                          color: Colors.blueGrey[800],
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenWidth / 22)),
                                          Text(
                                      _events[index].endDate!+" "+_events[index].endTime! ,
                                      style: TextStyle(
                                          color: Colors.blueGrey[800],
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenWidth / 24))
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
                                      context, "/more_options");
                                },
                                child: Icon(Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: screenWidth / 18)),
                            SizedBox(width: 10.0),
                            Text(
                              'Events',
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
            // accountBloc.currentEditAccountId = "";
            // if (accountBloc.openAccounts.length == 0) {
            //   showAlertDialog(context);
            // } else {
                Navigator.pushNamed(context, '/event_create');
            // }
          },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        bottomNavigationBar: BottomNavigationBarWidget());
  }
}
