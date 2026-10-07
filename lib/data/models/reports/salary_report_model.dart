class SalaryReportModel {
  final int? id;
  final String? employeeId;
  final String? employeeName;
  final String? employeeEmail;
  final String? month;
  final String? year;
  final num? basicSalary;
  final num? allowances;
  final num? bonuses;
  final num? commissions;
  final num? grossPay;
  final num? deductions;
  final num? netPay;
  final String? status;

  SalaryReportModel({
    this.id,
    this.employeeId,
    this.employeeName,
    this.employeeEmail,
    this.month,
    this.year,
    this.basicSalary,
    this.allowances,
    this.bonuses,
    this.commissions,
    this.grossPay,
    this.deductions,
    this.netPay,
    this.status,
  });

  factory SalaryReportModel.fromJson(Map<String, dynamic> json) {
    return SalaryReportModel(
      id: json['id'],
      employeeId: json['employee_id']?.toString(),
      employeeName: json['employee_name']?.toString(),
      employeeEmail: json['employee_email']?.toString(),
      month: json['month']?.toString(),
      year: json['year']?.toString(),
      basicSalary: json['basic_salary'],
      allowances: json['allowances'],
      bonuses: json['bonuses'],
      commissions: json['commissions'],
      grossPay: json['gross_pay'],
      deductions: json['deductions'],
      netPay: json['net_pay'],
      status: json['status']?.toString(),
    );
  }
}

class SalaryReportSummary {
  final int? totalRecords;
  final num? totalGrossPay;
  final num? totalDeductions;
  final num? totalNetPay;

  SalaryReportSummary({
    this.totalRecords,
    this.totalGrossPay,
    this.totalDeductions,
    this.totalNetPay,
  });

  factory SalaryReportSummary.fromJson(Map<String, dynamic> json) {
    return SalaryReportSummary(
      totalRecords: json['total_records'],
      totalGrossPay: json['total_gross_pay'],
      totalDeductions: json['total_deductions'],
      totalNetPay: json['total_net_pay'],
    );
  }
}
