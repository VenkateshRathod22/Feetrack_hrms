class ExpenseCategoryModel {
  String? id;
  String? partnerId;
  String? name;
  String? type;
  String? unitName;
  String? ratePerUnit;
  String? maxLimitAmount;
  String? status;
  String? createdAt;
  String? updatedAt;

  ExpenseCategoryModel({
    this.id,
    this.partnerId,
    this.name,
    this.type,
    this.unitName,
    this.ratePerUnit,
    this.maxLimitAmount,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  ExpenseCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    partnerId = json['partner_id'];
    name = json['name'];
    type = json['type'];
    unitName = json['unit_name'];
    ratePerUnit = json['rate_per_unit']?.toString();
    maxLimitAmount = json['max_limit_amount']?.toString();
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['partner_id'] = partnerId;
    data['name'] = name;
    data['type'] = type;
    data['unit_name'] = unitName;
    data['rate_per_unit'] = ratePerUnit;
    data['max_limit_amount'] = maxLimitAmount;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  @override
  String toString() => name ?? "";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseCategoryModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
