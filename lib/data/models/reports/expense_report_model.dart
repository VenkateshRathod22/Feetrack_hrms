class ExpenseReportModel {
  final int? id;
  final String? date;
  final String? employeeId;
  final String? employeeCode;
  final String? employeeName;
  final String? category;
  final String? description;
  final num? amount;
  final String? status;

  ExpenseReportModel({
    this.id,
    this.date,
    this.employeeId,
    this.employeeCode,
    this.employeeName,
    this.category,
    this.description,
    this.amount,
    this.status,
  });

  factory ExpenseReportModel.fromJson(Map<String, dynamic> json) {
    return ExpenseReportModel(
      id: json['id'],
      date: json['date']?.toString(),
      employeeId: json['employee_id']?.toString(),
      employeeCode: json['employee_code']?.toString(),
      employeeName: json['employee_name']?.toString(),
      category: json['category']?.toString(),
      description: json['description']?.toString(),
      amount: json['amount'],
      status: json['status']?.toString(),
    );
  }
}

class ExpenseReportSummary {
  final int? totalExpenses;
  final num? totalAmount;
  final int? approved;
  final int? pending;
  final int? rejected;

  ExpenseReportSummary({
    this.totalExpenses,
    this.totalAmount,
    this.approved,
    this.pending,
    this.rejected,
  });

  factory ExpenseReportSummary.fromJson(Map<String, dynamic> json) {
    return ExpenseReportSummary(
      totalExpenses: json['total_expenses'],
      totalAmount: json['total_amount'],
      approved: json['approved'],
      pending: json['pending'],
      rejected: json['rejected'],
    );
  }
}
