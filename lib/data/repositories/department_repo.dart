import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class DepartmentRepo {
  final ApiClient apiClient;

  DepartmentRepo({required this.apiClient});

  Future<Response> getDepartments(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.departments, "getDepartments", query: query);
  }

  Future<Response> getDepartmentsListing(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.departmentsListing, "getDepartmentsListing", query: query);
  }

  Future<Response> createDepartment(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.departments, "createDepartment", body);
  }

  Future<Response> updateDepartment(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.departments}/$id", "updateDepartment", body);
  }

  Future<Response> deleteDepartment(int id) async {
    return await apiClient.deleteData("${AppConstants.departments}/$id", "deleteDepartment");
  }
}
