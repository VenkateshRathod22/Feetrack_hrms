class AssetModel {
  final int? id;
  final String? partnerId;
  final int? branchId;
  final int? departmentId;
  final String? assetCode;
  final String? category;
  final String? name;
  final String? brand;
  final String? model;
  final String? serialNumber;
  final String? imeiNumber;
  final String? mobileNumber;
  final String? simNumber;
  final String? cardNumber;
  final String? purchaseDate;
  final String? purchaseCost;
  final String? condition;
  final String? status;
  final String? description;
  final String? branchName;
  final String? departmentName;

  AssetModel({
    this.id,
    this.partnerId,
    this.branchId,
    this.departmentId,
    this.assetCode,
    this.category,
    this.name,
    this.brand,
    this.model,
    this.serialNumber,
    this.imeiNumber,
    this.mobileNumber,
    this.simNumber,
    this.cardNumber,
    this.purchaseDate,
    this.purchaseCost,
    this.condition,
    this.status,
    this.description,
    this.branchName,
    this.departmentName,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) => AssetModel(
        id: json["id"],
        partnerId: json["partner_id"],
        branchId: json["branch_id"],
        departmentId: json["department_id"],
        assetCode: json["asset_code"],
        category: json["category"],
        name: json["name"],
        brand: json["brand"],
        model: json["model"],
        serialNumber: json["serial_number"],
        imeiNumber: json["imei_number"],
        mobileNumber: json["mobile_number"],
        simNumber: json["sim_number"],
        cardNumber: json["card_number"],
        purchaseDate: json["purchase_date"],
        purchaseCost: json["purchase_cost"]?.toString(),
        condition: json["condition"],
        status: json["status"],
        description: json["description"],
        branchName: json["branch"]?["name"],
        departmentName: json["department"]?["name"],
      );

  Map<String, dynamic> toJson() => {
        "asset_code": assetCode,
        "category": category,
        "name": name,
        "brand": brand,
        "model": model,
        "serial_number": serialNumber,
        "imei_number": imeiNumber,
        "mobile_number": mobileNumber,
        "sim_number": simNumber,
        "card_number": cardNumber,
        "purchase_date": purchaseDate,
        "purchase_cost": purchaseCost,
        "condition": condition,
        "status": status,
        "branch_id": branchId,
        "department_id": departmentId,
        "description": description,
      };
}

class AssetSummary {
  final int? totalAssets;
  final int? availableAssets;
  final int? issuedAssets;
  final int? damagedAssets;
  final num? totalAssetValue;

  AssetSummary({
    this.totalAssets,
    this.availableAssets,
    this.issuedAssets,
    this.damagedAssets,
    this.totalAssetValue,
  });

  factory AssetSummary.fromJson(Map<String, dynamic> json) => AssetSummary(
        totalAssets: json["total_assets"],
        availableAssets: json["available_assets"],
        issuedAssets: json["issued_assets"],
        damagedAssets: json["damaged_assets"],
        totalAssetValue: json["total_asset_value"],
      );
}

class AssetCategoryBreakdown {
  final String? label;
  final String? category;
  final int? total;

  AssetCategoryBreakdown({this.label, this.category, this.total});

  factory AssetCategoryBreakdown.fromJson(Map<String, dynamic> json) => AssetCategoryBreakdown(
        label: json["label"],
        category: json["category"],
        total: json["total"],
      );
}
