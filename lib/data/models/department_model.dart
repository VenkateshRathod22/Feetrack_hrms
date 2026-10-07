class DepartmentModel {
  int? id;
  String? partnerId;
  int? parentId;
  String? name;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  DepartmentModel({
    this.id,
    this.partnerId,
    this.parentId,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) => DepartmentModel(
        id: json["id"],
        partnerId: json["partner_id"],
        parentId: json["parent_id"],
        name: json["name"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "partner_id": partnerId,
        "parent_id": parentId,
        "name": name,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  String toString() => name ?? "";
}
