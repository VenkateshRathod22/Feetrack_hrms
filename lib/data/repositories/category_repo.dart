import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class CategoryRepo {
  final ApiClient apiClient;

  CategoryRepo({required this.apiClient});

  Future<Response> getCategories(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.productCategories, "getCategories", query: query);
  }

  Future<Response> createCategory(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.productCategories, "createCategory", body);
  }

  Future<Response> updateCategory(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.productCategories}/$id", "updateCategory", body);
  }

  Future<Response> deleteCategory(int id) async {
    return await apiClient.deleteData("${AppConstants.productCategories}/$id", "deleteCategory");
  }
}
