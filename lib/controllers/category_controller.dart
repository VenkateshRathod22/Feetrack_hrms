import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/category_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/category_repo.dart';

class CategoryController extends GetxController implements GetxService {
  final CategoryRepo categoryRepo;

  CategoryController({required this.categoryRepo});

  bool isLoading = false;
  List<CategoryModel> categoryList = [];

  final TextEditingController nameController = TextEditingController();

  Future<ResponseModel> getCategories({String? search}) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (search != null && search.isNotEmpty) query['search'] = search;

      Response response = await categoryRepo.getCategories(query);

      if (response.body != null && response.body['status'] == "success") {
        final List data = response.body['data'];
        categoryList = data.map((e) => CategoryModel.fromJson(e)).toList();
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Categories fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch categories");
      }
    } catch (e) {
      log("ERROR AT getCategories: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> createCategory() async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
      };

      Response response = await categoryRepo.createCategory(body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getCategories();
        update();
        return ResponseModel(true, response.body['message'] ?? "Category created successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to create category");
      }
    } catch (e) {
      log("ERROR AT createCategory: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> updateCategory(int id) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
      };

      Response response = await categoryRepo.updateCategory(id, body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getCategories();
        update();
        return ResponseModel(true, response.body['message'] ?? "Category updated successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to update category");
      }
    } catch (e) {
      log("ERROR AT updateCategory: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> deleteCategory(int id) async {
    isLoading = true;
    update();

    try {
      Response response = await categoryRepo.deleteCategory(id);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        categoryList.removeWhere((element) => element.id == id);
        update();
        return ResponseModel(true, response.body['message'] ?? "Category deleted successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete category");
      }
    } catch (e) {
      log("ERROR AT deleteCategory: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  void clearControllers() {
    nameController.clear();
  }

  void setEditData(CategoryModel category) {
    nameController.text = category.name ?? "";
    update();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
