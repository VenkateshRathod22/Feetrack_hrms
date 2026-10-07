import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class BranchRepo {
  final ApiClient apiClient;

  BranchRepo({required this.apiClient});

  Future<Response> getBranches(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.branches, "getBranches", query: query);
  }

  Future<Response> createBranch(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.branches, "createBranch", body);
  }

  Future<Response> updateBranch(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.branches}/$id", "updateBranch", body);
  }

  Future<Response> deleteBranch(int id) async {
    return await apiClient.deleteData("${AppConstants.branches}/$id", "deleteBranch");
  }
}
