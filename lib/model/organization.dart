class Organization {
  String? id;
  String? name;
  String? role;

  Organization({this.id, this.name, this.role});

  Organization.fromJson(Map data) {
    this.id = data['id'] != null ? data['id'].toString() : "";
    this.name = data['name'] != null ? data['name'] : "";
    this.role = data['role'] != null ? data['role'] : "";
  }

  toJson() {
    return {'id': id, 'name': name, 'role': role};
  }
}
