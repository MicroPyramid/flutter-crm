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

  Profile.fromJson(Map account) {
    this.id = account['id'] != null  ? account['id'] : 0;
    this.userName = account['username'] != null  ?account['username'] : "";
    this.appName = account['get_app_name'] != null  ?account['get_app_name'] : "";
    this.companyId = account['company'] != null  ?account['company'] : 0;
    this.role = account['role'] != null ? account['role'] : "";
    this.profileUrl = account['profile_pic'] != null ? account['profile_pic'] : "";
    this.dateOfJoin = account['date_joined'] != null ? account['date_joined'] : "";
    this.email = account['email'] != null ? account['email'] : "";
    this.firstName = account['first_name'] != null ? account['first_name'] : "";
    this.hasMarketingAccess = account['has_marketing_access'] != null  ?account['has_marketing_access']  : false;
    this.hasSalesAccess = account['has_sales_access'] != null  ? account['has_sales_access']  : false;
    this.isActive = account['is_active'] != null  ? account['is_active'] : false;
    this.isAdmin = account['is_admin'] != null  ? account['is_admin']: false;
    this.isStaff = account['is_staff'] != null  ? account['is_staff']: false ;
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
