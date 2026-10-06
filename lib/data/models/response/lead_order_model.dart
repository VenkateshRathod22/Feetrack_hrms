class LeadOrderModel {
  String? id;
  String? orderNumber;
  LeadOrderCustomer? lead;
  LeadOrderEmployee? employee;
  int? itemsCount;
  num? baseAmount;
  String? gstType;
  num? gstPercent;
  num? gstAmount;
  num? totalAmount;
  num? discount;
  num? finalAmount;
  num? paidAmount;
  num? remainingBalance;
  String? approvalStatus;
  String? paymentStatus;
  bool? targetCredited;
  LeadOrderStage? currentStage;
  String? createdAt;

  LeadOrderModel({
    this.id,
    this.orderNumber,
    this.lead,
    this.employee,
    this.itemsCount,
    this.baseAmount,
    this.gstType,
    this.gstPercent,
    this.gstAmount,
    this.totalAmount,
    this.discount,
    this.finalAmount,
    this.paidAmount,
    this.remainingBalance,
    this.approvalStatus,
    this.paymentStatus,
    this.targetCredited,
    this.currentStage,
    this.createdAt,
  });

  factory LeadOrderModel.fromJson(Map<String, dynamic> json) {
    return LeadOrderModel(
      id: json['id']?.toString(),
      orderNumber: json['order_number']?.toString(),
      lead: json['lead'] != null ? LeadOrderCustomer.fromJson(json['lead']) : null,
      employee: json['employee'] != null ? LeadOrderEmployee.fromJson(json['employee']) : null,
      itemsCount: json['items_count'],
      baseAmount: json['base_amount'],
      gstType: json['gst_type']?.toString(),
      gstPercent: json['gst_percent'],
      gstAmount: json['gst_amount'],
      totalAmount: json['total_amount'],
      discount: json['discount'],
      finalAmount: json['final_amount'],
      paidAmount: json['paid_amount'],
      remainingBalance: json['remaining_balance'],
      approvalStatus: json['approval_status']?.toString(),
      paymentStatus: json['payment_status']?.toString(),
      targetCredited: json['target_credited'],
      currentStage: json['current_stage'] != null ? LeadOrderStage.fromJson(json['current_stage']) : null,
      createdAt: json['created_at']?.toString(),
    );
  }
}

class LeadOrderCustomer {
  String? id;
  String? customerName;
  String? customerMobile;

  LeadOrderCustomer({this.id, this.customerName, this.customerMobile});

  factory LeadOrderCustomer.fromJson(Map<String, dynamic> json) {
    return LeadOrderCustomer(
      id: json['id']?.toString(),
      customerName: json['customer_name']?.toString(),
      customerMobile: json['customer_mobile']?.toString(),
    );
  }
}

class LeadOrderEmployee {
  String? id;
  String? name;

  LeadOrderEmployee({this.id, this.name});

  factory LeadOrderEmployee.fromJson(Map<String, dynamic> json) {
    return LeadOrderEmployee(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
    );
  }
}

class LeadOrderStage {
  String? id;
  String? name;
  String? assignedUser;
  String? department;

  LeadOrderStage({this.id, this.name, this.assignedUser, this.department});

  factory LeadOrderStage.fromJson(Map<String, dynamic> json) {
    return LeadOrderStage(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      assignedUser: json['assigned_user']?.toString(),
      department: json['department']?.toString(),
    );
  }
}
