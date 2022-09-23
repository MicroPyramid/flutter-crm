import 'package:bottle_crm/model/company.dart';
import 'package:bottle_crm/model/profile.dart';
import 'package:bottle_crm/model/team.dart';

class Document {
  int? id;
  String? title;
  String? documentFile;
  String? status;
  List<Profile>? sharedTo;
  List<Team>? teams;
  String? createdOn;
  Profile? createdBy;
  Company? company;

  Document(
      {this.id,
      this.title,
      this.documentFile,
      this.status,
      this.sharedTo,
      this.teams,
      this.createdOn,
      this.createdBy,
      this.company});

  Document.fromJson(Map document) {
    this.id = document['id'] != null ? document['id'] : 0;
    this.title = document['title'] != null ? document['title'] : "";
    this.documentFile =
        document['document_file'] != null ? document['document_file'] : "";
    this.status = document['status'] != null ? document['status'] : "";
    this.sharedTo = document['shared_to'] != null
        ? List<Profile>.from(
            document['shared_to'].map((contact) => Profile.fromJson(contact)))
        : [];
    this.teams = document["teams"] != null
        ? List<Team>.from(document["teams"].map((team) => Team.fromJson(team)))
        : [];
    this.createdOn = document['created_on'] != null
        ? document['created_on']
        // ? DateFormat("dd MMM, yyyy 'at' HH:mm")
        //     .format(DateFormat("yyyy-MM-dd").parse(document['created_on']))
        : "";
    this.createdBy = document['created_by'] != null
        ? Profile.fromJson(document['created_by'])
        : Profile();
    this.company = document['company'] != null
        ? Company.fromJson(document['company'])
        : Company();
  }

  toJson() {
    return {
      "id": id,
      "title": title,
      "document_file": documentFile,
      "status": status,
      "shared_to": sharedTo,
      "teams": teams,
      "created_on": createdOn,
      "created_by": createdBy,
      "company": company
    };
  }
}
