import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/expense_category_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/expense_category_repo.dart';

class ExpenseCategoryController extends GetxController implements GetxService {
  final ExpenseCategoryRepo expenseCategoryRepo;

  ExpenseCategoryController({required this.expenseCategoryRepo});

  bool isLoading = false;
  List<ExpenseCategoryModel> expenseCategoryList = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController unitNameController = TextEditingController();
  final TextEditingController ratePerUnitController = TextEditingController();
  final TextEditingController maxLimitController = TextEditingController();

  String selectedType = 'fixed';
  String selectedStatus = 'active';

  final List<String> types = ['fixed', 'per_unit'];
  final List<String> statuses = ['active', 'inactive'];

  Future<ResponseModel> getExpenseCategories({String? search}) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (search != null && search.isNotEmpty) query['search'] = search;

      Response response = await expenseCategoryRepo.getExpenseCategories(query);

      if (response.body != null && response.body['status'] == "success") {
        final List data = response.body['data'];
        expenseCategoryList = data.map((e) => ExpenseCategoryModel.fromJson(e)).toList();
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Expense categories fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch expense categories");
      }
    } catch (e) {
      log("ERROR AT getExpenseCategories: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> createExpenseCategory() async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "type": selectedType,
        "status": selectedStatus,
      };

      if (selectedType == 'per_unit') {
        body['unit_name'] = unitNameController.text;
        body['rate_per_unit'] = double.tryParse(ratePerUnitController.text) ?? 0;
      } else {
        body['max_limit_amount'] = double.tryParse(maxLimitController.text);
      }

      Response response = await expenseCategoryRepo.createExpenseCategory(body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getExpenseCategories();
        update();
        return ResponseModel(true, response.body['message'] ?? "Expense category created successfully.");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to create expense category");
      }
    } catch (e) {
      log("ERROR AT createExpenseCategory: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> updateExpenseCategory(String id) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "type": selectedType,
        "status": selectedStatus,
      };

      if (selectedType == 'per_unit') {
        body['unit_name'] = unitNameController.text;
        body['rate_per_unit'] = double.tryParse(ratePerUnitController.text) ?? 0;
      } else {
        body['max_limit_amount'] = double.tryParse(maxLimitController.text);
      }

      Response response = await expenseCategoryRepo.updateExpenseCategory(id, body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getExpenseCategories();
        update();
        return ResponseModel(true, response.body['message'] ?? "Expense category updated successfully.");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to update expense category");
      }
    } catch (e) {
      log("ERROR AT updateExpenseCategory: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> deleteExpenseCategory(String id) async {
    isLoading = true;
    update();

    try {
      Response response = await expenseCategoryRepo.deleteExpenseCategory(id);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        expenseCategoryList.removeWhere((element) => element.id == id);
        update();
        return ResponseModel(true, response.body['message'] ?? "Expense category deleted successfully.");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete expense category");
      }
    } catch (e) {
      log("ERROR AT deleteExpenseCategory: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  void setType(String? value) {
    if (value != null) {
      selectedType = value;
      update();
    }
  }

  void setStatus(String? value) {
    if (value != null) {
      selectedStatus = value;
      update();
    }
  }

  void clearControllers() {
    nameController.clear();
    unitNameController.clear();
    ratePerUnitController.clear();
    maxLimitController.clear();
    selectedType = 'fixed';
    selectedStatus = 'active';
  }

  void setEditData(ExpenseCategoryModel model) {
    nameController.text = model.name ?? "";
    unitNameController.text = model.unitName ?? "";
    ratePerUnitController.text = model.ratePerUnit ?? "";
    maxLimitController.text = model.maxLimitAmount ?? "";
    selectedType = model.type ?? 'fixed';
    selectedStatus = model.status ?? 'active';
    update();
  }

  @override
  void onClose() {
    nameController.dispose();
    unitNameController.dispose();
    ratePerUnitController.dispose();
    maxLimitController.dispose();
    super.onClose();
  }
}
