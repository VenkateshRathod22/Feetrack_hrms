import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class ExpenseRepo {
  final ApiClient apiClient;

  ExpenseRepo({required this.apiClient});

  Future<Response> applyExpense(FormData data) async {
    return await apiClient.postData(AppConstants.applyExpensePost, "applyExpense", data);
  }

  Future<Response> updateExpense(int id, FormData data) async {
    return await apiClient.postData("${AppConstants.applyExpensePost}/$id", "updateExpense", data);
  }

  Future<Response> getExpenseCategories() async {
    return await apiClient.getData(AppConstants.expenseCategories, "getExpenseCategories");
  }

  Future<Response> getExpenses() async {
    return await apiClient.getData(AppConstants.getExpenses, "getExpenses");
  }

  Future<Response> getTeamExpenses(String status, {String? employeeId}) async {
    Map<String, dynamic> query = {"status": status};
    if (employeeId != null) {
      query["employee_id"] = employeeId;
    }
    return await apiClient.getData(AppConstants.getTeamExpenses, "getTeamExpenses", query: query);
  }

  Future<Response> updateExpenseStatus(int expenseId, String status) async {
    return await apiClient.postData("${AppConstants.getTeamExpenses}/$expenseId/status", "updateExpenseStatus", {"status": status});
  }
}
