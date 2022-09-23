import 'dart:convert';

import 'package:bottle_crm/model/contact.dart';
import 'package:bottle_crm/model/events.dart';
import 'package:bottle_crm/services/crm_services.dart';

class EventBloc {
  List<Event> _events = [];
  Event? _currentEvent;
  int? _currentEventIndex;
  String? _currentEditEventId = "";
  String _offset = "";
  List _assignedToList = [];
  List<Contact> _contacts = [];
  List _recurringDays = [];
  Map _currentEditEvent = {
    "name": "",
    "event_type": "Recurring",
    "start_date": null,
    "start_time": "",
    "end_date": "",
    "end_time": "",
    "description": "",
    "contacts": [],
    "teams": [],
    "assigned_to": [],
    "recurring_day": [],
  };

  Future fetchEvents({filtersData}) async {
    try {
      Map? _copyFiltersData =
          filtersData != null ? new Map.from(filtersData) : null;

      await CrmService()
          .getEvents(queryParams: _copyFiltersData)
          .then((response) {
        var res = (json.decode(response.body));
        _assignedToList.clear();

        res['events'].forEach((_event) {
          Event event = Event.fromJson(_event);
          _events.add(event);
        });
        if (res['recurring_days'] != null) {
          _recurringDays.clear();
          res['recurring_days'].forEach((_recurringDay) {
            _recurringDays.add(_recurringDay[1]);
          });
        }
        print(_recurringDays);
        res['contacts_list'].forEach((_contact) {
          Contact contact = Contact.fromJson(_contact);
          _contacts.add(contact);
        });

        _offset = res['offset'] != null && res['offset'].toString() != "0"
            ? res['offset'].toString()
            : "";
      }).catchError((onError) {
        print("fetchEvents Error>> $onError");
      });
    } catch (e) {}
  }

  Future createEvent() async {
    Map? result;
    Map _copyCurrentEditEvent = Map.from(_currentEditEvent);
    _copyCurrentEditEvent['contacts'] = (_copyCurrentEditEvent['contacts']
        .map((contacts) => contacts.toString())).toList().toString();

    _copyCurrentEditEvent['teams'] = (_copyCurrentEditEvent['teams']
        .map((teams) => teams.toString())).toList().toString();

    _copyCurrentEditEvent['assigned_to'] = (_copyCurrentEditEvent['assigned_to']
        .map((assignedTo) => assignedTo.toString())).toList().toString();

    await CrmService()
        .createEvent(_copyCurrentEditEvent)
        .then((response) async {
      var res = json.decode(response.body);
      if (res['error'] == false) {
        await fetchEvents();
      }
      result = res;
    }).catchError((onError) {
      print('createEvents Error >> $onError');
      result = {"status": "error", "message": "Something went wrong"};
    });
    return result;
  }

  Future editEvent() async {
    Map? _result;
    Map _copyOfCurrentEditEvent = Map.from(_currentEditEvent);

    _copyOfCurrentEditEvent['contacts'] = (_copyOfCurrentEditEvent['contacts']
        .map((contacts) => contacts.toString())).toList().toString();

    _copyOfCurrentEditEvent['teams'] = (_copyOfCurrentEditEvent['teams']
        .map((teams) => teams.toString())).toList().toString();

    _copyOfCurrentEditEvent['assigned_to'] =
        (_copyOfCurrentEditEvent['assigned_to']
            .map((assignedTo) => assignedTo.toString())).toList().toString();

    await CrmService()
        .editEvent(_copyOfCurrentEditEvent, _currentEditEventId)
        .then((response) async {
      var res = json.decode(response.body);
      if (res['error'] == false) {
        await fetchEvents();
      }
      _result = res;
    }).catchError((onError) {
      print("editEvent Error >> $onError");
      _result = {"status": "error", "message": "Something went wrong."};
    });
    return _result;
  }

  Future deleteEvent(Event event) async {
    Map? result;
    await CrmService().deleteEvent(event.id).then((response) async {
      var res = (json.decode(response.body));
      await fetchEvents();
      result = res;
    }).catchError((onError) {
      print("deleteEvent Error >> $onError");
      result = {"status": "error", "message": "Something went wrong."};
    });
    return result;
  }

  updateCurrentEditEvent(Event event) {
    _currentEditEventId = event.id.toString();

    List contacts = [];
    List teams = [];
    List assignedUsers = [];

    event.contacts!.forEach((contact) {
      contacts.add(contact.id);
    });

    event.assignedTo!.forEach((assignedAccount) {
      assignedUsers.add(assignedAccount.id);
    });

    event.teams!.forEach((team) {
      teams.add(team.id);
    });

    _currentEditEvent = {
      "name": "",
      "event_type": "Recurring",
      "start_date": null,
      "start_time": "",
      "end_date": "",
      "end_time": "",
      "description": "",
      "contacts": [],
      "teams": [],
      "assigned_to": [],
      "recurring_day": [],
    };
  }

  cancelCurrentEditEvent() {
    _currentEditEventId = null;
    _currentEditEvent = {
      "name": "",
      "event_type": "Recurring",
      "start_date": null,
      "start_time": "",
      "end_date": "",
      "end_time": "",
      "description": "",
      "contacts": [],
      "teams": [],
      "assigned_to": [],
      "recurring_days": [],
    };
  }

  List<Event> get events {
    return _events;
  }

  Event? get currentEvent {
    return _currentEvent;
  }

  set currentEvent(event) {
    _currentEvent = event;
  }

  int? get currentEventIndex {
    return _currentEventIndex;
  }

  set currentEventIndex(index) {
    _currentEventIndex = index;
  }

  Map get currentEditEvent {
    return _currentEditEvent;
  }

  set currentEditEvent(currentEditEvent) {
    _currentEditEvent = currentEditEvent;
  }

  List get recurringDays {
    return _recurringDays;
  }

  String get offset {
    return _offset;
  }

  set offset(offset) {
    _offset = offset;
  }

  String? get currentEditEventId {
    return _currentEditEventId;
  }

  set currentEditEventId(id) {
    _currentEditEventId = id;
  }
}

final eventBloc = EventBloc();
