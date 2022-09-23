import 'package:bottle_crm/model/contact.dart';
import 'package:bottle_crm/model/profile.dart';
import 'package:bottle_crm/model/team.dart';
import 'package:intl/intl.dart';

import 'account.dart';
import 'company.dart';

class Case {
  int? id;
  String? name;
  String? status;
  String? priority;
  String? caseType;
  String? closedOn;
  String? description;
  Profile? createdBy;
  String? createdOn;
  bool? isActive;
  Account? account;
  List<Contact>? contacts;
  List<Team>? teams;
  List<Profile>? assignedTo;
  Company? company;
  String? createdOnText;
  List? caseAttachment;

  Case(
      {this.id,
      this.name,
      this.status,
      this.priority,
      this.caseType,
      this.closedOn,
      this.description,
      this.createdBy,
      this.createdOn,
      this.isActive,
      this.account,
      this.contacts,
      this.teams,
      this.assignedTo,
      this.company,
      this.createdOnText,
      this.caseAttachment});

  Case.fromJson(Map data) {
    this.status = data['status'] != null ? data['status'] : "";
    this.priority = data['priority'] != null ? data['priority'] : "";
    this.caseType = data['type_of_case'] != null ? data['type_of_case'] : "";
    this.id = data['id'] != null ? data['id'] : 0;
    this.name = data['name'] != null ? data['name'] : "";
    this.account =
        data['account'] != null ? Account.fromJson(data['account']) : Account();
    this.contacts = data['contacts'] != null
        ? List<Contact>.from(data["contacts"].map((x) => Contact.fromJson(x)))
        : [];

    this.closedOn = data['closed_on'] != null ? data['closed_on'] : "";
    this.description = data['description'] != null ? data['description'] : "";
    this.assignedTo = data['assigned_to'] != null
        ? List<Profile>.from(
            data["assigned_to"].map((x) => Profile.fromJson(x)))
        : [];
    this.createdBy = data['created_by'] != null
        ? Profile.fromJson(data['created_by'])
        : Profile();
    this.createdOn = data['created_on'] != null
        ? DateFormat("dd-MM-yyyy")
            .format(DateFormat("yyyy-MM-dd").parse(data['created_on']))
        : "";
    this.isActive = data['is_active'] != null ? data['is_active'] : false;
    this.teams = data['teams'] != null
        ? List<Team>.from(data["teams"].map((x) => Team.fromJson(x)))
        : [];
    this.company =
        data['company'] != null ? Company.fromJson(data['company']) : Company();
    this.createdOnText =
        data['created_on_arrow'] != null ? data['created_on_arrow'] : "";
    this.caseAttachment =
        data['case_attachment'] != null ? data['case_attachment'] : [];
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'priority': priority,
      'type_of_case': caseType,
      'account': account,
      'contacts': contacts,
      'closed_on': closedOn,
      'description': description,
      'assigned_to': assignedTo,
      'created_by': createdBy,
      'created_on': createdOn,
      'is_active': isActive,
      'teams': teams,
      'company': company,
      'created_on_arrow': createdOnText,
      'case_attachment': caseAttachment
    };
  }
}
