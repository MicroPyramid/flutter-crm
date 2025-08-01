// Base model classes for API responses

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int statusCode;
  final Map<String, dynamic>? errors;
  final Pagination? pagination;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    required this.statusCode,
    this.errors,
    this.pagination,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'],
      message: json['message'],
      statusCode: json['status_code'] ?? 200,
      errors: json['errors'],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class Pagination {
  final int page;
  final int limit;
  final int total;
  final int? totalPages;
  final bool hasNext;
  final bool hasPrev;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  bool get hasPrevious => hasPrev;
  int get pages => totalPages ?? 1;

  factory Pagination.fromJson(Map<String, dynamic> json) {
    final totalPagesValue = json['totalPages'] ?? json['pages'];
    int? totalPagesInt;
    
    if (totalPagesValue is int) {
      totalPagesInt = totalPagesValue;
    } else if (totalPagesValue is String && int.tryParse(totalPagesValue) != null) {
      totalPagesInt = int.parse(totalPagesValue);
    }
    
    return Pagination(
      page: (json['page'] is int) ? json['page'] : int.tryParse(json['page']?.toString() ?? '1') ?? 1,
      limit: (json['limit'] is int) ? json['limit'] : int.tryParse(json['limit']?.toString() ?? '10') ?? 10,
      total: (json['total'] is int) ? json['total'] : int.tryParse(json['total']?.toString() ?? '0') ?? 0,
      totalPages: totalPagesInt,
      hasNext: json['hasNext'] is bool ? json['hasNext'] : (json['hasNext']?.toString().toLowerCase() == 'true'),
      hasPrev: json['hasPrev'] is bool ? json['hasPrev'] : (json['hasPrev']?.toString().toLowerCase() == 'true'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
      'hasNext': hasNext,
      'hasPrev': hasPrev,
    };
  }
}

// Contact model
class Contact {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? title;
  final String? department;
  final String? street;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;
  final double? latitude;
  final double? longitude;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? ownerId;
  final String organizationId;
  final ContactOwner? owner;
  final ContactOrganization? organization;
  final List<RelatedAccount>? relatedAccounts;

  Contact({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.title,
    this.department,
    this.street,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.latitude,
    this.longitude,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.ownerId,
    required this.organizationId,
    this.owner,
    this.organization,
    this.relatedAccounts,
  });

  String get fullName => '$firstName $lastName';

  String get fullAddress {
    final parts = [
      street,
      city,
      state,
      postalCode,
      country,
    ].where((part) => part != null && part.isNotEmpty).toList();
    return parts.join(', ');
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'],
      phone: json['phone'],
      title: json['title'],
      department: json['department'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
      country: json['country'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      description: json['description'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      ownerId: json['ownerId'],
      organizationId: json['organizationId'] ?? '',
      owner: json['owner'] != null
          ? ContactOwner.fromJson(json['owner'])
          : null,
      organization: json['organization'] != null
          ? ContactOrganization.fromJson(json['organization'])
          : null,
      relatedAccounts: json['relatedAccounts'] != null
          ? (json['relatedAccounts'] as List<dynamic>)
                .map(
                  (account) =>
                      RelatedAccount.fromJson(account as Map<String, dynamic>),
                )
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'title': title,
      'department': department,
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'ownerId': ownerId,
      'organizationId': organizationId,
      'owner': owner?.toJson(),
      'organization': organization?.toJson(),
      'relatedAccounts': relatedAccounts
          ?.map((account) => account.toJson())
          .toList(),
    };
  }
}

class ContactOwner {
  final String id;
  final String name;
  final String email;

  ContactOwner({required this.id, required this.name, required this.email});

  String get fullName => name;

  factory ContactOwner.fromJson(Map<String, dynamic> json) {
    return ContactOwner(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}

class ContactOrganization {
  final String id;
  final String name;

  ContactOrganization({required this.id, required this.name});

  factory ContactOrganization.fromJson(Map<String, dynamic> json) {
    return ContactOrganization(id: json['id'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class RelatedAccount {
  final String id;
  final String role;
  final bool isPrimary;
  final DateTime startDate;
  final DateTime? endDate;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Account account;

  RelatedAccount({
    required this.id,
    required this.role,
    required this.isPrimary,
    required this.startDate,
    this.endDate,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.account,
  });

  factory RelatedAccount.fromJson(Map<String, dynamic> json) {
    return RelatedAccount(
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
      startDate: DateTime.parse(
        json['startDate'] ?? DateTime.now().toIso8601String(),
      ),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      description: json['description'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      account: Account.fromJson(json['account'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'isPrimary': isPrimary,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'account': account.toJson(),
    };
  }
}

class Account {
  final String id;
  final String name;
  final String type;
  final String? website;
  final String? phone;

  Account({
    required this.id,
    required this.name,
    required this.type,
    this.website,
    this.phone,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      website: json['website'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'website': website,
      'phone': phone,
    };
  }
}

// Contacts response wrapper for API
class ContactsResponse {
  final List<Contact> contacts;
  final Pagination? pagination;

  ContactsResponse({required this.contacts, this.pagination});

  factory ContactsResponse.fromJson(Map<String, dynamic> json) {
    return ContactsResponse(
      contacts:
          (json['contacts'] as List<dynamic>?)
              ?.map(
                (contactJson) =>
                    Contact.fromJson(contactJson as Map<String, dynamic>),
              )
              .toList() ??
          [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

// Lead model
class Lead {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? company;
  final String? title;
  final String status;
  final String leadSource;
  final String? industry;
  final String? rating;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? ownerId;
  final String organizationId;
  final bool isConverted;
  final DateTime? convertedAt;
  final String? convertedAccountId;
  final String? convertedContactId;
  final String? convertedOpportunityId;
  final String? contactId;
  final LeadOwner? owner;

  Lead({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.company,
    this.title,
    required this.status,
    required this.leadSource,
    this.industry,
    this.rating,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.ownerId,
    required this.organizationId,
    required this.isConverted,
    this.convertedAt,
    this.convertedAccountId,
    this.convertedContactId,
    this.convertedOpportunityId,
    this.contactId,
    this.owner,
  });

  String get fullName => '$firstName $lastName';

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'],
      phone: json['phone'],
      company: json['company'],
      title: json['title'],
      status: json['status'] ?? 'NEW',
      leadSource: json['leadSource'] ?? '',
      industry: json['industry'],
      rating: json['rating'],
      description: json['description'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      ownerId: json['ownerId'],
      organizationId: json['organizationId'] ?? '',
      isConverted: json['isConverted'] ?? false,
      convertedAt: json['convertedAt'] != null
          ? DateTime.parse(json['convertedAt'])
          : null,
      convertedAccountId: json['convertedAccountId'],
      convertedContactId: json['convertedContactId'],
      convertedOpportunityId: json['convertedOpportunityId'],
      contactId: json['contactId'],
      owner: json['owner'] != null ? LeadOwner.fromJson(json['owner']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'company': company,
      'title': title,
      'status': status,
      'leadSource': leadSource,
      'industry': industry,
      'rating': rating,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'ownerId': ownerId,
      'organizationId': organizationId,
      'isConverted': isConverted,
      'convertedAt': convertedAt?.toIso8601String(),
      'convertedAccountId': convertedAccountId,
      'convertedContactId': convertedContactId,
      'convertedOpportunityId': convertedOpportunityId,
      'contactId': contactId,
      'owner': owner?.toJson(),
    };
  }
}

class LeadOwner {
  final String id;
  final String name;
  final String email;

  LeadOwner({required this.id, required this.name, required this.email});

  String get fullName => name;

  factory LeadOwner.fromJson(Map<String, dynamic> json) {
    return LeadOwner(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}

// Lead response wrapper for API
class LeadsResponse {
  final List<Lead> leads;
  final Pagination pagination;

  LeadsResponse({required this.leads, required this.pagination});

  factory LeadsResponse.fromJson(Map<String, dynamic> json) {
    return LeadsResponse(
      leads:
          (json['leads'] as List<dynamic>?)
              ?.map(
                (leadJson) => Lead.fromJson(leadJson as Map<String, dynamic>),
              )
              .toList() ??
          [],
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

// Deal model
class Deal {
  final String id;
  final String title;
  final String? description;
  final double value;
  final String currency;
  final DealStage stage;
  final String? contactId;
  final String? companyId;
  final DateTime? expectedCloseDate;
  final double probability;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? customFields;

  Deal({
    required this.id,
    required this.title,
    this.description,
    required this.value,
    required this.currency,
    required this.stage,
    this.contactId,
    this.companyId,
    this.expectedCloseDate,
    required this.probability,
    required this.createdAt,
    required this.updatedAt,
    this.customFields,
  });

  factory Deal.fromJson(Map<String, dynamic> json) {
    return Deal(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      value: (json['value'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      stage: DealStage.fromString(json['stage'] ?? 'prospect'),
      contactId: json['contact_id'],
      companyId: json['company_id'],
      expectedCloseDate: json['expected_close_date'] != null
          ? DateTime.parse(json['expected_close_date'])
          : null,
      probability: (json['probability'] ?? 0).toDouble(),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      customFields: json['custom_fields'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'value': value,
      'currency': currency,
      'stage': stage.value,
      'contact_id': contactId,
      'company_id': companyId,
      'expected_close_date': expectedCloseDate?.toIso8601String(),
      'probability': probability,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'custom_fields': customFields,
    };
  }
}

enum DealStage {
  prospect('prospect'),
  qualified('qualified'),
  proposal('proposal'),
  negotiation('negotiation'),
  closed('closed'),
  won('won'),
  lost('lost');

  const DealStage(this.value);
  final String value;

  static DealStage fromString(String value) {
    return DealStage.values.firstWhere(
      (stage) => stage.value == value,
      orElse: () => DealStage.prospect,
    );
  }
}

// Company model
class Company {
  final String id;
  final String name;
  final String? website;
  final String? industry;
  final String? phone;
  final String? email;
  final Address? address;
  final int? employeeCount;
  final double? revenue;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? customFields;

  Company({
    required this.id,
    required this.name,
    this.website,
    this.industry,
    this.phone,
    this.email,
    this.address,
    this.employeeCount,
    this.revenue,
    required this.createdAt,
    required this.updatedAt,
    this.customFields,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      website: json['website'],
      industry: json['industry'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : null,
      employeeCount: json['employee_count'],
      revenue: json['revenue']?.toDouble(),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      customFields: json['custom_fields'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'website': website,
      'industry': industry,
      'phone': phone,
      'email': email,
      'address': address?.toJson(),
      'employee_count': employeeCount,
      'revenue': revenue,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'custom_fields': customFields,
    };
  }
}

// Address model
class Address {
  final String? street;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;

  Address({this.street, this.city, this.state, this.zipCode, this.country});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zip_code'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'country': country,
    };
  }

  String get fullAddress {
    final parts = [
      street,
      city,
      state,
      zipCode,
      country,
    ].where((part) => part != null && part.isNotEmpty).toList();
    return parts.join(', ');
  }
}

// Activity model
class Activity {
  final String id;
  final String type;
  final String title;
  final String? description;
  final String? contactId;
  final String? dealId;
  final String? companyId;
  final DateTime scheduledAt;
  final DateTime? completedAt;
  final ActivityStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Activity({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    this.contactId,
    this.dealId,
    this.companyId,
    required this.scheduledAt,
    this.completedAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      contactId: json['contact_id'],
      dealId: json['deal_id'],
      companyId: json['company_id'],
      scheduledAt: DateTime.parse(
        json['scheduled_at'] ?? DateTime.now().toIso8601String(),
      ),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      status: ActivityStatus.fromString(json['status'] ?? 'pending'),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'contact_id': contactId,
      'deal_id': dealId,
      'company_id': companyId,
      'scheduled_at': scheduledAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'status': status.value,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

enum ActivityStatus {
  pending('pending'),
  completed('completed'),
  cancelled('cancelled'),
  overdue('overdue');

  const ActivityStatus(this.value);
  final String value;

  static ActivityStatus fromString(String value) {
    return ActivityStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ActivityStatus.pending,
    );
  }
}

// Dashboard metrics model
class DashboardMetrics {
  final int totalLeads;
  final int totalOpportunities;
  final int totalAccounts;
  final int totalContacts;
  final int pendingTasks;
  final double opportunityRevenue;

  DashboardMetrics({
    required this.totalLeads,
    required this.totalOpportunities,
    required this.totalAccounts,
    required this.totalContacts,
    required this.pendingTasks,
    required this.opportunityRevenue,
  });

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    final metrics = json['metrics'] ?? {};
    return DashboardMetrics(
      totalLeads: metrics['totalLeads'] ?? 0,
      totalOpportunities: metrics['totalOpportunities'] ?? 0,
      totalAccounts: metrics['totalAccounts'] ?? 0,
      totalContacts: metrics['totalContacts'] ?? 0,
      pendingTasks: metrics['pendingTasks'] ?? 0,
      opportunityRevenue: (metrics['opportunityRevenue'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metrics': {
        'totalLeads': totalLeads,
        'totalOpportunities': totalOpportunities,
        'totalAccounts': totalAccounts,
        'totalContacts': totalContacts,
        'pendingTasks': pendingTasks,
        'opportunityRevenue': opportunityRevenue,
      },
    };
  }
}

// Task model
class Task {
  final String id;
  final String subject;
  final String? description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
  final String? ownerId;
  final String? createdById;
  final String? accountId;
  final String? contactId;
  final String? leadId;
  final String? opportunityId;
  final String? caseId;
  final String organizationId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TaskOwner? owner;
  final TaskUser? createdBy;
  final TaskAccount? account;
  final TaskContact? contact;
  final TaskLead? lead;
  final TaskOpportunity? opportunity;
  final TaskCase? case_;
  final TaskOrganization? organization;
  final List<TaskComment>? comments;

  Task({
    required this.id,
    required this.subject,
    this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    this.ownerId,
    this.createdById,
    this.accountId,
    this.contactId,
    this.leadId,
    this.opportunityId,
    this.caseId,
    required this.organizationId,
    required this.createdAt,
    required this.updatedAt,
    this.owner,
    this.createdBy,
    this.account,
    this.contact,
    this.lead,
    this.opportunity,
    this.case_,
    this.organization,
    this.comments,
  });

  // Backward compatibility getter
  String get title => subject;

  bool get isOverdue =>
      dueDate != null &&
      dueDate!.isBefore(DateTime.now()) &&
      status != TaskStatus.completed;

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      subject: json['subject'] ?? json['title'] ?? '',
      description: json['description'],
      status: TaskStatus.fromString(json['status'] ?? 'Not Started'),
      priority: TaskPriority.fromString(json['priority'] ?? 'Medium'),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      ownerId: json['ownerId'],
      createdById: json['createdById'],
      accountId: json['accountId'],
      contactId: json['contactId'],
      leadId: json['leadId'],
      opportunityId: json['opportunityId'],
      caseId: json['caseId'],
      organizationId: json['organizationId'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      owner: json['owner'] != null ? TaskOwner.fromJson(json['owner']) : null,
      createdBy: json['createdBy'] != null
          ? TaskUser.fromJson(json['createdBy'])
          : null,
      account: json['account'] != null
          ? TaskAccount.fromJson(json['account'])
          : null,
      contact: json['contact'] != null
          ? TaskContact.fromJson(json['contact'])
          : null,
      lead: json['lead'] != null ? TaskLead.fromJson(json['lead']) : null,
      opportunity: json['opportunity'] != null
          ? TaskOpportunity.fromJson(json['opportunity'])
          : null,
      case_: json['case'] != null ? TaskCase.fromJson(json['case']) : null,
      organization: json['organization'] != null
          ? TaskOrganization.fromJson(json['organization'])
          : null,
      comments: json['comments'] != null
          ? (json['comments'] as List<dynamic>)
                .map(
                  (commentJson) =>
                      TaskComment.fromJson(commentJson as Map<String, dynamic>),
                )
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'description': description,
      'status': status.value,
      'priority': priority.value,
      'dueDate': dueDate?.toIso8601String(),
      'ownerId': ownerId,
      'createdById': createdById,
      'accountId': accountId,
      'contactId': contactId,
      'leadId': leadId,
      'opportunityId': opportunityId,
      'caseId': caseId,
      'organizationId': organizationId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'owner': owner?.toJson(),
      'createdBy': createdBy?.toJson(),
      'account': account?.toJson(),
      'contact': contact?.toJson(),
      'lead': lead?.toJson(),
      'opportunity': opportunity?.toJson(),
      'case': case_?.toJson(),
      'organization': organization?.toJson(),
      'comments': comments?.map((comment) => comment.toJson()).toList(),
    };
  }
}

enum TaskStatus {
  notStarted('Not Started'),
  inProgress('In Progress'),
  completed('Completed'),
  cancelled('Cancelled');

  const TaskStatus(this.value);
  final String value;

  static TaskStatus fromString(String value) {
    return TaskStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TaskStatus.notStarted,
    );
  }

  // Backward compatibility getter
  static TaskStatus get toDo => TaskStatus.notStarted;
}

enum TaskPriority {
  high('High'),
  normal('Normal'),
  low('Low');

  const TaskPriority(this.value);
  final String value;

  static TaskPriority fromString(String value) {
    return TaskPriority.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => TaskPriority.normal,
    );
  }
}

enum LeadStatus {
  newLead('NEW'),
  pending('PENDING'),
  contacted('CONTACTED'),
  qualified('QUALIFIED'),
  unqualified('UNQUALIFIED'),
  converted('CONVERTED');

  const LeadStatus(this.value);
  final String value;

  static LeadStatus fromString(String value) {
    return LeadStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => LeadStatus.newLead,
    );
  }
}

enum LeadSource {
  web('WEB'),
  phoneInquiry('PHONE_INQUIRY'),
  partnerReferral('PARTNER_REFERRAL'),
  coldCall('COLD_CALL'),
  tradeShow('TRADE_SHOW'),
  employeeReferral('EMPLOYEE_REFERRAL'),
  advertisement('ADVERTISEMENT'),
  other('OTHER');

  const LeadSource(this.value);
  final String value;

  static LeadSource fromString(String value) {
    return LeadSource.values.firstWhere(
      (source) => source.value == value,
      orElse: () => LeadSource.web,
    );
  }

  String get displayName {
    switch (this) {
      case LeadSource.phoneInquiry:
        return 'Phone Inquiry';
      case LeadSource.partnerReferral:
        return 'Partner Referral';
      case LeadSource.coldCall:
        return 'Cold Call';
      case LeadSource.tradeShow:
        return 'Trade Show';
      case LeadSource.employeeReferral:
        return 'Employee Referral';
      case LeadSource.advertisement:
        return 'Advertisement';
      case LeadSource.other:
        return 'Other';
      default:
        return value;
    }
  }
}

enum LeadRating {
  hot('Hot'),
  warm('Warm'),
  cold('Cold');

  const LeadRating(this.value);
  final String value;

  static LeadRating fromString(String value) {
    return LeadRating.values.firstWhere(
      (rating) => rating.value == value,
      orElse: () => LeadRating.warm,
    );
  }
}

enum LeadIndustry {
  technology('Technology'),
  healthcare('Healthcare'),
  finance('Finance'),
  education('Education'),
  manufacturing('Manufacturing'),
  retail('Retail'),
  realEstate('Real Estate'),
  consulting('Consulting'),
  media('Media'),
  transportation('Transportation'),
  energy('Energy'),
  government('Government'),
  nonProfit('Non-profit'),
  other('Other');

  const LeadIndustry(this.value);
  final String value;

  static LeadIndustry fromString(String value) {
    return LeadIndustry.values.firstWhere(
      (industry) => industry.value == value,
      orElse: () => LeadIndustry.other,
    );
  }
}

class TaskOwner {
  final String id;
  final String name;
  final String email;

  TaskOwner({required this.id, required this.name, required this.email});

  factory TaskOwner.fromJson(Map<String, dynamic> json) {
    return TaskOwner(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}

class TaskAccount {
  final String id;
  final String name;
  final String? type;
  final String? website;
  final String? phone;

  TaskAccount({
    required this.id,
    required this.name,
    this.type,
    this.website,
    this.phone,
  });

  factory TaskAccount.fromJson(Map<String, dynamic> json) {
    return TaskAccount(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'],
      website: json['website'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'website': website,
      'phone': phone,
    };
  }
}

class TaskContact {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? title;

  TaskContact({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.title,
  });

  String get fullName => '$firstName $lastName';

  factory TaskContact.fromJson(Map<String, dynamic> json) {
    return TaskContact(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'],
      phone: json['phone'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'title': title,
    };
  }
}

class TaskUser {
  final String id;
  final String name;
  final String email;

  TaskUser({required this.id, required this.name, required this.email});

  factory TaskUser.fromJson(Map<String, dynamic> json) {
    return TaskUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}

class TaskLead {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? company;

  TaskLead({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.company,
  });

  String get fullName => '$firstName $lastName';

  factory TaskLead.fromJson(Map<String, dynamic> json) {
    return TaskLead(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'],
      company: json['company'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'company': company,
    };
  }
}

class TaskOpportunity {
  final String id;
  final String name;
  final double amount;
  final String status;
  final String stage;
  final DateTime? closeDate;

  TaskOpportunity({
    required this.id,
    required this.name,
    required this.amount,
    required this.status,
    required this.stage,
    this.closeDate,
  });

  factory TaskOpportunity.fromJson(Map<String, dynamic> json) {
    return TaskOpportunity(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      stage: json['stage'] ?? '',
      closeDate: json['closeDate'] != null
          ? DateTime.parse(json['closeDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'status': status,
      'stage': stage,
      'closeDate': closeDate?.toIso8601String(),
    };
  }
}

class TaskCase {
  final String id;
  final String subject;
  final String status;
  final String priority;

  TaskCase({
    required this.id,
    required this.subject,
    required this.status,
    required this.priority,
  });

  factory TaskCase.fromJson(Map<String, dynamic> json) {
    return TaskCase(
      id: json['id'] ?? '',
      subject: json['subject'] ?? '',
      status: json['status'] ?? '',
      priority: json['priority'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'status': status,
      'priority': priority,
    };
  }
}

class TaskOrganization {
  final String id;
  final String name;

  TaskOrganization({required this.id, required this.name});

  factory TaskOrganization.fromJson(Map<String, dynamic> json) {
    return TaskOrganization(id: json['id'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class TaskComment {
  final String id;
  final String body;
  final bool isPrivate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String authorId;
  final String organizationId;
  final String taskId;
  final TaskUser? author;

  TaskComment({
    required this.id,
    required this.body,
    required this.isPrivate,
    required this.createdAt,
    required this.updatedAt,
    required this.authorId,
    required this.organizationId,
    required this.taskId,
    this.author,
  });

  factory TaskComment.fromJson(Map<String, dynamic> json) {
    return TaskComment(
      id: json['id'] ?? '',
      body: json['body'] ?? '',
      isPrivate: json['isPrivate'] ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      authorId: json['authorId'] ?? '',
      organizationId: json['organizationId'] ?? '',
      taskId: json['taskId'] ?? '',
      author: json['author'] != null ? TaskUser.fromJson(json['author']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'isPrivate': isPrivate,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'authorId': authorId,
      'organizationId': organizationId,
      'taskId': taskId,
      'author': author?.toJson(),
    };
  }
}

// Tasks response wrapper for API
class TasksResponse {
  final List<Task> tasks;
  final Pagination? pagination;

  TasksResponse({required this.tasks, this.pagination});

  factory TasksResponse.fromJson(Map<String, dynamic> json) {
    return TasksResponse(
      tasks:
          (json['tasks'] as List<dynamic>?)
              ?.map(
                (taskJson) => Task.fromJson(taskJson as Map<String, dynamic>),
              )
              .toList() ??
          [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

// Keep the old model for backward compatibility (deprecated)
@Deprecated('Use DashboardMetrics instead')
class DashboardStats {
  final int totalContacts;
  final int totalLeads;
  final int totalDeals;
  final double totalRevenue;
  final int activitiesThisWeek;
  final double conversionRate;
  final Map<String, int> leadsBySource;
  final Map<String, double> dealsByStage;

  DashboardStats({
    required this.totalContacts,
    required this.totalLeads,
    required this.totalDeals,
    required this.totalRevenue,
    required this.activitiesThisWeek,
    required this.conversionRate,
    required this.leadsBySource,
    required this.dealsByStage,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalContacts: json['total_contacts'] ?? 0,
      totalLeads: json['total_leads'] ?? 0,
      totalDeals: json['total_deals'] ?? 0,
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      activitiesThisWeek: json['activities_this_week'] ?? 0,
      conversionRate: (json['conversion_rate'] ?? 0).toDouble(),
      leadsBySource: Map<String, int>.from(json['leads_by_source'] ?? {}),
      dealsByStage: Map<String, double>.from(json['deals_by_stage'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_contacts': totalContacts,
      'total_leads': totalLeads,
      'total_deals': totalDeals,
      'total_revenue': totalRevenue,
      'activities_this_week': activitiesThisWeek,
      'conversion_rate': conversionRate,
      'leads_by_source': leadsBySource,
      'deals_by_stage': dealsByStage,
    };
  }
}
