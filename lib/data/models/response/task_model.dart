import 'package:vlr/data/models/user_model.dart';

class TaskModel {
  int? id;
  String? employeeId;
  String? assignedBy;
  String? title;
  String? description;
  String? status;
  String? startDate;
  String? endDate;
  String? remark;
  String? dueDate;
  String? createdAt;
  String? updatedAt;
  bool? isOverdue;
  int? overdueDays;
  UserModel? assigner;

  TaskModel({
    this.id,
    this.employeeId,
    this.assignedBy,
    this.title,
    this.description,
    this.status,
    this.startDate,
    this.endDate,
    this.remark,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
    this.isOverdue,
    this.overdueDays,
    this.assigner,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id']?.toString();
    assignedBy = json['assigned_by']?.toString();
    title = json['title']?.toString();
    description = json['description']?.toString();
    status = json['status']?.toString();
    startDate = json['start_date']?.toString();
    endDate = json['end_date']?.toString();
    remark = json['remark']?.toString();
    dueDate = json['due_date']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    isOverdue = json['is_overdue'] == true || json['is_overdue'] == 1;
    overdueDays = int.tryParse(json['overdue_days']?.toString() ?? "0");
    if (json['assigner'] != null) {
      assigner = UserModel.fromJson(json['assigner']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employee_id'] = employeeId;
    data['assigned_by'] = assignedBy;
    data['title'] = title;
    data['description'] = description;
    data['status'] = status;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['remark'] = remark;
    data['due_date'] = dueDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_overdue'] = isOverdue;
    data['overdue_days'] = overdueDays;
    if (assigner != null) {
      data['assigner'] = assigner!.toJson();
    }
    return data;
  }
}

class TaskRemarkModel {
  int? id;
  int? taskId;
  String? userId;
  String? remark;
  String? createdAt;
  String? updatedAt;
  UserModel? user;

  TaskRemarkModel({
    this.id,
    this.taskId,
    this.userId,
    this.remark,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  TaskRemarkModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskId = json['task_id'];
    userId = json['user_id']?.toString();
    remark = json['remark']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    if (json['user'] != null) {
      user = UserModel.fromJson(json['user']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['task_id'] = taskId;
    data['user_id'] = userId;
    data['remark'] = remark;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
