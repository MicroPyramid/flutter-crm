import 'package:bottle_crm/model/profile.dart';
import 'package:bottle_crm/model/team.dart';
import 'package:intl/intl.dart';

import 'contact.dart';

class Lead {
  int? id;
  String? title;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? status;
  String? source;
  String? addressLine;
  String? street;
  String? city;
  String? state;
  String? postcode;
  String? country;
  String? website;
  String? skypeID;
  String? description;
  List<Profile>? assignedTo;
  String? accountName;
  String? opportunityAmount;
  Profile? createdBy;
  String? createdOn;
  bool? isActive;
  dynamic enqueryType;
  List? tags;
  List<Contact>? contacts;
  bool? createdFromSite;
  List<Team>? teams;
  // Company company;

  Lead({
    this.id,
    this.title,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.status,
    this.source,
    this.addressLine,
    this.street,
    this.city,
    this.state,
    this.postcode,
    this.country,
    this.website,
    this.skypeID,
    this.description,
    this.assignedTo,
    this.accountName,
    this.opportunityAmount,
    this.createdBy,
    this.createdOn,
    this.isActive,
    this.enqueryType,
    this.tags,
    this.contacts,
    this.createdFromSite,
    this.teams,
    // this.company,
  });

  factory Lead.fromJson(Map<String, dynamic> lead) => Lead(
        id: lead["id"] != null ? lead["id"] : 0,
        title: lead["title"] != null ? lead["title"] : "",
        firstName: lead["first_name"] != null ? lead["first_name"] : "",
        lastName: lead["last_name"] != null ? lead["last_name"] : "",
        email: lead["email"] != null ? lead["email"] : "",
        phone: lead["phone"] != null ? lead['phone'] : "",
        status: lead["status"] != null ? lead["status"] : "",
        source: lead["source"] != null ? lead["source"] : "",
        addressLine: lead["address_line"] != null ? lead["address_line"] : "",
        street: lead["street"] != null ? lead["street"] : "",
        city: lead["city"] != null ? lead["city"] : "",
        state: lead["state"] != null ? lead["state"] : "",
        postcode: lead["postcode"] != null ? lead["postcode"] : "",
        country: lead["country"] != null ? lead["country"] : "",
        website: lead["website"] != null ? lead["website"] : "",
        skypeID: lead["skype_ID"] != null ? lead["skype_ID"] : "",
        description: lead["description"] != null ? lead["description"] : "",
        assignedTo: lead["assigned_to"] != null
            ? List<Profile>.from(lead["assigned_to"]
                .map((_profile) => Profile.fromJson(_profile)))
            : [],
        accountName: lead["account_name"] != null ? lead["account_name"] : "",
        opportunityAmount: lead["opportunity_amount"] != null
            ? lead["opportunity_amount"]
            : "",
        createdBy: lead["created_by"] != null
            ? Profile.fromJson(lead["created_by"])
            : Profile(),
        createdOn: lead["created_on"] != null
            ? DateFormat("dd-MM-yyyy")
                .format(DateFormat("yyyy-MM-dd").parse(lead['created_on']))
            : "",
        isActive: lead["is_active"] != null ? lead["is_active"] : false,
        enqueryType: lead["enquery_type"] != null ? lead["enquery_type"] : "",
        tags: lead["tags"] != null ? lead["tags"] : [],
        contacts: lead["contacts"] != null
            ? List<Contact>.from(
                lead["contacts"].map((x) => Contact.fromJson(x)))
            : [],
        createdFromSite: lead["created_from_site"] != null
            ? lead["created_from_site"]
            : false,
        teams: lead["teams"] != null
            ? List<Team>.from(lead["teams"].map((x) => Team.fromJson(x)))
            : [],
        // teams: lead
        // company: lead["company"] != null ? lead["company"] : Company(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "status": status,
        "source": source,
        "address_line": addressLine,
        "street": street,
        "city": city,
        "state": state,
        "postcode": postcode,
        "country": country,
        "website": website,
        "skype_ID":skypeID,
        "description": description,
        "assigned_to": List<dynamic>.from(assignedTo!.map((x) => x.toJson())),
        "account_name": accountName,
        "opportunity_amount": opportunityAmount,
        "created_by": createdBy!.toJson(),
        "created_on": createdOn,
        "is_active": isActive,
        "enquery_type": enqueryType,
        "tags": tags,
        "contacts": List<dynamic>.from(contacts!.map((x) => x)),
        "created_from_site": createdFromSite,
        // "teams": List<dynamic>.from(teams.map((x) => x)),
        // "company": company,
      };
}
