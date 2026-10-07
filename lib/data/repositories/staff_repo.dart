import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class StaffRepo {
  final ApiClient apiClient;

  StaffRepo({required this.apiClient});

  Future<Response> getStaffList(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.staff, "getStaffList", query: query);
  }

  Future<Response> getPerformanceStaffList() async {
    return await apiClient.getData(AppConstants.performanceStaff, "getPerformanceStaffList");
  }

  Future<Response> getPerformanceStaffDetail(String id) async {
    return await apiClient.getData("${AppConstants.performanceStaffDetail}$id", "getPerformanceStaffDetail");
  }

  Future<Response> getEmployeesListing(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.employeesListing, "getEmployeesListing", query: query);
  }

  Future<Response> getStaffProfile(String staffId) async {
    return await apiClient.getData("${AppConstants.staffProfile}$staffId", "getStaffProfile");
  }

  Future<Response> createStaff(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.staff, "createStaff", body);
  }

  Future<Response> updateStaff(String staffId, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.staffProfile}$staffId", "updateStaff", body);
  }

  Future<Response> deleteStaff(String staffId) async {
    return await apiClient.deleteData("${AppConstants.staffProfile}$staffId", "deleteStaff");
  }
}
