class RecoveryReportModel {
  final String? id;
  final String? orderId;
  final String? employeeId;
  final String? employeeName;
  final String? customerName;
  final String? customerMobile;
  final num? totalAmount;
  final num? paidAmount;
  final num? remainingBalance;
  final String? paymentStatus;
  final String? approvalStatus;
  final String? createdAt;

  RecoveryReportModel({
    this.id,
    this.orderId,
    this.employeeId,
    this.employeeName,
    this.customerName,
    this.customerMobile,
    this.totalAmount,
    this.paidAmount,
    this.remainingBalance,
    this.paymentStatus,
    this.approvalStatus,
    this.createdAt,
  });

  factory RecoveryReportModel.fromJson(Map<String, dynamic> json) {
    return RecoveryReportModel(
      id: json['id']?.toString(),
      orderId: json['order_id']?.toString(),
      employeeId: json['employee_id']?.toString(),
      employeeName: json['employee_name']?.toString(),
      customerName: json['customer_name']?.toString(),
      customerMobile: json['customer_mobile']?.toString(),
      totalAmount: json['total_amount'],
      paidAmount: json['paid_amount'],
      remainingBalance: json['remaining_balance'],
      paymentStatus: json['payment_status']?.toString(),
      approvalStatus: json['approval_status']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class RecoveryReportSummary {
  final int? totalOrders;
  final num? totalAmount;
  final num? totalPaid;
  final num? totalRemaining;
  final Map<String, int>? paymentStatusCounts;

  RecoveryReportSummary({
    this.totalOrders,
    this.totalAmount,
    this.totalPaid,
    this.totalRemaining,
    this.paymentStatusCounts,
  });

  factory RecoveryReportSummary.fromJson(Map<String, dynamic> json) {
    return RecoveryReportSummary(
      totalOrders: json['total_orders'],
      totalAmount: json['total_amount'],
      totalPaid: json['total_paid'],
      totalRemaining: json['total_remaining'],
      paymentStatusCounts: json['payment_status_counts'] != null 
          ? Map<String, int>.from(json['payment_status_counts'])
          : null,
    );
  }
}
