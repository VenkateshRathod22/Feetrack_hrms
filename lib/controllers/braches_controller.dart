import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/branch_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/branch_repo.dart';

class BrachesController extends GetxController implements GetxService {
  final BranchRepo branchRepo;

  BrachesController({required this.branchRepo});

  bool isLoading = false;
  List<BranchModel> branchList = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lngController = TextEditingController();
  final TextEditingController radiusController = TextEditingController();
  String? selectedManagerId;
  String? selectedStatus = 'active';

  Future<ResponseModel> getBranchesList({String? search}) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (search != null) query['search'] = search;

      Response response = await branchRepo.getBranches(query);

      if (response.body != null && response.body['status'] == "success") {
        final List data = response.body['data'];
        branchList = data.map((e) => BranchModel.fromJson(e)).toList();
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Branches fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch branches");
      }
    } catch (e) {
      log("ERROR AT getBranchesList: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> createBranch() async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "address": addressController.text,
        "lat": latController.text,
        "lng": lngController.text,
        "radius": radiusController.text,
        "manager_id": selectedManagerId,
        "status": selectedStatus,
      };

      Response response = await branchRepo.createBranch(body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getBranchesList();
        update();
        return ResponseModel(true, response.body['message'] ?? "Branch created successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to create branch");
      }
    } catch (e) {
      log("ERROR AT createBranch: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> updateBranch(int id) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "address": addressController.text,
        "lat": latController.text,
        "lng": lngController.text,
        "radius": radiusController.text,
        "manager_id": selectedManagerId,
        "status": selectedStatus,
      };

      Response response = await branchRepo.updateBranch(id, body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getBranchesList();
        update();
        return ResponseModel(true, response.body['message'] ?? "Branch updated successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to update branch");
      }
    } catch (e) {
      log("ERROR AT updateBranch: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> deleteBranch(int id) async {
    isLoading = true;
    update();

    try {
      Response response = await branchRepo.deleteBranch(id);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        branchList.removeWhere((element) => element.id == id);
        update();
        return ResponseModel(true, response.body['message'] ?? "Branch deleted successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete branch");
      }
    } catch (e) {
      log("ERROR AT deleteBranch: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  void clearControllers() {
    nameController.clear();
    addressController.clear();
    latController.clear();
    lngController.clear();
    radiusController.clear();
    selectedManagerId = null;
    selectedStatus = 'active';
    update();
  }

  void setEditData(BranchModel branch) {
    nameController.text = branch.name ?? "";
    addressController.text = branch.address ?? "";
    latController.text = branch.lat ?? "";
    lngController.text = branch.lng ?? "";
    radiusController.text = branch.radius?.toString() ?? "";
    selectedManagerId = branch.managerId;
    selectedStatus = branch.status;
    update();
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    latController.dispose();
    lngController.dispose();
    radiusController.dispose();
    super.onClose();
  }
}
