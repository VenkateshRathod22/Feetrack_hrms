class LeadReportModel {
  final String? id;
  final String? customerName;
  final String? customerMobile;
  final String? assignedToId;
  final String? employeeCode;
  final String? assignedTo;
  final String? status;
  final String? notes;
  final String? createdAt;

  LeadReportModel({
    this.id,
    this.customerName,
    this.customerMobile,
    this.assignedToId,
    this.employeeCode,
    this.assignedTo,
    this.status,
    this.notes,
    this.createdAt,
  });

  factory LeadReportModel.fromJson(Map<String, dynamic> json) {
    return LeadReportModel(
      id: json['id']?.toString(),
      customerName: json['customer_name']?.toString(),
      customerMobile: json['customer_mobile']?.toString(),
      assignedToId: json['assigned_to_id']?.toString(),
      employeeCode: json['employee_code']?.toString(),
      assignedTo: json['assigned_to']?.toString(),
      status: json['status']?.toString(),
      notes: json['notes']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class LeadReportSummary {
  final int? totalLeads;
  final Map<String, int>? statusCounts;

  LeadReportSummary({
    this.totalLeads,
    this.statusCounts,
  });

  factory LeadReportSummary.fromJson(Map<String, dynamic> json) {
    return LeadReportSummary(
      totalLeads: json['total_leads'],
      statusCounts: json['status_counts'] != null 
          ? Map<String, int>.from(json['status_counts'])
          : null,
    );
  }
}
