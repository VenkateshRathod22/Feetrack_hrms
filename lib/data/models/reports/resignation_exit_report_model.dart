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

  factory ResignationExitReportSummary.fromJson(Map<String, dynamic> json) => ResignationExitReportSummary(
        totalRecords: json["total_records"],
        statusCounts: json["status_counts"],
        clearanceCounts: json["clearance_counts"],
        fnfCounts: json["fnf_counts"],
        totalFnfAmount: json["total_fnf_amount"],
      );
}
