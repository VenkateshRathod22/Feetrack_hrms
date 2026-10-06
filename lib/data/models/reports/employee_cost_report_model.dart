class EmployeeCostReportModel {
  final String? employeeId;
  final String? employeeName;
  final String? employeeCode;
  final String? email;
  final String? mobile;
  final String? department;
  final String? branch;
  final String? designation;
  final num? monthlySalary;
  final num? annualCtc;
  final num? salaryCost;
  final num? otHours;
  final num? otCost;
  final num? incentiveCost;
  final num? totalCost;

  EmployeeCostReportModel({
    this.employeeId,
    this.employeeName,
    this.employeeCode,
    this.email,
    this.mobile,
    this.department,
    this.branch,
    this.designation,
    this.monthlySalary,
    this.annualCtc,
    this.salaryCost,
    this.otHours,
    this.otCost,
    this.incentiveCost,
    this.totalCost,
  });

  factory EmployeeCostReportModel.fromJson(Map<String, dynamic> json) => EmployeeCostReportModel(
        employeeId: json["employee_id"]?.toString(),
        employeeName: json["employee_name"],
        employeeCode: json["employee_code"]?.toString(),
        email: json["email"],
        mobile: json["mobile"],
        department: json["department"],
        branch: json["branch"],
        designation: json["designation"],
        monthlySalary: json["monthly_salary"],
        annualCtc: json["annual_ctc"],
        salaryCost: json["salary_cost"],
        otHours: json["ot_hours"],
        otCost: json["ot_cost"],
        incentiveCost: json["incentive_cost"],
        totalCost: json["total_cost"],
      );
}

class EmployeeCostReportSummary {
  final num? totalEmployeeCost;
  final num? totalSalaryCost;
  final num? totalOvertimeCost;
  final num? totalIncentiveCost;
  final num? totalCtcCost;
  final num? totalOvertimeHours;
  final int? totalEmployees;

  EmployeeCostReportSummary({
    this.totalEmployeeCost,
    this.totalSalaryCost,
    this.totalOvertimeCost,
    this.totalIncentiveCost,
    this.totalCtcCost,
    this.totalOvertimeHours,
    this.totalEmployees,
  });

  factory EmployeeCostReportSummary.fromJson(Map<String, dynamic> json) => EmployeeCostReportSummary(
        totalEmployeeCost: json["total_employee_cost"],
        totalSalaryCost: json["total_salary_cost"],
        totalOvertimeCost: json["total_overtime_cost"],
        totalIncentiveCost: json["total_incentive_cost"],
        totalCtcCost: json["total_ctc_cost"],
        totalOvertimeHours: json["total_overtime_hours"],
        totalEmployees: json["total_employees"],
      );
}

class DeptCostBreakdown {
  final int? id;
  final String? department;
  final int? employees;
  final num? salaryCost;
  final num? percentage;

  DeptCostBreakdown({this.id, this.department, this.employees, this.salaryCost, this.percentage});

  factory DeptCostBreakdown.fromJson(Map<String, dynamic> json) => DeptCostBreakdown(
        id: json["id"] ?? json["department_id"],
        department: json["department"],
        employees: json["employees"] ?? json["employee_count"],
        salaryCost: json["salary_cost"],
        percentage: json["percentage"],
      );
}

class BranchCostBreakdown {
  final int? id;
  final String? branch;
  final int? employees;
  final num? salaryCost;
  final num? otCost;
  final num? incentiveCost;
  final num? totalCost;

  BranchCostBreakdown({this.id, this.branch, this.employees, this.salaryCost, this.otCost, this.incentiveCost, this.totalCost});

  factory BranchCostBreakdown.fromJson(Map<String, dynamic> json) => BranchCostBreakdown(
        id: json["id"] ?? json["branch_id"],
        branch: json["branch"],
        employees: json["employees"] ?? json["employee_count"],
        salaryCost: json["salary_cost"],
        otCost: json["ot_cost"],
        incentiveCost: json["incentive_cost"],
        totalCost: json["total_cost"],
      );
}

class MonthlyTrend {
  final String? month;
  final num? salaryCost;
  final num? otCost;
  final num? incentiveCost;
  final num? totalCost;

  MonthlyTrend({this.month, this.salaryCost, this.otCost, this.incentiveCost, this.totalCost});

  factory MonthlyTrend.fromJson(Map<String, dynamic> json) => MonthlyTrend(
        month: json["month"],
        salaryCost: json["salary_cost"],
        otCost: json["ot_cost"],
        incentiveCost: json["incentive_cost"],
        totalCost: json["total_cost"],
      );
}

class EmployeeCostAnalytics {
  final EmployeeCostReportSummary? summary;
  final List<DeptCostBreakdown>? deptCostBreakdown;
  final List<BranchCostBreakdown>? branchCostBreakdown;
  final List<MonthlyTrend>? monthlyTrends;

  EmployeeCostAnalytics({this.summary, this.deptCostBreakdown, this.branchCostBreakdown, this.monthlyTrends});

  factory EmployeeCostAnalytics.fromJson(Map<String, dynamic> json) => EmployeeCostAnalytics(
        summary: json["summary"] != null ? EmployeeCostReportSummary.fromJson(json["summary"]) : null,
        deptCostBreakdown: json["department_breakdown"] != null ? List<DeptCostBreakdown>.from(json["department_breakdown"].map((x) => DeptCostBreakdown.fromJson(x))) : [],
        branchCostBreakdown: json["branch_breakdown"] != null ? List<BranchCostBreakdown>.from(json["branch_breakdown"].map((x) => BranchCostBreakdown.fromJson(x))) : [],
        monthlyTrends: json["monthly_trends"] != null ? List<MonthlyTrend>.from(json["monthly_trends"].map((x) => MonthlyTrend.fromJson(x))) : [],
      );
}
