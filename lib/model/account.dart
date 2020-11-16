import 'package:flutter_crm/model/company.dart';
import 'package:flutter_crm/model/contact.dart';
import 'package:flutter_crm/model/lead.dart';
import 'package:flutter_crm/model/profile.dart';
import 'package:flutter_crm/model/team.dart';

class Account {
  int id;
  String name;
  String email;
  String phone;
  String industry;
  String billingAddressLine;
  String billingStreet;
  String billingCity;
  String billingState;
  String billingPostcode;
  String billingCountry;
  String website;
  String description;
  Profile createdBy;
  String createdOn;
  bool isActive;
  List<Map> tags;
  String status;
  Lead lead;
  String contactName;
  List<Contact> contacts;
  Profile assignedTo;
  List<Team> teams;
  Company company;

  Account(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.industry,
      this.billingAddressLine,
      this.billingStreet,
      this.billingCity,
      this.billingState,
      this.billingPostcode,
      this.billingCountry,
      this.website,
      this.description,
      this.createdBy,
      this.assignedTo,
      this.createdOn,
      this.isActive,
      this.tags,
      this.status,
      this.lead,
      this.contactName,
      this.contacts,
      this.teams,
      this.company});

  Account.fromJson(Map account) {
    this.id = account['id'];
    this.name = account['name'];
    this.email = account['email'];
    this.phone = account['phone'];
    this.industry = account['industry'];
    this.billingAddressLine = account['billing_address_line'];
    this.billingStreet = account['billing_street'];
    this.billingCity = account['billing_city'];
    this.billingState = account['billing_state'];
    this.billingPostcode = account['billing_postcode'];
    this.billingCountry = account['billing_country'];
    this.website = account['website'];
    this.description = account['description'];
    this.createdBy = account['created_by'];
    this.assignedTo = account['assigned_to'];
    this.createdOn = account['created_on'];
    this.isActive = account['is_active'];
    this.tags = account['tags'];
    this.status = account['status'];
    this.lead = account['lead'];
    this.contactName = account['contact_name'];
    this.contacts = account['contacts'];
    this.teams = account['teams'];
    this.company = account['company'];
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'industry': industry,
      'billing_address_line': billingAddressLine,
      'billing_street': billingStreet,
      'billing_city': billingCity,
      'billing_state': billingState,
      'billing_postcode': billingPostcode,
      'billing_country': billingCountry,
      'website': website,
      'description': description,
      'created_by': createdBy,
      'assigned_to': assignedTo,
      'created_on': createdOn,
      'is_active': isActive,
      'tags': tags,
      'status': status,
      'lead': lead,
      'contact_name': contactName,
      'contacts': contacts,
      'teams': teams,
      'company': company
    };
  }
}
