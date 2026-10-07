class ExitModel {
  String? id;
  String? partnerId;
  String? employeeId;
  String? createdBy;
  String? resignationDate;
  int? noticePeriodDays;
  String? lastWorkingDate;
  String? exitReason;
  String? clearanceStatus;
  String? fnfStatus;
  String? fnfAmount;
  String? fnfSettlementDate;
  String? status;
  String? remarks;
  Employee? employee;

  ExitModel({
    this.id,
    this.partnerId,
    this.employeeId,
    this.createdBy,
    this.resignationDate,
    this.noticePeriodDays,
    this.lastWorkingDate,
    this.exitReason,
    this.clearanceStatus,
    this.fnfStatus,
    this.fnfAmount,
    this.fnfSettlementDate,
    this.status,
    this.remarks,
    this.employee,
  });

  factory ExitModel.fromJson(Map<String, dynamic> json) {
    return ExitModel(
      id: json['id']?.toString(),
      partnerId: json['partner_id'],
      employeeId: json['employee_id'],
      createdBy: json['created_by'],
      resignationDate: json['resignation_date'],
      noticePeriodDays: json['notice_period_days'],
      lastWorkingDate: json['last_working_date'],
      exitReason: json['exit_reason'],
      clearanceStatus: json['clearance_status'],
      fnfStatus: json['fnf_status'],
      fnfAmount: json['fnf_amount']?.toString(),
      fnfSettlementDate: json['fnf_settlement_date'],
      status: json['status'],
      remarks: json['remarks'],
      employee: json['employee'] != null ? Employee.fromJson(json['employee']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'resignation_date': resignationDate,
      'notice_period_days': noticePeriodDays,
      'last_working_date': lastWorkingDate,
      'exit_reason': exitReason,
      'clearance_status': clearanceStatus,
      'fnf_status': fnfStatus,
      'fnf_amount': fnfAmount,
      'fnf_settlement_date': fnfSettlementDate,
      'status': status,
      'remarks': remarks,
    };
  }
}

class Employee {
  String? id;
  String? name;
  String? email;
  String? employeeCode;

  Employee({this.id, this.name, this.email, this.employeeCode});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      employeeCode: json['employee_code'],
    );
  }
}
