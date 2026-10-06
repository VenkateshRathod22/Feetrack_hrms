class LeadRecoveryResponseModel {
  String? status;
  RecoveryListSummary? summary;
  List<LeadRecoveryItem>? data;
  Pagination? pagination;

  LeadRecoveryResponseModel({this.status, this.summary, this.data, this.pagination});

  factory LeadRecoveryResponseModel.fromJson(Map<String, dynamic> json) {
    return LeadRecoveryResponseModel(
      status: json['status'],
      summary: json['summary'] != null ? RecoveryListSummary.fromJson(json['summary']) : null,
      data: json['data'] != null ? (json['data'] as List).map((i) => LeadRecoveryItem.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }
}

class RecoveryListSummary {
  num? totalOutstanding;
  int? totalPendingOrders;

  RecoveryListSummary({this.totalOutstanding, this.totalPendingOrders});

  factory RecoveryListSummary.fromJson(Map<String, dynamic> json) {
    return RecoveryListSummary(
      totalOutstanding: json['total_outstanding'],
      totalPendingOrders: json['total_pending_orders'],
    );
  }
}

class LeadRecoveryItem {
  String? orderId;
  String? orderNumber;
  RecoveryCustomer? customer;
  RecoveryEmployee? employee;
  int? itemsCount;
  RecoveryFinancials? financials;
  LastPayment? lastPayment;
  String? createdAt;

  LeadRecoveryItem({
    this.orderId,
    this.orderNumber,
    this.customer,
    this.employee,
    this.itemsCount,
    this.financials,
    this.lastPayment,
    this.createdAt,
  });

  factory LeadRecoveryItem.fromJson(Map<String, dynamic> json) {
    return LeadRecoveryItem(
      orderId: json['order_id'],
      orderNumber: json['order_number'],
      customer: json['customer'] != null ? RecoveryCustomer.fromJson(json['customer']) : null,
      employee: json['employee'] != null ? RecoveryEmployee.fromJson(json['employee']) : null,
      itemsCount: json['items_count'],
      financials: json['financials'] != null ? RecoveryFinancials.fromJson(json['financials']) : null,
      lastPayment: json['last_payment'] != null ? LastPayment.fromJson(json['last_payment']) : null,
      createdAt: json['created_at'],
    );
  }
}

class RecoveryCustomer {
  String? id;
  String? name;
  String? mobile;
  String? email;

  RecoveryCustomer({this.id, this.name, this.mobile, this.email});

  factory RecoveryCustomer.fromJson(Map<String, dynamic> json) {
    return RecoveryCustomer(
      id: json['id']?.toString(),
      name: json['name'],
      mobile: json['mobile'],
      email: json['email'],
    );
  }
}

class RecoveryEmployee {
  String? id;
  String? name;
  String? branch;
  String? department;

  RecoveryEmployee({this.id, this.name, this.branch, this.department});

  factory RecoveryEmployee.fromJson(Map<String, dynamic> json) {
    return RecoveryEmployee(
      id: json['id']?.toString(),
      name: json['name'],
      branch: json['branch'],
      department: json['department'],
    );
  }
}

class RecoveryFinancials {
  num? finalAmount;
  num? paidAmount;
  num? remainingBalance;
  String? paymentStatus;

  RecoveryFinancials({this.finalAmount, this.paidAmount, this.remainingBalance, this.paymentStatus});

  factory RecoveryFinancials.fromJson(Map<String, dynamic> json) {
    return RecoveryFinancials(
      finalAmount: json['final_amount'],
      paidAmount: json['paid_amount'],
      remainingBalance: json['remaining_balance'],
      paymentStatus: json['payment_status'],
    );
  }
}

class LastPayment {
  String? id;
  num? amount;
  String? paymentDate;
  String? paymentMethod;
  String? reference;

  LastPayment({this.id, this.amount, this.paymentDate, this.paymentMethod, this.reference});

  factory LastPayment.fromJson(Map<String, dynamic> json) {
    return LastPayment(
      id: json['id']?.toString(),
      amount: json['amount'],
      paymentDate: json['payment_date'],
      paymentMethod: json['payment_method'],
      reference: json['reference'],
    );
  }
}

class Pagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;

  Pagination({this.currentPage, this.lastPage, this.perPage, this.total});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
    );
  }
}
