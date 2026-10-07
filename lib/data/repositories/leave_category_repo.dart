import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class LeaveCategoryRepo {
  final ApiClient apiClient;

  LeaveCategoryRepo({required this.apiClient});

  Future<Response> getLeaveCategories(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.leaveCategories, "getLeaveCategories", query: query);
  }

  Future<Response> createLeaveCategory(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.leaveCategories, "createLeaveCategory", body);
  }

  Future<Response> updateLeaveCategory(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.leaveCategories}/$id", "updateLeaveCategory", body);
  }

  Future<Response> deleteLeaveCategory(int id) async {
    return await apiClient.deleteData("${AppConstants.leaveCategories}/$id", "deleteLeaveCategory");
  }
}
