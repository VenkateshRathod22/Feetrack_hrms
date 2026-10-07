class AttendanceOverrideModel {
  int? id;
  String? date;
  String? dateDisplay;
  String? previousStatus;
  String? newStatus;
  String? previousCheckInTime;
  String? previousCheckOutTime;
  String? newCheckInTime;
  String? newCheckOutTime;
  int? workingMinutes;
  int? lateMinutes;
  String? notes;
  String? loggedAt;
  OverrideEmployee? employee;
  OverrideShift? shift;
  OverrideBy? overriddenBy;

  AttendanceOverrideModel({
    this.id,
    this.date,
    this.dateDisplay,
    this.previousStatus,
    this.newStatus,
    this.previousCheckInTime,
    this.previousCheckOutTime,
    this.newCheckInTime,
    this.newCheckOutTime,
    this.workingMinutes,
    this.lateMinutes,
    this.notes,
    this.loggedAt,
    this.employee,
    this.shift,
    this.overriddenBy,
  });

  factory AttendanceOverrideModel.fromJson(Map<String, dynamic> json) {
    return AttendanceOverrideModel(
      id: json['id'],
      date: json['date']?.toString(),
      dateDisplay: json['date_display']?.toString(),
      previousStatus: json['previous_status']?.toString(),
      newStatus: json['new_status']?.toString(),
      previousCheckInTime: json['previous_check_in_time']?.toString(),
      previousCheckOutTime: json['previous_check_out_time']?.toString(),
      newCheckInTime: json['new_check_in_time']?.toString(),
      newCheckOutTime: json['new_check_out_time']?.toString(),
      workingMinutes: json['working_minutes'],
      lateMinutes: json['late_minutes'],
      notes: json['notes']?.toString(),
      loggedAt: json['logged_at']?.toString(),
      employee: json['employee'] != null ? OverrideEmployee.fromJson(json['employee']) : null,
      shift: json['shift'] != null ? OverrideShift.fromJson(json['shift']) : null,
      overriddenBy: json['overridden_by'] != null ? OverrideBy.fromJson(json['overridden_by']) : null,
    );
  }
}

class OverrideEmployee {
  String? id;
  String? name;
  String? employeeCode;
  String? department;
  String? branch;

  OverrideEmployee({this.id, this.name, this.employeeCode, this.department, this.branch});

  factory OverrideEmployee.fromJson(Map<String, dynamic> json) {
    return OverrideEmployee(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      employeeCode: json['employee_code']?.toString(),
      department: json['department']?.toString(),
      branch: json['branch']?.toString(),
    );
  }
}

class OverrideShift {
  int? id;
  String? name;

  OverrideShift({this.id, this.name});

  factory OverrideShift.fromJson(Map<String, dynamic> json) {
    return OverrideShift(
      id: json['id'],
      name: json['name']?.toString(),
    );
  }
}

class OverrideBy {
  String? id;
  String? name;

  OverrideBy({this.id, this.name});

  factory OverrideBy.fromJson(Map<String, dynamic> json) {
    return OverrideBy(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
    );
  }
}
