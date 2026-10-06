class BranchModel {
  int? id;
  String? partnerId;
  String? name;
  String? address;
  String? lat;
  String? lng;
  int? radius;
  String? managerId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  BranchModel({
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

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
        id: json["id"],
        partnerId: json["partner_id"],
        name: json["name"],
        address: json["address"],
        lat: json["lat"],
        lng: json["lng"],
        radius: json["radius"],
        managerId: json["manager_id"]?.toString(),
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
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

  @override
  String toString() => name ?? "";
}
