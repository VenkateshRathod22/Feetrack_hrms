import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class ExpenseCategoryRepo {
  final ApiClient apiClient;

  ExpenseCategoryRepo({required this.apiClient});

  Future<Response> getExpenseCategories(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.expenseCategories, "getExpenseCategories", query: query);
  }

  Future<Response> createExpenseCategory(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.expenseCategories, "createExpenseCategory", body);
  }

  Future<Response> updateExpenseCategory(String id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.expenseCategories}/$id", "updateExpenseCategory", body);
  }

  Future<Response> deleteExpenseCategory(String id) async {
    return await apiClient.deleteData("${AppConstants.expenseCategories}/$id", "deleteExpenseCategory");
  }
}
