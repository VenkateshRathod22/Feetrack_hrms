import 'package:vlr/services/date_formatters_and_converters.dart';

class NoticeModel {
  final int? id;
  final String? title;
  final String? content;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? type;
  final String? actionLink;
  final String? actionText;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NoticeModel({
    this.id,
    this.title,
    this.content,
    this.startDate,
    this.endDate,
    this.type,
    this.actionLink,
    this.actionText,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) => NoticeModel(
        id: int.tryParse(json["id"]?.toString() ?? ""),
        title: json["title"]?.toString(),
        content: json["content"]?.toString(),
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"].toString()).toLocal(),
        endDate: json["end_date"] == null
            ? null
            : DateTime.parse(json["end_date"].toString()),
        type: json["type"]?.toString(),
        actionLink: json["action_link"]?.toString(),
        actionText: json["action_text"]?.toString(),
        userId: int.tryParse(json["user_id"]?.toString() ?? ""),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"].toString()).toLocal(),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "type": type,
        "action_link": actionLink,
        "action_text": actionText,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  String get startDateFormat =>
      DateFormatters().dMy.format(startDate ?? getDateTime());

  String get endDateFormat =>
      DateFormatters().dMy.format(endDate ?? getDateTime());
}
