class AdvancePaymentModel {
  final int? id;
  final String? partnerId;
  final String? employeeId;
  final String? amount;
  final String? reason;
  final String? status;
  final String? remarks;
  final String? approvedBy;
  final String? deductionMonth;
  final String? deductionYear;
  final int? isDeducted;
  final String? createdAt;
  final String? updatedAt;

  AdvancePaymentModel({
    this.id,
    this.partnerId,
    this.employeeId,
    this.amount,
    this.reason,
    this.status,
    this.remarks,
    this.approvedBy,
    this.deductionMonth,
    this.deductionYear,
    this.isDeducted,
    this.createdAt,
    this.updatedAt,
  });

  factory AdvancePaymentModel.fromJson(Map<String, dynamic> json) {
    return AdvancePaymentModel(
      id: json['id'],
      partnerId: json['partner_id']?.toString(),
      employeeId: json['employee_id']?.toString(),
      amount: json['amount']?.toString(),
      reason: json['reason']?.toString(),
      status: json['status']?.toString(),
      remarks: json['remarks']?.toString(),
      approvedBy: json['approved_by']?.toString(),
      deductionMonth: json['deduction_month']?.toString(),
      deductionYear: json['deduction_year']?.toString(),
      isDeducted: json['is_deducted'],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partner_id': partnerId,
      'employee_id': employeeId,
      'amount': amount,
      'reason': reason,
      'status': status,
      'remarks': remarks,
      'approved_by': approvedBy,
      'deduction_month': deductionMonth,
      'deduction_year': deductionYear,
      'is_deducted': isDeducted,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
