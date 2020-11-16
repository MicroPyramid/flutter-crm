import 'package:flutter_crm/model/company.dart';
import 'package:flutter_crm/model/profile.dart';
import 'package:flutter_crm/model/team.dart';

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
      this.company});

  Contact.fromJson(Map contact) {
    this.id = contact['id'];
    this.firstName = contact['first_name'];
    this.lastName = contact['last_name'];
    this.email = contact['email'];
    this.phone = contact['phone'];
    this.address = contact['address'];
    this.description = contact['description'];
    this.assignedTo = contact['assigned_to'];
    this.createdBy = contact['created_by'];
    this.createdOn = contact['created_on'];
    this.isActive = contact['is_active'];
    this.teams = contact['teams'];
    this.company = contact['company'];
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
      'is_active': isActive,
      'teams': teams,
      'company': company
    };
  }
}
