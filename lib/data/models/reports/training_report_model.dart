class TrainingReportModel {
  final int? id;
  final int? trainingId;
  final String? trainingTitle;
  final String? trainer;
  final String? employeeId;
  final String? employeeCode;
  final String? employeeName;
  final String? department;
  final String? branch;
  final String? status;
  final String? result;
  final String? attendancePercentage;
  final String? assessmentScore;
  final String? assignedAt;

  TrainingReportModel({
    this.id,
    this.trainingId,
    this.trainingTitle,
    this.trainer,
    this.employeeId,
    this.employeeCode,
    this.employeeName,
    this.department,
    this.branch,
    this.status,
    this.result,
    this.attendancePercentage,
    this.assessmentScore,
    this.assignedAt,
  });

  factory TrainingReportModel.fromJson(Map<String, dynamic> json) => TrainingReportModel(
        id: json["id"],
        trainingId: json["training_id"],
        trainingTitle: json["training_title"],
        trainer: json["trainer"],
        employeeId: json["employee_id"],
        employeeCode: json["employee_code"],
        employeeName: json["employee_name"],
        department: json["department"],
        branch: json["branch"],
        status: json["status"],
        result: json["result"],
        attendancePercentage: json["attendance_percentage"]?.toString(),
        assessmentScore: json["assessment_score"]?.toString(),
        assignedAt: json["assigned_at"],
      );
}

class TrainingReportSummary {
  final int? totalAssigned;
  final int? totalCompleted;
  final int? totalPending;
  final num? avgAttendance;
  final num? avgAssessmentScore;

  TrainingReportSummary({
    this.totalAssigned,
    this.totalCompleted,
    this.totalPending,
    this.avgAttendance,
    this.avgAssessmentScore,
  });

  factory TrainingReportSummary.fromJson(Map<String, dynamic> json) => TrainingReportSummary(
        totalAssigned: json["total_assigned"],
        totalCompleted: json["total_completed"],
        totalPending: json["total_pending"] ?? json["pending_training"],
        avgAttendance: json["avg_attendance"] ?? json["avg_attendance_pct"],
        avgAssessmentScore: json["avg_assessment_score"] ?? json["avg_assessment_score_pct"],
      );
}

class TrainingAssignmentModel {
  final int? id;
  final String? employeeName;
  final String? employeeCode;
  final String? trainingTitle;
  final String? trainer;
  final String? department;
  final String? branch;
  final String? status;
  final String? result;
  final num? attendancePercentage;
  final num? assessmentScore;
  final String? assignedAt;
  final String? startDate;
  final String? completionDate;

  TrainingAssignmentModel({
    this.id,
    this.employeeName,
    this.employeeCode,
    this.trainingTitle,
    this.trainer,
    this.department,
    this.branch,
    this.status,
    this.result,
    this.attendancePercentage,
    this.assessmentScore,
    this.assignedAt,
    this.startDate,
    this.completionDate,
  });

  factory TrainingAssignmentModel.fromJson(Map<String, dynamic> json) => TrainingAssignmentModel(
        id: json["id"],
        employeeName: json["employee"]?["name"] ?? json["employee_name"],
        employeeCode: json["employee"]?["employee_code"] ?? json["employee_code"],
        trainingTitle: json["training"]?["title"] ?? json["training_title"],
        trainer: json["training"]?["trainer"] ?? json["trainer"],
        department: json["department"]?["name"] ?? json["department"],
        branch: json["branch"]?["name"] ?? json["branch"],
        status: json["status"],
        result: json["result"],
        attendancePercentage: num.tryParse(json["attendance_percentage"]?.toString() ?? "0"),
        assessmentScore: num.tryParse(json["assessment_score"]?.toString() ?? "0"),
        assignedAt: json["assigned_at"],
        startDate: json["start_date"],
        completionDate: json["completion_date"],
      );
}

class TrainingProgramModel {
  final int? id;
  final String? title;
  final String? description;
  final String? trainer;
  final String? trainingType;
  final String? startDate;
  final String? endDate;
  final int? duration;
  final num? passingScore;
  final String? status;
  final int? assignmentsCount;

  TrainingProgramModel({
    this.id,
    this.title,
    this.description,
    this.trainer,
    this.trainingType,
    this.startDate,
    this.endDate,
    this.duration,
    this.passingScore,
    this.status,
    this.assignmentsCount,
  });

