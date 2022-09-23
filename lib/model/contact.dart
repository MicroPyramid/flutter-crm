import 'package:bottle_crm/model/profile.dart';
import 'package:bottle_crm/model/team.dart';
import 'package:intl/intl.dart';

class Contact {
  int? id;
  String? salutation;
  String? firstName;
  String? lastName;
  String? primaryEmail;
  String? secondaryEmail;
  String? primaryMobile;
  String? secondaryMobile;
  String? dateOfBirth;
  String? linkedInUrl;
  String? facebookUrl;
  String? twitterUserName;
  String? organization;
  String? department;
  bool? doNotCall;
  String? title;
  Map? address;
  String? description;
  List<Profile>? assignedTo;
  Profile? createdBy;
  String? createdOn;
  bool? isActive;
  List<Team>? teams;
  String? createdOnText;
  List<Profile>? teamAndAssignedUsers;
  List<Profile>? assignedUsersNotInTeams;

  Contact(
      {this.id,
      this.salutation,
      this.firstName,
      this.lastName,
      this.primaryMobile,
      this.secondaryMobile,
      this.primaryEmail,
      this.secondaryEmail,
      this.dateOfBirth,
      this.linkedInUrl,
      this.facebookUrl,
      this.twitterUserName,
      this.organization,
      this.department,
      this.doNotCall,
      this.title,
      this.address,
      this.description,
      this.assignedTo,
      this.createdBy,
      this.createdOn,
      this.isActive,
      this.teams,
      this.createdOnText,
      this.teamAndAssignedUsers,
      this.assignedUsersNotInTeams});

  Contact.fromJson(Map contact) {
    Map address = {
      "address_line": "",
      "street": "",
      "city": "",
      "state": "",
      "postcode": "",
      "country": ""
    };

    address['address_line'] =
        contact['address'] != null && contact['address']['address_line'] != null
            ? contact['address']['address_line']
            : "";
    address['street'] =
        contact['address'] != null && contact['address']['street'] != null
            ? ", " + contact['address']['street']
            : "";
    address['city'] =
        contact['address'] != null && contact['address']['city'] != null
            ? ", " + contact['address']['city']
            : "";
    address['state'] =
        contact['address'] != null && contact['address']['state'] != null
            ? ", " + contact['address']['state']
            : "";
    address['postcode'] =
        contact['address'] != null && contact['address']['postcode'] != null
            ? ", " + contact['address']['postcode'].toString()
            : "";
    address['country'] =
        contact['address'] != null && contact['address']['country'] != null
            ? ", " + contact['address']['country']
            : "";

    this.id = contact['id'] != null ? contact['id'] : 0;
    this.salutation =
        contact['salutation'] != null ? contact['salutation'] : '';
    this.firstName = contact['first_name'] != null ? contact['first_name'] : '';
    this.lastName = contact['last_name'] != null ? contact['last_name'] : '';
    this.primaryEmail =
        contact['primary_email'] != null ? contact['primary_email'] : "";
    this.secondaryEmail =
        contact['secondary_email'] != null ? contact['secondary_email'] : "";
    this.primaryMobile =
        contact['mobile_number'] != null ? contact['mobile_number'] : "";
    this.secondaryEmail =
        contact['secondary_number'] != null ? contact['secondary_number'] : "";
    this.linkedInUrl =
        contact['linked_in_url'] != null ? contact['linked_in_url'] : "";
    this.facebookUrl =
        contact['facebook_url'] != null ? contact['facebook_url'] : "";
    this.twitterUserName =
        contact['twitter_username'] != null ? contact['twitter_username'] : "";
    this.dateOfBirth =
        contact['date_of_birth'] != null ? contact['date_of_birth'] : "";
    this.organization =
        contact['organization'] != null ? contact['organization'] : "";
    this.department =
        contact['department'] != null ? contact['department'] : "";
    this.doNotCall =
        contact['do_not_call'] != null ? contact['do_not_call'] : "";
    this.title = contact['title'] != null ? contact['title'] : "";
    this.address = address;
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
    this.teamAndAssignedUsers = contact['get_team_and_assigned_users'] != null
        ? List<Profile>.from(contact['get_team_and_assigned_users']
            .map((x) => Profile.fromJson(x)))
        : [];
    this.assignedUsersNotInTeams =
        contact['get_assigned_users_not_in_teams'] != null
            ? List<Profile>.from(contact['get_assigned_users_not_in_teams']
                .map((x) => Profile.fromJson(x)))
            : [];
  }

  toJson() {
    return {
      'salutation': salutation,
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'primary_email': primaryEmail,
      'secondary_email': secondaryEmail,
      'mobile_number': primaryMobile,
      'secondary_number': secondaryMobile,
      'linked_in_url': linkedInUrl,
      'facebook_url': facebookUrl,
      'twitter_username': twitterUserName,
      'organization': organization,
      'department': department,
      'date_of_birth': dateOfBirth,
      'do_not_call': doNotCall,
      'title ': title,
      'address': address,
      'description': description,
      'assigned_to': assignedTo,
      'created_by': createdBy,
      'created_on': createdOn,
      'created_on_arrow': createdOnText,
      'is_active': isActive,
      'teams': teams,
      'get_team_and_assigned_users': teamAndAssignedUsers,
      'get_assigned_users_not_in_teams': assignedUsersNotInTeams
    };
  }
}
