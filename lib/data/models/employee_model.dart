import 'dart:ui';

import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';

class EmployeesModel {
  final String? id;
  final String? employeeCode;
  final dynamic createdBy;
  final String? parentId;
  final String? departmentId;
  final String? reportingTo;
  final String? name;
  final String? email;
  final String? mobile;
  final String? role;
  final String? status;
  final String? walletBalance;
  final String? basicSalary;
  final dynamic emailVerifiedAt;
  final dynamic mobileVerifiedAt;
  final dynamic profileImage;
  final String? fcmToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final int? attendanceId;
  final String? todayStatus;
  final String? statusReason;
  final String? checkIn;
  final String? checkOut;
  final dynamic profileImageUrl;
  final String? avatarUrl;

  EmployeesModel({
    this.id,
    this.employeeCode,
    this.createdBy,
    this.parentId,
    this.departmentId,
    this.reportingTo,
    this.name,
    this.email,
    this.mobile,
    this.role,
    this.status,
    this.walletBalance,
    this.basicSalary,
    this.emailVerifiedAt,
    this.mobileVerifiedAt,
    this.profileImage,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.attendanceId,
    this.todayStatus,
    this.statusReason,
    this.checkIn,
    this.checkOut,
    this.profileImageUrl,
    this.avatarUrl,
  });

  factory EmployeesModel.fromJson(Map<String, dynamic> json) => EmployeesModel(
        id: json["id"]?.toString(),
        employeeCode: json["employee_code"]?.toString(),
        createdBy: json["created_by"],
        parentId: json["parent_id"]?.toString(),
        departmentId: json["department_id"]?.toString(),
        reportingTo: json["reporting_to"]?.toString(),
        name: json["name"]?.toString(),
        email: json["email"]?.toString(),
        mobile: json["mobile"]?.toString(),
        role: json["role"]?.toString(),
        status: json["status"]?.toString(),
        walletBalance: json["wallet_balance"]?.toString(),
        basicSalary: json["basic_salary"]?.toString(),
        emailVerifiedAt: json["email_verified_at"],
        mobileVerifiedAt: json["mobile_verified_at"],
        profileImage: json["profile_image"],
        fcmToken: json["fcm_token"]?.toString(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"].toString()),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"].toString()),
        deletedAt: json["deleted_at"],
        attendanceId: int.tryParse(json["attendance_id"]?.toString() ?? ""),
        todayStatus: json["today_status"]?.toString(),
        statusReason: json["status_reason"]?.toString(),
        checkIn: json["check_in"]?.toString(),
        checkOut: json["check_out"]?.toString(),
        profileImageUrl: json["profile_image_url"],
        avatarUrl: json["avatar_url"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_code": employeeCode,
        "created_by": createdBy,
        "parent_id": parentId,
        "department_id": departmentId,
        "reporting_to": reportingTo,
        "name": name,
        "email": email,
        "mobile": mobile,
        "role": role,
        "status": status,
        "wallet_balance": walletBalance,
        "basic_salary": basicSalary,
        "email_verified_at": emailVerifiedAt,
        "mobile_verified_at": mobileVerifiedAt,
        "profile_image": profileImage,
        "fcm_token": fcmToken,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "attendance_id": attendanceId,
        "today_status": todayStatus,
        "status_reason": statusReason,
        "check_in": checkIn,
        "check_out": checkOut,
        "profile_image_url": profileImageUrl,
        "avatar_url": avatarUrl,
      };

  bool get isNotPunchIn => todayStatus == "notPunchIn";
  bool get isPunchIn => todayStatus == "punch_in";
  bool get isPunchOut => todayStatus == "punch_out";
  bool get isShortLeave => todayStatus == "short_leave";
  bool get isHalfDay => todayStatus == "half_day";
  bool get isAbsent => todayStatus == "absent";
  bool get isLeave => todayStatus == "leave";
  bool get isHoliday => todayStatus == "holiday";
  bool get isWeekOff => todayStatus == "weekOff";

  Color get statusColor {
    if (isNotPunchIn) return notPunchIn;
    if (isPunchIn) return punchIn;
    if (isPunchOut) return punchOut;
    if (isShortLeave) return shortLeave;
    if (isHalfDay) return halfDay;
    if (isAbsent) return absent;
    if (isLeave) return leave;
    if (isHoliday) return holiday;
    if (isWeekOff) return weekOff;

    return defaultColor;
  }

  String get statusName {
    if (isNotPunchIn) return "Not Check-In";
    if (isPunchIn) return "Working";
    if (isPunchOut) return "Punched Out";
    if (isShortLeave) return "Short Leave";
    if (isHalfDay) return "Half Day";
    if (isAbsent) return "Absent";
    if (isLeave) return "On Leave";
    if (isHoliday) return "Holiday";
    if (isWeekOff) return "Week Off";

    return "Unknown";
  }

  String? get checkInTimeFormat {
    if (checkIn == null || (checkIn?.isEmpty ?? false)) {
      return "-- : --";
    }
    return convertTo12HourFormat(time24: checkIn, isShowAMPM: true);
  }

  String? get checkOutTimeFormat {
    if (checkOut == null || (checkOut?.isEmpty ?? false)) {
      return "-- : --";
    }
    return convertTo12HourFormat(time24: checkOut, isShowAMPM: true);
  }

  @override
  String toString() => name ?? "";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeesModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
