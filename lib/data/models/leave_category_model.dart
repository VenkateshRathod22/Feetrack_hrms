class LeaveCategoryModel {
  int? id;
  String? partnerId;
  String? name;
  int? days;
  bool? isUnlimited;
  bool? status;
  String? createdAt;
  String? updatedAt;

  LeaveCategoryModel({
    this.id,
    this.partnerId,
    this.name,
    this.days,
    this.isUnlimited,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  LeaveCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    partnerId = json['partner_id'];
    name = json['name'];
    days = json['days'];
    isUnlimited = json['is_unlimited'] is int ? json['is_unlimited'] == 1 : json['is_unlimited'];
    status = json['status'] is int ? json['status'] == 1 : json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['partner_id'] = partnerId;
    data['name'] = name;
    data['days'] = days;
    data['is_unlimited'] = isUnlimited;
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
      other is LeaveCategoryModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
