class ExitReasonReportModel {
  final int? id;
  final String? name;
  final String? type;
  final bool? isActive;
  final String? partnerId;

  ExitReasonReportModel({
    this.id,
    this.name,
    this.type,
    this.isActive,
    this.partnerId,
  });

  factory ExitReasonReportModel.fromJson(Map<String, dynamic> json) => ExitReasonReportModel(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        isActive: json["is_active"],
        partnerId: json["partner_id"],
      );
}

class ExitReasonReportSummary {
  final int? totalReasons;
  final int? voluntaryCount;
  final int? involuntaryCount;

  ExitReasonReportSummary({
    this.totalReasons,
    this.voluntaryCount,
    this.involuntaryCount,
  });

  factory ExitReasonReportSummary.fromJson(Map<String, dynamic> json) => ExitReasonReportSummary(
        totalReasons: json["total_reasons"],
        voluntaryCount: json["voluntary_count"],
        involuntaryCount: json["involuntary_count"],
      );
}
