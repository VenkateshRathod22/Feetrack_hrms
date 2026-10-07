class OrderReportModel {
  final String? id;
  final String? employeeId;
  final String? leadId;
  final String? customerName;
  final String? customerMobile;
  final String? employeeCode;
  final String? assignedTo;
  final String? currentStage;
  final num? totalAmount;
  final num? discount;
  final num? finalAmount;
  final num? paidAmount;
  final num? remainingBalance;
  final String? paymentStatus;
  final String? approvalStatus;
  final String? createdAt;

  OrderReportModel({
    this.id,
    this.employeeId,
    this.leadId,
    this.customerName,
    this.customerMobile,
    this.employeeCode,
    this.assignedTo,
    this.currentStage,
    this.totalAmount,
    this.discount,
    this.finalAmount,
    this.paidAmount,
    this.remainingBalance,
    this.paymentStatus,
    this.approvalStatus,
    this.createdAt,
  });

  factory OrderReportModel.fromJson(Map<String, dynamic> json) {
    return OrderReportModel(
      id: json['id']?.toString(),
      employeeId: json['employee_id']?.toString(),
      leadId: json['lead_id']?.toString(),
      customerName: json['customer_name']?.toString(),
      customerMobile: json['customer_mobile']?.toString(),
      employeeCode: json['employee_code']?.toString(),
      assignedTo: json['assigned_to']?.toString(),
      currentStage: json['current_stage']?.toString(),
      totalAmount: json['total_amount'],
      discount: json['discount'],
      finalAmount: json['final_amount'],
      paidAmount: json['paid_amount'],
      remainingBalance: json['remaining_balance'],
      paymentStatus: json['payment_status']?.toString(),
      approvalStatus: json['approval_status']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class OrderReportSummary {
  final int? totalOrders;
  final num? totalFinalAmount;
  final Map<String, int>? approvalCounts;
  final Map<String, int>? paymentCounts;

  OrderReportSummary({
    this.totalOrders,
    this.totalFinalAmount,
    this.approvalCounts,
    this.paymentCounts,
  });

  factory OrderReportSummary.fromJson(Map<String, dynamic> json) {
    return OrderReportSummary(
      totalOrders: json['total_orders'],
      totalFinalAmount: json['total_final_amount'],
      approvalCounts: json['approval_counts'] != null 
          ? Map<String, int>.from(json['approval_counts'])
          : null,
      paymentCounts: json['payment_counts'] != null 
          ? Map<String, int>.from(json['payment_counts'])
          : null,
    );
  }
}
