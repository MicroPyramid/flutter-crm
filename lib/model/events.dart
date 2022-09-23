import 'package:bottle_crm/model/contact.dart';
import 'package:bottle_crm/model/profile.dart';
import 'package:bottle_crm/model/team.dart';
import 'package:intl/intl.dart';

class Event {
  int? id;
  String? name;
  String? eventType;
  String? startDate;
  String? startTime;
  String? endDate;
  String? endTime;
  String? description;
  String? dateOfMeeting;
  String? createdOn;
  Profile? createdBy;
  List<Contact>? contacts;
  List<Profile>? assignedTo;
  List<Team>? teams;
  bool? isActive;
  String? status;

  Event(
      {this.id,
      this.name,
      this.eventType,
      this.startDate,
      this.startTime,
      this.endDate,
      this.endTime,
      this.description,
      this.dateOfMeeting,
      this.contacts,
      this.assignedTo,
      this.teams,
      this.createdOn,
      this.isActive,
      this.status,
      this.createdBy});

  Event.fromJson(Map event) {
    this.id = event['id'] != null ? event['id'] : 0;
    this.name = event['name'] != null ? event['name'] : "";
    this.description = event['description'] != null ? event['description'] : "";
    this.createdBy = event['created_by'] != null
        ? Profile.fromJson(event['created_by'])
        : Profile();
    this.assignedTo = event['assigned_to'] != null
        ? List<Profile>.from(
            event['assigned_to'].map((x) => Profile.fromJson(x)))
        : [];
    this.createdOn = event['created_on'] != null
        ? DateFormat("dd-MM-yyyy")
            .format(DateFormat("yyyy-MM-dd").parse(event['created_on']))
        : "";
    this.contacts = event["contacts"] != null
        ? List<Contact>.from(event["contacts"].map((x) => Contact.fromJson(x)))
        : [];
    this.teams = event["teams"] != null
        ? List<Team>.from(event["teams"].map((x) => Team.fromJson(x)))
        : [];
    this.isActive = event['is_active'] != null ? event['is_active'] : false;
    this.status = event['status'] != null ? event['status'] : "";
    this.eventType = event['event_type'] != null ? event['event_type'] : "";
    this.startDate = event['start_date'] != null ? event['start_date'] : "";
    this.startTime = event['start_time'] != null ? event['start_time'] : "";
    this.endDate = event['end_date'] != null ? event['end_date'] : "";
    this.endTime = event['end_time'] != null ? event['end_time'] : "";
    this.dateOfMeeting=
        event['date_of_meeting'] != null ? event['date_of_meeting'] : "";
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'event_type': eventType,
      'status': status,
      'is_active': isActive,
      'start_date': startDate,
      'start_time': startTime,
      'end_date': endDate,
      'end_time': endTime,
      'description': description,
      'date_of_meeting': dateOfMeeting,
      'created_by': createdBy,
      'created_on': createdOn,
      'contacts': contacts,
      'teams': teams,
      'assigned_to': assignedTo,
    };
  }
}
