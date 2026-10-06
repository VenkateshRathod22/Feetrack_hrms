class AttendanceChecklistModel {
  int? id;
  String? partnerId;
  String? question;
  String? mode;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  AttendanceChecklistModel({
    this.id,
    this.partnerId,
    this.question,
    this.mode,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory AttendanceChecklistModel.fromJson(Map<String, dynamic> json) => AttendanceChecklistModel(
        id: json["id"],
        partnerId: json["partner_id"]?.toString(),
        question: json["question"],
        mode: json["mode"],
        isActive: json["is_active"] == 1 || json["is_active"] == true,
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "partner_id": partnerId,
        "question": question,
        "mode": mode,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
