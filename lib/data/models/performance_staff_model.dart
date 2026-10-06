class PerformanceStaffModel {
  String? id;
  String? name;
  String? employeeCode;
  String? email;
  String? avatarUrl;
  String? department;
  String? designation;
  String? branch;
  String? scoreMode;
  PerformanceWeights? weights;

  PerformanceStaffModel({
    this.id,
    this.name,
    this.employeeCode,
    this.email,
    this.avatarUrl,
    this.department,
    this.designation,
    this.branch,
    this.scoreMode,
    this.weights,
  });

  factory PerformanceStaffModel.fromJson(Map<String, dynamic> json) => PerformanceStaffModel(
        id: json["id"]?.toString(),
        name: json["name"]?.toString(),
        employeeCode: json["employee_code"]?.toString(),
        email: json["email"]?.toString(),
        avatarUrl: json["avatar_url"]?.toString(),
        department: json["department"]?.toString(),
        designation: json["designation"]?.toString(),
        branch: json["branch"]?.toString(),
        scoreMode: json["score_mode"]?.toString(),
        weights: json["weights"] == null ? null : PerformanceWeights.fromJson(json["weights"]),
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
        "score_mode": scoreMode,
        "weights": weights?.toJson(),
      };
}

class PerformanceWeights {
  int? attendance;
  int? tasks;
  int? merchantTarget;
  int? monthlyTarget;
  int? total;

  PerformanceWeights({
    this.attendance,
    this.tasks,
    this.merchantTarget,
    this.monthlyTarget,
    this.total,
  });

  factory PerformanceWeights.fromJson(Map<String, dynamic> json) => PerformanceWeights(
        attendance: json["attendance"],
        tasks: json["tasks"],
        merchantTarget: json["merchant_target"],
        monthlyTarget: json["monthly_target"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "attendance": attendance,
        "tasks": tasks,
        "merchant_target": merchantTarget,
        "monthly_target": monthlyTarget,
        "total": total,
      };
}
