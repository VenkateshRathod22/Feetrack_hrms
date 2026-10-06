class PayrollReportModel {
  final int? id;
  final String? employeeId;
  final String? employeeName;
  final String? employeeEmail;
  final String? month;
  final String? year;
  final num? basicSalary;
  final num? grossPay;
  final num? netPay;
  final String? status;
  final int? presents;
  final int? absents;
  final int? leaves;
  final int? expenses;

  PayrollReportModel({
    this.id,
    this.employeeId,
    this.employeeName,
    this.employeeEmail,
    this.month,
    this.year,
    this.basicSalary,
    this.grossPay,
    this.netPay,
    this.status,
    this.presents,
    this.absents,
    this.leaves,
    this.expenses,
  });

  factory PayrollReportModel.fromJson(Map<String, dynamic> json) {
    return PayrollReportModel(
      id: json['id'],
      employeeId: json['employee_id']?.toString(),
      employeeName: json['employee_name']?.toString(),
      employeeEmail: json['employee_email']?.toString(),
      month: json['month']?.toString(),
      year: json['year']?.toString(),
      basicSalary: json['basic_salary'],
      grossPay: json['gross_pay'],
      netPay: json['net_pay'],
      status: json['status']?.toString(),
      presents: json['presents'],
      absents: json['absents'],
      leaves: json['leaves'],
      expenses: json['expenses'],
    );
  }
}

class PayrollReportSummary {
  final int? totalPayrolls;
  final int? totalPaid;
  final int? totalPending;
  final num? totalNetPay;

  PayrollReportSummary({
    this.totalPayrolls,
    this.totalPaid,
    this.totalPending,
    this.totalNetPay,
  });

  factory PayrollReportSummary.fromJson(Map<String, dynamic> json) {
    return PayrollReportSummary(
      totalPayrolls: json['total_payrolls'],
      totalPaid: json['total_paid'],
      totalPending: json['total_pending'],
      totalNetPay: json['total_net_pay'],
    );
  }
}
