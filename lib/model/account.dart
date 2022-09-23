import 'package:bottle_crm/model/contact.dart';
import 'package:bottle_crm/model/lead.dart';
import 'package:bottle_crm/model/profile.dart';
import 'package:bottle_crm/model/team.dart';
import 'package:intl/intl.dart';

class Account {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? industry;
  String? billingAddressLine;
  String? billingStreet;
  String? billingCity;
  String? billingState;
  String? billingPostcode;
  String? billingCountry;
  String? website;
  String? description;
  Profile? createdBy;
  String? createdOn;
  bool? isActive;
  List? tags;
  String? status;
  Lead? lead;
  String? contactName;
  List<Contact>? contacts;
  List<Profile>? assignedTo;
  List<Team>? teams;

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
      this.teams});

  Account.fromJson(Map account) {
    this.id = account['id'] != null ? account['id'] : 0;
    this.name = account['name'] != null ? account['name'] : "";
    this.email = account['email'] != null ? account['email'] : "";
    this.phone = account['phone'] != null ? account['phone'] : "";
    this.industry = account['industry'] != null ? account['industry'] : "";
    this.billingAddressLine = account['billing_address_line'] != null
        ? account['billing_address_line']
        : "";
    this.billingStreet =
        account['billing_street'] != null ? account['billing_street'] : "";
    this.billingCity =
        account['billing_city'] != null ? account['billing_city'] : "";
    this.billingState =
        account['billing_state'] != null ? account['billing_state'] : "";
    this.billingPostcode =
        account['billing_postcode'] != null ? account['billing_postcode'] : "";
    this.billingCountry =
        account['billing_country'] != null ? account['billing_country'] : "";
    this.website = account['website'] != null ? account['website'] : "";
    this.description =
        account['description'] != null ? account['description'] : "";
    this.createdBy = account['created_by'] != null
        ? Profile.fromJson(account['created_by'])
        : Profile();
    this.assignedTo = account['assigned_to'] != null
        ? List<Profile>.from(
            account['assigned_to'].map((x) => Profile.fromJson(x)))
        : [];
    this.createdOn = account['created_on'] != null
        ? DateFormat("dd-MM-yyyy")
            .format(DateFormat("yyyy-MM-dd").parse(account['created_on']))
        : "";
    this.isActive = account['is_active'] != null ? account['is_active'] : false;
    this.tags = account['tags'] != null ? account['tags'] : [];
    this.status = account['status'] != null ? account['status'] : "";
    this.lead =
        account['lead'] != null ? Lead.fromJson(account['lead']) : Lead();
    this.contactName =
        account['contact_name'] != null ? account['contact_name'] : "";
    this.contacts = account["contacts"] != null
        ? List<Contact>.from(
            account["contacts"].map((x) => Contact.fromJson(x)))
        : [];
    this.teams = account["teams"] != null
        ? List<Team>.from(account["teams"].map((x) => Team.fromJson(x)))
        : [];
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
      'teams': teams
    };
  }
}
