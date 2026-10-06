class CompanyDocumentModel {
  int? id;
  String? title;
  List<DocumentFile>? files;
  String? createdAt;

  CompanyDocumentModel({this.id, this.title, this.files, this.createdAt});

  factory CompanyDocumentModel.fromJson(Map<String, dynamic> json) {
    return CompanyDocumentModel(
      id: json['id'],
      title: json['title'],
      files: json['files'] != null
          ? (json['files'] as List).map((i) => DocumentFile.fromJson(i)).toList()
          : null,
      createdAt: json['created_at'],
    );
  }
}

class DocumentFile {
  String? url;
  String? type;
  String? size;

  DocumentFile({this.url, this.type, this.size});

  factory DocumentFile.fromJson(Map<String, dynamic> json) {
    return DocumentFile(
      url: json['url'],
      type: json['type'],
      size: json['size']?.toString(),
    );
  }
}
