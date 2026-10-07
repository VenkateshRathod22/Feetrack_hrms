import 'performance_staff_model.dart';

class PerformanceDetailModel {
  PerformanceEmployee? employee;
  String? scoreMode;
  PerformanceWeights? weights;
  List<PerformancePreset>? presets;
  PerformanceStats? stats;
  List<MonthlyPerformance>? monthlyPerformance;

  PerformanceDetailModel({
    this.employee,
    this.scoreMode,
    this.weights,
    this.presets,
    this.stats,
    this.monthlyPerformance,
  });

  factory PerformanceDetailModel.fromJson(Map<String, dynamic> json) => PerformanceDetailModel(
        employee: json["employee"] == null ? null : PerformanceEmployee.fromJson(json["employee"]),
        scoreMode: json["score_mode"]?.toString(),
        weights: json["weights"] == null ? null : PerformanceWeights.fromJson(json["weights"]),
        presets: json["presets"] == null
            ? []
            : List<PerformancePreset>.from(json["presets"].map((x) => PerformancePreset.fromJson(x))),
        stats: json["stats"] == null ? null : PerformanceStats.fromJson(json["stats"]),
        monthlyPerformance: json["monthly_performance"] == null
            ? []
            : List<MonthlyPerformance>.from(
                json["monthly_performance"].map((x) => MonthlyPerformance.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "employee": employee?.toJson(),
        "score_mode": scoreMode,
        "weights": weights?.toJson(),
        "presets": presets == null ? [] : List<dynamic>.from(presets!.map((x) => x.toJson())),
        "stats": stats?.toJson(),
        "monthly_performance":
            monthlyPerformance == null ? [] : List<dynamic>.from(monthlyPerformance!.map((x) => x.toJson())),
      };
}

class PerformanceEmployee {
  String? id;
  String? name;
  String? employeeCode;
  String? email;
  String? avatarUrl;
  String? department;
  String? designation;
  String? branch;

  PerformanceEmployee({
    this.id,
    this.name,
    this.employeeCode,
    this.email,
    this.avatarUrl,
    this.department,
    this.designation,
    this.branch,
  });

  factory PerformanceEmployee.fromJson(Map<String, dynamic> json) => PerformanceEmployee(
        id: json["id"]?.toString(),
        name: json["name"]?.toString(),
        employeeCode: json["employee_code"]?.toString(),
        email: json["email"]?.toString(),
        avatarUrl: json["avatar_url"]?.toString(),
        department: json["department"]?.toString(),
        designation: json["designation"]?.toString(),
        branch: json["branch"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "employee_code": employeeCode,
        "email": email,
        "avatar_url": avatarUrl,
        "department": department,
        "designation": designation,
        "branch": branch,
      };
}

class PerformancePreset {
  String? name;
  PerformanceWeights? weights;

  PerformancePreset({
    this.name,
    this.weights,
  });

  factory PerformancePreset.fromJson(Map<String, dynamic> json) => PerformancePreset(
        name: json["name"]?.toString(),
        weights: json["weights"] == null ? null : PerformanceWeights.fromJson(json["weights"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "weights": weights?.toJson(),
      };
}

class PerformanceStats {
  int? totalPresent;
  int? lateMarks;
  int? tasksCompleted;
  int? totalTasks;
  int? leavesTaken;

  PerformanceStats({
    this.totalPresent,
    this.lateMarks,
    this.tasksCompleted,
    this.totalTasks,
    this.leavesTaken,
  });

  factory PerformanceStats.fromJson(Map<String, dynamic> json) => PerformanceStats(
        totalPresent: json["total_present"],
        lateMarks: json["late_marks"],
        tasksCompleted: json["tasks_completed"],
        totalTasks: json["total_tasks"],
        leavesTaken: json["leaves_taken"],
      );

  Map<String, dynamic> toJson() => {
        "total_present": totalPresent,
        "late_marks": lateMarks,
        "tasks_completed": tasksCompleted,
        "total_tasks": totalTasks,
        "leaves_taken": leavesTaken,
      };
}

class MonthlyPerformance {
  String? month;
  dynamic attendance;
  dynamic tasks;
  dynamic merchantTarget;
  dynamic monthlyTarget;
  dynamic totalScore;
  String? grade;

  MonthlyPerformance({
    this.month,
    this.attendance,
    this.tasks,
    this.merchantTarget,
    this.monthlyTarget,
    this.totalScore,
    this.grade,
  });

  factory MonthlyPerformance.fromJson(Map<String, dynamic> json) => MonthlyPerformance(
        month: json["month"]?.toString(),
        attendance: json["attendance"],
        tasks: json["tasks"],
        merchantTarget: json["merchant_target"],
        monthlyTarget: json["monthly_target"],
        totalScore: json["total_score"],
        grade: json["grade"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "attendance": attendance,
        "tasks": tasks,
        "merchant_target": merchantTarget,
        "monthly_target": monthlyTarget,
        "total_score": totalScore,
        "grade": grade,
      };
}
