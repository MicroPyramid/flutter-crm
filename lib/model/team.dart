import 'package:bottle_crm/model/company.dart';
import 'package:bottle_crm/model/profile.dart';
import 'package:intl/intl.dart';

class Team {
  int? id;
  String? name;
  String? description;
  List<Profile>? users;
  String? createdOn;
  Profile? createdBy;
  int? createdById;
  Company? company;
  int? companyId;
  String? createdOnText;

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

  Team.fromJson(Map team) {
    this.id = team['id'] != null ? team['id'] : 0;
    this.name = team['name'] != null ? team['name'] : "";
    this.description = team['description'] != null ? team['description'] : "";
    this.users = team['users'] != null
        ? List<Profile>.from(team['users'].map((x) => Profile.fromJson(x)))
        : [];
    this.createdOn = team['created_on'] != null
        ? DateFormat("dd-MM-yyyy")
            .format(DateFormat("yyyy-MM-dd").parse(team['created_on']))
        : "";
    this.createdBy = team['created_by'] != null
        ? Profile.fromJson(team['created_by'])
        : Profile();
    this.createdById =
        team['created_by'] != null ? team['created_by']['id'] : 0;
    this.company =
        team['company'] != null ? Company.fromJson(team['company']) : Company();
    this.companyId = team['company'] != null ? team['company']['id'] : 0;
    this.createdOnText =
        team['created_on_arrow'] != null ? team['created_on_arrow'] : "";
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

  void forEach(Null Function(dynamic _user) param0) {}
}
