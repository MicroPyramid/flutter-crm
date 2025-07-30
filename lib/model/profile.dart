class Profile {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? profileUrl;
  String? role;
  bool? isActive;
  bool? isAdmin;
  bool? isStaff;
  bool? hasSalesAccess;
  bool? hasMarketingAccess;
  String? dateOfJoin;

  Profile(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.profileUrl,
      this.role,
      this.dateOfJoin,
      this.hasMarketingAccess,
      this.hasSalesAccess,
      this.isActive,
      this.isAdmin,
      this.isStaff});

  Profile.fromJson(Map profile) {
    // Handle both old format (with user_details) and new format (flat structure)
    if (profile['user_details'] != null) {
      // Old format
      this.id = profile['user_details']['id'] != null
          ? profile['user_details']['id']
          : 0;
      this.email = profile['user_details']['email'] != null
          ? profile['user_details']['email']
          : "";
      this.firstName = profile['user_details']['first_name'] != null
          ? profile['user_details']['first_name']
          : "";
      this.lastName = profile['user_details']['last_name'] != null
          ? profile['user_details']['last_name']
          : "";
      this.profileUrl = profile['user_details']['profile_pic'] != null
          ? profile['user_details']['profile_pic']
          : "";
    } else {
      // New format (flat structure from Google login)
      this.id = profile['id'] != null ? profile['id'].hashCode : 0;
      this.email = profile['email'] != null ? profile['email'] : "";
      
      // Parse name into firstName and lastName
      if (profile['name'] != null) {
        List<String> nameParts = profile['name'].toString().split(' ');
        this.firstName = nameParts.isNotEmpty ? nameParts.first : "";
        this.lastName = nameParts.length > 1 ? nameParts.skip(1).join(' ') : "";
      } else {
        this.firstName = "";
        this.lastName = "";
      }
      
      this.profileUrl = profile['profileImage'] != null
          ? profile['profileImage']
          : "";
    }

    // Common fields
    this.role = profile['role'] != null ? profile['role'] : "";
    this.dateOfJoin = profile['date_of_joining'] != null ? profile['date_of_joining'] : "";
    this.hasMarketingAccess = profile['has_marketing_access'] != null
        ? profile['has_marketing_access']
        : false;
    this.hasSalesAccess = profile['has_sales_access'] != null
        ? profile['has_sales_access']
        : false;
    this.isActive = profile['is_active'] != null ? profile['is_active'] : false;
    this.isAdmin = profile['is_admin'] != null ? profile['is_admin'] : false;
    this.isStaff = profile['is_staff'] != null ? profile['is_staff'] : false;
  }

  toJson() {
    return {
      'id': id,
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
