import 'salary_model.dart';

class EmployeeSalaryListModel {
  String? id;
  String? name;
  String? email;
  String? mobile;
  String? employeeCode;
  SalaryListDepartment? department;
  SalaryListBranch? branch;
  double? basicSalary;
  double? grossSalary;
  double? netSalary;
  double? totalAllowances;
  double? totalDeductions;
  double? performanceIncentive;
  double? salesIncentive;
  double? totalIncentives;
  double? incentiveAmount;
  String? incentiveText;
  String? salaryType;
  double? monthlyTarget;
  double? merchantTarget;
  double? commissionPercent;
  double? recoveryPercent;
  int? commissionLevelId;
  Allowances? allowances;
  Deductions? deductions;

  EmployeeSalaryListModel({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.employeeCode,
    this.department,
    this.branch,
    this.basicSalary,
    this.grossSalary,
    this.netSalary,
    this.totalAllowances,
    this.totalDeductions,
    this.performanceIncentive,
    this.salesIncentive,
    this.totalIncentives,
    this.incentiveAmount,
    this.incentiveText,
    this.salaryType,
    this.monthlyTarget,
    this.merchantTarget,
    this.commissionPercent,
    this.recoveryPercent,
    this.commissionLevelId,
    this.allowances,
    this.deductions,
  });

  factory EmployeeSalaryListModel.fromJson(Map<String, dynamic> json) => EmployeeSalaryListModel(
        id: json["id"]?.toString(),
        name: json["name"]?.toString(),
        email: json["email"]?.toString(),
        mobile: json["mobile"]?.toString(),
        employeeCode: json["employee_code"]?.toString(),
        department: json["department"] == null ? null : SalaryListDepartment.fromJson(json["department"]),
        branch: json["branch"] == null ? null : SalaryListBranch.fromJson(json["branch"]),
        basicSalary: double.tryParse(json["basic_salary"]?.toString() ?? "0"),
        grossSalary: double.tryParse(json["gross_salary"]?.toString() ?? "0"),
        netSalary: double.tryParse(json["net_salary"]?.toString() ?? "0"),
        totalAllowances: double.tryParse(json["total_allowances"]?.toString() ?? "0"),
        totalDeductions: double.tryParse(json["total_deductions"]?.toString() ?? "0"),
        performanceIncentive: double.tryParse(json["performance_incentive"]?.toString() ?? "0"),
        salesIncentive: double.tryParse(json["sales_incentive"]?.toString() ?? "0"),
        totalIncentives: double.tryParse(json["total_incentives"]?.toString() ?? "0"),
        incentiveAmount: double.tryParse(json["incentive_amount"]?.toString() ?? "0"),
        incentiveText: json["incentive_text"]?.toString(),
        salaryType: json["salary_type"]?.toString(),
        monthlyTarget: double.tryParse(json["monthly_target"]?.toString() ?? "0"),
        merchantTarget: double.tryParse(json["merchant_target"]?.toString() ?? "0"),
        commissionPercent: double.tryParse(json["commission_percent"]?.toString() ?? "0"),
        recoveryPercent: double.tryParse(json["recovery_percent"]?.toString() ?? "0"),
        commissionLevelId: json["commission_level_id"],
        allowances: (json["allowances"] == null || json["allowances"] is List)
            ? null
            : Allowances.fromJson(json["allowances"]),
        deductions: (json["deductions"] == null || json["deductions"] is List)
            ? null
            : Deductions.fromJson(json["deductions"]),
      );
}

class SalaryListDepartment {
  int? id;
  String? name;

  SalaryListDepartment({this.id, this.name});

  factory SalaryListDepartment.fromJson(Map<String, dynamic> json) => SalaryListDepartment(
        id: json["id"],
        name: json["name"]?.toString(),
      );
}

class SalaryListBranch {
  int? id;
  String? name;

  SalaryListBranch({this.id, this.name});

  factory SalaryListBranch.fromJson(Map<String, dynamic> json) => SalaryListBranch(
        id: json["id"],
        name: json["name"]?.toString(),
      );
}
