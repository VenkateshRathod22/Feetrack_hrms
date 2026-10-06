class CommissionLevelModel {
  int? id;
  String? partnerId;
  String? levelName;
  int? levelOrder;
  String? commissionPercent;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  CommissionLevelModel({
    this.id,
    this.partnerId,
    this.levelName,
    this.levelOrder,
    this.commissionPercent,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory CommissionLevelModel.fromJson(Map<String, dynamic> json) => CommissionLevelModel(
        id: json["id"],
        partnerId: json["partner_id"]?.toString(),
        levelName: json["level_name"],
        levelOrder: json["level_order"],
        commissionPercent: json["commission_percent"]?.toString(),
        description: json["description"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "partner_id": partnerId,
        "level_name": levelName,
        "level_order": levelOrder,
        "commission_percent": commissionPercent,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
