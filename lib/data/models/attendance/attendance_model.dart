import 'dart:ui';

import 'package:vlr/data/models/employee_model.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';

class AttendanceModel {
  final int? id;
  final String? employeeId;
  final DateTime? date;
  final String? checkIn;
  final String? checkOut;
  final String? status;
  final String? statusReason;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<CheckchecklistResponse>? checklistResponses;
  final List<CheckchecklistResponse>? checkOutChecklistResponses;
  final String? checkInLat;
  final String? checkInLng;
  final dynamic checkInPhoto;
  final String? checkInSelfie;
  final String? checkOutLat;
  final String? checkOutLng;
  final dynamic checkOutPhoto;
  final String? checkOutSelfie;
  final String? checkInSelfieUrl;
  final String? checkOutSelfieUrl;
  final dynamic checkInPhotoUrl;
  final dynamic checkOutPhotoUrl;
  final int? workingMinutes;
  final String? lateMinutes;
  final String? workingHours;
  final String? productiveHours;
  final String? overtimeHours;
  final String? workingMode;
  final EmployeesModel? employee;

  AttendanceModel({
    this.id,
    this.employeeId,
    this.date,
    this.checkIn,
    this.checkOut,
    this.status,
    this.statusReason,
    this.createdAt,
    this.updatedAt,
    this.checklistResponses,
    this.checkOutChecklistResponses,
    this.checkInLat,
    this.checkInLng,
    this.checkInPhoto,
    this.checkInSelfie,
    this.checkOutLat,
    this.checkOutLng,
    this.checkOutPhoto,
    this.checkOutSelfie,
    this.checkInSelfieUrl,
    this.checkOutSelfieUrl,
    this.checkInPhotoUrl,
    this.checkOutPhotoUrl,
    this.workingMinutes,
    this.lateMinutes,
    this.workingHours,
    this.productiveHours,
    this.overtimeHours,
    this.workingMode,
    this.employee,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      AttendanceModel(
        id: int.tryParse(json["id"]?.toString() ?? ""),
        employeeId: json["employee_id"]?.toString(),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        checkIn: json["check_in"]?.toString(),
        checkOut: json["check_out"]?.toString(),
        // status: "short_leave",
        status: json["status"]?.toString(),
        statusReason: json["status_reason"]?.toString(),

        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        checklistResponses: json["checklist_responses"] == null
            ? []
            : List<CheckchecklistResponse>.from(json["checklist_responses"]!
                .map((x) => CheckchecklistResponse.fromJson(x))),
        checkOutChecklistResponses:
            json["check_out_checklist_responses"] == null
                ? []
                : List<CheckchecklistResponse>.from(
                    json["check_out_checklist_responses"]!
                        .map((x) => CheckchecklistResponse.fromJson(x))),

        checkInLat: json["check_in_lat"]?.toString() ?? "--",
        checkInLng: json["check_in_lng"]?.toString() ?? "--",
        checkInPhoto: json["check_in_photo"],
        checkInSelfie: json["check_in_selfie"]?.toString(),
        checkOutLat: json["check_out_lat"]?.toString(),
        checkOutLng: json["check_out_lng"]?.toString(),
        checkOutPhoto: json["check_out_photo"],
        checkOutSelfie: json["check_out_selfie"]?.toString(),
        checkInSelfieUrl: json["check_in_selfie_url"]?.toString(),
        checkOutSelfieUrl: json["check_out_selfie_url"]?.toString(),
        checkInPhotoUrl: json["check_in_photo_url"],
        checkOutPhotoUrl: json["check_out_photo_url"],
        workingMinutes: json["working_minutes"] == null
            ? null
            : int.tryParse(json["working_minutes"].toString()),

        lateMinutes: json["late_minutes"]?.toString(),
        workingHours: json["working_hours"]?.toString(),
        productiveHours: json["productive_hours"]?.toString(),
        overtimeHours: json["overtime_hours"]?.toString(),
        workingMode: json["working_mode"]?.toString() ?? json["employee"]?["working_mode"]?.toString(),
        employee: json["employee"] == null ? null : EmployeesModel.fromJson(json["employee"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "date": date?.toIso8601String(),
        "check_in": checkIn,
        "check_out": checkOut,
        "status": status,
        "status_reason": statusReason,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "checklist_responses": checklistResponses == null
            ? []
            : List<dynamic>.from(checklistResponses!.map((x) => x.toJson())),
        "check_out_checklist_responses": checkOutChecklistResponses == null
            ? []
            : List<dynamic>.from(
                checkOutChecklistResponses!.map((x) => x.toJson())),
        "check_in_lat": checkInLat,
        "check_in_lng": checkInLng,
        "check_in_photo": checkInPhoto,
        "check_in_selfie": checkInSelfie,
        "check_out_lat": checkOutLat,
        "check_out_lng": checkOutLng,
        "check_out_photo": checkOutPhoto,
        "check_out_selfie": checkOutSelfie,
        "check_in_selfie_url": checkInSelfieUrl,
        "check_out_selfie_url": checkOutSelfieUrl,
        "check_in_photo_url": checkInPhotoUrl,
        "check_out_photo_url": checkOutPhotoUrl,
        "working_minutes": workingMinutes,
        "late_minutes": lateMinutes,
        "working_hours": workingHours,
        "productive_hours": productiveHours,
        "overtime_hours": overtimeHours,
        "working_mode": workingMode,
        "employee": employee?.toJson(),
      };
  factory AttendanceModel.demoPunchIn() {
    return AttendanceModel(
      id: 1,
      employeeId: "EMP001",
      date: DateTime.now(),
      checkIn: "09:15:00",
      checkOut: null,
      status: "punch_in",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      workingMinutes: 165,
      lateMinutes: "5",
      checkInLat: "12.9740317",
      checkInLng: "77.7142783",
      checkOutLat: "--",
      checkOutLng: "--",
      checkInSelfieUrl:
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400",
      checkOutSelfieUrl: null,
      checklistResponses: [
        CheckchecklistResponse(
          question: "Are you wearing your Employee ID Card?",
          answer: true,
        ),
        CheckchecklistResponse(
          question: "Are you wearing your Employee Uniform?",
          answer: true,
        ),
        CheckchecklistResponse(
          question: "Safety Shoes Worn?",
          answer: true,
        ),
        CheckchecklistResponse(
          question: "Helmet Available?",
          answer: false,
        ),
      ],
      checkOutChecklistResponses: [],
    );
  }

  factory AttendanceModel.demoPunchOut() {
    return AttendanceModel(
      id: 2,
      employeeId: "EMP001",
      date: DateTime.now(),

      checkIn: "09:15:00",
      checkOut: "18:12:45",

      status: "punch_out",

      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),

      workingMinutes: 537, // 8h 57m
      lateMinutes: "5",

      checkInLat: "12.9740317",
      checkInLng: "77.7142783",

      checkOutLat: "12.9740452",
      checkOutLng: "77.7142918",

      checkInPhoto: null,
      checkOutPhoto: null,

      checkInSelfie: null,
      checkOutSelfie: null,

      checkInSelfieUrl:
          "https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?q=80&w=774&auto=format&fit=crop",

      checkOutSelfieUrl:
          "https://plus.unsplash.com/premium_photo-1670282393309-70fd7f8eb1ef?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",

      checkInPhotoUrl: null,
      checkOutPhotoUrl: null,

      checklistResponses: [
        CheckchecklistResponse(
          question: "Are you wearing your Employee ID Card?",
          answer: true,
        ),
        CheckchecklistResponse(
          question: "Are you wearing your Employee Uniform?",
          answer: true,
        ),
        CheckchecklistResponse(
          question: "Safety shoes worn?",
          answer: true,
        ),
        CheckchecklistResponse(
          question: "Helmet available?",
          answer: true,
        ),
      ],

      checkOutChecklistResponses: [
        CheckchecklistResponse(
          question: "Completed today's assigned tasks?",
          answer: true,
        ),
        CheckchecklistResponse(
          question: "Submitted daily work report?",
          answer: true,
        ),
        CheckchecklistResponse(
          question: "Cleaned your work area?",
          answer: true,
        ),
        CheckchecklistResponse(
          question: "Returned all company equipment?",
          answer: true,
        ),
      ],
    );
  }

  String? get checkInTimeFormat {
    if (checkIn == null || (checkIn?.isEmpty ?? false)) {
      return "-- : --";
    }
    return convertTo12HourFormat(time24: checkIn, isShowAMPM: true);
  }

  String? get checkOutTimeFormat {
    if (checkOut == null || (checkOut?.isEmpty ?? false)) {
      return "-- : --";
    }
    return convertTo12HourFormat(time24: checkOut, isShowAMPM: true);
  }

  String? get workingTimeFormat {
    if (isPunchIn) {
      return getWorkingTime(checkIn);
    }
    return formatMinutesToHours(
      workingMinutes,
    );
  }

  String? get dataFormat => DateFormatters().dMyDash.format(
        date ?? getDateTime(),
      );

  bool get isNotPunchIn => status == "notPunchIn";
  bool get isPunchIn => status == "punch_in";
  bool get isPunchOut => status == "punch_out";
  bool get isShortLeave => status == "short_leave";
  bool get isHalfDay => status == "half_day";
  bool get isAbsent => status == "absent";
  bool get isLeave => status == "leave";
  bool get isHoliday => status == "holiday";
  bool get isWeekOff => status == "weekOff";

  bool get hasCheckOutLocation =>
      (checkOutLat?.isNotEmpty ?? false) && (checkOutLng?.isNotEmpty ?? false);

  bool get hasCheckInLocation =>
      (checkInLat?.isNotEmpty ?? false) && (checkInLng?.isNotEmpty ?? false);

  Color get statusColor {
    if (isNotPunchIn) return notPunchIn;
    if (isPunchIn) return punchIn;
    if (isPunchOut) return punchOut;
    if (isShortLeave) return shortLeave;
    if (isHalfDay) return halfDay;
    if (isAbsent) return absent;
    if (isLeave) return leave;
    if (isHoliday) return holiday;
    if (isWeekOff) return weekOff;

    return defaultColor;
  }

  String get statusName {
    if (isNotPunchIn) return "Check-In Pending";
    if (isPunchIn) return "Working";
    if (isPunchOut) return "Punched Out";
    if (isShortLeave) return "Short Leave";
    if (isHalfDay) return "Half Day";
    if (isAbsent) return "Absent";
    if (isLeave) return "On Leave";
    if (isHoliday) return "Holiday";
    if (isWeekOff) return "Week Off";

    return "Unknown";
  }

  String get location {
    if (hasCheckOutLocation) {
      return "$checkOutLat, $checkOutLng";
    }

    if (hasCheckInLocation) {
      return "$checkInLat, $checkInLng";
    }

    return "--";
  }

  String? get image {
    if (hasCheckOutLocation) {
      return checkOutSelfieUrl;
    }

    if (hasCheckInLocation) {
      return checkInSelfieUrl;
    }

    return "";
  }
}

class CheckchecklistResponse {
  final String? question;
  final bool? answer;

  CheckchecklistResponse({
    this.question,
    this.answer,
  });

  factory CheckchecklistResponse.fromJson(Map<String, dynamic> json) =>
      CheckchecklistResponse(
        question: json["question"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "answer": answer,
      };
}
