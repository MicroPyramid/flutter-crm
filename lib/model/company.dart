class Company {
  int? id;
  String? name;
  dynamic address;
  String? subDomain;
  int? userLimit;
  String? country;

  Company(
      {this.id,
      this.name,
      this.address,
      this.subDomain,
      this.userLimit,
      this.country});

  Company.fromJson(Map company) {
    this.id = company['id'] != null ? company['id'] : 0;
    this.name = company['name'] != null ? company['name'] : '';
    this.address = company['address']  != null ? company['address'] : '';
    this.subDomain = company['sub_domain'] != null ? company['sub_domain'] : "";
    this.userLimit = company['user_limit'] != null ? company['user_limit'] : 0;
    this.country = company['country']  != null ? company['country'] : '';
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'sub_domain': subDomain,
      'user_limit': userLimit,
      'country': country
    };
  }
}
