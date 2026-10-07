import 'package:vlr/data/models/user_model.dart';

class LeaveModel {
  int? id;
  String? employeeId;
  String? startDate;
  String? endDate;
  String? type;
  String? status;
  String? reason;
  String? createdAt;
  String? updatedAt;
  UserModel? employee;

  LeaveModel({
    this.id,
    this.employeeId,
    this.startDate,
    this.endDate,
    this.type,
    this.status,
    this.reason,
    this.createdAt,
    this.updatedAt,
    this.employee,
  });

  LeaveModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? "");
    employeeId = json['employee_id']?.toString();
    startDate = json['start_date']?.toString();
    endDate = json['end_date']?.toString();
    type = json['type']?.toString();
    status = json['status']?.toString();
    reason = json['reason']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    employee =
        json['employee'] != null ? UserModel.fromJson(json['employee']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employee_id'] = employeeId;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['type'] = type;
    data['status'] = status;
    data['reason'] = reason;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (employee != null) {
      data['employee'] = employee!.toJson();
    }
    return data;
  }
}
