import 'package:bottle_crm/model/profile.dart';
import 'package:intl/intl.dart';
import 'company.dart';

class Email {
  int? id;
  String? email;
  String? createdOn;
  Profile? createdBy;
  Company? company;

  Email({this.id, this.email, this.createdOn, this.createdBy, this.company});

  Email.fromJson(Map email) {
    this.id = email['id'] != null ? email['id'] : 0;
    this.email = email['email'] != null ? email['email'] : "";
    this.createdOn = email['created_on'] != null
        ? DateFormat("dd MMM, yyyy")
            .format(DateFormat("yyyy-MM-dd").parse(email['created_on']))
        : "";
    this.createdBy = email['created_by'] != null
        ? Profile.fromJson(email['created_by'])
        : Profile();
    this.company = email['company'] != null
        ? Company.fromJson(email['company'])
        : Company();
  }

  toJson() {
    return {
      "id": id,
      "email": email,
      "created_on": createdOn,
      "created_by": createdBy,
      "company": company
    };
  }
}
