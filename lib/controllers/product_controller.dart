import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/category_model.dart';
import 'package:vlr/data/models/product_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/product_repo.dart';

class ProductController extends GetxController implements GetxService {
  final ProductRepo productRepo;

  ProductController({required this.productRepo});

  bool isLoading = false;
  List<ProductModel> productList = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController gstPercentController = TextEditingController();
  CategoryModel? selectedCategory;
  String selectedGstType = "notinclude";
  String selectedStatus = "active";

  final List<String> gstTypeOptions = ["include", "notinclude"];
  final List<String> statusOptions = ["active", "inactive"];

  Future<ResponseModel> getProducts({String? search}) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (search != null && search.isNotEmpty) query['search'] = search;

      Response response = await productRepo.getProducts(query);

      if (response.body != null && response.body['status'] == "success") {
        final dynamic responseData = response.body['data'];
        List<dynamic> dataList = [];

        if (responseData is List) {
          dataList = responseData;
        } else if (responseData is Map && responseData['data'] is List) {
          dataList = responseData['data'];
        }

        productList = dataList.map((e) => ProductModel.fromJson(e)).toList();
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Products fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch products");
      }
    } catch (e) {
      log("ERROR AT getProducts: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> createProduct() async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "category_id": selectedCategory?.id,
        "amount": priceController.text,
        "gst_type": selectedGstType,
        "gst_percent": gstPercentController.text,
        "status": selectedStatus,
      };

      Response response = await productRepo.createProduct(body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getProducts();
        update();
        return ResponseModel(true, response.body['message'] ?? "Product added successfully.");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to add product");
      }
    } catch (e) {
      log("ERROR AT createProduct: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> updateProduct(int id) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "category_id": selectedCategory?.id,
        "amount": priceController.text,
        "gst_type": selectedGstType,
        "gst_percent": gstPercentController.text,
        "status": selectedStatus,
      };

      Response response = await productRepo.updateProduct(id, body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getProducts();
        update();
        return ResponseModel(true, response.body['message'] ?? "Product updated successfully.");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to update product");
      }
    } catch (e) {
      log("ERROR AT updateProduct: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> deleteProduct(int id) async {
    isLoading = true;
    update();

    try {
      Response response = await productRepo.deleteProduct(id);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        productList.removeWhere((element) => element.id == id);
        update();
        return ResponseModel(true, response.body['message'] ?? "Product deleted successfully.");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete product");
      }
    } catch (e) {
      log("ERROR AT deleteProduct: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  void clearControllers() {
    nameController.clear();
    priceController.clear();
    gstPercentController.clear();
    selectedCategory = null;
    selectedGstType = "notinclude";
    selectedStatus = "active";
    update();
  }

  void setEditData(ProductModel product) {
    nameController.text = product.name ?? "";
    priceController.text = product.amount ?? "";
    gstPercentController.text = product.gstPercent?.toString() ?? "";
    selectedCategory = product.category;
    selectedGstType = product.gstType ?? "notinclude";
    selectedStatus = product.status ?? "active";
    update();
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
