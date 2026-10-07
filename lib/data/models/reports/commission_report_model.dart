class CommissionReportModel {
  final int? id;
  final String? employeeId;
  final String? employeeName;
  final String? employeeCode;
  final num? commissionEarned;
  final num? recoveryEarned;
  final num? netPayout;
  final String? status;
  final String? month;
  final String? year;
  final String? createdAt;

  CommissionReportModel({
    this.id,
    this.employeeId,
    this.employeeName,
    this.employeeCode,
    this.commissionEarned,
    this.recoveryEarned,
    this.netPayout,
    this.status,
    this.month,
    this.year,
    this.createdAt,
  });

  factory CommissionReportModel.fromJson(Map<String, dynamic> json) {
    return CommissionReportModel(
      id: json['id'],
      employeeId: json['employee_id']?.toString(),
      employeeName: json['employee_name']?.toString(),
      employeeCode: json['employee_code']?.toString(),
      commissionEarned: json['commission_earned'],
      recoveryEarned: json['recovery_earned'],
      netPayout: json['net_payout'],
      status: json['status']?.toString(),
      month: json['month']?.toString(),
      year: json['year']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class CommissionReportSummary {
  final int? totalRecords;
  final num? totalCommissionEarned;
  final num? totalRecoveryEarned;
  final num? totalNetPayout;
  final Map<String, dynamic>? statusCounts;

  CommissionReportSummary({
    this.totalRecords,
    this.totalCommissionEarned,
    this.totalRecoveryEarned,
    this.totalNetPayout,
    this.statusCounts,
  });

  factory CommissionReportSummary.fromJson(Map<String, dynamic> json) {
    return CommissionReportSummary(
      totalRecords: json['total_records'],
      totalCommissionEarned: json['total_commission_earned'],
      totalRecoveryEarned: json['total_recovery_earned'],
      totalNetPayout: json['total_net_payout'],
      statusCounts: json['status_counts'] is Map ? json['status_counts'] : {},
    );
  }
}
