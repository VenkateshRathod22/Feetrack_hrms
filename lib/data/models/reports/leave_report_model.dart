class LeaveReportModel {
  final int? id;
  final String? employeeId;
  final String? employeeCode;
  final String? employeeName;
  final dynamic leaveType;
  final String? leaveTypeLabel;
  final String? startDate;
  final String? endDate;
  final String? reason;
  final int? durationDays;
  final String? status;

  LeaveReportModel({
    this.id,
    this.employeeId,
    this.employeeCode,
    this.employeeName,
    this.leaveType,
    this.leaveTypeLabel,
    this.startDate,
    this.endDate,
    this.reason,
    this.durationDays,
    this.status,
  });

  factory LeaveReportModel.fromJson(Map<String, dynamic> json) {
    return LeaveReportModel(
      id: json['id'],
      employeeId: json['employee_id']?.toString(),
      employeeCode: json['employee_code']?.toString(),
      employeeName: json['employee_name']?.toString(),
      leaveType: json['leave_type'],
      leaveTypeLabel: json['leave_type_label']?.toString(),
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      reason: json['reason']?.toString(),
      durationDays: json['duration_days'],
      status: json['status']?.toString(),
    );
  }
}

class LeaveReportSummary {
  final int? totalLeaves;
  final int? approved;
  final int? rejected;
  final int? pending;

  LeaveReportSummary({
    this.totalLeaves,
    this.approved,
    this.rejected,
    this.pending,
  });

  factory LeaveReportSummary.fromJson(Map<String, dynamic> json) {
    return LeaveReportSummary(
      totalLeaves: json['total_leaves'],
      approved: json['approved'],
      rejected: json['rejected'],
      pending: json['pending'],
    );
  }
}
