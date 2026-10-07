class ExitReasonModel {
  final int? id;
  final String? partnerId;
  final String? name;
  final String? type;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;

  ExitReasonModel({
    this.id,
    this.partnerId,
    this.name,
    this.type,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory ExitReasonModel.fromJson(Map<String, dynamic> json) => ExitReasonModel(
        id: json["id"],
        partnerId: json["partner_id"],
        name: json["name"],
        type: json["type"],
        isActive: json["is_active"] == 1 || json["is_active"] == true,
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "partner_id": partnerId,
        "name": name,
        "type": type,
        "is_active": isActive,
      };
}
