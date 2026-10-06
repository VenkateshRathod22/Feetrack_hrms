import 'package:vlr/data/models/notice_model.dart';
import 'package:vlr/data/models/response/task_model.dart';
import 'package:vlr/data/models/response/lead_model.dart';
import 'package:vlr/data/models/response/lead_order_model.dart';
import 'package:vlr/data/models/user_model.dart';

class DashboardModel {
  final List<dynamic>? departmentPerformance;
  final num? myAttendanceThisMonth;
  final List<WeeklyAttendance>? weeklyAttendance;
  final int? myPendingLeaves;
  final AttendanceToday? myAttendanceToday;
  final dynamic myLeaveToday;
  final MyShift? myShift;
  final bool? isLate;
  final int? lateMinutes;
  final List<dynamic>? upcomingLeaves;
  final String? leaveLabel;
  final List<dynamic>? upcomingHolidays;
  final bool? isHoliday;
  final String? holidayName;
  final bool? isWeekOff;
  final bool? isFullLeave;
  final bool? isHalfLeave;
  final bool? isAbsent;
  final List<String>? weekOffDays;
  final int? myPendingTasks;
  final String? taskLabel;
  final num? myExpensesAmount;
  final String? expenseLabel;
  final List<NoticeModel>? recentNotices;
  final List<TaskModel>? recentTasks;
  final List<TopAchiever>? topAchievers;
  final List<dynamic>? pipelineQueues;
  final ChartData? chartData;
  final int? totalLeads;
  final int? wonLeads;
  final int? totalOrders;
  final String? totalPipelineValue;
  final List<LeadModel>? recentLeads;
  final List<LeadOrderModel>? recentOrders;

  DashboardModel({
    this.departmentPerformance,
    this.myAttendanceThisMonth,
    this.weeklyAttendance,
    this.myPendingLeaves,
    this.myAttendanceToday,
    this.myLeaveToday,
    this.myShift,
    this.isLate,
    this.lateMinutes,
    this.upcomingLeaves,
    this.leaveLabel,
    this.upcomingHolidays,
    this.isHoliday,
    this.holidayName,
    this.isWeekOff,
    this.isFullLeave,
    this.isHalfLeave,
    this.isAbsent,
    this.weekOffDays,
    this.myPendingTasks,
    this.taskLabel,
    this.myExpensesAmount,
    this.expenseLabel,
    this.recentNotices,
    this.recentTasks,
    this.topAchievers,
    this.pipelineQueues,
    this.chartData,
    this.totalLeads,
    this.wonLeads,
    this.totalOrders,
    this.totalPipelineValue,
    this.recentLeads,
    this.recentOrders,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        departmentPerformance: json["departmentPerformance"],
        myAttendanceThisMonth: json["myAttendanceThisMonth"],
        weeklyAttendance: json["weeklyAttendance"] == null
            ? null
            : List<WeeklyAttendance>.from(json["weeklyAttendance"]
                .map((x) => WeeklyAttendance.fromJson(x))),
        myPendingLeaves: json["myPendingLeaves"],
        myAttendanceToday: json["myAttendanceToday"] == null
            ? null
            : AttendanceToday.fromJson(json["myAttendanceToday"]),
        myLeaveToday: json["myLeaveToday"],
        myShift: json["myShift"] == null
            ? null
            : MyShift.fromJson(json["myShift"]),
        isLate: json["isLate"],
        lateMinutes: json["lateMinutes"],
        upcomingLeaves: json["upcomingLeaves"],
        leaveLabel: json["leaveLabel"],
        upcomingHolidays: json["upcomingHolidays"],
        isHoliday: json["isHoliday"],
        holidayName: json["holidayName"],
        isWeekOff: json["isWeekOff"],
        isFullLeave: json["isFullLeave"],
        isHalfLeave: json["isHalfLeave"],
        isAbsent: json["isAbsent"],
        weekOffDays: json["weekOffDays"] == null
            ? null
            : List<String>.from(json["weekOffDays"].map((x) => x)),
        myPendingTasks: json["myPendingTasks"],
        taskLabel: json["taskLabel"],
        myExpensesAmount: json["myExpensesAmount"],
        expenseLabel: json["expenseLabel"],
        recentNotices: json["recentNotices"] == null
            ? null
            : List<NoticeModel>.from(
                json["recentNotices"].map((x) => NoticeModel.fromJson(x))),
        recentTasks: json["recentTasks"] == null
            ? null
            : List<TaskModel>.from(
                json["recentTasks"].map((x) => TaskModel.fromJson(x))),
        topAchievers: json["topAchievers"] == null
            ? null
            : List<TopAchiever>.from(
                json["topAchievers"].map((x) => TopAchiever.fromJson(x))),
        pipelineQueues: json["pipelineQueues"],
        chartData: json["chartData"] == null
            ? null
            : ChartData.fromJson(json["chartData"]),
        totalLeads: json["totalLeads"],
        wonLeads: json["wonLeads"],
        totalOrders: json["totalOrders"],
        totalPipelineValue: json["totalPipelineValue"]?.toString(),
        recentLeads: json["recentLeads"] == null
            ? null
            : List<LeadModel>.from(
                json["recentLeads"].map((x) => LeadModel.fromJson(x))),
        recentOrders: json["recentOrders"] == null
            ? null
            : List<LeadOrderModel>.from(
                json["recentOrders"].map((x) => LeadOrderModel.fromJson(x))),
      );
}

class AttendanceToday {
  final int? id;
  final String? status;
  final String? checkIn;
  final String? checkOut;

