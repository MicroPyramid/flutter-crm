import 'package:flutter_crm/model/profile.dart';
import 'package:intl/intl.dart';

import 'account.dart';

class Opportunity {
  int id;
  String name;
  Account account;
  String stage;
  String currency;
  String amount;
  String leadSource;
  int probability;
  // List<Contact> contacts;
  Profile closedBy;
  String closedOn;
  String description;
  // List<Profile> assignedTo;
  Profile createdBy;
  String createdOn;
  bool isActive;
  List tags;
  // List<Team> teams;
  int compantId;
  String createdOnText;

  Opportunity({
    this.id,
    this.name,
    this.account,
    this.amount,
    this.closedBy,
    this.closedOn,
    this.compantId,
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
    // this.contacts,
    // this.assignedTo,
    // this.teams
  });

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
    // this.contacts =
    //     opportunity['contacts'] != null ? List<Contact>.from(opportunity["contacts"].map((x) => Contact.fromJson(x)))
    //     : [];
    this.closedBy = opportunity['closed_by'] != null
        ? Profile.fromJson(opportunity['closed_by'])
        : Profile();
    this.closedOn =
        opportunity['closed_on'] != null ? opportunity['closed_on'] : "";
    this.description =
        opportunity['description'] != null ? opportunity['description'] : "";
    this.description =
        opportunity['description'] != null ? opportunity['description'] : "";
    // this.assignedTo = opportunity['assigned_to'] != null ? List<Profile>.from(opportunity["assigned_to"].map((x) => Profile.fromJson(x)))
    //     : [];
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
    // this.teams = opportunity['teams'] != null ? List<Team>.from(opportunity["teams"].map((x) => Team.fromJson(x)))
    //     : [];
    this.compantId =
        opportunity['company'] != null ? opportunity['company'] : 0;
    this.createdOnText = opportunity['created_on_arrow'] != null
        ? opportunity['created_on_arrow']
        : "";
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
      // 'contacts': contacts,
      'closed_by': closedBy,
      'closed_on': closedOn,
      'description': description,
      // 'assigned_to': assignedTo,
      'created_by': createdBy,
      'created_on': createdOn,
      'is_active': isActive,
      'tags': tags,
      // 'teams': teams,
      'company': compantId,
      'created_on_arrow': createdOnText,
    };
  }
}
