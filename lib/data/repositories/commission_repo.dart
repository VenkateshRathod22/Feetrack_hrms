import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class CommissionRepo {
  final ApiClient apiClient;

  CommissionRepo({required this.apiClient});

  Future<Response> getCommissionHistory(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.commissionHistory, "getCommissionHistory", query: query);
  }

  Future<Response> processCommission(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.processCommission, "processCommission", body);
  }
}
