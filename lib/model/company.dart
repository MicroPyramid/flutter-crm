class Company {
  int id;
  String name;
  String address;
  String subDomain;
  int userLimit;
  String country;

  Company(
      {this.id,
      this.name,
      this.address,
      this.subDomain,
      this.userLimit,
      this.country});

  Company.fromJson(Map company) {
    this.id = company['id'];
    this.name = company['name'];
    this.address = company['address'];
    this.subDomain = company['sub_domain'];
    this.userLimit = company['user_limit'];
    this.country = company['country'];
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
