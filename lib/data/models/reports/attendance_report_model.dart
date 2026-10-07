class AttendanceReportModel {
  final int? id;
  final String? date;
  final String? employeeId;
  final String? employeeCode;
  final String? employeeName;
  final String? checkIn;
  final String? checkOut;
  final int? workingMinutes;
  final dynamic lateMinutes;
  final String? status;
  final String? workingMode;
  final String? totalHours;
  final String? productiveHours;
  final String? overtimeHours;

  AttendanceReportModel({
    this.id,
    this.date,
    this.employeeId,
    this.employeeCode,
    this.employeeName,
    this.checkIn,
    this.checkOut,
    this.workingMinutes,
    this.lateMinutes,
    this.status,
    this.workingMode,
    this.totalHours,
    this.productiveHours,
    this.overtimeHours,
  });

  factory AttendanceReportModel.fromJson(Map<String, dynamic> json) {
    return AttendanceReportModel(
      id: json['id'],
      date: json['date']?.toString(),
      employeeId: json['employee_id']?.toString(),
      employeeCode: json['employee_code']?.toString(),
      employeeName: json['employee_name']?.toString(),
      checkIn: json['check_in']?.toString(),
      checkOut: json['check_out']?.toString(),
      workingMinutes: json['working_minutes'],
      lateMinutes: json['late_minutes'],
      status: json['status']?.toString(),
      workingMode: json['working_mode']?.toString(),
      totalHours: json['total_hours']?.toString(),
      productiveHours: json['productive_hours']?.toString(),
      overtimeHours: json['overtime_hours']?.toString(),
    );
  }
}

class AttendanceReportSummary {
  final int? totalRecords;
  final int? present;
  final int? lateRecords;
  final int? missedPunch;
  final String? totalHours;
  final String? productiveHours;
  final String? overtimeHours;

  AttendanceReportSummary({
    this.totalRecords,
    this.present,
    this.lateRecords,
    this.missedPunch,
    this.totalHours,
    this.productiveHours,
    this.overtimeHours,
  });

  factory AttendanceReportSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceReportSummary(
      totalRecords: json['total_records'],
      present: json['present'],
      lateRecords: json['late_records'],
      missedPunch: json['missed_punch'],
      totalHours: json['total_hours'],
      productiveHours: json['productive_hours'],
      overtimeHours: json['overtime_hours'],
    );
  }
}
