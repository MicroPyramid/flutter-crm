import 'package:flutter_crm/model/company.dart';
import 'package:flutter_crm/model/profile.dart';
import 'package:flutter_crm/model/team.dart';
import 'package:intl/intl.dart';

class Contact {
  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  Map address;
  String description;
  List<Profile> assignedTo;
  Profile createdBy;
  String createdOn;
  bool isActive;
  List<Team> teams;
  Company company;
  String createdOnText;
  Profile teamAndAssignedUsers;
  Profile assignedUsersNotInTeams;

  Contact(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.address,
      this.description,
      this.assignedTo,
      this.createdBy,
      this.createdOn,
      this.isActive,
      this.teams,
      this.company,
      this.createdOnText,
      this.teamAndAssignedUsers,
      this.assignedUsersNotInTeams});

  Contact.fromJson(Map contact) {
    this.id = contact['id'] != null ? contact['id'] : 0;
    this.firstName = contact['first_name'] != null ? contact['first_name'] : '';
    this.lastName = contact['last_name'] != null ? contact['last_name'] : '';
    this.email = contact['email'] != null ? contact['email'] : "";
    this.phone = contact['phone'] != null ? contact['phone'] : "";
    this.address = contact['address'] != null ? contact['address'] : {};
    this.description =
        contact['description'] != null ? contact['description'] : "";
    this.assignedTo = contact['assigned_to'] != null
        ? List<Profile>.from(
            contact['assigned_to'].map((x) => Profile.fromJson(x)))
        : [];
    this.createdBy = contact['created_by'] != null
        ? Profile.fromJson(contact['created_by'])
        : Profile();
    this.createdOn = contact['created_on'] != null
        ? DateFormat("dd-MM-yyyy")
            .format(DateFormat("yyyy-MM-dd").parse(contact['created_on']))
        : "";
    this.createdOnText =
        contact['created_on_arrow'] != null ? contact['created_on_arrow'] : "";
    this.isActive = contact['is_active'] != null ? contact['is_active'] : false;
    this.teams = contact['teams'] != null
        ? List<Team>.from(contact['teams'].map((x) => Team.fromJson(x)))
        : [];
    this.company = contact['company'] != null
        ? Company.fromJson(contact['company'])
        : Company();
  }

  toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'description': description,
      'assigned_to': assignedTo,
      'created_by': createdBy,
      'created_on': createdOn,
      'created_on_arrow': createdOnText,
      'is_active': isActive,
      'teams': teams,
      'company': company
    };
  }
}
