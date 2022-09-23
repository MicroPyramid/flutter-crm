import 'package:bottle_crm/model/profile.dart';
import 'package:intl/intl.dart';
import 'company.dart';

class Domain {
  int? id;
  String? domain;
  String? createdOn;
  Profile? createdBy;
  Company? company;

  Domain({this.id, this.domain, this.createdOn, this.createdBy, this.company});

  Domain.fromJson(Map domain) {
    this.id = domain['id'] != null ? domain['id'] : 0;
    this.domain = domain['domain'] != null ? domain['domain'] : "";
    this.createdOn = domain['created_on'] != null
        ? DateFormat("dd MMM, yyyy")
            .format(DateFormat("yyyy-MM-dd").parse(domain['created_on']))
        : "";
    this.createdBy = domain['created_by'] != null
        ? Profile.fromJson(domain['created_by'])
        : Profile();
    this.company = domain['company'] != null
        ? Company.fromJson(domain['company'])
        : Company();
  }

  toJson() {
    return {
      "id": id,
      "domain": domain,
      "created_on": createdOn,
      "created_by": createdBy,
      "company": company
    };
  }
}
