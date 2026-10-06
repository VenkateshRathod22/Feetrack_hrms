class LeadOrderCalculationModel {
  ProductCalc? product;
  num? baseUnitPrice;
  num? unitGst;
  num? unitTotal;
  num? baseSubtotal;
  bool? isGstIncluded;
  num? gstRate;
  num? gstAmount;
  num? subtotal;
  num? discount;
  num? finalAmount;
  num? paidAmount;
  num? remainingBalance;

  LeadOrderCalculationModel({
    this.product,
    this.baseUnitPrice,
    this.unitGst,
    this.unitTotal,
    this.baseSubtotal,
    this.isGstIncluded,
    this.gstRate,
    this.gstAmount,
    this.subtotal,
    this.discount,
    this.finalAmount,
    this.paidAmount,
    this.remainingBalance,
  });

  factory LeadOrderCalculationModel.fromJson(Map<String, dynamic> json) {
    return LeadOrderCalculationModel(
      product: json['product'] != null ? ProductCalc.fromJson(json['product']) : null,
      baseUnitPrice: json['base_unit_price'],
      unitGst: json['unit_gst'],
      unitTotal: json['unit_total'],
      baseSubtotal: json['base_subtotal'],
      isGstIncluded: json['is_gst_included'],
      gstRate: json['gst_rate'],
      gstAmount: json['gst_amount'],
      subtotal: json['subtotal'],
      discount: json['discount'],
      finalAmount: json['final_amount'],
      paidAmount: json['paid_amount'],
      remainingBalance: json['remaining_balance'],
    );
  }
}

class ProductCalc {
  int? id;
  String? name;
  num? amount;
  String? gstType;
  num? gstPercent;

  ProductCalc({this.id, this.name, this.amount, this.gstType, this.gstPercent});

  factory ProductCalc.fromJson(Map<String, dynamic> json) {
    return ProductCalc(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      gstType: json['gst_type'],
      gstPercent: json['gst_percent'],
    );
  }
}
