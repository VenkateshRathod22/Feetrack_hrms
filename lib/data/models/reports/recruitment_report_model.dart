class RecruitmentModel {
  final int? id;
  final String? partnerId;
  final String? createdBy;
  final int? departmentId;
  final String? employeeId;
  final String? jobTitle;
  final int? vacanciesCount;
  final String? candidateName;
  final String? candidateEmail;
  final String? candidatePhone;
  final String? interviewStage;
  final String? status;
  final String? offerStatus;
  final String? joiningStatus;
  final String? costPerHire;
  final String? interviewDate;
  final String? remarks;
  final String? createdAt;
  final String? updatedAt;
  final String? departmentName;
  final String? employeeName;

  RecruitmentModel({
    this.id,
    this.partnerId,
    this.createdBy,
    this.departmentId,
    this.employeeId,
    this.jobTitle,
    this.vacanciesCount,
    this.candidateName,
    this.candidateEmail,
    this.candidatePhone,
    this.interviewStage,
    this.status,
    this.offerStatus,
    this.joiningStatus,
    this.costPerHire,
    this.interviewDate,
    this.remarks,
    this.createdAt,
    this.updatedAt,
    this.departmentName,
    this.employeeName,
  });

  factory RecruitmentModel.fromJson(Map<String, dynamic> json) => RecruitmentModel(
        id: json["id"],
        partnerId: json["partner_id"],
        createdBy: json["created_by"],
        departmentId: json["department_id"],
        employeeId: json["employee_id"],
        jobTitle: json["job_title"],
        vacanciesCount: json["vacancies_count"],
        candidateName: json["candidate_name"],
        candidateEmail: json["candidate_email"],
        candidatePhone: json["candidate_phone"],
        interviewStage: json["interview_stage"],
        status: json["status"],
        offerStatus: json["offer_status"],
        joiningStatus: json["joining_status"],
        costPerHire: json["cost_per_hire"]?.toString(),
        interviewDate: json["interview_date"],
        remarks: json["remarks"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        departmentName: json["department_name"] ?? (json["department"] != null ? json["department"]["name"] : null),
        employeeName: json["employee_name"] ?? (json["employee"] != null ? json["employee"]["name"] : null),
      );

  Map<String, dynamic> toJson() => {
        "job_title": jobTitle,
        "vacancies_count": vacanciesCount,
        "candidate_name": candidateName,
        "candidate_email": candidateEmail,
        "candidate_phone": candidatePhone,
        "employee_id": employeeId,
        "department_id": departmentId,
        "interview_stage": interviewStage,
        "status": status,
        "offer_status": offerStatus,
        "joining_status": joiningStatus,
        "cost_per_hire": costPerHire,
        "interview_date": interviewDate,
        "remarks": remarks,
      };
}

typedef RecruitmentReportModel = RecruitmentModel;

class RecruitmentReportSummary {
  final int? totalCandidates;
  final int? totalVacancies;
  final Map<String, dynamic>? statusCounts;
  final Map<String, dynamic>? offerCounts;
  final Map<String, dynamic>? joiningCounts;

  RecruitmentReportSummary({
    this.totalCandidates,
    this.totalVacancies,
    this.statusCounts,
    this.offerCounts,
    this.joiningCounts,
  });

  factory RecruitmentReportSummary.fromJson(Map<String, dynamic> json) => RecruitmentReportSummary(
        totalCandidates: json["total_candidates"],
        totalVacancies: json["total_vacancies"],
        statusCounts: json["status_counts"],
        offerCounts: json["offer_counts"],
        joiningCounts: json["joining_counts"],
      );
}
