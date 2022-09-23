import 'package:bottle_crm/model/contact.dart';
import 'package:bottle_crm/model/profile.dart';
import 'package:bottle_crm/model/team.dart';
import 'package:intl/intl.dart';

import 'account.dart';
import 'company.dart';

class Opportunity {
  int? id;
  String? name;
  Account? account;
  String? stage;
  String? currency;
  String? amount;
  String? leadSource;
  int? probability;
  List<Contact>? contacts;
  Profile? closedBy;
  String? closedOn;
  String? dueDate;
  String? description;
  List<Profile>? assignedTo;
  Profile? createdBy;
  String? createdOn;
  bool? isActive;
  List? tags;
  List<Team>? teams;
  Company? company;
  String? createdOnText;
  List? opportunityAttachment;

  Opportunity(
      {this.id,
      this.name,
      this.account,
      this.amount,
      this.closedBy,
      this.closedOn,
      this.dueDate,
      this.company,
      this.createdBy,
      this.createdOn,
      this.createdOnText,
      this.currency,
      this.description,
      this.isActive,
      this.leadSource,
      this.probability,
      this.stage,
      this.tags,
      this.contacts,
      this.assignedTo,
      this.teams,
      this.opportunityAttachment});

  Opportunity.fromJson(Map opportunity) {
    this.id = opportunity['id'] != null ? opportunity['id'] : 0;
    this.name = opportunity['name'] != null ? opportunity['name'] : "";
    this.account = opportunity['account'] != null
        ? Account.fromJson(opportunity['account'])
        : Account();
    this.stage = opportunity['stage'] != null ? opportunity['stage'] : "";
    this.currency =
        opportunity['currency'] != null ? opportunity['currency'] : "";
    this.amount = opportunity['amount'] != null ? opportunity['amount'] : "";
    this.leadSource =
        opportunity['lead_source'] != null ? opportunity['lead_source'] : "";
    this.probability =
        opportunity['probability'] != null ? opportunity['probability'] : 0;
    this.contacts = opportunity['contacts'] != null
        ? List<Contact>.from(
            opportunity["contacts"].map((x) => Contact.fromJson(x)))
        : [];
    this.closedBy = opportunity['closed_by'] != null
        ? Profile.fromJson(opportunity['closed_by'])
        : Profile();
    this.closedOn =
        opportunity['closed_on'] != null ? opportunity['closed_on'] : "";
    this.dueDate =
        opportunity['due_date'] != null ? opportunity['due_date'] : "";
    this.description =
        opportunity['description'] != null ? opportunity['description'] : "";
    this.description =
        opportunity['description'] != null ? opportunity['description'] : "";
    this.assignedTo = opportunity['assigned_to'] != null
        ? List<Profile>.from(
            opportunity["assigned_to"].map((x) => Profile.fromJson(x)))
        : [];
    this.createdBy = opportunity['created_by'] != null
        ? Profile.fromJson(opportunity['created_by'])
        : Profile();
    this.createdOn = opportunity['created_on'] != null
        ? DateFormat("dd-MM-yyyy")
            .format(DateFormat("yyyy-MM-dd").parse(opportunity['created_on']))
        : "";
    this.isActive =
        opportunity['is_active'] != null ? opportunity['is_active'] : false;
    this.tags = opportunity['tags'] != null ? opportunity['tags'] : [];
    this.teams = opportunity['teams'] != null
        ? List<Team>.from(opportunity["teams"].map((x) => Team.fromJson(x)))
        : [];
    this.company = opportunity['company'] != null
        ? Company.fromJson(opportunity['company'])
        : Company();
    this.createdOnText = opportunity['created_on_arrow'] != null
        ? opportunity['created_on_arrow']
        : "";
    this.opportunityAttachment =
        opportunity['opportunity_attachment'].length != 0
            ? opportunity['opportunity_attachment']
            : [];
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'account': account,
      'stage': stage,
      'currency': currency,
      'amount': amount,
      'lead_source': leadSource,
      'probability': probability,
      'contacts': contacts,
      'closed_by': closedBy,
      'closed_on': closedOn,
      'due_date': dueDate,
      'description': description,
      'assigned_to': assignedTo,
      'created_by': createdBy,
      'created_on': createdOn,
      'is_active': isActive,
      'tags': tags,
      'teams': teams,
      'company': company,
      'created_on_arrow': createdOnText,
      'opportunity_attachment': opportunityAttachment
    };
  }
}
