import 'category_model.dart';

class ProductModel {
  int? id;
  String? partnerId;
  int? categoryId;
  String? categoryName;
  String? name;
  String? amount;
  String? gstType;
  num? gstPercent;
  num? gstAmount;
  num? totalPrice;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  CategoryModel? category;

  ProductModel({
    this.id,
    this.partnerId,
    this.categoryId,
    this.categoryName,
    this.name,
    this.amount,
    this.gstType,
    this.gstPercent,
    this.gstAmount,
    this.totalPrice,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        partnerId: json["partner_id"]?.toString(),
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        name: json["name"],
        amount: json["amount"]?.toString(),
        gstType: json["gst_type"],
        gstPercent: json["gst_percent"],
        gstAmount: json["gst_amount"],
        totalPrice: json["total_price"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        category: json["category"] == null
            ? null
            : CategoryModel.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "partner_id": partnerId,
        "category_id": categoryId,
        "category_name": categoryName,
        "name": name,
        "amount": amount,
        "gst_type": gstType,
        "gst_percent": gstPercent,
        "gst_amount": gstAmount,
        "total_price": totalPrice,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "category": category?.toJson(),
      };

  @override
  String toString() => name ?? "";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
