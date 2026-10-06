class RoleModel {
  int? id;
  String? name;
  String? guardName;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? permissionsCount;
  List<PermissionModel>? permissions;

  RoleModel({
    this.id,
    this.name,
    this.guardName,
    this.createdAt,
    this.updatedAt,
    this.permissionsCount,
    this.permissions,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
        id: json["id"],
        name: json["name"],
        guardName: json["guard_name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        permissionsCount: json["permissions_count"],
        permissions: json["permissions"] == null
            ? []
            : List<PermissionModel>.from(
                json["permissions"].map((x) => PermissionModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "guard_name": guardName,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "permissions_count": permissionsCount,
        "permissions": permissions == null
            ? []
            : List<dynamic>.from(permissions!.map((x) => x.toJson())),
      };
}

class PermissionModel {
  int? id;
  String? name;
  String? guardName;
  DateTime? createdAt;
  DateTime? updatedAt;

  PermissionModel({
    this.id,
    this.name,
    this.guardName,
    this.createdAt,
    this.updatedAt,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) => PermissionModel(
        id: json["id"],
        name: json["name"],
        guardName: json["guard_name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "guard_name": guardName,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class PermissionModuleModel {
  String? module;
  String? title;
  List<PermissionModel>? permissions;

  PermissionModuleModel({
    this.module,
    this.title,
    this.permissions,
  });

  factory PermissionModuleModel.fromJson(Map<String, dynamic> json) =>
      PermissionModuleModel(
        module: json["module"],
        title: json["title"],
        permissions: json["permissions"] == null
            ? []
            : List<PermissionModel>.from(
                json["permissions"].map((x) => PermissionModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "module": module,
        "title": title,
        "permissions": permissions == null
            ? []
            : List<dynamic>.from(permissions!.map((x) => x.toJson())),
      };
}
