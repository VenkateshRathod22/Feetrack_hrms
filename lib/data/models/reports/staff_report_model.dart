class StaffReportModel {
  final String? id;
  final String? employeeCode;
  final String? name;
  final String? email;
  final String? mobile;
  final String? role;
  final String? department;
  final String? branch;
  final String? shift;
  final num? basicSalary;
  final num? walletBalance;
  final String? employmentStatus;
  final String? status;

  StaffReportModel({
    this.id,
    this.employeeCode,
    this.name,
    this.email,
    this.mobile,
    this.role,
    this.department,
    this.branch,
    this.shift,
    this.basicSalary,
    this.walletBalance,
    this.employmentStatus,
    this.status,
  });

  factory StaffReportModel.fromJson(Map<String, dynamic> json) {
    return StaffReportModel(
      id: json['id']?.toString(),
      employeeCode: json['employee_code']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      mobile: json['mobile']?.toString(),
      role: json['role']?.toString(),
      department: json['department']?.toString(),
      branch: json['branch']?.toString(),
      shift: json['shift']?.toString(),
      basicSalary: json['basic_salary'],
      walletBalance: json['wallet_balance'],
      employmentStatus: json['employment_status']?.toString(),
      status: json['status']?.toString(),
    );
  }
}

class StaffReportSummary {
  final int? totalStaff;
  final int? activeStaff;
  final num? totalBasicSalary;
  final num? totalWallet;

  StaffReportSummary({
    this.totalStaff,
    this.activeStaff,
    this.totalBasicSalary,
    this.totalWallet,
  });

  factory StaffReportSummary.fromJson(Map<String, dynamic> json) {
    return StaffReportSummary(
      totalStaff: json['total_staff'],
      activeStaff: json['active_staff'],
      totalBasicSalary: json['total_basic_salary'],
      totalWallet: json['total_wallet'],
    );
  }
}
