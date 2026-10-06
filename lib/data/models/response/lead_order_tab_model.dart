class LeadOrderTabModel {
  String? key;
  String? label;
  int? count;

  LeadOrderTabModel({this.key, this.label, this.count});

  factory LeadOrderTabModel.fromJson(Map<String, dynamic> json) {
    return LeadOrderTabModel(
      key: json['key']?.toString(),
      label: json['label']?.toString(),
      count: int.tryParse(json['count']?.toString() ?? "0"),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['label'] = label;
    data['count'] = count;
    return data;
  }
}
