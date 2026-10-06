class TaskStatusModel {


  int? id;
  String? partnerId;
  String? name;
  String? slug;
  String? color;
  int? order;
  bool? isCompleted;
  bool? status;
  String? createdAt;
  String? updatedAt;

  TaskStatusModel({
    this.id,
    this.partnerId,
    this.name,
    this.slug,
    this.color,
    this.order,
    this.isCompleted,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory TaskStatusModel.fromJson(Map<String, dynamic> json) {
    return TaskStatusModel(
      id: json['id'],
      partnerId: json['partner_id']?.toString(),
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      color: json['color']?.toString(),
      order: json['order'],
      isCompleted: json['is_completed'] is bool 
          ? json['is_completed'] 
          : (json['is_completed'] == 1 || json['is_completed'] == "1"),
      status: json['status'] is bool 
          ? json['status'] 
          : (json['status'] == 1 || json['status'] == "1"),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  @override
  String toString() => name ?? "";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskStatusModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
