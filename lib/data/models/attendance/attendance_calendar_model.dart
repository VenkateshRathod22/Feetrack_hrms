import 'attendance_model.dart';

class AttendanceCalendarModel {
  final List<CalendarEmployee>? employees;
  final String? selectedEmployeeId;
  final int? month;
  final int? year;
  final String? monthName;
  final int? daysInMonth;
  final int? startDayOfWeek;
  final CalendarSummary? summary;
  final List<CalendarDay>? days;

  AttendanceCalendarModel({
    this.employees,
    this.selectedEmployeeId,
    this.month,
    this.year,
    this.monthName,
    this.daysInMonth,
    this.startDayOfWeek,
    this.summary,
    this.days,
  });

  factory AttendanceCalendarModel.fromJson(Map<String, dynamic> json) {
    return AttendanceCalendarModel(
      employees: json['employees'] != null
          ? (json['employees'] as List)
              .map((i) => CalendarEmployee.fromJson(i))
              .toList()
          : null,
      selectedEmployeeId: json['selected_employee_id']?.toString(),
      month: json['month'],
      year: json['year'],
      monthName: json['month_name'],
      daysInMonth: json['days_in_month'],
      startDayOfWeek: json['start_day_of_week'],
      summary: json['summary'] != null
          ? CalendarSummary.fromJson(json['summary'])
          : null,
      days: json['days'] != null
          ? (json['days'] as List).map((i) => CalendarDay.fromJson(i)).toList()
          : null,
    );
  }
}

class CalendarEmployee {
  final String? id;
  final String? name;
  final String? profileImageUrl;

  CalendarEmployee({this.id, this.name, this.profileImageUrl});

  factory CalendarEmployee.fromJson(Map<String, dynamic> json) {
    return CalendarEmployee(
      id: json['id']?.toString(),
      name: json['name'],
      profileImageUrl: json['profile_image_url'],
    );
  }
}

class CalendarSummary {
  final int? absent;
  final int? weekOff;
  final int? punchIn;
  final int? holiday;
  final int? leave;

  CalendarSummary({
    this.absent,
    this.weekOff,
    this.punchIn,
    this.holiday,
    this.leave,
  });

  factory CalendarSummary.fromJson(Map<String, dynamic> json) {
    return CalendarSummary(
      absent: json['absent'],
      weekOff: json['week_off'],
      punchIn: json['punch_in'],
      holiday: json['holiday'],
      leave: json['leave'],
    );
  }
}

class CalendarDay {
  final int? day;
  final String? date;
  final String? status;
  final bool? isToday;
  final bool? isSunday;
  final bool? isPast;
  final bool? clickable;
  final String? leaveType;
  final String? holidayName;
  final AttendanceModel? attendance;

  CalendarDay({
    this.day,
    this.date,
    this.status,
    this.isToday,
    this.isSunday,
    this.isPast,
    this.clickable,
    this.leaveType,
    this.holidayName,
    this.attendance,
  });

  factory CalendarDay.fromJson(Map<String, dynamic> json) {
    return CalendarDay(
      day: json['day'],
      date: json['date'],
      status: json['status'],
      isToday: json['is_today'],
      isSunday: json['is_sunday'],
      isPast: json['is_past'],
      clickable: json['clickable'],
      leaveType: json['leave_type'],
      holidayName: json['holiday_name'],
      attendance: json['attendance'] != null
          ? AttendanceModel.fromJson(json['attendance'])
          : null,
    );
  }
}
