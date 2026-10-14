class NoticeReportModel {
  final int? id;
  final String? title;
  final String? type;
  final String? content;
  final String? startDate;
  final String? endDate;
  final dynamic departmentIds;
  final String? createdAt;

  NoticeReportModel({
    this.id,
    this.title,
    this.type,
    this.content,
    this.startDate,
    this.endDate,
    this.departmentIds,
    this.createdAt,
  });

  factory NoticeReportModel.fromJson(Map<String, dynamic> json) {
    return NoticeReportModel(
      id: json['id'],
      title: json['title']?.toString(),
      type: json['type']?.toString(),
      content: json['content']?.toString(),
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      departmentIds: json['department_ids'],
      createdAt: json['created_at']?.toString(),
    );
  }
}


class NoticeReportSummary {
  final int? totalNotices;
  final Map<String, int>? typeCounts;

  NoticeReportSummary({
    this.totalNotices,
    this.typeCounts,
  });

  factory NoticeReportSummary.fromJson(Map<String, dynamic> json) {
    final dynamic rawTypeCounts = json['type_counts'];

    final Map<String, int> parsedTypeCounts = {};

    if (rawTypeCounts is Map) {
      rawTypeCounts.forEach((key, value) {
        parsedTypeCounts[key.toString()] =
            int.tryParse(value.toString()) ?? 0;
      });
    }

    return NoticeReportSummary(
      totalNotices: int.tryParse(
        json['total_notices']?.toString() ?? '',
      ),
      typeCounts: parsedTypeCounts,
    );
  }
}