  factory TrainingProgramModel.fromJson(Map<String, dynamic> json) => TrainingProgramModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        trainer: json["trainer"],
        trainingType: json["training_type"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        duration: json["duration"],
        passingScore: num.tryParse(json["passing_score"]?.toString() ?? "0"),
        status: json["status"],
        assignmentsCount: json["assignments_count"],
      );
}

class TrainingSummary {
  final int? totalAssigned;
  final int? totalCompleted;
  final int? pendingTraining;
  final num? avgAttendancePct;
  final num? avgAssessmentScorePct;

  TrainingSummary({
    this.totalAssigned,
    this.totalCompleted,
    this.pendingTraining,
    this.avgAttendancePct,
    this.avgAssessmentScorePct,
  });

  factory TrainingSummary.fromJson(Map<String, dynamic> json) => TrainingSummary(
        totalAssigned: json["total_assigned"],
        totalCompleted: json["total_completed"],
        pendingTraining: json["pending_training"],
        avgAttendancePct: json["avg_attendance_pct"],
        avgAssessmentScorePct: json["avg_assessment_score_pct"],
      );
}

class TrainingBreakdownItem {
  final int? id;
  final String? name;
  final String? department;
  final String? branch;
  final String? title;
  final int? assigned;
  final int? completed;
  final int? pending;
  final num? attendancePct;
  final num? scorePct;

  TrainingBreakdownItem({
    this.id,
    this.name,
    this.department,
    this.branch,
    this.title,
    this.assigned,
    this.completed,
    this.pending,
    this.attendancePct,
    this.scorePct,
  });

  factory TrainingBreakdownItem.fromJson(Map<String, dynamic> json) => TrainingBreakdownItem(
        id: json["id"],
        name: json["name"],
        department: json["department"],
        branch: json["branch"],
        title: json["title"],
        assigned: json["assigned"],
        completed: json["completed"],
        pending: json["pending"],
        attendancePct: num.tryParse(json["attendance_pct"]?.toString() ?? "0"),
        scorePct: num.tryParse(json["score_pct"]?.toString() ?? "0"),
      );
}

class TrainingMonthlyTrend {
  final String? month;
  final int? assigned;
  final int? completed;
  final int? pending;
  final num? attendancePct;
  final num? scorePct;

  TrainingMonthlyTrend({this.month, this.assigned, this.completed, this.pending, this.attendancePct, this.scorePct});

  factory TrainingMonthlyTrend.fromJson(Map<String, dynamic> json) => TrainingMonthlyTrend(
        month: json["month"],
        assigned: json["assigned"],
        completed: json["completed"],
        pending: json["pending"],
        attendancePct: num.tryParse(json["attendance_pct"]?.toString() ?? "0"),
        scorePct: num.tryParse(json["score_pct"]?.toString() ?? "0"),
      );
}

class TrainingAnalytics {
  final TrainingSummary? summary;
  final List<TrainingBreakdownItem>? deptBreakdown;
  final List<TrainingBreakdownItem>? branchBreakdown;
  final List<TrainingBreakdownItem>? programBreakdown;
  final List<TrainingMonthlyTrend>? monthlyTrends;

  TrainingAnalytics({this.summary, this.deptBreakdown, this.branchBreakdown, this.programBreakdown, this.monthlyTrends});

  factory TrainingAnalytics.fromJson(Map<String, dynamic> json) => TrainingAnalytics(
        summary: json["summary"] != null ? TrainingSummary.fromJson(json["summary"]) : null,
        deptBreakdown: json["dept_breakdown"] != null ? List<TrainingBreakdownItem>.from(json["dept_breakdown"].map((x) => TrainingBreakdownItem.fromJson(x))) : [],
        branchBreakdown: json["branch_breakdown"] != null ? List<TrainingBreakdownItem>.from(json["branch_breakdown"].map((x) => TrainingBreakdownItem.fromJson(x))) : [],
        programBreakdown: json["program_breakdown"] != null ? List<TrainingBreakdownItem>.from(json["program_breakdown"].map((x) => TrainingBreakdownItem.fromJson(x))) : [],
        monthlyTrends: json["monthly_trends"] != null ? List<TrainingMonthlyTrend>.from(json["monthly_trends"].map((x) => TrainingMonthlyTrend.fromJson(x))) : [],
      );
}
