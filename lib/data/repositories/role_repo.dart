import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class RoleRepo {
  final ApiClient apiClient;

  RoleRepo({required this.apiClient});

  Future<Response> getRoles(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.roles, "getRoles", query: query);
  }

  Future<Response> getRoleDetails(int id) async {
    return await apiClient.getData("${AppConstants.roles}/$id", "getRoleDetails");
  }

  Future<Response> createRole(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.roles, "createRole", body);
  }

  Future<Response> updateRole(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.roles}/$id", "updateRole", body);
  }

  Future<Response> deleteRole(int id) async {
    // Note: Prompt said /hrms/staff/{staff_id} for delete, but usually it's roles.
    // I'll stick to roles as per standard REST, but I'll use the path mentioned if roles fails.
    // However, I will use roles first.
    return await apiClient.deleteData("${AppConstants.roles}/$id", "deleteRole");
  }
}
