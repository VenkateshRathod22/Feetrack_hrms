import 'dart:convert';

class WorkShiftModel {
  int? id;
  String? partnerId;
  int? branchId;
  String? name;
  String? startTime;
  String? endTime;
  int? autoMarkAttendance;
  String? autoMarkStatus;
  int? lateToleranceMinutes;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? minPresentMins;
  int? minHalfDayMins;
  int? autoAbsentMarkMins;
  List<String>? weekOffDays;

  WorkShiftModel({
    this.id,
    this.partnerId,
    this.branchId,
    this.name,
    this.startTime,
    this.endTime,
    this.autoMarkAttendance,
    this.autoMarkStatus,
    this.lateToleranceMinutes,
    this.createdAt,
    this.updatedAt,
    this.minPresentMins,
    this.minHalfDayMins,
    this.autoAbsentMarkMins,
    this.weekOffDays,
  });

  factory WorkShiftModel.fromJson(Map<String, dynamic> json) {
    List<String>? _weekOff;
    if (json["week_off_days"] != null) {
      if (json["week_off_days"] is String) {
        try {
          _weekOff = List<String>.from(jsonDecode(json["week_off_days"]));
        } catch (e) {
          _weekOff = [];
        }
      } else if (json["week_off_days"] is List) {
        _weekOff = List<String>.from(json["week_off_days"]);
      }
    }

    return WorkShiftModel(
      id: json["id"],
      partnerId: json["partner_id"],
      branchId: json["branch_id"],
      name: json["name"],
      startTime: json["start_time"],
      endTime: json["end_time"],
      autoMarkAttendance: json["auto_mark_attendance"] is bool 
          ? (json["auto_mark_attendance"] ? 1 : 0) 
          : json["auto_mark_attendance"],
      autoMarkStatus: json["auto_mark_status"],
      lateToleranceMinutes: json["late_tolerance_minutes"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      minPresentMins: json["min_present_mins"],
      minHalfDayMins: json["min_half_day_mins"],
      autoAbsentMarkMins: json["auto_absent_mark_mins"],
      weekOffDays: _weekOff,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "partner_id": partnerId,
        "branch_id": branchId,
        "name": name,
        "start_time": startTime,
        "end_time": endTime,
        "auto_mark_attendance": autoMarkAttendance,
        "auto_mark_status": autoMarkStatus,
        "late_tolerance_minutes": lateToleranceMinutes,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "min_present_mins": minPresentMins,
        "min_half_day_mins": minHalfDayMins,
        "auto_absent_mark_mins": autoAbsentMarkMins,
        "week_off_days": weekOffDays,
      };
}
