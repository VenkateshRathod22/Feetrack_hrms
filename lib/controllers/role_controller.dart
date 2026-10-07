import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/models/role_model.dart';
import 'package:vlr/data/repositories/permission_repo.dart';
import 'package:vlr/data/repositories/role_repo.dart';

class RoleController extends GetxController implements GetxService {
  final RoleRepo roleRepo;
  final PermissionRepo permissionRepo;

  RoleController({required this.roleRepo, required this.permissionRepo});

  bool isLoading = false;
  List<RoleModel> roleList = [];
  RoleModel? roleDetails;

  final TextEditingController nameController = TextEditingController();
  List<String> selectedPermissions = [];
  List<PermissionModel> availablePermissions = [];
  List<PermissionModuleModel> availablePermissionModules = [];

  Future<ResponseModel> getPermissions() async {
    isLoading = true;
    update();
    try {
      Response response = await permissionRepo.getPermissions();
      if (response.body != null && response.body['status'] == "success") {
        final data = response.body['data'];
        if (data is List) {
          availablePermissionModules = data
              .map((e) => PermissionModuleModel.fromJson(
                  Map<String, dynamic>.from(e)))
              .toList();
        }

        // Flatten for any legacy use cases if needed, though better to use modules
        availablePermissions = [];
        for (var module in availablePermissionModules) {
          if (module.permissions != null) {
            availablePermissions.addAll(module.permissions!);
          }
        }

        isLoading = false;
        update();
        return ResponseModel(true, "Permissions fetched");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, "Failed to fetch permissions");
      }
    } catch (e) {
      log("ERROR AT getPermissions: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> getRoles({String? search}) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (search != null && search.isNotEmpty) query['search'] = search;

      Response response = await roleRepo.getRoles(query);

      if (response.body != null && response.body['status'] == "success") {
        final data = response.body['data'];
        if (data is List) {
          roleList = data
              .map((e) => RoleModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
        isLoading = false;
        update();
        return ResponseModel(true,
            response.body['message'] ?? "Roles fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(
            false, response.body?['message'] ?? "Failed to fetch roles");
      }
    } catch (e) {
      log("ERROR AT getRoles: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> getRoleDetails(int id) async {
    isLoading = true;
    update();

    try {
      Response response = await roleRepo.getRoleDetails(id);

      if (response.body != null && response.body['status'] == "success") {
        final data = response.body['data'];
        if (data is List) {
          if (data.isNotEmpty) {
            roleDetails = RoleModel.fromJson(Map<String, dynamic>.from(data[0]));
          }
        } else if (data is Map) {
          roleDetails = RoleModel.fromJson(Map<String, dynamic>.from(data));
        }

        isLoading = false;
        update();
        return ResponseModel(true,
            response.body['message'] ?? "Role details fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(
            false, response.body?['message'] ?? "Failed to fetch role details");
      }
    } catch (e) {
      log("ERROR AT getRoleDetails: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> createRole() async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "permissions": selectedPermissions,
      };

      Response response = await roleRepo.createRole(body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getRoles();
        update();
        return ResponseModel(true, response.body['message'] ?? "Role created successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to create role");
      }
    } catch (e) {
      log("ERROR AT createRole: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> updateRole(int id) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "permissions": selectedPermissions,
      };

      Response response = await roleRepo.updateRole(id, body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getRoles();
        update();
        return ResponseModel(true, response.body['message'] ?? "Role updated successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to update role");
      }
    } catch (e) {
      log("ERROR AT updateRole: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> deleteRole(int id) async {
    isLoading = true;
    update();

    try {
      Response response = await roleRepo.deleteRole(id);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        roleList.removeWhere((element) => element.id == id);
        update();
        return ResponseModel(true, response.body['message'] ?? "Role deleted successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete role");
      }
    } catch (e) {
      log("ERROR AT deleteRole: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  void togglePermission(String permission) {
    if (selectedPermissions.contains(permission)) {
      selectedPermissions.remove(permission);
    } else {
      selectedPermissions.add(permission);
    }
    update();
  }

  void toggleModulePermissions(PermissionModuleModel module, bool? value) {
    if (module.permissions == null) return;
    for (var permission in module.permissions!) {
      if (permission.name != null) {
        if (value == true) {
          if (!selectedPermissions.contains(permission.name)) {
            selectedPermissions.add(permission.name!);
          }
        } else {
          selectedPermissions.remove(permission.name!);
        }
      }
    }
    update();
  }

  bool isModuleAllSelected(PermissionModuleModel module) {
    if (module.permissions == null || module.permissions!.isEmpty) return false;
    return module.permissions!
        .every((p) => selectedPermissions.contains(p.name));
  }

  void clearControllers() {
    nameController.clear();
    selectedPermissions = [];
    roleDetails = null;
  }

  void setEditData(RoleModel role) {
    // API response for name has partner_id prefix, but create/update usually takes just the short name.
    // However, I'll set what's in the model and the user can edit it.
    // Often names are like "partnerId_ShortName", let's try to extract if possible, or just keep it.
    String displayName = role.name ?? "";
    if (displayName.contains("_")) {
        displayName = displayName.split("_").last;
    }
    nameController.text = displayName;
    
    selectedPermissions = role.permissions?.map((e) => e.name ?? "").toList() ?? [];
    update();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
