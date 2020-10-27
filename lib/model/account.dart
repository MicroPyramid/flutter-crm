class Account {
  String id;
  String companyId;
  String email;
  String userName;
  String firstName;
  String lastName;
  String profileUrl;
  String role;
  bool isActive;
  bool isAdmin;
  bool isStaff;
  bool hasSalesAccess;
  bool hasMarketingAccess;
  String dateOfJoin;
  String appName;

  Account(
      {this.id,
      this.companyId,
      this.email,
      this.userName,
      this.firstName,
      this.lastName,
      this.profileUrl,
      this.role,
      this.appName,
      this.dateOfJoin,
      this.hasMarketingAccess,
      this.hasSalesAccess,
      this.isActive,
      this.isAdmin,
      this.isStaff});

  Account.fromJson(Map account) {
    this.id = account['id'].toString();
    this.userName = account['username'];
    this.appName = account['get_app_name'];
    this.companyId = account['company'].toString();
    this.role = account['role'] != null ? account['role'] : "";
    this.profileUrl =
        account['profile_pic'] != null ? account['profile_pic'] : "";
    this.dateOfJoin =
        account['date_joined'] != null ? account['date_joined'] : "";
    this.email = account['email'] != null ? account['email'] : "";
    this.firstName = account['first_name'] != null ? account['first_name'] : "";
    this.hasMarketingAccess = account['has_marketing_access'];
    this.hasSalesAccess = account['has_sales_access'];
    this.isActive = account['is_active'];
    this.isAdmin = account['is_admin'];
    this.isStaff = account['is_staff'];
    this.lastName = account['last_name'] != null ? account['last_name'] : "";
  }

  toJson() {
    return {
      'id': id,
      'username': userName,
      'get_app_name': appName,
      'company': companyId,
      'role': role,
      'profile_pic': profileUrl,
      'date_joined': dateOfJoin,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'has_marketing_access': hasMarketingAccess,
      'has_sales_access': hasSalesAccess,
      'is_active': isActive,
      'is_admin': isAdmin,
      'is_staff': isStaff
    };
  }
}
