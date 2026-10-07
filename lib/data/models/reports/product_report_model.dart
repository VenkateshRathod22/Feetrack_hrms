class ProductReportModel {
  final int? id;
  final String? name;
  final int? categoryId;
  final String? category;
  final num? amount;
  final String? status;
  final String? createdAt;

  ProductReportModel({
    this.id,
    this.name,
    this.categoryId,
    this.category,
    this.amount,
    this.status,
    this.createdAt,
  });

  factory ProductReportModel.fromJson(Map<String, dynamic> json) {
    return ProductReportModel(
      id: json['id'],
      name: json['name']?.toString(),
      categoryId: json['category_id'],
      category: json['category']?.toString(),
      amount: json['amount'],
      status: json['status']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class ProductReportSummary {
  final int? totalProducts;
  final int? active;
  final int? inactive;
  final num? totalAmount;

  ProductReportSummary({
    this.totalProducts,
    this.active,
    this.inactive,
    this.totalAmount,
  });

  factory ProductReportSummary.fromJson(Map<String, dynamic> json) {
    return ProductReportSummary(
      totalProducts: json['total_products'],
      active: json['active'],
      inactive: json['inactive'],
      totalAmount: json['total_amount'],
    );
  }
}
