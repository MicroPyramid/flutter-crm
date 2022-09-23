import 'package:bottle_crm/model/lead.dart';
import 'package:bottle_crm/model/organization.dart';
import 'package:bottle_crm/model/profile.dart';
import 'package:intl/intl.dart';

class Settings {
  int? id;
  String? title;
  String? website;
  Profile? createdBy;
  String? createdOn;
  List<Lead>? leadAssignedTo;
  List? tags;
  Organization? org;

  Settings(
      {this.id,
      this.title,
      this.website,
      this.createdBy,
      this.createdOn,
      this.leadAssignedTo,
      this.tags,
      this.org});

  Settings.fromJson(Map settings) {
    this.id = settings['id'] != null ? settings['id'] : 0;
    this.title = settings['title'] != null ? settings['title'] : "";
    this.website = settings['website'] != null ? settings['website'] : "";
    this.createdBy = settings['created_by'] != null
        ? Profile.fromJson(settings['created_by'])
        : Profile();
    this.createdOn = settings['created_on'] != null
        ? DateFormat("dd-MM-yyyy")
            .format(DateFormat("yyyy-MM-dd").parse(settings['created_on']))
        : "";

    this.leadAssignedTo = settings['lead_assigned_to'] != null
        ? List<Lead>.from(
            settings['lead_assigned_to'].map((x) => Lead.fromJson(x)))
        : [];
    this.tags = settings['tags'] != null ? settings['tags'] : [];
    this.org = settings['org'] != null
        ? Organization.fromJson(settings['org'])
        : Organization();
  }

  toJson() {
    return {
      'id': id,
      'title': title,
      'website': website,
      'created_by': createdBy,
      'created_on': createdOn,
      'lead_assigned_to': leadAssignedTo,
      'tags': tags,
      'org': org
    };
  }
}
