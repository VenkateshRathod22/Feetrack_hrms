class TaskReportModel {
  final int? id;
  final String? title;
  final String? employeeId;
  final String? employeeCode;
  final String? employeeName;
  final dynamic priority;
  final String? description;
  final String? dueDate;
  final String? status;
  final String? createdAt;

  TaskReportModel({
    this.id,
    this.title,
    this.employeeId,
    this.employeeCode,
    this.employeeName,
    this.priority,
    this.description,
    this.dueDate,
    this.status,
    this.createdAt,
  });

  factory TaskReportModel.fromJson(Map<String, dynamic> json) {
    return TaskReportModel(
      id: json['id'],
      title: json['title']?.toString(),
      employeeId: json['employee_id']?.toString(),
      employeeCode: json['employee_code']?.toString(),
      employeeName: json['employee_name']?.toString(),
      priority: json['priority'],
      description: json['description']?.toString(),
      dueDate: json['due_date']?.toString(),
      status: json['status']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class TaskReportSummary {
  final int? totalTasks;
  final Map<String, int>? statusCounts;

  TaskReportSummary({
    this.totalTasks,
    this.statusCounts,
  });

  factory TaskReportSummary.fromJson(Map<String, dynamic> json) {
    return TaskReportSummary(
      totalTasks: json['total_tasks'],
      statusCounts: json['status_counts'] != null 
          ? Map<String, int>.from(json['status_counts'])
          : null,
    );
  }
}
