class UserModel {
  final String? id;
  final String? employeeCode;
  final String? createdBy;
  final String? parentId;
  final String? departmentId;
  final String? branchId;
  final String? shiftId;
  final String? reportingTo;
  final String? joiningDate;
  final String? resignationDate;
  final String? terminationDate;
  final String? employmentStatus;
  final String? name;
  final String? email;
  final String? mobile;
  final String? role;
  final String? status;
  final String? workingMode;
  final String? employmentType;
  final String? walletBalance;
  final String? basicSalary;
  final DateTime? emailVerifiedAt;
  final DateTime? mobileVerifiedAt;
  final String? profileImage;
  final String? profileImageUrl;
  final String? designationId;
  final String? fcmToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final List<String>? roles;
  final List<String>? permissions;

  const UserModel({
    this.id,
    this.employeeCode,
    this.createdBy,
    this.parentId,
    this.departmentId,
    this.branchId,
    this.shiftId,
    this.reportingTo,
    this.joiningDate,
    this.resignationDate,
    this.terminationDate,
    this.employmentStatus,
    this.name,
    this.email,
    this.mobile,
    this.role,
    this.status,
    this.workingMode,
    this.employmentType,
    this.walletBalance,
    this.basicSalary,
    this.emailVerifiedAt,
    this.mobileVerifiedAt,
    this.profileImage,
    this.profileImageUrl,
    this.designationId,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.roles,
    this.permissions,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      employeeCode: json['employee_code']?.toString(),
      createdBy: json['created_by']?.toString(),
      parentId: json['parent_id']?.toString(),
      departmentId: json['department_id']?.toString(),
      branchId: json['branch_id']?.toString(),
      shiftId: json['shift_id']?.toString(),
      reportingTo: json['reporting_to']?.toString(),
      joiningDate: json['joining_date']?.toString(),
      resignationDate: json['resignation_date']?.toString(),
      terminationDate: json['termination_date']?.toString(),
      employmentStatus: json['employment_status']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      mobile: json['mobile']?.toString(),
      role: json['role']?.toString(),
      status: json['status']?.toString(),
      workingMode: json['working_mode']?.toString(),
      employmentType: json['employment_type']?.toString(),
      walletBalance: json['wallet_balance']?.toString(),
      basicSalary: json['basic_salary']?.toString(),
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.tryParse(json['email_verified_at'].toString())
          : null,
      mobileVerifiedAt: json['mobile_verified_at'] != null
          ? DateTime.tryParse(json['mobile_verified_at'].toString())
          : null,
      profileImage: json['profile_image']?.toString(),
      profileImageUrl: json['profile_image_url']?.toString(),
      designationId: json['designation_id']?.toString(),
      fcmToken: json['fcm_token']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'].toString())
          : null,
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_code': employeeCode,
      'created_by': createdBy,
      'parent_id': parentId,
      'department_id': departmentId,
      'branch_id': branchId,
      'shift_id': shiftId,
      'reporting_to': reportingTo,
      'joining_date': joiningDate,
      'resignation_date': resignationDate,
      'termination_date': terminationDate,
      'employment_status': employmentStatus,
      'name': name,
      'email': email,
      'mobile': mobile,
      'role': role,
      'status': status,
      'working_mode': workingMode,
      'employment_type': employmentType,
      'wallet_balance': walletBalance,
      'basic_salary': basicSalary,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'mobile_verified_at': mobileVerifiedAt?.toIso8601String(),
      'profile_image': profileImage,
      'profile_image_url': profileImageUrl,
      'designation_id': designationId,
      'fcm_token': fcmToken,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'roles': roles,
      'permissions': permissions,
    };
  }

  @override
  String toString() => name ?? "";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
