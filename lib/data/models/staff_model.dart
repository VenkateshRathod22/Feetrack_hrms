import 'dart:convert';

class StaffModel {
  String? id;
  String? employeeCode;
  dynamic createdBy;
  String? parentId;
  dynamic departmentId;
  dynamic branchId;
  dynamic shiftId;
  String? reportingTo;
  String? joiningDate;
  String? resignationDate;
  String? terminationDate;
  String? employmentStatus;
  String? name;
  String? email;
  String? mobile;
  String? role;
  String? status;
  String? workingMode;
  String? employmentType;
  String? walletBalance;
  String? basicSalary;
  DateTime? emailVerifiedAt;
  DateTime? mobileVerifiedAt;
  dynamic profileImage;
  String? fcmToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  dynamic designationId;
  dynamic profileImageUrl;
  List<StaffRole>? roles;
  StaffDepartment? department;
  StaffManager? manager;
  StaffBranch? branch;
  StaffShift? shift;

  StaffModel({
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
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.designationId,
    this.profileImageUrl,
    this.roles,
    this.department,
    this.manager,
    this.branch,
    this.shift,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) => StaffModel(
        id: json["id"]?.toString(),
        employeeCode: json["employee_code"]?.toString(),
        createdBy: json["created_by"],
        parentId: json["parent_id"]?.toString(),
        departmentId: json["department_id"],
        branchId: json["branch_id"],
        shiftId: json["shift_id"],
        reportingTo: json["reporting_to"]?.toString(),
        joiningDate: json["joining_date"]?.toString(),
        resignationDate: json["resignation_date"]?.toString(),
        terminationDate: json["termination_date"]?.toString(),
        employmentStatus: json["employment_status"]?.toString(),
        name: json["name"]?.toString(),
        email: json["email"]?.toString(),
        mobile: json["mobile"]?.toString(),
        role: json["role"]?.toString(),
        status: json["status"]?.toString(),
        workingMode: json["working_mode"]?.toString(),
        employmentType: json["employment_type"]?.toString(),
        walletBalance: json["wallet_balance"]?.toString(),
        basicSalary: json["basic_salary"]?.toString(),
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        mobileVerifiedAt: json["mobile_verified_at"] == null
            ? null
            : DateTime.parse(json["mobile_verified_at"]),
        profileImage: json["profile_image"],
        fcmToken: json["fcm_token"]?.toString(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        designationId: json["designation_id"],
        profileImageUrl: json["profile_image_url"],
        roles: json["roles"] == null
            ? []
            : List<StaffRole>.from(
                json["roles"].map((x) => StaffRole.fromJson(x))),
        department: json["department"] == null
            ? null
            : StaffDepartment.fromJson(json["department"]),
        manager: json["manager"] == null
            ? null
            : StaffManager.fromJson(json["manager"]),
        branch: json["branch"] == null
            ? null
            : StaffBranch.fromJson(json["branch"]),
        shift: json["shift"] == null
            ? null
            : StaffShift.fromJson(json["shift"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_code": employeeCode,
        "created_by": createdBy,
        "parent_id": parentId,
        "department_id": departmentId,
        "branch_id": branchId,
        "shift_id": shiftId,
        "reporting_to": reportingTo,
        "joining_date": joiningDate,
        "resignation_date": resignationDate,
        "termination_date": terminationDate,
        "employment_status": employmentStatus,
        "name": name,
        "email": email,
        "mobile": mobile,
        "role": role,
        "status": status,
        "working_mode": workingMode,
        "employment_type": employmentType,
        "wallet_balance": walletBalance,
        "basic_salary": basicSalary,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "mobile_verified_at": mobileVerifiedAt?.toIso8601String(),
        "profile_image": profileImage,
        "fcm_token": fcmToken,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "designation_id": designationId,
        "profile_image_url": profileImageUrl,
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
        "department": department?.toJson(),
        "manager": manager?.toJson(),
        "branch": branch?.toJson(),
        "shift": shift?.toJson(),
      };
}

class StaffRole {
  int? id;
  String? name;
  String? guardName;
  DateTime? createdAt;
  DateTime? updatedAt;

  StaffRole({
    this.id,
    this.name,
    this.guardName,
    this.createdAt,
    this.updatedAt,
  });

  factory StaffRole.fromJson(Map<String, dynamic> json) => StaffRole(
        id: json["id"],
        name: json["name"],
        guardName: json["guard_name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "guard_name": guardName,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class StaffDepartment {
  int? id;
  String? partnerId;
  dynamic parentId;
  String? name;
  dynamic description;
  DateTime? createdAt;
  DateTime? updatedAt;

  StaffDepartment({
    this.id,
    this.partnerId,
    this.parentId,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory StaffDepartment.fromJson(Map<String, dynamic> json) =>
      StaffDepartment(
        id: json["id"],
        partnerId: json["partner_id"],
        parentId: json["parent_id"],
        name: json["name"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "partner_id": partnerId,
        "parent_id": parentId,
        "name": name,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class StaffManager {
  String? id;
  String? employeeCode;
  dynamic createdBy;
  String? parentId;
  int? departmentId;
  int? branchId;
  int? shiftId;
  dynamic reportingTo;
  String? joiningDate;
  dynamic resignationDate;
  dynamic terminationDate;
  String? employmentStatus;
  String? name;
  String? email;
  String? mobile;
  String? role;
  String? status;
  String? workingMode;
  String? employmentType;
  String? walletBalance;
  String? basicSalary;
  dynamic emailVerifiedAt;
  dynamic mobileVerifiedAt;
  dynamic profileImage;
  String? fcmToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  dynamic designationId;
  dynamic profileImageUrl;

  StaffManager({
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
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.designationId,
    this.profileImageUrl,
  });

  factory StaffManager.fromJson(Map<String, dynamic> json) => StaffManager(
        id: json["id"],
        employeeCode: json["employee_code"],
        createdBy: json["created_by"],
        parentId: json["parent_id"],
        departmentId: json["department_id"],
        branchId: json["branch_id"],
        shiftId: json["shift_id"],
        reportingTo: json["reporting_to"],
        joiningDate: json["joining_date"],
        resignationDate: json["resignation_date"],
        terminationDate: json["termination_date"],
        employmentStatus: json["employment_status"],
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
        role: json["role"],
        status: json["status"],
        workingMode: json["working_mode"],
        walletBalance: json["wallet_balance"],
        basicSalary: json["basic_salary"],
        emailVerifiedAt: json["email_verified_at"],
        mobileVerifiedAt: json["mobile_verified_at"],
        profileImage: json["profile_image"],
        fcmToken: json["fcm_token"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        designationId: json["designation_id"],
        profileImageUrl: json["profile_image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_code": employeeCode,
        "created_by": createdBy,
        "parent_id": parentId,
        "department_id": departmentId,
        "branch_id": branchId,
        "shift_id": shiftId,
        "reporting_to": reportingTo,
        "joining_date": joiningDate,
        "resignation_date": resignationDate,
        "termination_date": terminationDate,
        "employment_status": employmentStatus,
        "name": name,
        "email": email,
        "mobile": mobile,
        "role": role,
        "status": status,
        "working_mode": workingMode,
        "employment_type": employmentType,
        "wallet_balance": walletBalance,
        "basic_salary": basicSalary,
        "email_verified_at": emailVerifiedAt,
        "mobile_verified_at": mobileVerifiedAt,
        "profile_image": profileImage,
        "fcm_token": fcmToken,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "designation_id": designationId,
        "profile_image_url": profileImageUrl,
      };
}

class StaffBranch {
  int? id;
  String? partnerId;
  String? name;
  String? address;
  String? lat;
  String? lng;
  int? radius;
  dynamic managerId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  StaffBranch({
    this.id,
    this.partnerId,
    this.name,
    this.address,
    this.lat,
    this.lng,
    this.radius,
    this.managerId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory StaffBranch.fromJson(Map<String, dynamic> json) => StaffBranch(
        id: json["id"],
        partnerId: json["partner_id"],
        name: json["name"],
        address: json["address"],
        lat: json["lat"],
        lng: json["lng"],
        radius: json["radius"],
        managerId: json["manager_id"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "partner_id": partnerId,
        "name": name,
        "address": address,
        "lat": lat,
        "lng": lng,
        "radius": radius,
        "manager_id": managerId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class StaffShift {
  int? id;
  String? partnerId;
  dynamic branchId;
  String? name;
  String? startTime;
  String? endTime;
  int? autoMarkAttendance;
  String? autoMarkStatus;
  int? lateToleranceMinutes;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? minPresentMins;
  int? minHalfDayMins;
  int? autoAbsentMarkMins;
  String? weekOffDays;

  StaffShift({
    this.id,
    this.partnerId,
    this.branchId,
    this.name,
    this.startTime,
    this.endTime,
    this.autoMarkAttendance,
    this.autoMarkStatus,
    this.lateToleranceMinutes,
    this.createdAt,
    this.updatedAt,
    this.minPresentMins,
    this.minHalfDayMins,
    this.autoAbsentMarkMins,
    this.weekOffDays,
  });

  factory StaffShift.fromJson(Map<String, dynamic> json) => StaffShift(
        id: json["id"],
        partnerId: json["partner_id"],
        branchId: json["branch_id"],
        name: json["name"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        autoMarkAttendance: json["auto_mark_attendance"],
        autoMarkStatus: json["auto_mark_status"],
        lateToleranceMinutes: json["late_tolerance_minutes"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        minPresentMins: json["min_present_mins"],
        minHalfDayMins: json["min_half_day_mins"],
        autoAbsentMarkMins: json["auto_absent_mark_mins"],
        weekOffDays: json["week_off_days"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "partner_id": partnerId,
        "branch_id": branchId,
        "name": name,
        "start_time": startTime,
        "end_time": endTime,
        "auto_mark_attendance": autoMarkAttendance,
        "auto_mark_status": autoMarkStatus,
        "late_tolerance_minutes": lateToleranceMinutes,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "min_present_mins": minPresentMins,
        "min_half_day_mins": minHalfDayMins,
        "auto_absent_mark_mins": autoAbsentMarkMins,
        "week_off_days": weekOffDays,
      };
}
