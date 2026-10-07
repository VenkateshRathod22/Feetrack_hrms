class DocumentModel {
  final int? id;
  final String? partnerId;
  final String? employeeId;
  final String? createdBy;
  final String? documentCategory;
  final String? documentType;
  final String? title;
  final String? documentNumber;
  final String? filePath;
  final String? issueDate;
  final String? expiryDate;
  final String? status;
  final String? remarks;
  final String? createdAt;
  final String? updatedAt;
  final String? fileUrl;
  final String? employeeName;
  final String? employeeCode;

  DocumentModel({
    this.id,
    this.partnerId,
    this.employeeId,
    this.createdBy,
    this.documentCategory,
    this.documentType,
    this.title,
    this.documentNumber,
    this.filePath,
    this.issueDate,
    this.expiryDate,
    this.status,
    this.remarks,
    this.createdAt,
    this.updatedAt,
    this.fileUrl,
    this.employeeName,
    this.employeeCode,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
        id: json["id"],
        partnerId: json["partner_id"],
        employeeId: json["employee_id"],
        createdBy: json["created_by"],
        documentCategory: json["document_category"],
        documentType: json["document_type"],
        title: json["title"],
        documentNumber: json["document_number"],
        filePath: json["file_path"],
        issueDate: json["issue_date"],
        expiryDate: json["expiry_date"],
        status: json["status"],
        remarks: json["remarks"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        fileUrl: json["file_url"],
        employeeName: json["employee"]?["name"],
        employeeCode: json["employee"]?["employee_code"],
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "document_category": documentCategory,
        "document_type": documentType,
        "title": title,
        "document_number": documentNumber,
        "issue_date": issueDate,
        "expiry_date": expiryDate,
        "status": status,
        "remarks": remarks,
      };
}

typedef DocumentReportModel = DocumentModel;

class DocumentReportSummary {
  final int? totalRecords;
  final Map<String, dynamic>? statusCounts;
  final Map<String, dynamic>? categoryCounts;
  final int? expiringSoon;

  DocumentReportSummary({
    this.totalRecords,
    this.statusCounts,
    this.categoryCounts,
    this.expiringSoon,
  });

  factory DocumentReportSummary.fromJson(Map<String, dynamic> json) => DocumentReportSummary(
        totalRecords: json["total_records"],
        statusCounts: json["status_counts"],
        categoryCounts: json["category_counts"],
        expiringSoon: json["expiring_soon"],
      );
}
