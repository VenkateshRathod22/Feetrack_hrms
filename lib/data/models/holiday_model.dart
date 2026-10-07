class HolidayModel {
  int? id;
  String? partnerId;
  int? branchId;
  String? name;
  String? date;
  DateTime? createdAt;
  DateTime? updatedAt;
  HolidayBranch? branch;

  HolidayModel({
    this.id,
    this.partnerId,
    this.branchId,
    this.name,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.branch,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json) => HolidayModel(
        id: json["id"],
        partnerId: json["partner_id"]?.toString(),
        branchId: json["branch_id"],
        name: json["name"],
        date: json["date"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        branch: json["branch"] == null ? null : HolidayBranch.fromJson(json["branch"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "partner_id": partnerId,
        "branch_id": branchId,
        "name": name,
        "date": date,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "branch": branch?.toJson(),
      };
}

class HolidayBranch {
  int? id;
  String? partnerId;
  String? name;
  String? address;
  String? lat;
  String? lng;
  int? radius;
  dynamic managerId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  HolidayBranch({
    this.id,
    this.partnerId,
    this.name,
    this.address,
    this.lat,
    this.lng,
    this.radius,
    this.managerId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory HolidayBranch.fromJson(Map<String, dynamic> json) => HolidayBranch(
        id: json["id"],
        partnerId: json["partner_id"],
        name: json["name"],
        address: json["address"],
        lat: json["lat"],
        lng: json["lng"],
        radius: json["radius"],
        managerId: json["manager_id"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "partner_id": partnerId,
        "name": name,
        "address": address,
        "lat": lat,
        "lng": lng,
        "radius": radius,
        "manager_id": managerId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
