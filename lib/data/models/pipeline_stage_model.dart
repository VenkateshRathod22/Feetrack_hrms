class PipelineStageModel {
  String? id;
  String? partnerId;
  String? name;
  int? departmentId;
  int? orderIndex;
  bool? countsTowardsTarget;
  DateTime? createdAt;
  DateTime? updatedAt;
  PipelineDepartment? department;

  PipelineStageModel({
    this.id,
    this.partnerId,
    this.name,
    this.departmentId,
    this.orderIndex,
    this.countsTowardsTarget,
    this.createdAt,
    this.updatedAt,
    this.department,
  });

  factory PipelineStageModel.fromJson(Map<String, dynamic> json) => PipelineStageModel(
        id: json["id"]?.toString(),
        partnerId: json["partner_id"]?.toString(),
        name: json["name"],
        departmentId: json["department_id"],
        orderIndex: json["order_index"],
        countsTowardsTarget: json["counts_towards_target"] == 1 || json["counts_towards_target"] == true,
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        department: json["department"] == null ? null : PipelineDepartment.fromJson(json["department"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "partner_id": partnerId,
        "name": name,
        "department_id": departmentId,
        "order_index": orderIndex,
        "counts_towards_target": countsTowardsTarget,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "department": department?.toJson(),
      };
}

class PipelineDepartment {
  int? id;
  String? partnerId;
  String? name;
  String? description;

  PipelineDepartment({
    this.id,
    this.partnerId,
    this.name,
    this.description,
  });

  factory PipelineDepartment.fromJson(Map<String, dynamic> json) => PipelineDepartment(
        id: json["id"],
        partnerId: json["partner_id"]?.toString(),
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "partner_id": partnerId,
        "name": name,
        "description": description,
      };
}
