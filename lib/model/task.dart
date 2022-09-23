import 'package:bottle_crm/model/company.dart';
import 'package:bottle_crm/model/profile.dart';
import 'package:intl/intl.dart';

import 'account.dart';
import 'company.dart';
import 'contact.dart';
import 'profile.dart';
import 'team.dart';

class Task {
  int? id;
  String? title;
  String? status;
  String? priority;
  String? dueDate;
  Account? account;
  Profile? createdBy;
  String? createdOn;
  List<Contact>? contacts;
  List<Team>? teams;
  List<Profile>? assignedTo;
  Company? company;

  Task(
      {this.id,
      this.title,
      this.status,
      this.priority,
      this.dueDate,
      this.account,
      this.createdBy,
      this.createdOn,
      this.contacts,
      this.teams,
      this.assignedTo,
      this.company});

  Task.fromJson(Map task) {
    this.id = task['id'] != null ? task['id'] : 0;
    this.title = task['title'] != null ? task['title'] : "";
    this.status = task['status'] != null ? task['status'] : "";
    this.priority = task['priority'] != null ? task['priority'] : "";
    this.dueDate = task['due_date'] != null ? task['due_date'] : "";
    this.account = task['account'] != null ? task['account'] : Account();
    this.createdBy = task['created_by'] != null
        ? Profile.fromJson(task['created_by'])
        : Profile();
    this.createdOn = task['created_on'] != null
        ? DateFormat("dd-MM-yyyy")
            .format(DateFormat("yyyy-MM-dd").parse(task['created_on']))
        : "";
    this.contacts = task['contacts'] != null
        ? List<Contact>.from(task['contacts'].map((x) => Contact.fromJson(x)))
        : [];
    this.teams = task['teams'] != null
        ? List<Team>.from(task['teams'].map((x) => Team.fromJson(x)))
        : [];
    this.assignedTo = task['assigned_to'] != null
        ? List<Profile>.from(
            task['assigned_to'].map((x) => Profile.fromJson(x)))
        : [];
    this.company =
        task['company'] != null ? Company.fromJson(task['company']) : Company();
  }

  toJson() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'priority': priority,
      'due_date': dueDate,
      'account': account,
      'created_by': createdBy,
      'created_on': createdOn,
      'contacts': contacts,
      'teams': teams,
      'assigned_to': assignedTo,
      'company': company
    };
  }
}
