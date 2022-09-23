class Organization {
  int? id;
  String? name;

  Organization({this.id, this.name});

  Organization.fromJson(Map data) {
    this.id = data['id'] != null ? data['id'] : 0;
    this.name = data['name'] != null ? data['name'] : "";
  }

  toJson() {
    return {'id': id, 'name': name};
  }
}