  AttendanceToday({this.id, this.status, this.checkIn, this.checkOut});

  factory AttendanceToday.fromJson(Map<String, dynamic> json) =>
      AttendanceToday(
        id: json["id"],
        status: json["status"],
        checkIn: json["check_in"],
        checkOut: json["check_out"],
      );
}

class TopAchiever {
  final UserModel? user;
  final num? business;
  final num? target;
  final num? pct;

  TopAchiever({this.user, this.business, this.target, this.pct});

  factory TopAchiever.fromJson(Map<String, dynamic> json) => TopAchiever(
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
        business: json["business"],
        target: json["target"],
        pct: json["pct"],
      );
}

class WeeklyAttendance {
  final String? date;
  final num? hours;

  WeeklyAttendance({this.date, this.hours});

  factory WeeklyAttendance.fromJson(Map<String, dynamic> json) =>
      WeeklyAttendance(
        date: json["date"],
        hours: json["hours"],
      );
}

class MyShift {
  final int? id;
  final String? partnerId;
  final String? name;
  final String? startTime;
  final String? endTime;
  final int? autoMarkAttendance;
  final String? autoMarkStatus;
  final int? lateToleranceMinutes;
  final num? minPresentMins;
  final num? minHalfDayMins;
  final num? autoAbsentMarkMins;
  final List<String>? weekOffDays;

  MyShift({
    this.id,
    this.partnerId,
    this.name,
    this.startTime,
    this.endTime,
    this.autoMarkAttendance,
    this.autoMarkStatus,
    this.lateToleranceMinutes,
    this.minPresentMins,
    this.minHalfDayMins,
    this.autoAbsentMarkMins,
    this.weekOffDays,
  });

  factory MyShift.fromJson(Map<String, dynamic> json) => MyShift(
        id: json["id"],
        partnerId: json["partner_id"],
        name: json["name"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        autoMarkAttendance: json["auto_mark_attendance"],
        autoMarkStatus: json["auto_mark_status"],
        lateToleranceMinutes: json["late_tolerance_minutes"],
        minPresentMins: json["min_present_mins"],
        minHalfDayMins: json["min_half_day_mins"],
        autoAbsentMarkMins: json["auto_absent_mark_mins"],
        weekOffDays: json["week_off_days"] == null
            ? null
            : List<String>.from(json["week_off_days"] is String
                ? [] // Could parse string if it's JSON string
                : json["week_off_days"].map((x) => x)),
      );
}

class ChartData {
  final List<int>? taskStatus;
  final List<String>? monthlyLabels;
  final List<int>? monthlyTasks;
  final List<dynamic>? topEmployeesLabels;
  final List<dynamic>? topEmployeesTasks;

  ChartData({
    this.taskStatus,
    this.monthlyLabels,
    this.monthlyTasks,
    this.topEmployeesLabels,
    this.topEmployeesTasks,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
        taskStatus: json["taskStatus"] == null
            ? null
            : List<int>.from(json["taskStatus"].map((x) => x)),
        monthlyLabels: json["monthlyLabels"] == null
            ? null
            : List<String>.from(json["monthlyLabels"].map((x) => x)),
        monthlyTasks: json["monthlyTasks"] == null
            ? null
            : List<int>.from(json["monthlyTasks"].map((x) => x)),
        topEmployeesLabels: json["topEmployeesLabels"],
        topEmployeesTasks: json["topEmployeesTasks"],
      );
}
