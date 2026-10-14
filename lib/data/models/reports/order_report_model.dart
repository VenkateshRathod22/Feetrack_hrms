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
  final double? totalRevenue;
  final double? collectedAmount;
  final double? pendingBalance;
  final double? totalFinalAmount;
  final Map<String, int>? approvalCounts;
  final Map<String, int>? paymentCounts;

  OrderReportSummary({
    this.totalOrders,
    this.totalRevenue,
    this.collectedAmount,
    this.pendingBalance,
    this.totalFinalAmount,
    this.approvalCounts,
    this.paymentCounts,
  });

  factory OrderReportSummary.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic value) {
      return int.tryParse(value?.toString() ?? '');
    }

    double? parseDouble(dynamic value) {
      return double.tryParse(value?.toString() ?? '');
    }

    Map<String, int> parseCounts(dynamic value) {
      final Map<String, int> result = {};

      // Parse a JSON object such as {"approved": 5, "pending": 2}.
      if (value is Map) {
        value.forEach((key, count) {
          result[key.toString()] =
              int.tryParse(count.toString()) ?? 0;
        });
      }

      // If the API sends [], keep an empty map.
      return result;
    }

    return OrderReportSummary(
      totalOrders: parseInt(json['total_orders']),
      totalRevenue: parseDouble(json['total_revenue']),
      collectedAmount: parseDouble(json['collected_amount']),
      pendingBalance: parseDouble(json['pending_balance']),
      totalFinalAmount: parseDouble(json['total_final_amount']),
      approvalCounts: parseCounts(json['approval_counts']),
      paymentCounts: parseCounts(json['payment_counts']),
    );
  }
}