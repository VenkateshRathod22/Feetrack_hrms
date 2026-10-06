class AssetReportModel {
  final int? id;
  final String? assetCode;
  final String? category;
  final String? name;
  final String? brand;
  final String? model;
  final String? serialNumber;
  final String? imeiNumber;
  final String? purchaseDate;
  final num? purchaseCost;
  final String? condition;
  final String? status;
  final String? branch;
  final String? department;
  final String? createdBy;

  AssetReportModel({
    this.id,
    this.assetCode,
    this.category,
    this.name,
    this.brand,
    this.model,
    this.serialNumber,
    this.imeiNumber,
    this.purchaseDate,
    this.purchaseCost,
    this.condition,
    this.status,
    this.branch,
    this.department,
    this.createdBy,
  });

  factory AssetReportModel.fromJson(Map<String, dynamic> json) => AssetReportModel(
        id: json["id"],
        assetCode: json["asset_code"],
        category: json["category"],
        name: json["name"],
        brand: json["brand"],
        model: json["model"],
        serialNumber: json["serial_number"],
        imeiNumber: json["imei_number"],
        purchaseDate: json["purchase_date"],
        purchaseCost: json["purchase_cost"],
        condition: json["condition"],
        status: json["status"],
        branch: json["branch"],
        department: json["department"],
        createdBy: json["created_by"],
      );
}

class AssetReportSummary {
  final int? totalAssets;
  final int? available;
  final int? issued;
  final int? damaged;
  final num? totalCost;

  AssetReportSummary({
    this.totalAssets,
    this.available,
    this.issued,
    this.damaged,
    this.totalCost,
  });

  factory AssetReportSummary.fromJson(Map<String, dynamic> json) => AssetReportSummary(
        totalAssets: json["total_assets"],
        available: json["available"],
        issued: json["issued"],
        damaged: json["damaged"],
        totalCost: json["total_cost"],
      );
}
