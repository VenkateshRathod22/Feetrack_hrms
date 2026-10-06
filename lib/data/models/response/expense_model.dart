import 'package:vlr/data/models/user_model.dart';

class ExpenseModel {
  int? id;
  String? employeeId;
  String? expenseCategoryId;
  String? amount;
  String? quantity;
  String? unitRate;
  String? category;
  String? date;
  String? description;
  String? status;
  String? remarks;
  String? uploadFile;
  String? createdAt;
  String? updatedAt;
  UserModel? employee;

  ExpenseModel({
    this.id,
    this.employeeId,
    this.expenseCategoryId,
    this.amount,
    this.quantity,
    this.unitRate,
    this.category,
    this.date,
    this.description,
    this.status,
    this.remarks,
    this.uploadFile,
    this.createdAt,
    this.updatedAt,
    this.employee,
  });

  ExpenseModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? "");
    employeeId = json['employee_id']?.toString();
    expenseCategoryId = json['expense_category_id']?.toString();
    amount = json['amount']?.toString();
    quantity = json['quantity']?.toString();
    unitRate = json['unit_rate']?.toString();
    category = json['category']?.toString();
    date = json['date']?.toString();
    description = json['description']?.toString();
    status = json['status']?.toString();
    remarks = json['remarks']?.toString();
    uploadFile = json['upload_file']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    employee =
        json['employee'] != null ? UserModel.fromJson(json['employee']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employee_id'] = employeeId;
    data['expense_category_id'] = expenseCategoryId;
    data['amount'] = amount;
    data['quantity'] = quantity;
    data['unit_rate'] = unitRate;
    data['category'] = category;
    data['date'] = date;
    data['description'] = description;
    data['status'] = status;
    data['remarks'] = remarks;
    data['upload_file'] = uploadFile;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (employee != null) {
      data['employee'] = employee!.toJson();
    }
    return data;
  }
}
