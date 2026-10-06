class EmployeesAttendanceSummaryModel {
  final int? punchOut;
  final int? absent;
  final int? halfDay;
  final int? punchIn;
  final int? leave;
  final int? holiday;
  final int? weekOff;
  final int? late;
  final String? totalHours;
  final String? productiveHours;
  final String? overtimeHours;

  EmployeesAttendanceSummaryModel({
    this.punchOut,
    this.absent,
    this.halfDay,
    this.punchIn,
    this.leave,
    this.holiday,
    this.weekOff,
    this.late,
    this.totalHours,
    this.productiveHours,
    this.overtimeHours,
  });

  factory EmployeesAttendanceSummaryModel.fromJson(Map<String, dynamic> json) =>
      EmployeesAttendanceSummaryModel(
        punchOut: int.tryParse(json["punch_out"]?.toString() ?? ""),
        absent: int.tryParse(json["absent"]?.toString() ?? ""),
        halfDay: int.tryParse(json["half_day"]?.toString() ?? ""),
        punchIn: int.tryParse(json["punch_in"]?.toString() ?? ""),
        leave: int.tryParse(json["leave"]?.toString() ?? ""),
        holiday: int.tryParse(json["holiday"]?.toString() ?? ""),
        weekOff: int.tryParse(json["weekOff"]?.toString() ?? ""),
        late: int.tryParse(json["late"]?.toString() ?? ""),
        totalHours: json["total_hours"]?.toString(),
        productiveHours: json["productive_hours"]?.toString(),
        overtimeHours: json["overtime_hours"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "punch_out": punchOut,
        "absent": absent,
        "half_day": halfDay,
        "punch_in": punchIn,
        "leave": leave,
        "holiday": holiday,
        "weekOff": weekOff,
        "late": late,
        "total_hours": totalHours,
        "productive_hours": productiveHours,
        "overtime_hours": overtimeHours,
      };
}
