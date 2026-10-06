class ProductCategoryReportModel {
  final int? id;
  final String? name;
  final String? status;
  final String? createdAt;

  ProductCategoryReportModel({
    this.id,
    this.name,
    this.status,
    this.createdAt,
  });

  factory ProductCategoryReportModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryReportModel(
      id: json['id'],
      name: json['name']?.toString(),
      status: json['status']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class ProductCategoryReportSummary {
  final int? totalCategories;
  final int? active;
  final int? inactive;

  ProductCategoryReportSummary({
    this.totalCategories,
    this.active,
    this.inactive,
  });

  factory ProductCategoryReportSummary.fromJson(Map<String, dynamic> json) {
    return ProductCategoryReportSummary(
      totalCategories: json['total_categories'],
      active: json['active'],
      inactive: json['inactive'],
    );
  }
}
