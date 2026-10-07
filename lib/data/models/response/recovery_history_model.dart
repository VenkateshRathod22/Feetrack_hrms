class RecoveryHistoryResponseModel {
  String? status;
  RecoverySummary? summary;
  List<RecoveryHistoryItem>? data;
  Pagination? pagination;

  RecoveryHistoryResponseModel({this.status, this.summary, this.data, this.pagination});

  factory RecoveryHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return RecoveryHistoryResponseModel(
      status: json['status'],
      summary: json['summary'] != null ? RecoverySummary.fromJson(json['summary']) : null,
      data: json['data'] != null ? (json['data'] as List).map((i) => RecoveryHistoryItem.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }
}

class RecoverySummary {
  num? totalRecovered;
  num? thisMonthRecovered;
  num? todayRecovered;
  int? totalTransactions;

  RecoverySummary({this.totalRecovered, this.thisMonthRecovered, this.todayRecovered, this.totalTransactions});

  factory RecoverySummary.fromJson(Map<String, dynamic> json) {
    return RecoverySummary(
      totalRecovered: json['total_recovered'],
      thisMonthRecovered: json['this_month_recovered'],
      todayRecovered: json['today_recovered'],
      totalTransactions: json['total_transactions'],
    );
  }
}

class RecoveryHistoryItem {
  String? id;
  String? orderId;
  String? orderNumber;
  num? amount;
  String? paymentMethod;
  String? paymentDate;
  String? reference;
  String? notes;
  RecoveryCustomer? customer;
  OrderFinancials? orderFinancials;
  CollectedBy? collectedBy;
  String? createdAt;

  RecoveryHistoryItem({
    this.id,
    this.orderId,
    this.orderNumber,
    this.amount,
    this.paymentMethod,
    this.paymentDate,
    this.reference,
    this.notes,
    this.customer,
    this.orderFinancials,
    this.collectedBy,
    this.createdAt,
  });

  factory RecoveryHistoryItem.fromJson(Map<String, dynamic> json) {
    return RecoveryHistoryItem(
      id: json['id'],
      orderId: json['order_id'],
      orderNumber: json['order_number'],
      amount: json['amount'],
      paymentMethod: json['payment_method'],
      paymentDate: json['payment_date'],
      reference: json['reference'],
      notes: json['notes'],
      customer: json['customer'] != null ? RecoveryCustomer.fromJson(json['customer']) : null,
      orderFinancials: json['order_financials'] != null ? OrderFinancials.fromJson(json['order_financials']) : null,
      collectedBy: json['collected_by'] != null ? CollectedBy.fromJson(json['collected_by']) : null,
      createdAt: json['created_at'],
    );
  }
}

class RecoveryCustomer {
  String? id;
  String? name;
  String? mobile;

  RecoveryCustomer({this.id, this.name, this.mobile});

  factory RecoveryCustomer.fromJson(Map<String, dynamic> json) {
    return RecoveryCustomer(
      id: json['id'],
      name: json['name'],
      mobile: json['mobile'],
    );
  }
}

class OrderFinancials {
  num? finalAmount;
  num? paidAmount;
  num? remainingBalance;

  OrderFinancials({this.finalAmount, this.paidAmount, this.remainingBalance});

  factory OrderFinancials.fromJson(Map<String, dynamic> json) {
    return OrderFinancials(
      finalAmount: json['final_amount'],
      paidAmount: json['paid_amount'],
      remainingBalance: json['remaining_balance'],
    );
  }
}

class CollectedBy {
  String? id;
  String? name;

  CollectedBy({this.id, this.name});

  factory CollectedBy.fromJson(Map<String, dynamic> json) {
    return CollectedBy(
      id: json['id'],
      name: json['name'],
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
