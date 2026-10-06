class AttritionReportModel {
  final String? id;
  final String? employeeId;
  final String? employeeCode;
  final String? employeeName;
  final String? branch;
  final String? department;
  final String? exitType;
  final String? exitReason;
  final String? resignationDate;
  final String? exitDate;
  final String? lastWorkingDate;
  final String? clearanceStatus;
  final String? fnfStatus;
  final String? status;
  final int? noticePeriodDays;
  final String? remarks;

  AttritionReportModel({
    this.id,
    this.employeeId,
    this.employeeCode,
    this.employeeName,
    this.branch,
    this.department,
    this.exitType,
    this.exitReason,
    this.resignationDate,
    this.exitDate,
    this.lastWorkingDate,
    this.clearanceStatus,
    this.fnfStatus,
    this.status,
    this.noticePeriodDays,
    this.remarks,
  });

  factory AttritionReportModel.fromJson(Map<String, dynamic> json) => AttritionReportModel(
        id: json["id"]?.toString(),
        employeeId: json["employee_id"]?.toString(),
        employeeCode: json["employee_code"]?.toString(),
        employeeName: json["employee"] != null ? json["employee"]["name"] : json["employee_name"],
        branch: json["branch"] != null ? json["branch"]["name"] : json["branch"],
        department: json["department"] != null ? json["department"]["name"] : json["department"],
        exitType: json["exit_type"],
        exitReason: json["exit_reason"],
        resignationDate: json["resignation_date"],
        exitDate: json["exit_date"],
        lastWorkingDate: json["last_working_date"],
        clearanceStatus: json["clearance_status"],
        fnfStatus: json["fnf_status"],
        status: json["status"],
        noticePeriodDays: json["notice_period_days"],
        remarks: json["remarks"],
      );
}

class AttritionReportSummary {
  final int? currentActiveEmployees;
  final int? totalExits;
  final int? voluntaryExits;
  final int? involuntaryExits;
  final num? attritionRate;
  final int? openingHeadcount;
  final int? closingHeadcount;
  final num? averageHeadcount;
  final int? newJoiners;
  final int? totalStaff;
  final num? avgHeadcount;
  final List<MonthlyExit>? monthlyExits;
  final List<DeptAttrition>? deptAttrition;
  final List<BranchAttrition>? branchAttrition;
  final List<ReasonBreakdown>? reasonBreakdown;

  AttritionReportSummary({
    this.currentActiveEmployees,
    this.totalExits,
    this.voluntaryExits,
    this.involuntaryExits,
    this.attritionRate,
    this.openingHeadcount,
    this.closingHeadcount,
    this.averageHeadcount,
    this.newJoiners,
    this.totalStaff,
    this.avgHeadcount,
    this.monthlyExits,
    this.deptAttrition,
    this.branchAttrition,
    this.reasonBreakdown,
  });

  factory AttritionReportSummary.fromJson(Map<String, dynamic> json) => AttritionReportSummary(
        currentActiveEmployees: json["current_active_employees"],
        totalExits: json["total_exits"],
        voluntaryExits: json["voluntary_exits"],
        involuntaryExits: json["involuntary_exits"],
        attritionRate: json["attrition_rate"],
        openingHeadcount: json["opening_headcount"],
        closingHeadcount: json["closing_headcount"],
        averageHeadcount: json["average_headcount"],
        newJoiners: json["new_joiners"],
        totalStaff: json["total_staff"],
        avgHeadcount: json["avg_headcount"],
        monthlyExits: json["monthly_exits"] == null ? [] : List<MonthlyExit>.from(json["monthly_exits"].map((x) => MonthlyExit.fromJson(x))),
        deptAttrition: json["dept_attrition"] == null ? [] : List<DeptAttrition>.from(json["dept_attrition"].map((x) => DeptAttrition.fromJson(x))),
        branchAttrition: json["branch_attrition"] == null ? [] : List<BranchAttrition>.from(json["branch_attrition"].map((x) => BranchAttrition.fromJson(x))),
        reasonBreakdown: json["reason_breakdown"] == null ? [] : List<ReasonBreakdown>.from(json["reason_breakdown"].map((x) => ReasonBreakdown.fromJson(x))),
      );
}

class MonthlyExit {
  final String? month;
  final int? exits;

  MonthlyExit({this.month, this.exits});

  factory MonthlyExit.fromJson(Map<String, dynamic> json) => MonthlyExit(
        month: json["month"],
        exits: json["exits"],
      );
}

class DeptAttrition {
  final int? departmentId;
  final String? department;
  final int? exits;
  final int? employees;
  final num? rate;

  DeptAttrition({this.departmentId, this.department, this.exits, this.employees, this.rate});

  factory DeptAttrition.fromJson(Map<String, dynamic> json) => DeptAttrition(
        departmentId: json["department_id"],
        department: json["department"],
        exits: json["exits"] ?? json["count"],
        employees: json["employees"],
        rate: json["rate"] ?? json["count"], // Use count if rate is not provided
      );
}

class BranchAttrition {
  final int? branchId;
  final String? branch;
  final int? exits;
  final int? employees;
  final num? rate;

  BranchAttrition({this.branchId, this.branch, this.exits, this.employees, this.rate});

  factory BranchAttrition.fromJson(Map<String, dynamic> json) => BranchAttrition(
        branchId: json["branch_id"],
        branch: json["branch"],
        exits: json["exits"] ?? json["count"],
        employees: json["employees"],
        rate: json["rate"] ?? json["count"],
      );
}

class ReasonBreakdown {
  final String? exitReason;
  final int? count;
  final num? percentage;

  ReasonBreakdown({this.exitReason, this.count, this.percentage});

  factory ReasonBreakdown.fromJson(Map<String, dynamic> json) => ReasonBreakdown(
        exitReason: json["exit_reason"] ?? json["reason"],
        count: json["count"],
        percentage: json["percentage"],
      );
}
