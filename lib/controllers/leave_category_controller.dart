import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/leave_category_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/leave_category_repo.dart';

class LeaveCategoryController extends GetxController implements GetxService {
  final LeaveCategoryRepo leaveCategoryRepo;

  LeaveCategoryController({required this.leaveCategoryRepo});

  bool isLoading = false;
  List<LeaveCategoryModel> leaveCategoryList = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  bool status = true;
  bool isUnlimited = false;

  Future<ResponseModel> getLeaveCategories({String? search}) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (search != null && search.isNotEmpty) query['search'] = search;

      Response response = await leaveCategoryRepo.getLeaveCategories(query);

      if (response.body != null && response.body['status'] == "success") {
        final List data = response.body['data'];
        leaveCategoryList = data.map((e) => LeaveCategoryModel.fromJson(e)).toList();
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Leave categories fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch leave categories");
      }
    } catch (e) {
      log("ERROR AT getLeaveCategories: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> createLeaveCategory() async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "days": int.tryParse(daysController.text) ?? 0,
        "is_unlimited": isUnlimited,
        "status": status,
      };

      Response response = await leaveCategoryRepo.createLeaveCategory(body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getLeaveCategories();
        update();
        return ResponseModel(true, response.body['message'] ?? "Leave category created successfully.");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to create leave category");
      }
    } catch (e) {
      log("ERROR AT createLeaveCategory: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> updateLeaveCategory(int id) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "days": int.tryParse(daysController.text) ?? 0,
        "is_unlimited": isUnlimited,
        "status": status,
      };

      Response response = await leaveCategoryRepo.updateLeaveCategory(id, body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getLeaveCategories();
        update();
        return ResponseModel(true, response.body['message'] ?? "Leave category updated successfully.");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to update leave category");
      }
    } catch (e) {
      log("ERROR AT updateLeaveCategory: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> deleteLeaveCategory(int id) async {
    isLoading = true;
    update();

    try {
      Response response = await leaveCategoryRepo.deleteLeaveCategory(id);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        leaveCategoryList.removeWhere((element) => element.id == id);
        update();
        return ResponseModel(true, response.body['message'] ?? "Leave category deleted successfully.");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete leave category");
      }
    } catch (e) {
      log("ERROR AT deleteLeaveCategory: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  void toggleStatus(bool? value) {
    status = value ?? true;
    update();
  }

  void clearControllers() {
    nameController.clear();
    daysController.clear();
    status = true;
    isUnlimited = false;
  }

  void setEditData(LeaveCategoryModel leaveCategory) {
    nameController.text = leaveCategory.name ?? "";
    daysController.text = leaveCategory.days?.toString() ?? "";
    status = leaveCategory.status ?? true;
    isUnlimited = leaveCategory.isUnlimited ?? false;
    update();
  }

  @override
  void onClose() {
    nameController.dispose();
    daysController.dispose();
    super.onClose();
  }
}
