class ProbationModel {
  final int? id;
  final String? partnerId;
  final String? employeeId;
  final String? createdBy;
  final String? startDate;
  final String? confirmationDueDate;
  final String? extendedDueDate;
  final bool? isExtended;
  final String? extensionReason;
  final String? assetAllocation;
  final String? status;
  final String? confirmationDate;
  final String? evaluationNotes;
  final String? createdAt;
  final String? updatedAt;
  final String? employeeName;
  final String? employeeCode;

  ProbationModel({
    this.id,
    this.partnerId,
    this.employeeId,
    this.createdBy,
    this.startDate,
    this.confirmationDueDate,
    this.extendedDueDate,
    this.isExtended,
    this.extensionReason,
    this.assetAllocation,
    this.status,
    this.confirmationDate,
    this.evaluationNotes,
    this.createdAt,
    this.updatedAt,
    this.employeeName,
    this.employeeCode,
  });

  factory ProbationModel.fromJson(Map<String, dynamic> json) => ProbationModel(
        id: json["id"],
        partnerId: json["partner_id"],
        employeeId: json["employee_id"],
        createdBy: json["created_by"],
        startDate: json["start_date"],
        confirmationDueDate: json["confirmation_due_date"],
        extendedDueDate: json["extended_due_date"],
        isExtended: json["is_extended"],
        extensionReason: json["extension_reason"],
        assetAllocation: json["asset_allocation"],
        status: json["status"],
        confirmationDate: json["confirmation_date"],
        evaluationNotes: json["evaluation_notes"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        employeeName: json["employee_name"] ?? (json["employee"] != null ? json["employee"]["name"] : null),
        employeeCode: json["employee_code"] ?? (json["employee"] != null ? json["employee"]["employee_code"] : null),
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "start_date": startDate,
        "confirmation_due_date": confirmationDueDate,
        "asset_allocation": assetAllocation,
        "status": status,
        if (extendedDueDate != null) "extended_due_date": extendedDueDate,
        if (isExtended != null) "is_extended": isExtended,
        if (extensionReason != null) "extension_reason": extensionReason,
        if (confirmationDate != null) "confirmation_date": confirmationDate,
        if (evaluationNotes != null) "evaluation_notes": evaluationNotes,
      };
}

typedef ProbationReportModel = ProbationModel;

class ProbationReportSummary {
  final int? totalRecords;
  final Map<String, dynamic>? statusCounts;
  final int? isExtendedCount;

  ProbationReportSummary({this.totalRecords, this.statusCounts, this.isExtendedCount});

  factory ProbationReportSummary.fromJson(Map<String, dynamic> json) => ProbationReportSummary(
        totalRecords: json["total_records"],
        statusCounts: json["status_counts"],
        isExtendedCount: json["is_extended"],
      );
}
