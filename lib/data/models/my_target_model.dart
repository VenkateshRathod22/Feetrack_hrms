class MyTargetModel {
  final Metrics? metrics;
  final Structure? structure;

  MyTargetModel({this.metrics, this.structure});

  factory MyTargetModel.fromJson(Map<String, dynamic> json) {
    return MyTargetModel(
      metrics: json['metrics'] != null ? Metrics.fromJson(json['metrics']) : null,
      structure: json['structure'] != null ? Structure.fromJson(json['structure']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metrics': metrics?.toJson(),
      'structure': structure?.toJson(),
    };
  }
}

class Metrics {
  final dynamic baseCommission;
  final dynamic recoveryCommission;
  final dynamic hierarchyCommission;
  final dynamic totalCommission;
  final dynamic targetAchieved;
  final dynamic targetRequired;
  final dynamic recoveryBusiness;
  final dynamic newBusiness;
  final dynamic basicSalary;
  final dynamic estTotalEarning;

  Metrics({
    this.baseCommission,
    this.recoveryCommission,
    this.hierarchyCommission,
    this.totalCommission,
    this.targetAchieved,
    this.targetRequired,
    this.recoveryBusiness,
    this.newBusiness,
    this.basicSalary,
    this.estTotalEarning,
  });

  factory Metrics.fromJson(Map<String, dynamic> json) {
    return Metrics(
      baseCommission: json['base_commission'],
      recoveryCommission: json['recovery_commission'],
      hierarchyCommission: json['hierarchy_commission'],
      totalCommission: json['total_commission'],
      targetAchieved: json['target_achieved'],
      targetRequired: json['target_required'],
      recoveryBusiness: json['recovery_business'],
      newBusiness: json['new_business'],
      basicSalary: json['basic_salary'],
      estTotalEarning: json['est_total_earning'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_commission': baseCommission,
      'recovery_commission': recoveryCommission,
      'hierarchy_commission': hierarchyCommission,
      'total_commission': totalCommission,
      'target_achieved': targetAchieved,
      'target_required': targetRequired,
      'recovery_business': recoveryBusiness,
      'new_business': newBusiness,
      'basic_salary': basicSalary,
      'est_total_earning': estTotalEarning,
    };
  }
}

class Structure {
  final int? id;
  final dynamic merchantTarget;
  final String? employeeId;
  final String? salaryType;
  final String? monthlyTarget;
  final String? commissionPercent;
  final String? recoveryPercent;
  final String? basicSalary;
  final dynamic allowances;
  final dynamic deductions;
  final String? grossSalary;
  final String? netSalary;
  final String? createdAt;
  final String? updatedAt;
  final dynamic commissionLevelId;

  Structure({
    this.id,
    this.merchantTarget,
    this.employeeId,
    this.salaryType,
    this.monthlyTarget,
    this.commissionPercent,
    this.recoveryPercent,
    this.basicSalary,
    this.allowances,
    this.deductions,
    this.grossSalary,
    this.netSalary,
    this.createdAt,
    this.updatedAt,
    this.commissionLevelId,
  });

  factory Structure.fromJson(Map<String, dynamic> json) {
    return Structure(
      id: json['id'],
      merchantTarget: json['merchant_target'],
      employeeId: json['employee_id'],
      salaryType: json['salary_type'],
      monthlyTarget: json['monthly_target'],
      commissionPercent: json['commission_percent'],
      recoveryPercent: json['recovery_percent'],
      basicSalary: json['basic_salary'],
      allowances: json['allowances'],
      deductions: json['deductions'],
      grossSalary: json['gross_salary'],
      netSalary: json['net_salary'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      commissionLevelId: json['commission_level_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchant_target': merchantTarget,
      'employee_id': employeeId,
      'salary_type': salaryType,
      'monthly_target': monthlyTarget,
      'commission_percent': commissionPercent,
      'recovery_percent': recoveryPercent,
      'basic_salary': basicSalary,
      'allowances': allowances,
      'deductions': deductions,
      'gross_salary': grossSalary,
      'net_salary': netSalary,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'commission_level_id': commissionLevelId,
    };
  }
}
