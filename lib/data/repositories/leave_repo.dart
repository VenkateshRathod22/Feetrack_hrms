import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class LeaveRepo {
  final ApiClient apiClient;

  LeaveRepo({required this.apiClient});

  Future<Response> applyLeave(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.applyLeavePost, "applyLeave", body);
  }

  Future<Response> getLeaves() async {
    return await apiClient.getData(AppConstants.getLeaves, "getLeaves");
  }

  Future<Response> getTeamLeaves(String status, {String? employeeId}) async {
    Map<String, dynamic> query = {"status": status};
    if (employeeId != null) {
      query["employee_id"] = employeeId;
    }
    return await apiClient.getData(AppConstants.getTeamLeaves, "getTeamLeaves", query: query);
  }

  Future<Response> updateLeaveStatus(int leaveId, String status) async {
    return await apiClient.postData("${AppConstants.getTeamLeaves}/$leaveId/status", "updateLeaveStatus", {"status": status});
  }

  Future<Response> getLeaveCategories() async {
    return await apiClient.getData(AppConstants.leaveCategories, "getLeaveCategories");
  }
}
