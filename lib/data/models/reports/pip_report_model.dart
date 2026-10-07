class PipModel {
  final int? id;
  final String? partnerId;
  final String? employeeId;
  final String? createdBy;
  final String? reason;
  final String? startDate;
  final String? endDate;
  final String? improvementTargets;
  final String? reviewResult;
  final String? status;
  final String? remarks;
  final String? createdAt;
  final String? updatedAt;
  final String? employeeName;
  final String? employeeCode;

  PipModel({
    this.id,
    this.partnerId,
    this.employeeId,
    this.createdBy,
    this.reason,
    this.startDate,
    this.endDate,
    this.improvementTargets,
    this.reviewResult,
    this.status,
    this.remarks,
    this.createdAt,
    this.updatedAt,
    this.employeeName,
    this.employeeCode,
  });

  factory PipModel.fromJson(Map<String, dynamic> json) => PipModel(
        id: json["id"],
        partnerId: json["partner_id"],
        employeeId: json["employee_id"],
        createdBy: json["created_by"],
        reason: json["reason"],
        improvementTargets: json["improvement_targets"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        status: json["status"],
        reviewResult: json["review_result"],
        remarks: json["remarks"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        employeeName: json["employee_name"] ?? (json["employee"] != null ? json["employee"]["name"] : null),
        employeeCode: json["employee_code"] ?? (json["employee"] != null ? json["employee"]["employee_code"] : null),
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "reason": reason,
        "start_date": startDate,
        "end_date": endDate,
        "improvement_targets": improvementTargets,
        "status": status,
        "remarks": remarks,
        if (reviewResult != null) "review_result": reviewResult,
      };
}

typedef PipReportModel = PipModel;

class PipReportSummary {
  final int? totalPips;
  final Map<String, dynamic>? statusCounts;

  PipReportSummary({this.totalPips, this.statusCounts});

  factory PipReportSummary.fromJson(Map<String, dynamic> json) => PipReportSummary(
        totalPips: json["total_pips"],
        statusCounts: json["status_counts"],
      );
}
