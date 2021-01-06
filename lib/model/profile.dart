class Profile {
  int id;
  int companyId;
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

  Profile(
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

  Profile.fromJson(Map profile) {
    this.id = profile['id'] != null ? profile['id'] : 0;
    this.userName = profile['username'] != null ? profile['username'] : "";
    this.appName =
        profile['get_app_name'] != null ? profile['get_app_name'] : "";
    this.companyId = profile['company'] != null ? profile['company'] : 0;
    this.role = profile['role'] != null ? profile['role'] : "";
    this.profileUrl =
        profile['profile_pic'] != null ? profile['profile_pic'] : "";
    this.dateOfJoin =
        profile['date_joined'] != null ? profile['date_joined'] : "";
    this.email = profile['email'] != null ? profile['email'] : "";
    this.firstName = profile['first_name'] != null ? profile['first_name'] : "";
    this.hasMarketingAccess = profile['has_marketing_access'] != null
        ? profile['has_marketing_access']
        : false;
    this.hasSalesAccess = profile['has_sales_access'] != null
        ? profile['has_sales_access']
        : false;
    this.isActive = profile['is_active'] != null ? profile['is_active'] : false;
    this.isAdmin = profile['is_admin'] != null ? profile['is_admin'] : false;
    this.isStaff = profile['is_staff'] != null ? profile['is_staff'] : false;
    this.lastName = profile['last_name'] != null ? profile['last_name'] : "";
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
