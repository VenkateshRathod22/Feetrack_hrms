
class SalaryStructureModel {
int? id;
String? employeeId;
String? salaryType;
double? monthlyTarget;
double? commissionPercent;
double? recoveryPercent;
double? basicSalary;
double? merchantTarget;
double? totalAllowances;
double? performanceIncentive;
double? salesIncentive;
String? incentiveText;
Allowances? allowances;
Deductions? deductions;
double? grossSalary;
double? netSalary;
DateTime? createdAt;
DateTime? updatedAt;
int? commissionLevelId;

SalaryStructureModel({
this.id,
this.employeeId,
this.salaryType,
this.monthlyTarget,
this.commissionPercent,
this.recoveryPercent,
this.basicSalary,
this.merchantTarget,
this.totalAllowances,
this.performanceIncentive,
this.salesIncentive,
this.incentiveText,
this.allowances,
this.deductions,
this.grossSalary,
this.netSalary,
this.createdAt,
this.updatedAt,
this.commissionLevelId,
});

// ==============================
// SAFE DOUBLE PARSER
// ==============================
static double? _toDouble(dynamic value) {
if (value == null) return null;

if (value is num) {
return value.toDouble();
}

return double.tryParse(value.toString());
}

// ==============================
// SAFE INT PARSER
// ==============================
static int? _toInt(dynamic value) {
if (value == null) return null;

if (value is int) {
return value;
}

if (value is num) {
return value.toInt();
}

return int.tryParse(value.toString());
}

// ==============================
// SAFE DATE PARSER
// ==============================
static DateTime? _toDateTime(dynamic value) {
if (value == null) return null;

return DateTime.tryParse(value.toString());
}

factory SalaryStructureModel.fromJson(Map<String, dynamic> json) {
return SalaryStructureModel(
id: _toInt(json["id"]),

employeeId: json["employee_id"]?.toString(),

salaryType: json["salary_type"]?.toString(),

monthlyTarget: _toDouble(json["monthly_target"]),

commissionPercent: _toDouble(
json["commission_percent"],
),

recoveryPercent: _toDouble(
json["recovery_percent"],
),

basicSalary: _toDouble(
json["basic_salary"],
),

merchantTarget: _toDouble(
json["merchant_target"],
),

totalAllowances: _toDouble(
json["total_allowances"],
),

performanceIncentive: _toDouble(
json["performance_incentive"],
),

salesIncentive: _toDouble(
json["sales_incentive"],
),

incentiveText: json["incentive_text"]?.toString(),

// ==============================
// ALLOWANCES
// ==============================
allowances: json["allowances"] is Map
? Allowances.fromJson(
Map<String, dynamic>.from(
json["allowances"],
),
)
    : null,

// ==============================
// DEDUCTIONS
// ==============================
deductions: json["deductions"] is Map
? Deductions.fromJson(
Map<String, dynamic>.from(
json["deductions"],
),
)
    : null,

grossSalary: _toDouble(
json["gross_salary"],
),

netSalary: _toDouble(
json["net_salary"],
),

createdAt: _toDateTime(
json["created_at"],
),

updatedAt: _toDateTime(
json["updated_at"],
),

commissionLevelId: _toInt(
json["commission_level_id"],
),
);
}

Map<String, dynamic> toJson() {
return {
"id": id,
"employee_id": employeeId,
"salary_type": salaryType,
"monthly_target": monthlyTarget,
"commission_percent": commissionPercent,
"recovery_percent": recoveryPercent,
"basic_salary": basicSalary,
"merchant_target": merchantTarget,
"total_allowances": totalAllowances,
"performance_incentive": performanceIncentive,
"sales_incentive": salesIncentive,
"incentive_text": incentiveText,
"allowances": allowances?.toJson(),
"deductions": deductions?.toJson(),
"gross_salary": grossSalary,
"net_salary": netSalary,
"created_at": createdAt?.toIso8601String(),
"updated_at": updatedAt?.toIso8601String(),
"commission_level_id": commissionLevelId,
};
}
}

// =====================================================
// ALLOWANCES MODEL
// =====================================================

class Allowances {
double? hra;
double? da;
double? conveyance;
double? medical;
double? special;
double? travel;
double? internet;
double? food;
double? performanceIncentive;
double? salesIncentive;
double? bonus;
double? overtime;
double? shift;
double? other;

Allowances({
this.hra,
this.da,
this.conveyance,
this.medical,
this.special,
this.travel,
this.internet,
this.food,
this.performanceIncentive,
this.salesIncentive,
this.bonus,
this.overtime,
this.shift,
this.other,
});

static double? _toDouble(dynamic value) {
if (value == null) return null;

if (value is num) {
return value.toDouble();
}

return double.tryParse(value.toString());
}

factory Allowances.fromJson(
Map<String, dynamic> json,
) {
return Allowances(
hra: _toDouble(json["hra"]),
da: _toDouble(json["da"]),
conveyance: _toDouble(
json["conveyance"],
),
medical: _toDouble(
json["medical"],
),
special: _toDouble(
json["special"],
),
travel: _toDouble(
json["travel"],
),
internet: _toDouble(
json["internet"],
),
food: _toDouble(
json["food"],
),
performanceIncentive: _toDouble(
json["performance_incentive"],
),
salesIncentive: _toDouble(
json["sales_incentive"],
),
bonus: _toDouble(
json["bonus"],
),
overtime: _toDouble(
json["overtime"],
),
shift: _toDouble(
json["shift"],
),
other: _toDouble(
json["other"],
),
);
}

Map<String, dynamic> toJson() {
return {
"hra": hra,
"da": da,
"conveyance": conveyance,
"medical": medical,
"special": special,
"travel": travel,
"internet": internet,
"food": food,
"performance_incentive": performanceIncentive,
"sales_incentive": salesIncentive,
"bonus": bonus,
"overtime": overtime,
"shift": shift,
"other": other,
};
}
}

// =====================================================
// DEDUCTIONS MODEL
// =====================================================

class Deductions {
double? pf;
double? esi;
double? pt;
double? tds;
double? lwf;
double? noticePeriod;
double? other;

Deductions({
this.pf,
this.esi,
this.pt,
this.tds,
this.lwf,
this.noticePeriod,
this.other,
});

static double? _toDouble(dynamic value) {
if (value == null) return null;

if (value is num) {
return value.toDouble();
}

return double.tryParse(value.toString());
}

factory Deductions.fromJson(
Map<String, dynamic> json,
) {
return Deductions(
pf: _toDouble(json["pf"]),

esi: _toDouble(json["esi"]),

pt: _toDouble(json["pt"]),

tds: _toDouble(json["tds"]),

lwf: _toDouble(json["lwf"]),

noticePeriod: _toDouble(
json["notice_period"],
),

other: _toDouble(
json["other"],
),
);
}

Map<String, dynamic> toJson() {
return {
"pf": pf,
"esi": esi,
"pt": pt,
"tds": tds,
"lwf": lwf,
"notice_period": noticePeriod,
"other": other,
};
}
}

