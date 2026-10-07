import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class CommissionLevelRepo {
  final ApiClient apiClient;

  CommissionLevelRepo({required this.apiClient});

  Future<Response> getCommissionLevels(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.commissionLevels, "getCommissionLevels", query: query);
  }

  Future<Response> addCommissionLevel(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.commissionLevels, "addCommissionLevel", body);
  }

  Future<Response> updateCommissionLevel(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.commissionLevels}/$id", "updateCommissionLevel", body);
  }

  Future<Response> deleteCommissionLevel(int id) async {
    return await apiClient.deleteData("${AppConstants.commissionLevels}/$id", "deleteCommissionLevel");
  }
}
