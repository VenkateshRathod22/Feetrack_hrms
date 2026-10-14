class ResignationExitReportModel {
  final String? id;
  final String? employeeId;
  final String? employeeCode;
  final String? employeeName;
  final String? resignationDate;
  final String? exitDate;
  final String? lastWorkingDate;
  final String? exitType;
  final String? exitReason;
  final int? noticePeriodDays;
  final String? clearanceStatus;
  final String? fnfStatus;
  final num? fnfAmount;
  final String? fnfSettlementDate;
  final String? status;
  final String? remarks;
  final String? createdBy;

  ResignationExitReportModel({
    this.id,
    this.employeeId,
    this.employeeCode,
    this.employeeName,
    this.resignationDate,
    this.exitDate,
    this.lastWorkingDate,
    this.exitType,
    this.exitReason,
    this.noticePeriodDays,
    this.clearanceStatus,
    this.fnfStatus,
    this.fnfAmount,
    this.fnfSettlementDate,
    this.status,
    this.remarks,
    this.createdBy,
  });

  factory ResignationExitReportModel.fromJson(Map<String, dynamic> json) => ResignationExitReportModel(
        id: json["id"],
        employeeId: json["employee_id"],
        employeeCode: json["employee_code"],
        employeeName: json["employee_name"],
        resignationDate: json["resignation_date"],
        exitDate: json["exit_date"],
        lastWorkingDate: json["last_working_date"],
        exitType: json["exit_type"],
        exitReason: json["exit_reason"],
        noticePeriodDays: json["notice_period_days"],
        clearanceStatus: json["clearance_status"],
        fnfStatus: json["fnf_status"],
        fnfAmount: json["fnf_amount"],
        fnfSettlementDate: json["fnf_settlement_date"],
        status: json["status"],
        remarks: json["remarks"],
        createdBy: json["created_by"],
      );
}


class ResignationExitReportSummary {
  final int? totalRecords;
  final Map<String, dynamic>? statusCounts;
  final Map<String, dynamic>? clearanceCounts;
  final Map<String, dynamic>? fnfCounts;
  final num? totalFnfAmount;

  ResignationExitReportSummary({
    this.totalRecords,
    this.statusCounts,
    this.clearanceCounts,
    this.fnfCounts,
    this.totalFnfAmount,
  });

  factory ResignationExitReportSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    Map<String, dynamic> parseCounts(dynamic value) {
      if (value is Map) {
        return Map<String, dynamic>.from(value);
      }

      // Handle [] or null safely.
      return <String, dynamic>{};
    }

    return ResignationExitReportSummary(
      totalRecords: int.tryParse(
        json['total_records']?.toString() ?? '',
      ),
      statusCounts: parseCounts(json['status_counts']),
      clearanceCounts: parseCounts(json['clearance_counts']),
      fnfCounts: parseCounts(json['fnf_counts']),
      totalFnfAmount: num.tryParse(
        json['total_fnf_amount']?.toString() ?? '',
      ),
    );
  }
}
