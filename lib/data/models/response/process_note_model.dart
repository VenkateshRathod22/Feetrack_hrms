class ProcessNoteModel {
  int? id;
  String? title;
  String? description;
  String? status;
  String? createdAt;

  ProcessNoteModel({
    this.id,
    this.title,
    this.description,
    this.status,
    this.createdAt,
  });

  factory ProcessNoteModel.fromJson(Map<String, dynamic> json) {
    return ProcessNoteModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
}
