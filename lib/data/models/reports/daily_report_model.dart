import 'package:vlr/data/models/employee_model.dart';

class DailyReportModel {
  int? id;
  String? employeeId;
  String? partnerId;
  String? reportDate;
  String? summary;
  String? status;
  String? managerId;
  String? createdAt;
  String? updatedAt;
  int? itemsCount;
  int? completionPercentage;
  List<DailyReportItemModel>? items;
  EmployeesModel? employee;

  DailyReportModel({
    this.id,
    this.employeeId,
    this.partnerId,
    this.reportDate,
    this.summary,
    this.status,
    this.managerId,
    this.createdAt,
    this.updatedAt,
    this.itemsCount,
    this.completionPercentage,
    this.items,
    this.employee,
  });

  DailyReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id']?.toString();
    partnerId = json['partner_id']?.toString();
    reportDate = json['report_date']?.toString();
    summary = json['summary']?.toString();
    status = json['status']?.toString();
    managerId = json['manager_id']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    itemsCount = json['items_count'];
    completionPercentage = json['completion_percentage'];
    if (json['items'] != null) {
      items = <DailyReportItemModel>[];
      json['items'].forEach((v) {
        items!.add(DailyReportItemModel.fromJson(v));
      });
    }
    if (json['employee'] != null) {
      employee = EmployeesModel.fromJson(json['employee']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
    data['partner_id'] = this.partnerId;
    data['report_date'] = this.reportDate;
    data['summary'] = this.summary;
    data['status'] = this.status;
    data['manager_id'] = this.managerId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['items_count'] = this.itemsCount;
    data['completion_percentage'] = this.completionPercentage;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.employee != null) {
      data['employee'] = this.employee!.toJson();
    }
    return data;
  }
}

class DailyReportItemModel {
  int? id;
  int? dailyWorkReportId;
  int? taskId;
  String? title;
  String? details;
  String? category;
  String? status;
  String? priority;
  int? timeSpentHours;
  int? timeSpentMinutes;
  String? createdAt;
  String? updatedAt;

  DailyReportItemModel({
    this.id,
    this.dailyWorkReportId,
    this.taskId,
    this.title,
    this.details,
    this.category,
    this.status,
    this.priority,
    this.timeSpentHours,
    this.timeSpentMinutes,
    this.createdAt,
    this.updatedAt,
  });

  DailyReportItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dailyWorkReportId = json['daily_work_report_id'];
    taskId = json['task_id'];
    title = json['title']?.toString();
    details = json['details']?.toString();
    category = json['category']?.toString();
    status = json['status']?.toString();
    priority = json['priority']?.toString();
    timeSpentHours = json['time_spent_hours'];
    timeSpentMinutes = json['time_spent_minutes'];
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['daily_work_report_id'] = this.dailyWorkReportId;
    data['task_id'] = this.taskId;
    data['title'] = this.title;
    data['details'] = this.details;
    data['category'] = this.category;
    data['status'] = this.status;
    data['priority'] = this.priority;
    data['time_spent_hours'] = this.timeSpentHours;
    data['time_spent_minutes'] = this.timeSpentMinutes;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
