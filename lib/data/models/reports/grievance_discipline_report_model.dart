class GrievanceModel {
  final int? id;
  final String? partnerId;
  final String? employeeId;
  final String? createdBy;
  final String? recordType;
  final String? title;
  final String? description;
  final String? incidentDate;
  final String? actionTaken;
  final String? resolutionNotes;
  final String? status;
  final String? filePath;
  final String? fileUrl;
  final String? createdAt;
  final String? updatedAt;
  final String? employeeName;
  final String? employeeCode;

  GrievanceModel({
    this.id,
    this.partnerId,
    this.employeeId,
    this.createdBy,
    this.recordType,
    this.title,
    this.description,
    this.incidentDate,
    this.actionTaken,
    this.resolutionNotes,
    this.status,
    this.filePath,
    this.fileUrl,
    this.createdAt,
    this.updatedAt,
    this.employeeName,
    this.employeeCode,
  });

  factory GrievanceModel.fromJson(Map<String, dynamic> json) => GrievanceModel(
        id: json["id"],
        partnerId: json["partner_id"],
        employeeId: json["employee_id"],
        createdBy: json["created_by"],
        recordType: json["record_type"],
        title: json["title"],
        description: json["description"],
        incidentDate: json["incident_date"],
        actionTaken: json["action_taken"],
        resolutionNotes: json["resolution_notes"],
        status: json["status"],
        filePath: json["file_path"],
        fileUrl: json["file_url"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        employeeName: json["employee"]?["name"],
        employeeCode: json["employee"]?["employee_code"],
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "record_type": recordType,
        "title": title,
        "description": description,
        "incident_date": incidentDate,
        "action_taken": actionTaken,
        "resolution_notes": resolutionNotes,
        "status": status,
      };
}

typedef GrievanceDisciplineReportModel = GrievanceModel;

class GrievanceDisciplineReportSummary {
  final int? totalRecords;
  final Map<String, dynamic>? statusCounts;
  final Map<String, dynamic>? typeCounts;

  GrievanceDisciplineReportSummary({
    this.totalRecords,
    this.statusCounts,
    this.typeCounts,
  });

  factory GrievanceDisciplineReportSummary.fromJson(Map<String, dynamic> json) => GrievanceDisciplineReportSummary(
        totalRecords: json["total_records"],
        statusCounts: json["status_counts"],
        typeCounts: json["type_counts"],
      );
}
