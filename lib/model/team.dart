import 'package:flutter_crm/model/company.dart';
import 'package:flutter_crm/model/profile.dart';

class Team {
  int id;
  String name;
  String description;
  List<Profile> users;
  String createdOn;
  Profile createdBy;
  int createdById;
  Company company;
  int companyId;
  String createdOnText;

  Team(
      {this.id,
      this.name,
      this.description,
      this.users,
      this.createdOn,
      this.createdBy,
      this.createdById,
      this.company,
      this.companyId,
      this.createdOnText});

  Team.fromJson(Map account) {
    this.id = account['id'] != null ? account['id'] : 0;
    this.name = account['name'] != null ? account['name'] : "";
    this.description =
        account['description'] != null ? account['description'] : "";
    this.users = account['users'] != null
        ? List<Profile>.from(account['users'].map((x) => Profile.fromJson(x)))
        : [];
    this.createdOn = account['created_on'] != null ? account['created_on'] : "";
    this.createdBy = account['created_by'] != null
        ? Profile.fromJson(account['created_by'])
        : Profile();
    this.createdById =
        account['created_by_id'] != null ? account['created_by_id'] : 0;
    this.company = account['company'] != null
        ? Company.fromJson(account['company'])
        : Company();
    this.companyId = account['company_id'] != null ? account['company_id'] : 0;
    this.createdOnText =
        account['created_on_arrow'] != null ? account['created_on_arrow'] : "";
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'users': users,
      'created_on': createdOn,
      'created_by': createdBy,
      'created_by_id': createdById,
      'company': company,
      'company_id': companyId,
      'created_on_arrow': createdOnText,
    };
  }
}
