import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/department_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/department_repo.dart';

class DepartmentController extends GetxController implements GetxService {
  final DepartmentRepo departmentRepo;

  DepartmentController({required this.departmentRepo});

  bool isLoading = false;
  List<DepartmentModel> departmentList = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  int? selectedParentId;
  
  // For branch_heads mapping: branch_id -> manager_id
  Map<String, String> branchHeads = {};

  Future<ResponseModel> getDepartmentList({String? search}) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (search != null) query['search'] = search;

      Response response = await departmentRepo.getDepartmentsListing(query);

      if (response.body != null && response.body['status'] == "success") {
        final List data = response.body['data'];
        departmentList = data.map((e) => DepartmentModel.fromJson(e)).toList();
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Departments fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch departments");
      }
    } catch (e) {
      log("ERROR AT getDepartmentList: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> createDepartment() async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "description": descriptionController.text,
        "parent_id": selectedParentId,
        "branch_heads": branchHeads,
      };

      Response response = await departmentRepo.createDepartment(body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getDepartmentList();
        update();
        return ResponseModel(true, response.body['message'] ?? "Department created successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to create department");
      }
    } catch (e) {
      log("ERROR AT createDepartment: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> updateDepartment(int id) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "description": descriptionController.text,
        "parent_id": selectedParentId,
        "branch_heads": branchHeads,
      };

      Response response = await departmentRepo.updateDepartment(id, body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getDepartmentList();
        update();
        return ResponseModel(true, response.body['message'] ?? "Department updated successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to update department");
      }
    } catch (e) {
      log("ERROR AT updateDepartment: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> deleteDepartment(int id) async {
    isLoading = true;
    update();

    try {
      Response response = await departmentRepo.deleteDepartment(id);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        departmentList.removeWhere((element) => element.id == id);
        update();
        return ResponseModel(true, response.body['message'] ?? "Department deleted successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete department");
      }
    } catch (e) {
      log("ERROR AT deleteDepartment: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  void addBranchHead(String branchId, String branchZone) {
    branchHeads[branchId] = branchZone;
    update();
  }

  void removeBranchHead(String branchId) {
    branchHeads.remove(branchId);
    update();
  }

  void clearControllers() {
    nameController.clear();
    descriptionController.clear();
    selectedParentId = null;
    branchHeads.clear();
    update();
  }

  void setEditData(DepartmentModel dept) {
    nameController.text = dept.name ?? "";
    descriptionController.text = dept.description ?? "";
    selectedParentId = dept.parentId;
    // Note: branch_heads might need separate fetch if not in GET list, 
    // but I'll clear it for now or assume it's set manually.
    branchHeads.clear();
    update();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
