class User {
  int? id;
  String? firstName;
  String? lastName;
  String? role;
  String? email;
  String? alternateEmail;
  String? phone;
  String? alternatePhone;
  String? skypeID;
  String? profilePic;
  bool? hasSalesAccess;
  bool? hasMarktingAccess;
  String? isMarketingAdmin;
  bool? isActive;
  String? status;
  String? adressLine;
  String? street;
  String? city;
  String? state;
  String? pincode;
  String? country;
  String? description;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.role,
    this.phone,
    this.alternatePhone,
    this.email,
    this.alternateEmail,
    this.skypeID,
    this.profilePic,
    this.hasSalesAccess,
    this.hasMarktingAccess,
    this.isMarketingAdmin,
    this.isActive,
    this.status,
    this.adressLine,
    this.street,
    this.city,
    this.state,
    this.pincode,
    this.country,
    this.description,
  });

  User.fromJson(Map user) {
    this.id = user['id'] != null ? user['id'] : 0;
    this.firstName = user['user_details']['first_name'] != null
        ? user['user_details']['first_name']
        : "";
    this.lastName = user['user_details']['last_name'] != null
        ? user['user_details']['last_name']
        : "";
    this.role = user['role'] != null ? user['role'] : "";
    this.email = user['user_details']['email'] != null
        ? user['user_details']['email']
        : "";
    this.alternateEmail = user['user_details']['alternate_email'] != null
        ? user['user_details']['alternate_email']
        : "";
    this.phone = user['phone'] != null ? user['phone'] : "";
    this.alternatePhone =
        user['alternate_phone'] != null ? user['alternate_phone'] : "";
    this.skypeID = user['user_details']['skype_ID'] != null
        ? user['user_details']['skype_ID']
        : "";
    this.profilePic = user['user_details']['profile_pic '] != null
        ? user['user_details']['profile_pic ']
        : "";
    this.hasSalesAccess =
        user['has_sales_access'] != null ? user['has_sales_access'] : "";
    this.hasMarktingAccess = user['has_marketing_access'] != null
        ? user['has_marketing_access']
        : "";
    this.isMarketingAdmin = user['is_organization_admin'] != null
        ? user['is_organization_admin']
        : "";
    this.description = user['user_details']['description'] != null
        ? user['user_details']['description']
        : "";
    this.isActive = user['is_active'] != null ? user['is_active'] : false;    
    this.status = user['status'] != null ? user['status'] : "";
    this.adressLine = user['address_line'] != null ? user['address_line'] : "";
    this.street = user['street'] != null ? user['street'] : "";
    this.city = user['city'] != null ? user['city'] : "";
    this.state = user['state'] != null ? user['state'] : "";
    this.pincode = user['pincode'] != null ? user['pincode'] : "";
    this.country = user['country'] != null ? user['country'] : "";
  }

  toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'email': email,
      'alternate_email': alternateEmail,
      'phone': phone,
      'alternate_phone': alternatePhone,
      'profile_pic': profilePic,
      'skype_ID': skypeID,
      'has_sales_access ': hasSalesAccess,
      'has_marketing_access': hasMarktingAccess,
      'is_organization_admin': isMarketingAdmin,
      'is_active':isActive,
      'status':status,
      'description': description,
      'address_line': adressLine,
      'street': street,
      'state': state,
      'city': city,
      'pincode': pincode,
      'country': country,
    };
  }
}
